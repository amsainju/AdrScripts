# CreateJob
A program to create jobs for the AdrParallelRunScript.sh. 
It takes listofDirectories.txt as an arguement and creates jobs.txt as an output.

# listofDirectories.txt
Contains the path of each directories containing *.dat files.
User have to create this file. 

# jobs.txt
It contains the jobs to be processed by adr code.
CreateJob code will create this file. 

# AdrParallelRunScript.sh
It takes the number of processors as an argument and distributes each job in jobs.txt to different processors. 



