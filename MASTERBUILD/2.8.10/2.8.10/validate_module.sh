#!/bin/sh
#
# This script is used to verify and validate installed applications.
#

# Add a single test command 
SINGLE_TEST="cmake --version"

# Add multiple test commands
function MultipleTests()
{
    cmake --version
    ccmake --version
}

case "$1" in
    -s|--single-test)
        echo -n ${SINGLE_TEST}
        ;;
    *)            
        MultipleTests
        ;;
esac
