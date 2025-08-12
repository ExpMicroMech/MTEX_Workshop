%% mini loading script
% you can insert this into the start of other scripts
% - - - 
clear;
home;
close all;

%% Load Toolboxes
% The h5oina loader requires astroEBSD: https://github.com/benjaminbritton/AstroEBSD
% and the code requires MTEX version 5.10.2: https://mtex-toolbox.github.io/download

%Toolboxes - folder locations
mtex_location='C:\Users\ruthb\OneDrive\Documents\MTEX\mtex-5.10.2'; % update this
astro_location='C:\Users\ruthb\OneDrive\Documents\GitHub\AstroEBSD';% update this

%start mtex if needed
try EBSD;
catch
    run(fullfile(mtex_location,"startup.m"));
end

%start AstroEBSD if needed
try astro_loadcheck;
catch
    run(fullfile(astro_location,"start_AstroEBSD.m"));
end

%% h5oina file location

% folder 
file1_folder='C:\Users\ruthb\OneDrive - UBC\3 - pFIB\6 - Troubleshooting\20250127-aztecUpdate\aztecupdate\h5oina'; %location where the data is stored
% file
file1_name='aztecupdate Specimen 1 Site 1 Map Data 1'; %should be a h5oina file, do not add in the .h5oina file extension

%extra (workshop)
file_dset='1'; %data set number of interest in the h5 file
mb_length = 500; %micro bar length for plots - if you want to override, you can comment this out/clear this variable and the override will not happen

% extra for 2 phase (comment out if not needed)
phase_names={'Iron bcc (old)','Iron fcc'}; %overwrite the phase names
phase_colors={'R','B'}; %overwrite the colors

%% make a results folder if needed

%create a results folder
file1_name_us=file1_name;
file1_name_us(strfind(file1_name_us,' '))='_';

resultsdir=fullfile(cd,'results',file1_name_us);
if isdir(resultsdir) == 0; mkdir(resultsdir); end

%% load the h5oina file

% Make a full file name
file1_full=fullfile(file1_folder,[file1_name '.h5oina']);

% load one file 
% h5oina_file=file1_full; % file name
warningOn=0; % turn on/off warnings during loading
[ebsd_original,dataset_header,ebsd_patternmatched,h5_original,h5_patternmatch] = load_h5oina_pm2(file1_name,file1_folder,warningOn);
ebsd=ebsd_patternmatched; % if not pattern matched it will default to original ebsd data

%% Set the plotting preferences - this has to be validated for your instrument

%this is set up for the pFIB and Oxford Insturments systems at UBC
setMTEXpref('xAxisDirection','east');           %aztec
setMTEXpref('zAxisDirection','outofPlane');     %aztec

%font size and overwrite the scale bar if you want
setMTEXpref('FontSize',12)

