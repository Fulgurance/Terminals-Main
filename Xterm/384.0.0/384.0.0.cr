class Target < ISM::Software
    
    def prepare
        super

        fileReplaceText(path:       "#{buildDirectoryPath}/termcap",
                        text:       ":tc=xterm-new:",
                        newText:    ":tc=xterm-new:kb=^?:")

        fileAppendData( path:   "#{buildDirectoryPath}/terminfo",
                        data:   "\tkbs=\\177,")
    end

    def configure
        super

        configureSource(arguments:      "--prefix=/usr          \
                                        --sysconfdir=/etc       \
                                        --localstatedir=/var    \
                                        --disable-static        \
                                        --with-app-defaults=/etc/X11/app-defaults",
                        path:           buildDirectoryPath,
                        environment:    {"TERMINFO" => "/usr/share/terminfo"})
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install-ti",
                    path:       buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications")

        copyFile(   "#{buildDirectoryPath}*.desktop",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/")
    end

end
