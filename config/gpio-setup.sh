#!/bin/bash
# GPIO Configuration Script for Jetson Orin Nano
# Run this script to configure GPIO pins for your application

# Export GPIO pins
echo "Configuring GPIO pins..."

# GPIO 79 (Pin 12) - Output for LED
echo 79 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio79/direction
echo 0 > /sys/class/gpio/gpio79/value

# GPIO 80 (Pin 16) - Input for button  
echo 80 > /sys/class/gpio/export
echo in > /sys/class/gpio/gpio80/direction

# GPIO 81 (Pin 18) - PWM output
echo 81 > /sys/class/gpio/export  
echo out > /sys/class/gpio/gpio81/direction

# Set permissions for jetson user
chown jetson:gpio /sys/class/gpio/gpio79/value
chown jetson:gpio /sys/class/gpio/gpio80/value
chown jetson:gpio /sys/class/gpio/gpio81/value

chmod 664 /sys/class/gpio/gpio79/value
chmod 664 /sys/class/gpio/gpio80/value
chmod 664 /sys/class/gpio/gpio81/value

echo "GPIO configuration complete!"

# Example usage:
# LED on:  echo 1 > /sys/class/gpio/gpio79/value
# LED off: echo 0 > /sys/class/gpio/gpio79/value
# Read button: cat /sys/class/gpio/gpio80/value