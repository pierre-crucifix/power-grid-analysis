%% Import data from households spreadsheets (.csv)
% Script for importing data from the following csv files :
%
%    Workbook: Input\HouseDataCSV\house****.csv %csv file name
%
% This script will import data retrieved from smart meters in csv files
% and convert them to .mat files adapted for Matlab. Export is also
% managed by the script with house****.mat created in the Output folder

clc; clear; close all;
savePath = './Output/HouseDataMAT';

for i=1:1145 %1145 households

    %% Initialize variables.
    filename = ['C:\Users\Pierre\Documents\MEGAsync\UCL\CPME\Dossier partagé Mémoire\Etude Techno-economique\Pierre\Mesures manquantes\Input\HouseDataCSV\house' num2str(i) '.csv'];
    delimiter = ',';
    startRow = 2;

    %% Format for each line of text:
    %   column1: text (%s)
    %	column2: double (%f)
    % For more information, see the TEXTSCAN documentation.
    formatSpec = '%s%f%[^\n\r]';

    %% Open the text file.
    fileID = fopen(filename,'r');

    %% Read columns of data according to the format.
    % This call is based on the structure of the file used to generate this
    % code. If an error occurs for a different file, try regenerating the code
    % from the Import Tool.
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' , ...
        startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

    %% Close the text file.
    fclose(fileID);

    %% Post processing for unimportable data.
    % No unimportable data rules were applied during the import, so no post
    % processing code is included. To generate code which works for
    % unimportable data, select unimportable cells in a file and regenerate the
    % script.

    %% Create output variable
    %house1 = table(dataArray{1:end-1}, 'VariableNames', {'Time','Power'});
    house = table(dataArray{1:end-1}, 'VariableNames', {'Time','Power'});
    
    %% Save output varible to mat format
    saveFile = ['house' num2str(i) '.mat'];
    curPath = pwd;
    cd("./Output/HouseDataMAT/")
    save(saveFile,'house'); %tochange si on a un nom de variable dynamique, ou un tableau
    cd(curPath)
    
    
    %% Clear temporary variables
    clearvars filename delimiter startRow formatSpec fileID dataArray ans;
end
