%% Import data from spreadsheet (.xlsx)
% Script for importing data from the following spreadsheet:
%
%    Workbook: Input\refTime.xlsx %Excel file name
%    Worksheet: refTime - Copy    %Excel sheet name
%
% This script will import 'perfect' data generated in the first column of
% an Excel file with the help of Excel autocompletion ; Export is also
% managed by the script with refTime.mat created in the Output folder

%% Setup the Import Options
opts = spreadsheetImportOptions("NumVariables", 1);

% Specify sheet and range
opts.Sheet = "refTime - Copy";
opts.DataRange = "A1:A77733";

% Specify column names and types
opts.VariableNames = "Jan2011000000";
opts.VariableTypes = "string";
opts = setvaropts(opts, 1, "WhitespaceRule", "preserve");
opts = setvaropts(opts, 1, "EmptyFieldRule", "auto");

% Import the data
refTime = readtable("C:\Users\Pierre\Documents\MEGAsync\UCL\CPME\Dossier partagé Mémoire\Etude Techno-economique\Pierre\Mesures manquantes\Input\refTime.xlsx", opts, "UseExcel", false);

%% Save data
saveFile = ["refTime.mat"];
curPath = pwd;
cd("./Output/")
save(saveFile,'refTime');
cd(curPath)


%% Clear temporary variables
clear opts