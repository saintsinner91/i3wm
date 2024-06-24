#!/bin/bash

# Install necessary packages
sudo pacman -S nvidia nvidia-utils nvidia-libgl arandr sddm polkit-gnome picom dunst feh brave kitty google-chrome ranger i3lock dmenu

# Enable SDDM service
sudo systemctl enable sddm

# Start SDDM service
sudo systemctl start sddm

# Configure i3lock
sudo tee /etc/systemd/system/i3lock.service <<EOF
[Unit]
Description=i3lock
Before=sleep.target

[Service]
User=$USER
ExecStart=/usr/bin/i3lock
Type=forking

[Install]
WantedBy=sleep.target
EOF

# Enable i3lock service
sudo systemctl enable i3lock

# Add i3 config
sudo tee ~/.config/i3/config <<EOF
set $Locker i3lock && sleep 1

set $mode_system System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown
mode "$mode_system" {
    bindsym l exec --no-startup-id $Locker, mode "default"
    bindsym e exec --no-startup-id i3-msg exit, mode "default"
    bindsym s exec --no-startup-id $Locker && systemctl suspend, mode "default"
    bindsym h exec --no-startup-id $Locker && systemctl hibernate, mode "default"
    bindsym r exec --no-startup-id systemctl reboot, mode "default"
    bindsym Shift+s exec --no-startup-id systemctl poweroff -i, mode "default"

    # back to normal: Enter or Escape
    bindsym Return mode "default"
    bindsym Escape mode "default"
}

bindsym $mod+Pause mode "$mode_system"

# Manual management of external displays
set $mode_display Ext Screen (v) VGA ON, (h) HDMI ON, (x) VGA OFF, (y) HDMI OFF
mode "$mode_display" {
    bindsym v exec --no-startup-id xrandr --output VGA1 --auto --right-of LVDS1, mode "default"
    bindsym h exec --no-startup-id xrandr --output HDMI1 --auto --right-of LVDS1, mode "default"
    bindsym x exec --no-startup-id xrandr --output VGA1 --auto --off, mode "default"
    bindsym y exec --no-startup-id xrandr --output HDMI1 --auto --off, mode "default"

    # back to normal: Enter or Escape
    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym $mod+x mode "$mode_display"
EOF
