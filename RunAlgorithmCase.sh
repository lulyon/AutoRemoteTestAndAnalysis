#!/bin/bash
#########################################################################
# File Name: RunAlgorithmCase.sh
# Author: 1uliang
# mail: lulyon@126.com
# Created Time: 2013年09月23日 星期一 20时44分00秒
#########################################################################

declare kernel_max
declare algorithm_name
declare executable_path
declare datainput_path
declare dataoutput_path
declare measuredtime_path
declare log_path
declare command_file

source config.ini 

log_path=./logdata
command_file=./commandlines.txt

measuredtime_path=$log_path

echo "kernel_max: $kernel_max"
echo "algorithm_name: $algorithm_name"
echo "executable_path: $executable_path"
echo "datainput_path: $datainput_path"
echo "dataoutput_path: $dataoutput_path"
# echo "log_path: $log_path"
# echo "command_file: $command_file"

# while true;
# do
#    read -p "Do you wish to clean the output data directory: $dataoutput_path?" yn
	
#    case $yn in
#        [Yy]* ) rm -r $dataoutput_path; mkdir -p $dataoutput_path; break;;
#        [Nn]* ) break;;
#        * ) echo "Please answer yes or no.";;
#    esac
# done


# while true;
# do
#    read -p "Do you wish to clean the measured time data directory: $log_path?" yn

#    case $yn in
#        [Yy]* ) rm -r $log_path; mkdir -p $log_path; break;;
#        [Nn]* ) break;;
#        * ) echo "Please answer yes or no.";;
#    esac
# done
mkdir -p $log_path;

tempfilename=./local_tempfile_

cat $command_file | sed '#^\s*$#d' | sed "s#{executable_path}#$executable_path#g" | \
    sed "s#{datainput_path}#$datainput_path#g" | \
    sed "s#{dataoutput_path}#$dataoutput_path#g" | \
    sed "s#{measuredtime_path}#$measuredtime_path#g" > $tempfilename

declare -a commands
oldIFS=$IFS
IFS=$'\n'
commands=(`cat $tempfilename`)
IFS=$oldIFS

case_num=${#commands[*]}
echo "case number: $case_num"
echo "algorithm name: $algorithm_name"
echo "Test begin..."

for ((i=0; i<case_num; i++))
do
	echo "Test case $i commandline: ${commands[$i]} begin..."
	j=1
	let k=i+1
	filename=$measuredtime_path/$algorithm_name$k.time
	
	logname=$log_path/$algorithm_name$k.log
	# totaltime=$log_path/$algorithm_name$k.time
	iotime=$log_path/$algorithm_name$k.io
	cputime=$log_path/$algorithm_name$k.cpu
	tempkernelfile=$log_path/$algorithm_name$k.kernel


	if [ -f $filename ];
        then
            rm $filename
        fi

	if [ -f $logname ];
        then
            rm $logname
        fi

	if [ -f $iotime ];
        then
            rm $iotime
        fi

	if [ -f $cputime ];
        then
            rm $cputime
        fi

	if [ -f $tempkernelfile ];
        then
            rm $tempkernelfile
        fi



	while [ $j -le $kernel_max ];
	do
		echo "Test case $k with $j kernel begin..."
		echo "${commands[$i]}" | sed "s#{kernel}#$j#g" | ( read command; echo "Running command: $command"; printf "$j\t" >>$filename; TIMEFORMAT='%3R'; time ($command 2>&1 >>$logname) 1>/dev/null 2>$tempfilename )
		echo "Test case $k with $j kernel takes `cat $tempfilename` seconds"
		cat $tempfilename >> $filename

		printf "$j\n" >> $tempkernelfile
		
		
	#	if [$? -eq 0];
	#	then
	#		echo "Test case $i with $j kernel done."
	#	else
	#		echo "Test case $i with $j kernel fail."
	#	fi
		let j=j*2;
	#	cat $filename >> $algorithm_name

	done
	# cat $logname | grep "\[DEBUG\]\[TIMESPAN\]\[TOTAL\]" | sed "s#\[DEBUG\]\[TIMESPAN\]\[TOTAL\]##g" > $tempfilename
        
        # paste $tempkernelfile $tempfilename > $totaltime
	
	cat $logname | grep "\[DEBUG\]\[TIMESPAN\]\[IO\]" | sed "s#\[DEBUG\]\[TIMESPAN\]\[IO\]##g" > $tempfilename
        paste $tempkernelfile $tempfilename > $iotime
	
	cat $logname | grep "\[DEBUG\]\[TIMESPAN\]\[COMPUTING\]" | sed "s#\[DEBUG\]\[TIMESPAN\]\[COMPUTING\]##g" > $tempfilename
        paste $tempkernelfile $tempfilename > $cputime

	if [ -f $tempkernelfile ];
        then
            rm $tempkernelfile
        fi

	echo "Test case $k done."
done

if [ -f $tempfilename ];
then
    rm $tempfilename;
fi

echo "archiving log files"
# cd `echo $log_path`
# cd ..
# mv `echo ${log_path##*/}` logdata
tar cf logdata.tar `echo $log_path`
# cp logdata.tar `echo $PWD`
# cd `echo $PWD`

echo "Test done."


