#! /usr/bin/env bash
# use chmod +x AdrParallelRunScript.sh
numberofProcessors=$1
jobstxt=$2
joblog=$(echo $jobstxt | cut -c1-6)-$(date +"%y%m%d-%H%M%S").adr.log
dataDir=$3
shortMode=$4
xmlFile=$(ls $dataDir/*.xml | head -n 1)
valueRange=$(sh ./extract_xml_linux.sh $xmlFile printRange)

export LD_LIBRARY_PATH=/home/.MATLAB/R2018a/bin/glnxa64:/home/.MATLAB/R2018a/sys/os/glnxa64:$LD_LIBRARY_PATH

set -o monitor 
# means: run background processes in a separate processes...
trap add_next_job CHLD 
# execute add_next_job when we receive a child complete signal

readarray todo_array < $jobstxt
index=0
max_jobs=$numberofProcessors
echo "Number of Process: " $max_jobs

function add_next_job {
    # if still jobs to do then add one
    if [[ $index -lt ${#todo_array[*]} ]]
    then
        echo adding job ${todo_array[$index]}
        do_job ${todo_array[$index]} & 
        index=$(($index+1))
    fi
}

function do_job {
    echo "starting job $1 $2 $3"
    STARTTIME=`date`
    ./adr -i $1 -m 1 -r $valueRange -sm $shortMode
    ENDTIME=`date`
    echo $1 $2 $3 $STARTTIME $ENDTIME>> $joblog
}

# add initial set of jobs
while [[ $index -lt $max_jobs ]]
do
    add_next_job
done

# wait for all jobs to complete
wait
echo "All jobs completed"
