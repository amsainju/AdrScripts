// removed the index counter
//#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define DEFAULT_PATH_LENGTH				512
#define DirNum 128
char *uniqueIndex;
int jobInDirectoryCount[DirNum];  //Assuming 128 different Directory Locations
int start[DirNum];
int end[DirNum];
int directoryCounter = 0;
int jobinDirectoryCounter = 0;
int jobCounter = 0;
int maxJobinDirectory = 0;

int main(int argc, char**argv) {
	char* directoryListFile;
	char* directory;
	char* line;
	char* command;
	int numberofProcessor = 0;
	int completedJobs = 0;
	int nrows = 500000;  // Assuming at most 500k jobs
	char **joblist = malloc(nrows * sizeof(char *)); // Allocate row pointers
	for (int i = 0; i < nrows; i++)
		joblist[i] = malloc(DEFAULT_PATH_LENGTH * sizeof(char));  // Allocate each row separately
	FILE* fh, *fo, *fdl;
	char *tempIndex;
	uniqueIndex = malloc(DEFAULT_PATH_LENGTH*sizeof(char));
	tempIndex = malloc(DEFAULT_PATH_LENGTH*sizeof(char));
	directoryListFile = malloc(DEFAULT_PATH_LENGTH*sizeof(char));
	directory = malloc(DEFAULT_PATH_LENGTH*sizeof(char));
	line = malloc(DEFAULT_PATH_LENGTH*sizeof(char));
	command = malloc(DEFAULT_PATH_LENGTH*sizeof(char));

	if (argc >1) {
		if (argc >= 3) {
			if (strcmp(argv[2], "resume") == 0) {
				if (argc == 4) {
					numberofProcessor = atoi(argv[3]);
				}
				else {
					numberofProcessor = 15; //default number of processor used..  
				}
				fh = fopen("jobs.log", "r");
				while (fgets(line, DEFAULT_PATH_LENGTH, fh) != NULL) { //count the number of completed jobs
					completedJobs++;
				}
				fclose(fh);
				printf("jobsProcessed = %d\n", completedJobs);
			}
		}
		else {

			remove("jobs.log");  //remove existing jobs.log
		}
		strcpy(directoryListFile, argv[1]);
		fdl = fopen(directoryListFile, "r");
		while (fgets(directory, DEFAULT_PATH_LENGTH, fdl) != NULL) {
			start[directoryCounter] = jobCounter;
			directory[strcspn(directory, "\n")] = 0;
			if (strlen(directory) == 0) {
				break;
			}

			strcpy(command, "ls ");
			strcat(command, directory);
			strcat(command, "/*.dat|sort -n > tempjoblist.txt"); //save all the filenames for each directory in tempjoblist.txt
			system(command);
			fh = fopen("tempjoblist.txt", "r");
			//read line by line
			while (fgets(line, DEFAULT_PATH_LENGTH, fh) != NULL) {
					strcpy(joblist[jobCounter], line);
					jobCounter++;
					jobinDirectoryCounter++;
			}
			end[directoryCounter] = jobCounter - 1;
			jobInDirectoryCount[directoryCounter] = jobinDirectoryCounter;
			if (maxJobinDirectory<jobinDirectoryCounter) {
				maxJobinDirectory = jobinDirectoryCounter;
			}
			directoryCounter++;
			fclose(fh);
		}
		fh = fopen("jobs.txt", "w");
		fo = fopen("jobs.log", "w");
		if (completedJobs >= numberofProcessor * 2) {
			completedJobs = completedJobs - numberofProcessor * 2;  //redo some constant number of completed jobs again. Some last jobs can be partially complete. 

		}
		//printf("jobsProcessed = %d\n", completedJobs);
		int index;
		int counter = 0;
		for (int i = 0; i<maxJobinDirectory; i++) {
			for (int j = 0; j<directoryCounter; j++) {
				index = start[j] + i;
				if (index <= end[j]) {
					if (counter >= completedJobs) {
						fputs(joblist[index], fh);
					}
					else {
						fputs(joblist[index], fo);
						counter++;
					}

				}
			}

		}
		fclose(fo);
		fclose(fh);
		free(tempIndex);
		free(uniqueIndex);
		free(line);
		free(directory);
		fclose(fdl);
		for (int i = 0; i<nrows; i++) {
			free(joblist[i]);
		}
		free(joblist);
		// fclose(fo);
		remove("tempjoblist.txt");
		printf("Jobs Created Successfully!\n");
	}
	else {
		printf("Please Provide the file with list of directories.\n");
	}
	return 0;
}
