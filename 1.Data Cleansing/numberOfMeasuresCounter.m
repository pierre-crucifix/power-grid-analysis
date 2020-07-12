clc; clear; close all;

folderPath = "Input\HouseDataMAT\";
filename = "";
numberOfMeasures = zeros(1,1145);

for i=1:1145 %households
    filename = [strcat(folderPath,'house', num2str(i), '.mat')];
    load(filename); %will create a house variable with 2 columns: the first one with dates/times & the second one with consumption
    
    House=table2array(house); %BE CAREFUL, EVERYTHING GOES IN A THONG BECAUSE MATLAB WANTS ONLY ONE TYPE IN THE WHOLE ARRAY.
    numberOfMeasures(i)=length(House);   
end


%% Saving

    curPath = pwd;
    cd("./Output/")
    save('numberOfMeasures.mat','numberOfMeasures');    
    cd(curPath)
    