#!/bin/bash
# this be tested on Debian
# ref:
#   https://unix.stackexchange.com/questions/378373/add-virtual-output-to-xorg
#   https://github.com/kbumsik/VirtScreen/issues/16#issuecomment-865128729
#   https://github.com/dianariyanto/virtual-display-linux
#   https://manpages.debian.org/testing/xserver-xorg-video-intel/intel.4.en.html   
#   https://www.x.org/releases/current/doc/man/man5/xorg.conf.5.xhtml
#   https://www.x.org/releases/current/doc/man/man5/xorg.conf.5.xhtml#heading12
#   https://github.com/DisplayLink/evdi
# todo:
#   1. amd/nvidia should support virtual output too, chatgpt told me at least
#   2. for hardware encoding, you may need something like:
#        aptitude install libmfx-dev libva-dev intel-media-va-driver-non-free

if ![ -e /etc/X11/xorg.conf.d/20-intel.conf]; then
        sudo tee /etc/X11/xorg.conf.d/20-intel.conf <<EOF
# these modelines dump from a fake hdmi dongle
Section "Monitor"
    	Identifier      "MonitorVirtual"
	Modeline "1920x1080"  148.50  1920 2008 2052 2200  1080 1084 1089 1125 +hsync +vsync
        Modeline "2880x1800"  167.00  2880 2910 2920 3030  1800 1820 1828 1836 +hsync +vsync
        Modeline "2560x1600"  268.50  2560 2608 2640 2720  1600 1603 1609 1646 +hsync +vsync
        Modeline "2560x1440"  241.50  2560 2608 2640 2720  1440 1443 1449 1481 +hsync +vsync
        Modeline "1366x768"   85.50  1366 1436 1579 1792  768 771 774 798 +hsync +vsync
        Modeline "720x480"   27.00  720 736 798 858  480 489 495 525 -hsync -vsync
        Modeline "1280x720"   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync
        Modeline "1920x1080i"   74.25  1920 2008 2052 2200  1080 1084 1094 1125 interlace +hsync +vsync
        Modeline "720x576"   27.00  720 732 796 864  576 581 586 625 -hsync -vsync
        Modeline "1280x720"   74.25  1280 1720 1760 1980  720 725 730 750 +hsync +vsync
        Modeline "1920x1080i"   74.25  1920 2448 2492 2640  1080 1084 1094 1125 interlace +hsync +vsync
        Modeline "1440x576i"   27.00  1440 1464 1590 1728  576 580 586 625 interlace -hsync -vsync
        Modeline "1920x1080"   74.25  1920 2558 2602 2750  1080 1084 1089 1125 +hsync +vsync
        Modeline "1920x1080"   74.25  1920 2448 2492 2640  1080 1084 1089 1125 +hsync +vsync
        Modeline "1920x1080"   74.25  1920 2008 2052 2200  1080 1084 1089 1125 +hsync +vsync
        Modeline "1920x1080"  148.50  1920 2448 2492 2640  1080 1084 1089 1125 +hsync +vsync
        Modeline "1920x1080"  297.00  1920 2008 2052 2200  1080 1084 1089 1125 +hsync +vsync
        Modeline "800x600"   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync
        Modeline "640x480"   25.18  640 656 752 800  480 490 492 525 -hsync -vsync
        Modeline "1024x768"   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync
        Modeline "1280x1024"  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync
        Modeline "1280x800"   71.00  1280 1328 1360 1440  800 803 809 823 +hsync -vsync
        Modeline "1440x900"   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync
        Modeline "1600x900"  119.00  1600 1696 1864 2128  900 901 904 932 -hsync +vsync
        Modeline "1680x1050"  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync
        Modeline "1600x1200"  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync
        Modeline "1920x1200"  154.00  1920 1968 2000 2080  1200 1203 1209 1235 +hsync -vsync
        Modeline "2560x1440_120.00"  661.25  2560 2784 3064 3568  1440 1443 1448 1545 -hsync +vsync
        Modeline "1680x1050_120.00"  313.75  1680 1816 2000 2320  1050 1053 1059 1128 -hsync +vsync
	Option "DPMS" "false"
	Option "Enable" "true"
        Option "PreferredMode" "1680x1050"        
EndSection

Section "Device"
        Identifier "intelgpu0"
        Option "Monitor-VIRTUAL1" "MonitorVirtual"
        Driver "intel"
        Option "VirtualHeads" "1"
EndSection

EOF
    sudo systemctl restart display-manager
    sleep 2
    sudo systemctl restart nxserver
    sleep 1
fi

# export DISPLAY=:0.0
# xrandr --newmode "1680x1050_60.00"  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync
# xrandr --addmode VIRTUAL1 "1680x1050_60.00"
# # all the magic trigger here
# xrandr --output VIRTUAL1 --mode "1680x1050_60.00"
