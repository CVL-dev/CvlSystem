#!/bin/sh
# \
exec `which tclsh` "$0" ${1+"$@"}

proc run_test_script {testFile module version} {

    if {[catch {exec $testFile} result]} {
        puts stderr "Long validation $module $version failed: $result"
        exit 2
    } 
}

proc run_test_command {testCommand module version} {
    if {[catch {open "|$testCommand" "r"} result]} {
        puts stderr "Short validation $module $version failed: $result"
        exit 2
    } 
}

proc validate_module {testCommand module version} {
    run_test_command $testCommand $module $version
    set testFile "/usr/local/$module/$version/validate_module.sh"
    if [file exists $testFile] {
        run_test_script $testFile $module $version
    }
}

