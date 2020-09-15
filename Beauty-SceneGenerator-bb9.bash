#!/bin/bash
IFS=$'\t\n'
declare -i scene=1
declare -i RecordingScene=2
declare -i dca=1
declare -i i=0
declare -i j=0
declare -i index=0
declare -a asdf

#Import Lines From File Into Array. File Needs to be pre-saved with CR/LF forced.
for line in $(cat ./beauty6.txt)
do

asdf+=($line)

done

#Parse and Output Scenes 1 Thru 9
while [ $scene -lt 9 ]
do
	
	#Scene Header
	echo "SCENE $scene"
		echo "RSCENE $RecordingScene"
	cat ./x32header.txt > "BEAUTY.00$RecordingScene.scn"

	
	#For Each DCA, 
	while [ $i -lt 8 ]
	do
		index=($scene*8)+$i
		j=$i+1;
		
		#Check If DCA Is Empty.
		if [ "${asdf[$index]}" != "xxx" ];
		then
			
			#Check if DCA 8 Workaround
			if [ $j = 8 ];
			then
				echo "/dca/8 ON  -3.6" >> "BEAUTY.00$RecordingScene.scn"
				echo "/dca/8/config \"BAND\" 1 YE" >> "BEAUTY.00$RecordingScene.scn"
			#If DCA 1>7, output Name
			else
				echo "/dca/$j ON  -3.6" >> "BEAUTY.00$RecordingScene.scn"
				echo "/dca/$j/config \"${asdf[$index]}\" 1 WH" >> "BEAUTY.00$RecordingScene.scn"
			fi
		#If DCA Is Empty, Output Empty
		else
			echo "/dca/$j OFF  -oo" >> "BEAUTY.00$RecordingScene.scn"
			echo "/dca/$j/config \".\" 1 OFF" >> "BEAUTY.00$RecordingScene.scn"
			
		fi
		((i++))
		
	done
	
	cat ./x32footer.txt >> "BEAUTY.00$RecordingScene.scn"
	
	
	i=0
	((scene++))
	((RecordingScene++))

done



while [ $scene -lt 83 ]
do
	
	#Scene Header

	cat ./x32header.txt > "BEAUTY.0$RecordingScene.scn"

	echo "SCENE $scene"
	echo "RSCENE $RecordingScene"
	
	#For Each DCA, 
	while [ $i -lt 8 ]
	do
		index=($scene*8)+$i
		j=$i+1;
		
		#Check If DCA Is Empty.
		if [ "${asdf[$index]}" != "xxx" ];
		then
			
			#Check if DCA 8 Workaround
			if [ $j = 8 ];
			then
				echo "/dca/8 ON  -3.6" >> "BEAUTY.0$RecordingScene.scn"
				echo "/dca/8/config \"BAND\" 1 YE" >> "BEAUTY.0$RecordingScene.scn"
			#If DCA 1>7, output Name
			else
				echo "/dca/$j ON  -3.6" >> "BEAUTY.0$RecordingScene.scn"
				echo "/dca/$j/config \"${asdf[$index]}\" 1 WH" >> "BEAUTY.0$RecordingScene.scn"
			fi
		#If DCA Is Empty, Output Empty
		else
			echo "/dca/$j OFF  -oo" >> "BEAUTY.0$RecordingScene.scn"
			echo "/dca/$j/config \".\" 1 OFF" >> "BEAUTY.0$RecordingScene.scn"
			
		fi
		((i++))
		
	done
	
	cat ./x32footer.txt >> "BEAUTY.0$RecordingScene.scn"
	
	
	i=0
	((scene++))
	((RecordingScene++))

done


#Generate SHOWFILE

echo "#2.1#" > "BEAUTY.shw"
echo 'show "BEAUTY" 31 65535 63 15 49152 65535 65535 63487 32991 255 "3.07"' >> "BEAUTY.shw"

i=2
while [ $i -lt 10 ]
do
	echo "scene/00$i" ' "Beauty" "" %000000000 1'  >> "BEAUTY.shw"
	((i++))
done

while [ $i -lt 84 ]
do
	echo "scene/0$i" ' "Beauty" "" %000000000 1'  >> "BEAUTY.shw"
	((i++))
done

