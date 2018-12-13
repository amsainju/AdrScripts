CreateJob.c
Arguments (listofDirectories.txt, "resume", numberofProcessors)
          (Argument 1,           Argument2, Arugment 3)

- The program fails if Argument 1 is not provided. 
- If Arugment 2 and 3 are not provided
     The program removes the existing jobs.log file and create jobs.txt file using list of directories in listofDirectories.txt file 
     This jobs.txt file will contain job for each channal file in each directories included in listofDirectories.txt file. 

- If Arugment 3 is not provided. i.e. numberofProcessors
   Default value = 15 is assumed 

- If all the arguments are provided i.e. in the form: ./createjobs listofDirectories.txt resume 10 
   here 10 is the nubmerofProcessors
   The script may fail to complete because of power off, system errors or some other issues. 
   So, to resume the script run and avoid reconversion of all the already converted channel files,
      The program will first count the number of files processed using existing jobs.log file, say numberOfProcessedFiles
      Then, in the next step to create new job.txt file, 
            The program will skip (numberOfProcessedFiles-numberofProcessor*2) = X jobs. that means these jobs are not included in jobs.txt files. 
            The program delete all the content of existing jobs.log file and add X jobs to it to indicate that these jobs are already done. 
            This step is done to make it convinient when the user had to resume the script multiple time. 
            (numberOfProcessedFiles was deducted by numberofProcessor*2 because if the script is killed before completion 
            some of the child process maynot be completed but can be recored as completed in jobs.log file and we may have incomplete .mat file in output directories
            So, we we do some costant number of adr reruns (at max N = numberofProcessor*2) for the last ran N jobs before the script stopped. 


