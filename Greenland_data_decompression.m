
function [] = Greenland_data_decompression(input_of_adr)
%disp(input_of_adr);
%	clear all;
% parse input_of_adr (/home/radarops/d0/20180101_55555_Channel7_0000.dat)
% extract the input path A : (/home/radarops/d0/)
input_path = input_of_adr(1:end-33);
filename = [input_of_adr(end-32:end-4) '.mat'];
% extract filename (20180101_55555_Channel7_0000.mat)
% read the file listofDirectories.txt  that maps input directory to output directory
		% /home/radarops/d0  /home/radarops/d9
		% /home/radarops/d1  /home/radarops/d13
		A = fopen('/home/radarops/Arpan/Adr/OutputFolderMapper.txt','r');
		map = textscan(A, '%s %s');

% compare the input path A with the one in the listofDirectories.txt and extract respective outputDirectory
		mapidx = strcmp([map{:}], input_path);
		output_dir = map{2}{find(mapidx(:, 1))};
    
	load([input_path filename])
    save([output_dir filename],'Short_Chirp_PPS_Count_Values','Short_Chirp_Profiles',...
    'Long_Chirp_PPS_Count_Values','Long_Chirp_Profiles','-v7.3','-nocompression')
    clear Short_Chirp_PPS_Count_Values Short_Chirp_Profiles Long_Chirp_PPS_Count_Values Long_Chirp_Profiles              
    delete([input_path filename])
end

