clear;
home;
close all;

file1_folder='C:\Users\benja\OneDrive\Documents\GitHub\MTEX_Workshop\Data';
file1_name='Mg_Pecs1 Specimen 1 Site 1 Map Data 1';

file1_full=fullfile(file1_folder,[file1_name '.h5oina']);

%read the H5OINA EBSD Data - this will return two structures, with the data
%contained per layer/slice in the file
[ebsd_data,header_data]=H5OINA_Read(file1_full);
