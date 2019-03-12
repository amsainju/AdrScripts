#! /usr/bin/env bash
# use chmod +x AdrParallelScript.sh
#Takes 1 argument numberofProcessors 
numberofProcessors=$1
export PATH=/YOUR_PATH/Matlab2018a/bin:$PATH  #change to your path
export LD_LIBRARY_PATH=/YOUR_PATH/Matlab2018a/bin/glnxa64:$LD_LIBRARY_PATH  #change to your path
set -o monitor 
# means: run background processes in a separate processes...
trap add_next_job CHLD 
# execute add_next_job when we receive a child complete signal

readarray todo_array < jobs.txt
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
    echo "starting job $1"
    STARTTIME=`date`
    ./adr -i $1 -m 1 -r 3808  #may need to change the range gate value 
    datfile=$1
    datfile=${datfile::-4}
    matextention='.mat'
    matfile=$datfile$matextention 
    nohup matlab -nodisplay -nodesktop -r "decompression('$matfile');exit"
    ENDTIME=`date`
    echo "decompression job $matfile completed"
    echo $1 $2 $3 $STARTTIME $ENDTIME>> jobs.log
}

# add initial set of jobs
while [[ $index -lt $max_jobs ]]
do
    add_next_job
done

# wait for all jobs to complete
wait
echo "All jobs completed"

