# RGB realtime led Power with homewizzard (KilloWatt/Hour) Indicator

## A Short video
Youtube link: https://www.youtube.com/watch?v=imgvzoSaZbI <br />
[![IMAGE VIDEO](https://img.youtube.com/vi/imgvzoSaZbI/0.jpg)](https://www.youtube.com/watch?v=imgvzoSaZbI)<br />

## What does it do?
First of all you need a smart p1 power meter in your home.
The current power used in your home will be translated into a RGB colour.
So for example we can set the colour according to the used Kilowatts. for example under 500 watts the led will be green, from 500 to 1500 watts it will be yellow and all above will be red. in beween the colours are faded into eachother to get a smoother effect.
We use Wifi Leds from MI Light, these settings can be adjusted.

## What do we need?
- A homewizzard P1 meter reader, check: https://www.homewizard.com/p1-meter/
  the script will connect the api, make sure that its enabled in the settings of homewizzard (its enabled by default)
- A Raspberry 3 or a Linux system to run the script

- MI light wifi bulb <br>
![shopping](https://user-images.githubusercontent.com/13587295/191190398-d194c220-f271-432f-adc2-7f5205767242.png)

- MI Light wifi gateway <br>
![mi-light-wifi-module-mat-wit](https://user-images.githubusercontent.com/13587295/191190309-77555394-f8e9-483b-8dae-2b96672886a5.jpg)


## Before we start
- Edit the homewizzardp1.py and set ipad = "192.168.1.56" to the ip of the homewizzard
- Edit start_watt.txt and eind_watt.txt to your needs, it contains the starting wattage and ending wattage
- For the colour you can change colour_start.txt and colour_end.txt, for example colour 90 in RGB =  90, 0, 0  see https://rgb.to/ for reference
- Make sure you have installed guile: sudo apt-get install guile-2.0
- Edit KWh_TO_LED.sh and change the ip to your MI Light wifi gateway, leave the port as it is

## Start
- Now start the script with Python3 homewizzardp1.py and it will update the lamp of the colour every 10seconds





