#!/bin/bash
#milight controller
#sudo apt-get install guile-2.0
ipaddress="192.168.1.105"
portnum="8899"

#eindcommand
ctrl="\x55"
#zone 0 tm 4 >>  "\x42" "\x45" "\x47" "\x49" "\x4B"
zone="\X42"
#kleurcommand
cmd="\x40"
#prefix
pre="\x"
null="\x00"

#-----------------------------------------------------------SCRIPT----------------------------------------------------------------
#start HUE (0-255) value green colour = 90
#swrd=90
swrd=$(tail -1 colour_start.txt)

#end value hue ring (0-255) 
#ewrd=176
ewrd=$(tail -1 colour_end.txt)

#start at KWH (0-3680) 
#bkwh=0
bkwh=$(tail -1 start_watt.txt)

#eindkwh (0-3680) 
#ekwh=3000
ekwh=$(tail -1 eind_watt.txt)

#kijk of er een txt aanwezig is met een reeds opgeslagen waarde:
if [[ ! -e kwhnow.txt ]]; then
    echo "kwhnow.txt bestand niet gevonden" > ERROR.txt
    echo "" > LOG_CMD.txt
    sleep 5
    continue
fi

if [[ ! -e HUE.txt ]]; then
    touch HUE.txt
    echo "100" >> HUE.txt
fi

#kijk of er een txt aanwezig is met een reeds opgeslagen waarde:
if [[ ! -e KWH.txt ]]; then
    touch KWH.txt
    echo "250" >> KWH.txt
fi

#--------------------------haal begin waarde op uit txt----------------
var4=$(tail -1 HUE.txt)
var9=$(tail -1 KWH.txt)
#----------------------------get current watts and convert to hue------------
#var1a=$(tail -1 KWh_Totaal.txt | sed "s/.*: //")
var1a=$(tail -1 kwhnow.txt)
x1=$(($var1a - $bkwh))
x2=$(($ekwh - $bkwh))
x3=$(($ewrd - $swrd))
var3a=$(guile -c "(display (+ $swrd(* $x3 (/ $x1 $x2.0))))")
#var4a=$(printf %.0f $var3a)
var3ab=$(echo $var3a | tr '.' ',')
var4a=$(printf %.0f $var3ab)
#echo $var4a


#save new value in txt file
echo $var4a > HUE.txt
echo $var1a > KWH.txt
# no errors:
#echo "No ERRORS" > ERROR.txt

#logfile:
echo "--------------------------RAPPORT--------------------------"  > LOG_CMD.txt
echo "$(date) $(ls -1 | wc -l) Laatste KWh waarde: " $var9 ",  Recente KWh waarde: " $var1a ",  Laatste HUE Waarde voor MIlight: " $var4 ",  Recente HUE Waarde voor MIlight: " $var4a >> LOG_CMD.txt

#--------------------------make transition between variable var4 & var4a---led lamp will slowly change colour
if (($var4 > $var4a));
then 
    #if var4 is bigger(countdown):
    COUNTER=$var4
    echo -n -e "\x42\x55" >/dev/udp/$ipaddress/$portnum || echo -n -e "\x42\x55" | nc -w 1 -u $ipaddress $portnum
    #echo "verzonden Hexcode:"  >> LOG_CMD.txt
    sleep 1
    while [ "$COUNTER" -ne "$var4a" ]
    do
        #echo "$COUNTER"
        var7=$(printf "%x\n" $COUNTER)
        #echo $var7
        #echo $cmd$pre$var7$ctrl >> LOG_CMD.txt
        echo -n -e "$cmd$pre$var7$ctrl" >/dev/udp/$ipaddress/$portnum || echo -n -e "$cmd$pre$var7$ctrl" | nc -w 1 -u $ipaddress $portnum
            COUNTER=$[$COUNTER -1]
        sleep 0.5
    done
elif (( $var4 < $var4a ))
then
    #if var4a is bigger(count up):
    COUNTER=$var4
    echo -n -e "\x42\x55" >/dev/udp/$ipaddress/$portnum || echo -n -e "\x42\x55" | nc -w 1 -u $ipaddress $portnum
    #echo -n -e "$zone$null$ctrl" >/dev/udp/$ipaddress/$portnum || echo -n -e "$zone$null$ctrl" | nc -w 1 -u $ipaddress $portnum
    #echo "sent Hexcode:"  >> LOG_CMD.txt
    sleep 1
    while [ "$COUNTER" -ne "$var4a" ]
    do
            #echo "$COUNTER"
        var7=$(printf "%x\n" $COUNTER)
        #echo $var7
        #echo $cmd$pre$var7$ctrl >> LOG_CMD.txt
        echo -n -e "$cmd$pre$var7$ctrl" >/dev/udp/$ipaddress/$portnum || echo -n -e "$cmd$pre$var7$ctrl" | nc -w 1 -u $ipaddress $portnum
            COUNTER=$[$COUNTER +1]
        sleep 0.5
    done
fi;

