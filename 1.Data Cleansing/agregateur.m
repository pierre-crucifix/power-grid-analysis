%% Aggregates and aligns data according to actual measured hours

clc; clear; close all;

load Input\orderedRefTime.mat %gives refTimeOrderedMatrix
load Input\numberOfMeasures.mat % gives numberOfMeasures 
%(a matrix with the number of measures per household, see previous script)

folderPath = "Input\HouseDataMAT\";

totalPower=NaN(77733,1145);%similar to zeros() but with NaN in it
%89.004.285 elements


for j=1:1145 %number of households
    filename = [strcat(folderPath,'house', num2str(j), '.mat')];
    load(filename); %will create a house variable with 2 columns: the first
        %one with dates/times & the second one with consumption
    
    House=table2array(house); %BE CAREFUL, EVERYTHING GOES IN A STRING 
        %BECAUSE MATLAB WANTS ONLY ONE TYPE IN THE WHOLE ARRAY.
    
    incompleteTime(1:numberOfMeasures(j),j)=House(1:numberOfMeasures(j),1);
    
    incompletePower(1:numberOfMeasures(j),j)=str2double(House(1:numberOfMeasures(j),2)); 
        % We remake the strings in double
    
    k=1;%init
    for i=1:77733 %number of quarter hours of measurements
        datatime=strsplit(incompleteTime(k,j),'+'); %We cut off the "+" that manages the time zone and we will only be interested in the quarter of an hour later
       if strcmp(datatime(1),refTimeOrderedMatrix(i))
           totalPower(i,j)=incompletePower(k,j);
           k=k+1;
       else
           %do nothing, let NaN
       end
    end
    
end

%% Save de la matrice avec des NaN mais données alignées
    curPath = pwd;
    cd("./Output/")
    
    save('totalPowerWithNaN.mat','totalPower');
        
    cd(curPath)




