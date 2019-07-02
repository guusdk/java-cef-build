package org.paleozogt.gradle.zip

import org.apache.commons.compress.archivers.zip.ZipArchiveEntry
import org.apache.commons.compress.archivers.zip.ZipFile
import org.apache.commons.io.IOUtils
import org.gradle.api.file.FileCopyDetails
import org.gradle.api.internal.file.CopyActionProcessingStreamAction
import org.gradle.api.internal.file.FileResolver
import org.gradle.api.internal.file.copy.CopyAction
import org.gradle.api.internal.file.copy.CopyActionProcessingStream
import org.gradle.api.internal.file.copy.FileCopyDetailsInternal
import org.gradle.api.tasks.WorkResult
import org.gradle.internal.nativeintegration.filesystem.FileSystem

import java.nio.file.Files

class UnzipCopyAction implements CopyAction {
    private final FileResolver fileResolver

    UnzipCopyAction(FileResolver fileResolver) {
        this.fileResolver = fileResolver
    }

    @Override
    WorkResult execute(CopyActionProcessingStream stream) {
        FileCopyDetailsInternalAction action = new FileCopyDetailsInternalAction()
        stream.process(action)
        return action
    }

    private class FileCopyDetailsInternalAction implements CopyActionProcessingStreamAction, WorkResult {
        private boolean didWork

        @Override
        void processFile(FileCopyDetailsInternal details) {
            File target = fileResolver.resolve(details.getRelativePath().getPathString())

            try {
                explodeZip(details, target.parentFile)
                didWork= true
            } catch (IOException e) {
                boolean copied = details.copyTo(target)
                if (copied) {
                    didWork = true
                }
            }
        }

        protected void explodeZip(FileCopyDetails fileDetails, File target) {
            ZipFile zipFile= new ZipFile(fileDetails.file)

            zipFile.entries.each { ZipArchiveEntry entry ->
                File entryFile = new File(target, entry.name)
                entryFile.parentFile.mkdirs()

                if (entry.isUnixSymlink()) {
                    String linkEntry= getEntryContents(zipFile, entry)
                    File linkEntryFile= new File(linkEntry)
                    Files.createSymbolicLink(entryFile.toPath(), linkEntryFile.toPath())
                } else if (entry.isDirectory()) {
                    entryFile.mkdir()
                    Files.chmod(entryFile, getEntryMode(entry))
                } else {
                    copyStreamToFile(zipFile.getInputStream(entry), entryFile)
                    getFileSystem().chmod(entryFile, getEntryMode(entry))
                }
            }
        }

        protected static int getEntryMode(ZipArchiveEntry entry) {
            int unixMode = entry.getUnixMode() & 0777
            if (unixMode == 0) {
                //no mode infos available - fall back to defaults
                if (entry.isDirectory()){
                    unixMode = FileSystem.DEFAULT_DIR_MODE
                } else{
                    unixMode = FileSystem.DEFAULT_FILE_MODE
                }
            }
            return unixMode
        }

        protected static String getEntryContents(ZipFile zipFile, ZipArchiveEntry entry) throws IOException {
            InputStream entryStream= zipFile.getInputStream(entry)
            ByteArrayOutputStream contents= new ByteArrayOutputStream()
            IOUtils.copy(entryStream, contents)
            return contents.toString()
        }

        protected static void copyStreamToFile(InputStream inputStream, File outputFile) {
            OutputStream outputStream= null
            try {
                outputStream= new FileOutputStream(outputFile)
                IOUtils.copy(inputStream, outputStream)
            } finally {
                IOUtils.closeQuietly(outputStream)
            }
        }

        @Override
        boolean getDidWork() {
            return didWork
        }
    }
}
