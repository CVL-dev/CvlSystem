#
# Define CVL package information and properties
#
# Set package description
set(${PROJECT_NAME}_DESCRIPTION_SUMMARY "CVL ${PROJECT_NAME} package")

# Set vendor
set(${PROJECT_NAME}_PACKAGE_VENDOR "CVL")

string(TOLOWER ${PROJECT_NAME} CvlProjectNameLowerCase)
string(REPLACE "." "_" CvlProjectNameLowerCaseDash ${CvlProjectNameLowerCase})
# Set package name
#set(${PROJECT_NAME}_CPACK_PACKAGE_NAME "cvl-${${PROJECT_NAME}_APPLICATION_NAME}")
set(${PROJECT_NAME}_CPACK_PACKAGE_NAME "cvl-${CvlProjectNameLowerCaseDash}")

SetRpmPackageRequires(${PROJECT_NAME}_RPM_PACKAGE_REQUIRES)
