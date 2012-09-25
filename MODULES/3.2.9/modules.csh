#----------------------------------------------------------------------#
# system-wide csh.modules                                              #
# Initialize modules for all csh-derivative shells                     #
#----------------------------------------------------------------------#
if ($?tcsh) then
	set modules_shell="tcsh"
else
	set modules_shell="csh"
endif

source /usr/local/Modules/default/init/${modules_shell}

unset modules_shell
