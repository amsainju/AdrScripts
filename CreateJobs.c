// removed the index counter
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define DEFAULT_PATH_LENGTH				512
char *uniqueIndex;
int jobInDirectoryCount[100];
int start[100];
int end[100];
int directoryCounter = 0;
int jobindirectoryCounter = 0;
int jobCounter = 0;
int maxJobinDirectory = 0;

int main(int argc, char**argv){
	char* directoryList_filename; 
	char* directory;
	char* line; 
	char* command;
	int numberofProcessor=0; 
	int jobProcessed = 0;
	int nrows = 500000;
	char **joblist = malloc(nrows * sizeof(char *)); // Allocate row pointers
	for(int i = 0; i < nrows; i++)
  		joblist[i] = malloc(512 * sizeof(char));  // Allocate each row separately
	FILE* fh,*fo,*fdl;
	char *tempIndex;
	uniqueIndex = malloc(DEFAULT_PATH_LENGTH*sizeof(char));
	tempIndex = malloc(DEFAULT_PATH_LENGTH*sizeof(char));
	directoryList_filename = malloc(DEFAULT_PATH_LENGTH*sizeof(char));
	directory = malloc(DEFAULT_PATH_LENGTH*sizeof(char));
	line = malloc(DEFAULT_PATH_LENGTH*sizeof(char));
	command = malloc(DEFAULT_PATH_LENGTH*sizeof(char));

	if(argc >1){
		if (argc>=3){
			if(strcmp(argv[2],"resume")==0){
				if(argc==4){
					numberofProcessor = atoi(argv[3]);
				}
				else{
					numberofProcessor = 15; //default number of processor used..  
				}
				fh = fopen("jobs.log","r");
				while (fgets(line, DEFAULT_PATH_LENGTH, fh) != NULL)  {
					jobProcessed++;
				}
				fclose(fh);
				printf("jobsProcessed = %d\n",jobProcessed);
			}
		}else{

			remove("jobs.log");
		}
		strcpy(directoryList_filename,argv[1]);
		fdl = fopen(directoryList_filename,"r");
		while (fgets(directory, DEFAULT_PATH_LENGTH, fdl) != NULL)  {
			start[directoryCounter] = jobCounter;
			directory[strcspn(directory, "\n")] = 0;
			if(strlen(directory)==0){
				break;
			}

			strcpy(command,"ls ");
			strcat(command,directory);
			strcat(command,"/*.dat|sort -n > info.txt");
			system(command);  
			fh = fopen("info.txt", "r");
			//read line by line
			while (fgets(line, DEFAULT_PATH_LENGTH, fh) != NULL)  {
				if(strstr(line, "Channel") != NULL){
						strcpy(joblist[jobCounter],line);
						jobCounter++;
						jobindirectoryCounter++;
				}
			}
			end[directoryCounter]= jobCounter-1;
			jobInDirectoryCount[directoryCounter]=jobindirectoryCounter; 
			if(maxJobinDirectory<jobindirectoryCounter){
				maxJobinDirectory= jobindirectoryCounter;
			}
			directoryCounter++;
			fclose(fh);
		}
		fh = fopen("jobs.txt","w");
		fo = fopen("jobs.log","w");
		jobProcessed= jobProcessed-numberofProcessor*2;
		printf("jobsProcessed = %d\n",jobProcessed);
		int index;
		int counter = 0;
		for (int i=0;i<maxJobinDirectory;i++){
			for(int j=0;j<directoryCounter;j++){
				index = start[j]+i;
				if(index<=end[j]){
					if(counter>=jobProcessed){
						fputs(joblist[index], fh);
					}
					else{
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
		for (int i=0;i<nrows;i++){
		free(joblist[i]);
		}
        free(joblist);
	   // fclose(fo);
		remove("info.txt");
		printf("Jobs Created Successfully!\n");
	}
	else{
		printf("Please Provide the file with list of directories.\n");
	}
	return 0;
}
