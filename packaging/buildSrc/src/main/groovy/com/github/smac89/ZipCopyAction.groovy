package com.github.smac89

import groovy.transform.CompileStatic
import groovy.transform.PackageScope
import groovy.transform.TupleConstructor
import org.apache.commons.compress.archivers.zip.*
import org.gradle.api.file.FileCopyDetails
import org.gradle.api.file.FileTreeElement
import org.gradle.api.internal.file.CopyActionProcessingStreamAction
import org.gradle.api.internal.file.copy.CopyAction
import org.gradle.api.internal.file.copy.CopyActionProcessingStream
import org.gradle.api.internal.file.copy.FileCopyDetailsInternal
import org.gradle.api.tasks.WorkResult
import org.gradle.api.tasks.WorkResults

import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths

@PackageScope
@CompileStatic
@TupleConstructor
class ZipCopyAction implements CopyAction {
    final File zipFile

    @Override
    WorkResult execute(final CopyActionProcessingStream stream) {
        new ZipArchiveOutputStream(zipFile).withCloseable { zipOutStr ->
            zipOutStr.with {
                encoding = 'utf-8'
                useLanguageEncodingFlag = true
                createUnicodeExtraFields = ZipArchiveOutputStream.UnicodeExtraFieldPolicy.ALWAYS
                fallbackToUTF8 = true
            }

            ParallelScatterZipCreator pZipCreator = new ParallelScatterZipCreator()
            stream.process(new StreamAction(pZipCreator, zipOutStr))

            pZipCreator.writeTo(zipOutStr)
        }
        return WorkResults.didWork(true)
    }

    @CompileStatic
    @TupleConstructor
    static class StreamAction implements CopyActionProcessingStreamAction {
        final ParallelScatterZipCreator pZipCreator
        final ZipArchiveOutputStream zipDirOutStr

        private final List<Path> visitedSymlinks = []

        @Override
        void processFile(FileCopyDetailsInternal details) {
            if (!isChildOfVisitedSymlink(details)) {
                if (isSymLink(details)) {
                    visitSymLink(details)
                } else if (details.isDirectory()) {
                    visitDir(details)
                } else {
                    visitFile(details)
                }
            }
        }

        private boolean isChildOfVisitedSymlink(FileCopyDetails copyDetails) {
            return visitedSymlinks.any {
                isChildOf(it, copyDetails.file.toPath())
            }
        }

        private static boolean isChildOf(Path maybeParent, Path file) {
            return file.startsWith(maybeParent)
        }

        private static boolean isSymLink(FileTreeElement treeElement) {
            try {
                return Files.isSymbolicLink(Paths.get(treeElement.file.absolutePath))
            } catch (UnsupportedOperationException ignored) {
                return false
            }
        }

        private void visitFile(FileCopyDetails fileDetails) {
            pZipCreator.addArchiveEntry {
                ZipArchiveEntry archiveEntry = new ZipArchiveEntry(fileDetails.path).tap {
                    setTime(fileDetails.lastModified)
                    setUnixMode(UnixStat.FILE_FLAG | fileDetails.mode)
                    setMethod(ZipMethod.DEFLATED.code)
                }
                return ZipArchiveEntryRequest.createZipArchiveEntryRequest(archiveEntry,
                                                                           fileDetails.&open)
            }
        }

        private void visitDir(FileCopyDetails dirDetails) {
            def archiveEntry = new ZipArchiveEntry("${dirDetails.path}/").tap {
                setTime(dirDetails.lastModified)
                setUnixMode(UnixStat.DIR_FLAG | dirDetails.mode)
                setMethod(ZipMethod.DEFLATED.code)
            }
            zipDirOutStr.putArchiveEntry(archiveEntry)
            zipDirOutStr.closeArchiveEntry()
        }

        protected void visitSymLink(FileCopyDetails linkDetails) {
            visitedSymlinks << linkDetails.file.toPath()

            pZipCreator.addArchiveEntry {
                Path link = Files.readSymbolicLink(linkDetails.file.toPath())
                ZipArchiveEntry archiveEntry = new ZipArchiveEntry(linkDetails.path).tap {
                    setTime(linkDetails.lastModified)
                    setUnixMode(UnixStat.LINK_FLAG | linkDetails.mode)
                    setMethod(ZipMethod.DEFLATED.code)
                }
                return ZipArchiveEntryRequest.createZipArchiveEntryRequest(archiveEntry) {
                    new ByteArrayInputStream(link.toString().getBytes(StandardCharsets.UTF_8))
                }
            }
        }
    }
}
