#!/usr/bin/bash

# To restart dwm without logging out or
# closing applications, change or add a
# startup script so that it loads dwm in
# a while loop, for example:
# dwm can now be restarted without destroying other
# X windows by pressing the usual Mod-Shift-Q combination.
# It is a good idea to place the above startup script
# into a separate file, ~/bin/startdwm for instance, and
# execute it through ~/.xinitrc. Consider running the script
# with exec to avoid security implications with remaining
# logged in after the X server is terminated; see Xinit#Autostart
# X at login for more information. From this point on, when you
# wish to end the X session, simply execute pkill dwm, or
# bind it to a convenient keybind.

while true; do
    # Log stderror to a file
    dwm 2> ~/.dwm.log
    # No error logging
    #dwm >/dev/null 2>&1
done
