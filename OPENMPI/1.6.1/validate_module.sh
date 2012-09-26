#!/bin/sh
#
# This script is used to verify and validate installed applications.
#

# Add a single test command 
SINGLE_TEST="mpirun --version"

# Add multiple test commands
function MultipleTests()
{
    mpiCC --version
    mpicc --version
#    mpic++ --version
}

case "$1" in
    -s|--single-test)
        echo -n ${SINGLE_TEST}
        ;;
    *)            
        MultipleTests
        ;;
esac
