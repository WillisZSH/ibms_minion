
#!/bin/bash

#the first is start at Barcode[0],  we minus one in Barcode number in arg, so just input the real sample barcode we used in ONT seq
#Usage
#sh reads_count.sh 220809MN015-13BC_single 1 13

#TEMP=/work/ylllab2021/temp/220809MN015-13BC/demulti
#Barcode=("01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13")
Barcode=("01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26" "27" "28" "29" "30" "31" "32" "33" "34" "35" "36" "37" "38" "39" "40" "41" "42" "43" "44" "45" "46" "47" "48" "49" "50" "51" "52" "53" "54" "55" "56" "57" "58" "59" "60" "61" "62" "63" "64" "65" "66" "67" "68" "69" "70" "71" "72" "73" "74" "75" "76" "77" "78" "79" "80" "81" "82" "83" "84" "85" "86" "87" "88" "89" "90" "91" "92" "93" "94" "95" "96")
set -e
folder=$1
first=$2
final=$3
TEMP=/work/ylllab2021/temp/${folder}/demulti

echo -n "${folder} fastq reads" > /work/ylllab2021/temp/${folder}/${folder}_reads_count.txt

for ((i=$2-1; i<=$3-1; i=i+1))
do
{
echo  $(cat $TEMP/barcode${Barcode[i]}/*.fastq |wc -l)/4 | bc >> /work/ylllab2021/temp/${folder}/${folder}_reads_count.txt
}
done
