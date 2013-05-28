set(CvlDefaultComment "HPC applications")

set(CvlDefaultIcon "applications-system")

SetCvlPath(CVL_PATH)

function(SetModuleFile description version singleCommand base)

set(template "#%Module1.0#######################################################################
## $name modulefile
##

set ver [lrange [split [ module-info name ] / ] 1 1 ]
set name [lrange [split [ module-info name ] / ] 0 0 ]
set loading [module-info mode load]

proc ModulesHelp { } {
puts stderr \"tThis module sets the environment for $name v$ver\"
}
set ModulesVersion ${version}
set ModuleDescription \"${description}\"
set ValidationSource {/usr/local/bin/validate_module.tcl}

module-whatis   \"$ModuleDescription (v$ModulesVersion)\"

prepend-path LD_LIBRARY_PATH /usr/local/$name/$ver/lib
prepend-path MANPATH /usr/local/$name/$ver/share/man
prepend-path PATH /usr/local/$name/$ver/bin

set single_command \"${singleCommand}\" 
if {$loading && [file exists $ValidationSource]} {
    source $ValidationSource
    validate_module $single_command $name $ver
}
")

set(${base} "${template}" PARENT_SCOPE)

endfunction(SetModuleFile)

function(SetVersion versionNumber versionFile)
set(template "#%Module1.0###########################################################
##
## version file
##
set ModulesVersion ${versionNumber}")
set(${versionFile} "${template}" PARENT_SCOPE)
endfunction(SetVersion)

function(SetPostScriptFile module directory scriptFile)
set(internalScript "
cp ${directory}/.version -f /usr/local/Modules/modulefiles/${module}")

set(${scriptFile} "${internalScript}" PARENT_SCOPE)
endfunction(SetPostScriptFile)

set(CvlMenuDeclaration "<!DOCTYPE Menu PUBLIC \"-//freedesktop//DTD Menu 1.0//EN\" \"http://www.freedesktop.org/standards/menu-spec/1.0/menu.dtd\">")

#
# First try to set a menu layout particualry for CVL project. But if we need to
# support other project menu layout, it should separate the specific parameters
# from common definitions here. Todo ...
# 
set(CvlMenu "menus")
set(CvlMenuRoot "cvl")
set(CvlMerge "applications-merged")
set(CvlMenuApplication "application")
set(CvlMenuLocation "/usr/local/share/xdg/menus/applications-merged/${CvlMenuApplication}")
set(CvlMenuToolbox "toolbox")
set(CvlMenuStructuralBiologyDriver "structural-biology")
set(CvlMenuNeuroimagingDriver "neuroimaging")
set(CvlMenuEnergyMaterialsDriver "energy-materials")
set(CvlMenuEnergyMaterialsAtom "energy-materials-atom")
set(CvlMenuEnergyMaterialsXray "energy-materials-xray")
set(CvlMenuSystem "system")
set(CvlDesktopDirectory "desktop-directories")
set(CvlDesktop "applications")

# Menu names
set(CvlMenuName "Characterisation Virtual Laboratory")
set(CvlTooboxName "Toolbox")
set(CvlSystemName "System")
set(CvlMenuStructuralBiologyName "Structural Biology")
set(CvlMenuNeuroimagingName "Neuroimaging")
set(CvlMenuEnergyMaterialsName "Energy Materials")
set(CvlMenuEnergyMaterialsAtomName "Energy Materials Atom Probe Workbench")
set(CvlMenuEnergyMaterialsXrayName "Energy Materials Xray Workbench")

set(CvlMenuSourcePrefix "${CMAKE_BINARY_DIR}/${CvlMenu}")
set(CvlMenuMergeSource "${CvlMenuSourcePrefix}/${CvlMerge}")

set(CvlMenuApplicationSourcePath "${CvlMenuMergeSource}/${CvlMenuApplication}")
set(CvlMenuToolboxSourcePath "${CvlMenuApplicationSourcePath}/${CvlMenuToolbox}")
set(CvlMenuDriverSourcePath "${CvlMenuApplicationSourcePath}/${CvlMenuDriver}")
set(CvlMenuSystemSourcePath "${CvlMenuApplicationSourcePath}/${CvlMenuSystem}")
set(CvlDirectorySourcePath "${CvlMenuSourcePrefix}/${CvlDesktopDirectory}")
set(CvlDesktopSourcePath "${CvlMenuSourcePrefix}/${CvlDesktop}")

set(CvlMenuTargetRootPrefix "/etc/xdg/menus")
set(CvlMenuTargetPrefix "/usr/local/share/xdg/menus")
#set(CvlDirectoryTargetPrefix "/usr/share")
set(CvlDirectoryTargetPrefix "/usr/local/share")
set(CvlMenuRootMergeTargetPath "${CvlMenuTargetRootPrefix}/${CvlMerge}")
set(CvlMenuMergeTargetPath "${CvlMenuTargetPrefix}/${CvlMerge}")
#set(CvlMenuApplicationTargetPath "${CvlMenuMergeTargetPath}")
set(CvlMenuApplicationTargetPath "${CvlMenuMergeTargetPath}/${CvlMenuApplication}")
set(CvlMenuToolboxTargetPath "${CvlMenuApplicationTargetPath}/${CvlMenuToolbox}")
set(CvlMenuDriverTargetPath "${CvlMenuApplicationTargetPath}/${CvlMenuDriver}")
set(CvlMenuSystemTargetPath "${CvlMenuApplicationTargetPath}/${CvlMenuSystem}")
set(CvlDirectoryTargetPath "${CvlDirectoryTargetPrefix}/${CvlDesktopDirectory}")
set(CvlDesktopTargetPath "${CvlDirectoryTargetPrefix}/${CvlDesktop}")

function(GenerateRunScript filename path depedencies module version licenseAgreement)
set(template "#!/bin/sh
#
# CVL run script for GUI applications.
#\n")

if(NOT licenseAgreement STREQUAL "None")
set(template "${template}
if [ ! -f \"${licenseAgreement}\" ]; then
    module load cvl
    CvlLicenseErrorMessage.py
    exit 1
fi
\n")
endif()

    set(fqpn "${path}/${filename}-run")
    file(WRITE ${fqpn} "${template}\nVIS=$(which cvlvisrun)\nmodule load ${module}/${version}\n")

    if(NOT depedencies STREQUAL "NO")
        string(REPLACE ":" ";" dependencyList ${depedencies})
        foreach(dependency IN LISTS dependencyList)
            file(APPEND ${fqpn} "module load ${dependency}\n") 
        endforeach()
    endif()

    file(APPEND ${fqpn} "\${VIS} ${filename}\n")
#    file(APPEND ${fqpn} "${template}\nVIS=$(which cvlvisrun)\nmodule load ${module}/${version}\n\${VIS} ${filename}\n")

    # Bug in cmake
    ChangeFileAccessPermission(${fqpn} "755")
endfunction(GenerateRunScript)

function(GetCvlDesktopDirectoryFile filename)
    set(${filename} "cvl-${${PROJECT_NAME}_APPLICATION_NAME}")
endfunction(GetCvlDesktopDirectoryFile)

function(GetCvlDesktopFile filename)
    set(${filename} "cvl-${${PROJECT_NAME}_APPLICATION_NAME}-${${PROJECT_NAME}_VERSION}")
endfunction(GetCvlDesktopFile)

function(SetCvlTopMenu parentName menuName directoryName mergeDirectory menu)
set(template "${CvlMenuDeclaration}
<Menu>
    <Name>${parentName}</Name>
    <Layout>
        <Merge type=\"menus\" />
        <Menuname>${menuName}</Menuname>
    </Layout>
    <Menu>
        <Name>${menuName}</Name>
        <Directory>${directoryName}.directory</Directory>
        <MergeDir>${mergeDirectory}</MergeDir>
    </Menu>
</Menu>")
set(${menu} ${template} PARENT_SCOPE)
endfunction(SetCvlTopMenu)

function(SetCvlApplicationMenu menuName directoryName category menu parentName)
set(template "${CvlMenuDeclaration}
<Menu>
    <Name>${parentName}</Name>
    <Menu>
        <Name>${menuName}</Name>
        <Directory>${directoryName}.directory</Directory>
        <Include>
            <And>
                <Category>X-CVL-${category}</Category>
            </And>
        </Include>
    </Menu>
</Menu>")
set(${menu} ${template} PARENT_SCOPE)
endfunction(SetCvlApplicationMenu)

function(SetMenuDirectory name icon comment directory)
set(template "[Desktop Entry]
Comment=${comment}
GenericName=
Icon=${icon}
Type=Directory
Name=${name}")
set(${directory} ${template} PARENT_SCOPE)
endfunction(SetMenuDirectory)

function(SetMenuDesktop name filename path category icon comment addTerminal licenseAgreement desktop)

set(template "[Desktop Entry]
Type=Application
Comment=${comment}
Exec=${path}/${filename}
GenericName=
Icon=${icon}
Name=${name}
StartupNotify=true
Categories=X-CVL-${category}")

if(addTerminal)
set(template "${template}
Terminal=1
TerminalOptions=--noclose -T ${name} \"Debug Window\"")
endif()

# Disable it, due to xfce bug.
#if(NOT licenseAgreement STREQUAL "None")
#set(template "${template}
#TryExec=\"${licenseAgreement}\"")
#endif()

set(${desktop} "${template}" PARENT_SCOPE)
endfunction(SetMenuDesktop)

function(InstallMenuDirectory directoryName applicationName icon comment menuName applicationCategory groupCategory parentName)

    if(icon STREQUAL "")
        set(icon "package")
    endif()

    if(comment STREQUAL "")
        set(comment "HPC application")
    endif()
   
    # Set application menu
    string(TOUPPER ${applicationName} ApplicationName)

    if(groupCategory STREQUAL "None")
        set(fileName ${applicationName})
        SetCvlApplicationMenu(${ApplicationName} "cvl-${applicationName}" "${applicationCategory}" menu ${parentName})
    else()
        set(fileName ${groupCategory})
        SetCvlApplicationMenu(${groupCategory} "cvl-${groupCategory}" "${applicationCategory}" menu ${parentName})
    endif()

    file(WRITE "${CvlMenuApplicationSourcePath}/${directoryName}/cvl-${fileName}.menu" ${menu})

    # Set application directory
    SetMenuDirectory(${menuName} ${icon} ${comment} directory)
#    SetMenuDirectory(${ApplicationName} ${icon} ${comment} directory)
    file(WRITE "${CvlDirectorySourcePath}/cvl-${fileName}.directory" ${directory})

    # Todo: component installation
    install(FILES "${CvlMenuApplicationSourcePath}/${directoryName}/cvl-${fileName}.menu" DESTINATION ${CvlMenuApplicationTargetPath}/${directoryName})
    install(FILES "${CvlDirectorySourcePath}/cvl-${fileName}.directory" DESTINATION ${CvlDirectoryTargetPath})
endfunction(InstallMenuDirectory)

function(CheckOrSetDefaultComment comment)
    if(NOT comment)
        set(${comment} ${CvlDefaultComment} PARENT_SCOPE)
    endif()
endfunction(CheckOrSetDefaultComment)

function(SetMenuComment name comment)
    set(${comment} "${CvlDefaultComment} ${name}" PARENT_SCOPE)
endfunction(SetMenuComment)

function(CheckOrSetDefaultIcon icon)
    if(NOT icon)
        set(${icon} ${CvlDefaultIcon} PARENT_SCOPE)
    endif()
endfunction(CheckOrSetDefaultIcon)

# This function cannot be used, if the parameter dependency is not set or "",
# it implies that no parameter in the function call and resulting an error.
function(CheckOrSetDependency dependency)
    if(NOT dependency)
        set(${dependency} "NO" PARENT_SCOPE)
    endif()
endfunction(CheckOrSetDependency)

function(InstallMenuDesktop desktopName applicationName desktopComment desktopIcon filename fqpn dependencyList version addTerminal license category)

#    string(TOUPPER ${applicationName} category)

    SetMenuDesktop("${desktopName}" "${filename}-run" "${fqpn}" "${category}" "${desktopIcon}" "${desktopComment}" "${addTerminal}" "${license}" desktop)

    set(desktopFile "cvl-${applicationName}-${version}-${filename}.desktop")
    file(WRITE "${CvlDesktopSourcePath}/${desktopFile}" ${desktop})
    
    # Todo: component installation.
    install(FILES "${CvlDesktopSourcePath}/${desktopFile}" DESTINATION "${CvlDesktopTargetPath}")

    GenerateRunScript(${filename} ${fqpn} ${dependencyList} ${applicationName} ${version} "${license}")

endfunction(InstallMenuDesktop)

function(InstallCvlMenuBase)

    if(NOT EXISTS "${CvlMenuMergeSource}/${CvlMenuRoot}.menu")
        # Setup top menu
        SetCvlTopMenu("Applications" ${CvlMenuName} ${CvlMenuRoot} ${CvlMenuLocation} cvlMenu)
        file(WRITE ${CvlMenuMergeSource}/${CvlMenuRoot}.menu ${cvlMenu})

        SetMenuDirectory(${CvlMenuName} "system-search" ${CvlMenuName} directory)
        file(WRITE "${CvlDirectorySourcePath}/cvl.directory" ${directory})
    endif()

    # Todo: fix it for component installation.
    install(FILES "${CvlMenuMergeSource}/${CvlMenuRoot}.menu" DESTINATION ${CvlMenuRootMergeTargetPath})
    install(FILES "${CvlMenuMergeSource}/${CvlMenuRoot}.menu" DESTINATION ${CvlMenuMergeTargetPath})
    install(FILES "${CvlDirectorySourcePath}/cvl.directory" DESTINATION ${CvlDirectoryTargetPath})
endfunction(InstallCvlMenuBase)

function(InstallCvlApplicationMenu menuName type icon)
    
    set(filename "cvl-${type}")
    set(menuFqpn "${CvlMenuApplicationSourcePath}/${filename}.menu")
    set(directoryFqpn "${CvlDirectorySourcePath}/${filename}.directory")
    
    if(NOT EXISTS "${menuFqpn}")
        # Setup application menu
        SetCvlTopMenu(${CvlMenuName} ${menuName} ${filename} ${type} menu)

        file(WRITE ${menuFqpn} ${menu})
        SetMenuDirectory(${menuName} "${icon}" "HPC applications" directory)
        file(WRITE "${directoryFqpn}" ${directory})
    endif()

    # Todo: fix it for component installation.
    install(FILES "${menuFqpn}" DESTINATION "${CvlMenuApplicationTargetPath}/${path}")
    install(FILES "${directoryFqpn}" DESTINATION "${CvlDirectoryTargetPath}")

endfunction(InstallCvlApplicationMenu)

function(InstallCvlMenu menuName directoryName applicationName directoryMenuName directoryComment directoryIcon menuIcon applicationCategory groupCategory)
    
    # Install top menu
    InstallCvlMenuBase()
    
    # Install application menu
    InstallCvlApplicationMenu(${menuName} ${directoryName} ${menuIcon})
    
    # Install menu directory 
    InstallMenuDirectory(${directoryName} ${applicationName} ${directoryIcon} ${directoryComment} ${directoryMenuName} ${applicationCategory} ${groupCategory} ${menuName}) 
    
endfunction(InstallCvlMenu)

function(SetLicenseAgreementFile prefix licenseFile agreement output)

set(binDirectory "${prefix}/bin")

if(NOT (EXISTS "${binDirectory}" AND IS_DIRECTORY "${binDirectory}"))
    file(MAKE_DIRECTORY "${binDirectory}")
endif()

set(fileName "license-agreement")
set(fileFullPath "${binDirectory}/${fileName}")

set(licenseScript "#!/bin/sh
module load cvl
CvlLicense.sh ${prefix}/${licenseFile} ${agreement}")

file(WRITE "${fileFullPath}" ${licenseScript})
ChangeFileAccessPermission("${fileFullPath}" "755")

set(${output} "${fileName}" PARENT_SCOPE)
endfunction(SetLicenseAgreementFile)

function(SetLicenseAgreementMenu category applicationName applicationVersion installDirectory licenseFile)
    set(menuName "License Agreement")
    SetLicenseAgreement(${applicationName} ${applicationVersion} agreement)
    SetLicenseAgreementFile(${installDirectory} ${licenseFile} ${agreement} filename)
    set(comment "${applicationName} ${applicationVersion} license agreement")
    set(icon "document")
    set(dependencyList "NO")
    set(terminal false)
    set(license "None")
    set(fqpn "${installDirectory}/bin")
    InstallMenuDesktop("${menuName}" ${applicationName} ${comment} ${icon} ${filename} ${fqpn} ${dependencyList} ${applicationVersion} ${terminal} ${license} ${category})
endfunction(SetLicenseAgreementMenu)

