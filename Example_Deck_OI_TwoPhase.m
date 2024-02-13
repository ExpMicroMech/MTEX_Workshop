clear;
home;
close all;

%% The h5 file location

file1_folder='C:\Users\benja\OneDrive\Documents\GitHub\MTEX_Workshop\Data'; %location where the data is stored
file1_name='Ti6246 Post_PECS Site 2 Map Data 4'; %should be a h5oina file, do not add in the .h5oina file extension

% file1_folder='/MATLAB Drive/MTEX_Workshop/Data/';
% file1_name='Mg_Pecs1 Specimen 1 Site 1 Map Data 1'; %should be a h5oina file, do not add in the .h5oina file extension

file_dset='1'; %data set number of interest in the h5 file

mb_length = 20; %micro bar length for plots - if you want to override, you can comment this out/clear this variable and the override will not happen

%% Load MTEX

%location of MTEX 5.10.2
%if MTEX loaded this doesn't matter
%if MTEX is not loaded, then this will be used to start MTEX up
mtex_location='C:\Users\benja\OneDrive\Documents\MATLAB\mtex-5.10.2';
% mtex_location='/MATLAB Drive/mtex-5.10.2';

%start mtex if needed
try EBSD;
catch
    run(fullfile(mtex_location,"startup.m"));
end

%create a results folder
file1_name_us=file1_name;
file1_name_us(strfind(file1_name_us,' '))='_';

resultsdir=fullfile(cd,'results',file1_name_us);
if isdir(resultsdir) == 0; mkdir(resultsdir); end

%% Read the h5oina data into Matlab

%Make this a full file name
file1_full=fullfile(file1_folder,[file1_name '.h5oina']);

%read the H5OINA EBSD Data - this will return two structures, with the data
%contained per layer/slice in the file, and also a contents file if you
%need to load anything else
[ebsd_data,header_data,h5oina_contents]=H5OINA_Read(file1_full);

phase_names={'Ti Alpha','Ti Beta'}; %overwrite the phase names
phase_colors={'R','B'}; %overwrite the colors

%convert into a MTEX container
[ebsd] = H5OINA_Convert(ebsd_data,header_data,file_dset,phase_names,phase_colors);

%% Set the plotting preferences - this has to be validated for your instrument

%this is set up for the pFIB and Oxford Insturments systems at UBC
setMTEXpref('xAxisDirection','east');           %aztec
setMTEXpref('zAxisDirection','outofPlane');     %aztec

%font size and overwrite the scale bar if you want
setMTEXpref('FontSize',12)

%% Now do some plots

%band contrast
figure;
plot(ebsd,ebsd.prop.Band_Contrast); colormap('gray');

if exist('mb_length','var'); mp = MTEX_mb_fix(mb_length); end %change the micronbar length to make it prettier/easier to read

