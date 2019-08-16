if [`pgrep unagi` -gt 0]
then
    killall unagi
else
    unagi
fi