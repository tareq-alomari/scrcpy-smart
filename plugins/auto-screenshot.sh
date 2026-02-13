#!/bin/bash
# Example Plugin: Auto Screenshot Every 5 Seconds

echo "📸 Auto Screenshot Plugin"
echo "Taking screenshots every 5 seconds..."
echo "Press Ctrl+C to stop"

count=1
while true; do
    scrcpy-smart --screenshot
    echo "Screenshot $count taken"
    ((count++))
    sleep 5
done
