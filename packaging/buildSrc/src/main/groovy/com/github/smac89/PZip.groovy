package com.github.smac89

import groovy.transform.CompileStatic
import org.gradle.api.internal.file.copy.CopyAction
import org.gradle.api.tasks.bundling.AbstractArchiveTask

@CompileStatic
class PZip extends AbstractArchiveTask {

    PZip() {
        archiveExtension.set('zip')
    }

    @Override
    protected CopyAction createCopyAction() {
        return new ZipCopyAction(archiveFile.get().asFile)
    }
}
