include(CvlIcon)

GetMenuParameter(Type subtype directory desktop)

if(Type)

    string(TOLOWER ${Type} type)

    if(type STREQUAL "cvl")
        string(TOLOWER ${subtype} projectType)
        string(REPLACE ":" ";" stringList ${directory})
        list(LENGTH stringList CheckLength)
        if(CheckLength LESS 2)
            message(FATAL_ERROR "error: invalid MenuDirectory value ${directory}")
        endif() 
        list(GET stringList 0 directoryName)
        list(GET stringList 1 dicon)
        if(CheckLength GREATER 2)
            list(GET stringList 2 applicationCategory)
            set(groupCategory ${applicationCategory})
        else()
            set(applicationCategory "${${PROJECT_NAME}_APPLICATION_NAME}")
            set(groupCategory "None")
        endif()
        
        string(TOUPPER ${applicationCategory} applicationCategory)

        SetMenuComment("${directoryName}" directoryComment)

        # Check and install full path if icon is from package.
        SetPath(${dicon} ${${PROJECT_NAME}_INSTALL_DIR} directoryIcon)

        if(projectType STREQUAL "${CvlMenuToolbox}")
            set(projectMenuName ${CvlTooboxName})
            set(projectMenuIcon ${CvlTooboxIcon})
        elseif(projectType STREQUAL "${CvlMenuStructuralBiologyDriver}")
            set(projectMenuName ${CvlMenuStructuralBiologyName})
            set(projectMenuIcon ${CvlStructuralBiologyIcon})
        elseif(projectType STREQUAL "${CvlMenuNeuroimagingDriver}")
            set(projectMenuName ${CvlMenuNeuroimagingName})
            set(projectMenuIcon ${CvlMenuNeuroimagingIcon})
        elseif(projectType STREQUAL "${CvlMenuEnergyMaterialsDriver}")
            set(projectMenuName ${CvlMenuEnergyMaterialsName})
            set(projectMenuIcon ${CvlMenuEnergyMaterialsIcon})
        elseif(projectType STREQUAL "${CvlMenuEnergyMaterialsAtom}")
            set(projectMenuName ${CvlMenuEnergyMaterialsAtomName})
            set(projectMenuIcon ${CvlMenuEnergyMaterialsAtomIcon})
        elseif(projectType STREQUAL "${CvlMenuEnergyMaterialsXray}")
            set(projectMenuName ${CvlMenuEnergyMaterialsXrayName})
            set(projectMenuIcon ${CvlMenuEnergyMaterialsXrayIcon})
        elseif(projectType STREQUAL "${CvlMenuSystem}")
            set(projectMenuName ${CvlSystemName})
            set(projectMenuIcon ${CvlSystemIcon})
        else()
            message(WARNING "Unkown menu projectType ${projectType}")
        endif()

        if(projectMenuName)

            CheckOrSetDefaultIcon(${directoryIcon})
            InstallCvlMenu(${projectMenuName} ${projectType} ${${PROJECT_NAME}_APPLICATION_NAME} "${directoryName}" "${directoryComment}" ${directoryIcon} ${projectMenuIcon} ${applicationCategory} ${groupCategory})
        
            if(desktop)
                GetLibraryDependencyList(dependencyList)
                if(NOT dependencyList)
                    set(dependencyList "NO")
                endif()

                set(licenseAgreementFile "None")

                foreach(d IN LISTS desktop)
                    string(STRIP ${d} d)
                    string(REPLACE ":" ";" stringList ${d})
                    list(LENGTH stringList CheckLength)
                    if(CheckLength LESS 4)
                        message(FATAL_ERROR "error: invalid MenuDesktop value ${d}")
                    endif() 
                    list(GET stringList 0 binaryFile)
                    list(GET stringList 1 applicationMenuName)
                    list(GET stringList 2 icon)
                    list(GET stringList 3 addTerminal)

                    if(CheckLength GREATER 4)
                        list(GET stringList 4 licenseFile)
                    else()
                        set(licenseFile "None")
                    endif()

                    SetMenuComment("${applicationMenuName}" desktopComment)

                    CheckOrSetDefaultIcon(${icon})
                    GetDirectoryName(${binaryFile} parent)
                    if(parent STREQUAL ".")
                        set(fqpn "${${PROJECT_NAME}_INSTALL_DIR}")
                    else()
                        set(fqpn "${${PROJECT_NAME}_INSTALL_DIR}/${parent}")
                    endif()

                    # Check if the icon is from pacakge installation location
                    SetPath(${icon} ${${PROJECT_NAME}_INSTALL_DIR} desktopIcon)

                    GetFilename(${binaryFile} filename)

                    if(licenseFile STREQUAL "None")
                        set(applicationLicense "None")
                    else()
                        SetLicenseAgreement(${${PROJECT_NAME}_APPLICATION_NAME} ${${PROJECT_NAME}_VERSION} applicationLicense) 
                        if(licenseAgreementFile STREQUAL "None") 
                            set(licenseAgreementFile "${licenseFile}")
                        endif()
                    endif()

                    InstallMenuDesktop("${applicationMenuName}" ${${PROJECT_NAME}_APPLICATION_NAME} ${desktopComment} ${desktopIcon} ${filename} ${fqpn} ${dependencyList} ${${PROJECT_NAME}_VERSION} ${addTerminal} ${applicationLicense} ${applicationCategory})

                endforeach()
                
                if(NOT licenseAgreementFile STREQUAL "None")
                    SetLicenseAgreementMenu(${applicationCategory} ${${PROJECT_NAME}_APPLICATION_NAME} ${${PROJECT_NAME}_VERSION} ${${PROJECT_NAME}_INSTALL_DIR} ${licenseAgreementFile})
                endif()
            endif()
        endif()
    else()
        message(WARNING "Unkown menu type ${type}")
    endif()
else()        
    message(STATUS "No menu configuration")
endif()
