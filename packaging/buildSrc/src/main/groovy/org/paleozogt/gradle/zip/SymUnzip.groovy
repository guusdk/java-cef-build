package org.paleozogt.gradle.zip


import org.gradle.api.InvalidUserDataException
import org.gradle.api.internal.file.copy.CopyAction
import org.gradle.api.internal.file.copy.CopySpecInternal
import org.gradle.api.internal.file.copy.DestinationRootCopySpec
import org.gradle.api.tasks.AbstractCopyTask
import org.gradle.api.tasks.OutputDirectory

class SymUnzip extends AbstractCopyTask {
    @Override
    protected CopyAction createCopyAction() {
        File destinationDir = getDestinationDir()
        if (destinationDir == null) {
            throw new InvalidUserDataException("No copy destination directory has been specified, use 'into' to specify a target directory.")
        }
        return new UnzipCopyAction(fileLookup.getFileResolver(destinationDir))
    }

    @Override
    protected CopySpecInternal createRootSpec() {
       return instantiator.newInstance(DestinationRootCopySpec, fileResolver, super.createRootSpec())
    }

    @Override
    DestinationRootCopySpec getRootSpec() {
        return super.getRootSpec() as DestinationRootCopySpec
    }

    /**
     * Returns the directory to copy files into.
     *
     * @return The destination dir.
     */
    @OutputDirectory
    File getDestinationDir() {
        return rootSpec.destinationDir
    }

    /**
     * Sets the directory to copy files into. This is the same as calling {@link #into(Object)} on this task.
     *
     * @param destinationDir The destination directory. Must not be null.
     */
    void setDestinationDir(File destinationDir) {
        into(destinationDir)
    }
}
