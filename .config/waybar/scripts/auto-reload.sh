while inotifywait -e close_write ~/.config/waybar/colors.css 2>/dev/null; do
    killall -SIGUSR2 waybar 2>/dev/null && continue
    pkill waybar 2>/dev/null; waybar & disown
done