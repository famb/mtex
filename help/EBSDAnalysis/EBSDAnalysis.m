%% EBSD Data Analysis
% This sections gives you an overview over the functionality MTEX offers to
% analyze EBSD data.
%
%
%% Import of EBSD Data
%
% The most comfortable way to import EBSD data into MTEX is to use
% the import wizard, which can be started by the command

import_wizard

%%
% If the data are in a format supported by MTEX the import wizard generates
% a script which imports the data. More information about the import wizard
% and a list of supported file formats can be found
% [[interfacesEBSD_index.html,here]]. A typical script generated by the import 
% wizard looks a follows.


cs = symmetry('-3m',[1.2 1.2 3.5]); % crystal symmetry
ss   = symmetry('triclinic');        % specimen symmetry

% file names
fnames = [mtexDataPath '/aachen_ebsd/85_829grad_07_09_06.txt'];

% load data
ebsd = loadEBSD(fnames,cs,ss,'header',1,'layout',[5,6,7],'xy',[3 4])

%% Plotting EBSD Data
%
% EBSD data are plotted using the [[EBSD_plot.html,plot]] command.
% It asign a color to each orientation and plots a map of these colors.
% There are several options to specify the way the colors are assigned.

figure('position',[100 100 600 300])
plot(ebsd)

%% Modify EBSD Data
%
% MTEX offers a lot of operations to analyze and manipulate EBSD data, e.g.
%
% * plot pole figures of EBSD data
% * rotate EBSD data
% * find outliers
% * remove specific measurements
% * combine EBSD data from several meassurements
% * compute an ODF
%
% An exhausive introduction how to analyze and modify EBSD data can be found
% <EBSDModification.html here>

%% Calculate an ODF from EBSD Data
%
% The command [[EBSD_calcODF.html,calcODF]]  performs an ODF calculation
% from EBSD data using kernel density estimation EBSD data. For a precise
% explaination of the algorithm and the available options look
% <EBSD2ODFestimation.html here>. 

odf = calcODF(ebsd,'halfwidth',10*degree)
plotpdf(odf,Miller(1,0,0,cs),'reduced')


%% Simulate EBSD Data
%
% Simulating EBSD data from a given ODF has been proven to be
% usefull to analyze the stability of the ODF estimation process. There is
% an <EBSDSimulation.html example> demostrating how to determine the
% number of individuel orientation measurements to estimate the ODF up to a
% given error. The MTEX command to simulate EBSD data is
% <ODF_simulateEBSD.html simulateEBSD>, e.g.

ebsd = simulateEBSD(unimodalODF(idquaternion,cs,ss),500)
plotpdf(ebsd,Miller(1,0,0),'reduced','MarkerSize',3)

%% Demo
%
% For a more exausive description of the EBSD class have a look at the 
% [[ebsd_demo.html,EBSD demo]]!
% 
