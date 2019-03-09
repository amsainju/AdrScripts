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
$ gcc -o createjob createjob.c
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
It takes the number of processors as an argument and distributes each job in jobs.txt to different processors. Currently, it assumes each *.dat file as a separate job. 
Pre-requirements:
1. Matlab 2018a/2018b

### Setting Environment Variables
Open the AdrParallelRunScript.sh and replace "YOUR_PATH" with the Matlab Installation path. 
```
export LD_LIBRARY_PATH=/YOUR_PATH/Matlab2018a/bin/glnxa64:$LD_LIBRARY_PATH
```
AdrParallelRunScript.sh takes only one argument: the number of processors. Before you run the script make sure the jobs.txt file is in the same directory. 

```
$./AdrParallelRunScript.sh 15
```

# ADR Code Compilation 
Adr code can be downloaded from the following link:
https://github.com/amsainju/adr
Linux executable for Adr can be downloaded from Executables subdirectory. 
Before you run the compilation command make sure libmat.so and libmx.so  are present in the same directory as adr.c adr.h and main.c. 
```
$ export LD_LIBRARY_PATH=/YOUR_PATH/Matlab2018b/bin/glnxa64:$LD_LIBRARY_PATH

$ gcc -L /YOUR_PATH/Matlab2018b/bin/glnxa64 -L /YOUR_PATH/Matlab2018b/sys/os/glnxa64 -I /YOUR_PATH/Matlab2018b/extern/include -o adr adr.c main.c -lm -lmat -lmx
```