%% Plot the map of phases/indexed data
figure;
plot(ebsd');

%overlay with Band Contrast
figure;
plot(ebsd,ebsd.prop.Band_Contrast); colormap('gray');
hold on;
plot(ebsd,'FaceAlpha','0.3');
hold on;
if exist('mb_length','var'); mp = MTEX_mb_fix(mb_length); end %change the micronbar length to make it prettier/easier to read

%% IPF-x, y and z
% compute the colors
ipfKey1 = ipfHSVKey(ebsd(phase_names{1}));
ipfKey2 = ipfHSVKey(ebsd(phase_names{2}));

%plot the key
f1=figure;
plot(ipfKey1)
nextAxis
plot(ipfKey2)

% now generate the IPF colour maps
ipfKey1.inversePoleFigureDirection = vector3d.X;
colors_X1 = ipfKey1.orientation2color(ebsd(phase_names{1}).orientations);
ipfKey1.inversePoleFigureDirection = vector3d.Y;
colors_Y1 = ipfKey1.orientation2color(ebsd(phase_names{1}).orientations);
ipfKey1.inversePoleFigureDirection = vector3d.Z;
colors_Z1 = ipfKey1.orientation2color(ebsd(phase_names{1}).orientations);

ipfKey2.inversePoleFigureDirection = vector3d.X;
colors_X2 = ipfKey2.orientation2color(ebsd(phase_names{2}).orientations);
ipfKey2.inversePoleFigureDirection = vector3d.Y;
colors_Y2 = ipfKey2.orientation2color(ebsd(phase_names{2}).orientations);
ipfKey2.inversePoleFigureDirection = vector3d.Z;
colors_Z2 = ipfKey2.orientation2color(ebsd(phase_names{2}).orientations);


%now plot the three IPF coloured maps
f2=figure;
plot(ebsd,'micronbar','off');
title('Phases')
nextAxis
plot(ebsd(phase_names{1}),colors_X1,'micronbar','off'); title('alpha IPF-X')
nextAxis
plot(ebsd(phase_names{1}),colors_Y1,'micronbar','off'); title('alpha IPF-Y')
nextAxis
plot(ebsd(phase_names{1}),colors_Z1,'micronbar','on'); title('alpha IPF-Z')

nextAxis
plot(ebsd(phase_names{2}),colors_X2,'micronbar','off'); title('beta IPF-X')
nextAxis
plot(ebsd(phase_names{2}),colors_Y2,'micronbar','off'); title('beta IPF-Y')
nextAxis
plot(ebsd(phase_names{2}),colors_Z2,'micronbar','on'); title('beta IPF-Z')

nextAxis
plot(ebsd(phase_names{1}),colors_X1,'micronbar','off'); hold on
plot(ebsd(phase_names{2}),colors_X2,'micronbar','off');  title('dual IPF-X')
nextAxis
plot(ebsd(phase_names{1}),colors_Y1,'micronbar','off'); hold on
plot(ebsd(phase_names{2}),colors_Y2,'micronbar','off'); title('dual IPF-Y')
nextAxis
plot(ebsd(phase_names{1}),colors_Z1,'micronbar','on'); hold on
plot(ebsd(phase_names{2}),colors_Y2,'micronbar','off'); title('dual IPF-Z')

if exist('mb_length','var'); mp = MTEX_mb_fix(mb_length); end %change the micronbar length to make it prettier/easier to read

%save the figures;
drawnow(); %updates the graphics engine to make sure it saves things properly
% print(f1,fullfile(resultsdir,'Map_IPFkey.png'),'-dpng','-r600');
% print(f2,fullfile(resultsdir,'Map_IPF.png'),'-dpng','-r600');
%% Plot the PF - scatter

%plot planes as spots, and use a subset
figure
plotPDF(ebsd(phase_names{1}).orientations,[Miller(0,0,1,ebsd(phase_names{1}).CS) Miller(1,1,0,ebsd(phase_names{1}).CS)])
nextAxis
plotPDF(ebsd(phase_names{2}).orientations,[Miller(0,1,1,ebsd(phase_names{2}).CS) Miller(1,1,1,ebsd(phase_names{2}).CS)])

%% Construct the ODF

%suggested reading:
%https://mtex-toolbox.github.io/ODFTutorial.html
%https://mtex-toolbox.github.io/PoleFigure2ODF.html

% compute the ODF
odf1 = calcDensity(ebsd(phase_names{1}).orientations);
odf2 = calcDensity(ebsd(phase_names{2}).orientations);
% You could also change/fix the half width - compare this different ODF
% odf = calcDensity(ebsd(mineral_name).orientations,'halfwidth',2*degree);

figure
plotPDF(odf1,[Miller(0,0,1,ebsd(phase_names{1}).CS) Miller(1,1,0,ebsd(phase_names{1}).CS)])
mtexColorbar('location','southoutside')
mtexColorMap blue2red
nextAxis
plotPDF(odf2,[Miller(0,1,1,ebsd(phase_names{2}).CS) Miller(1,1,1,ebsd(phase_names{2}).CS)])
mtexColorbar('location','southoutside')
mtexColorMap blue2red

%% ideas

%you could extract one or more grains from the alpha phase and look at the
%orientations of the nearby beta

%you could measure the grain size or aspect ratio
%you could estimate the volume fraction
%
%you could estimate the volume fraction and consider that unindexed points
%are sysemtically more likley to be one phase or another
%
%you could estimate volume fraction after a clean up routine
%% copy this m file over, for archival purposes

mf_long=mfilename('fullpath');
[f1,f2,f3]=fileparts(mf_long);
mf_start=[mf_long '.m'];
mf_end=fullfile(resultsdir,[f2 '.m']);
try
copyfile(mf_start,mf_end)
catch
    warning('m file not saved, likely due to spaces in the file name');
end