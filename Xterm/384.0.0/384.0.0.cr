class Target < ISM::Software
    
    def prepare
        super

        fileReplaceText("#{buildDirectoryPath}/termcap",":tc=xterm-new:",":tc=xterm-new:kb=^?:")
        fileAppendData("#{buildDirectoryPath}/terminfo","\tkbs=\\177,")
    end

    def configure
        super

        configureSource(arguments: ["--prefix=/usr",
                                    "--sysconfdir=/etc",
                                    "--localstatedir=/var",
                                    "--disable-static",
                                    "--with-app-defaults=/etc/X11/app-defaults"],
                        path: buildDirectoryPath,
                        environment: {"TERMINFO" => "/usr/share/terminfo"})
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install-ti"],buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications")
        copyFile(Dir["#{buildDirectoryPath}*.desktop"],"#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/")
    end

end
