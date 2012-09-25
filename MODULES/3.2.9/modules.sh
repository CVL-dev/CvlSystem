#----------------------------------------------------------------------#
# system-wide profile.modules                                          #
# Initialize modules for all sh-derivative shells                      #
#----------------------------------------------------------------------#
trap "" 1 2 3

case "$0" in
    -bash|bash|*/bash) . /usr/local/Modules/default/init/bash ;; 
       -ksh|ksh|*/ksh) . /usr/local/Modules/default/init/ksh ;; 
          -sh|sh|*/sh) . /usr/local/Modules/default/init/sh ;; 
                    *) . /usr/local/Modules/default/init/sh ;; 	# default for scripts
esac

trap 1 2 3
