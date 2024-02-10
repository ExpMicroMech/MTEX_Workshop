clear;
home;
close all;

%% The h5 file location

file1_folder='C:\Users\benja\OneDrive\Documents\GitHub\MTEX_Workshop\Data';
file1_name='Mg_Pecs1 Specimen 1 Site 1 Map Data 1';

file1_full=fullfile(file1_folder,[file1_name '.h5oina']);

file_dset='1'; %data set number of interest in the h5 file

%% Load MTEX

%location of MTEX 5.10.2
%if MTEX loaded this doesn't matter
%if MTEX is not loaded, then it will start MTEX up
mtex_location='C:\Users\benja\OneDrive\Documents\MATLAB\mtex-5.10.2';

%start mtex if needed
try EBSD;
catch
    run(fullfile(mtex_location,"startup.m"));
end

%% Read the h5oina data into Matlab

%read the H5OINA EBSD Data - this will return two structures, with the data
%contained per layer/slice in the file
[ebsd_data,header_data,h5oina_contents]=H5OINA_Read(file1_full);

%read and convert the phase data
CS{1}='notIndexed';
num_phases=numel(header_data.(['s' file_dset]).phase);

for n=1:num_phases
    phaseN=1+n;
    Space_Group=header_data.(['s' file_dset]).phase{1}.Space_Group;
    Lattice_Dimensions=double(header_data.(['s' file_dset]).phase{1}.Lattice_Dimensions);
    Mineral=char(header_data.(['s' file_dset]).phase{1}.Phase_Name);
    Lattice_Angles=double(header_data.(['s' file_dset]).phase{1}.Lattice_Angles);

    CS{phaseN} = crystalSymmetry('SpaceId',Space_Group, ...
        Lattice_Dimensions,...
        Lattice_Angles,...
        'Mineral',Mineral);
end


