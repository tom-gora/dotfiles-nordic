#! /bin/zsh

virsh start win11;                                                                                                                                                                                        1 ✘  18:18:17 ▓▒░
virt-viewer -f win11 &;
xdotool search --name "Windows 11" set_desktop_for_window 1 &;
xdotool set_desktop 1 &;
