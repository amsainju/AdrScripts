# listofDirectories.txt
Contains the path of each directories containing *.dat files.
Users have to create this file. 
Sample listofDirectories.txt is included in the 'Samples' subdirectory.
```
Format:  
/path1/directory1
/path2/directory2
...
```

# createjob
A program to create jobs for the AdrParallelRunScript.sh. 
It takes listofDirectories.txt as an argument and creates jobs.txt as an output.
```
$ gcc -o createjob CreateJobs.c
```
```
$ ./createjob listofDirectories.txt
```



# jobs.txt
It contains the jobs to be processed by adr code.
Sample jobs.txt is included in the 'Samples' subdirectoy.
```
Format:
/PATH/d0/20180714_212441_Channel0_0000.dat
/PATH/d1/20180811_124231_Channel1_0000.dat
/PATH/d2/20180811_124231_Channel2_0000.dat
/PATH/d3/20180811_124231_Channel3_0000.dat
/PATH/d4/20180811_124231_Channel4_0000.dat
/PATH/d5/20180811_124231_Channel5_0000.dat
...
```

# AdrParallelRunScript.sh
It takes four parameters:
1. the number of processors
2. filename with list of jobs
3. range gate value
4. Short Mode Value for Adr code  (1 for CO, 3 for Japan and GreenLand Data)

  This script distributes each job in job file to different processors. Currently, it assumes each *.dat file as a separate job.
  The script does the following tasks:
  1. convert .dat files to compressed .mat files
  2. decompress .mat files.
  
Pre-requirements:
1. Matlab 2018a/2018b

### Setting Environment Variables
Open the AdrParallelRunScript.sh and replace "YOUR_PATH" with the Matlab Installation path. 
```
export LD_LIBRARY_PATH=/YOUR_PATH/Matlab2018a/bin/glnxa64:$LD_LIBRARY_PATH
```


```
$./AdrParallelRunScript.sh 15 jobs.txt 13888 1
```
where 15 is the number of processors, jobs.txt is the file with list of jobs, 13888 is the range gate value, 1 is short mode value

# ADR Code Compilation 
Adr code can be downloaded from the following link:
https://github.com/amsainju/adr
Linux executable for Adr can be downloaded from binaries subdirectory. 
Before you run the compilation command make sure libmat.so and libmx.so  are present in the same directory as adr.c adr.h and main.c. 
```
$ export PATH=/YOUR_PATH/Matlab2018a/bin:$PATH

$ export LD_LIBRARY_PATH=/YOUR_PATH/Matlab2018a/bin/glnxa64:$LD_LIBRARY_PATH

$ gcc -L /YOUR_PATH/Matlab2018a/bin/glnxa64 -L /YOUR_PATH/Matlab2018a/sys/os/glnxa64 -I /YOUR_PATH/Matlab2018a/extern/include -o adr adr.c main.c -lm -lmat -lmx
```

#How to Run in Chronological Order
1. create a file with list of directories path (listOfDirectories.txt)
2. run createjob program
```
$./createjob listOfDirectories.txt
```
3. Run AdrParallelRunScript.sh
```
$./AdrParallelRunScript.sh 15 jobs.txt 13888 1
```





