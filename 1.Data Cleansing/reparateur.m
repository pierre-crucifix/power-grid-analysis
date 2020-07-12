
%% Repairs missing / aberrant data

clc; clear; close all;

load Input\totalPowerWithNaN.mat

%% Removal of extreme values from the array

puissancemaxplausible=7.4/4; % Maximum plausible power from a consumer household, will be used as a terminal to identify erroneous data
puissanceminplausible=0; % There is no production, all that is negative is therefore measurement errors


for i=1:77733 %77733
    for j=1:1145 %1145
        if ((totalPower(i,j)>puissancemaxplausible)||(totalPower(i,j)<0))
            totalPower(i,j)= NaN; %will be replaced by the weighted average at the same time when the value is too extreme
        end        
    end
end        



%% Calculations of new averages 
%no longer taking into account extreme values due to measurement errors

meanConsumption=zeros(1,1145);%prealloc
meanConsumption=nanmean(totalPower);%We take the average of each column
globalMeanConsumption=nanmean(meanConsumption);

%% Calculation of the average per quarter hour for all the houses where we 
%have data at the corresponding quarters of an hour

%y = nansum( X ) returns the sum of the elements of X , computed after
%removing all NaN values.

moyenneGlobaleQuartHoraire = zeros(77733,1);
moyenneGlobaleQuartHoraire = nanmean(totalPower')'; %to average the lines without taking NaN into account, and thus dividing by the actual number of data
moyenneGlobaleQuartHoraire(1)=0;

%It then remains to go through the table box by box in search of NaN 
%(double loop for) and change the value according to the total individual 
%average consumption on the average consumption of all the total people 
%multiplied by the average consumption at the present moment

for i=1:77733 %77733
    for j=1:1145 %1145
        if isnan(totalPower(i,j))
            totalPower(i,j) = min(meanConsumption(j) / globalMeanConsumption * moyenneGlobaleQuartHoraire(i) , 1.85); %We limit it to 7.4/4=1.85 as before
        end        
    end
end
            
%% Various check-ups on the final data

minValue = min(min(totalPower));
maxValue = max(max(totalPower));
maxHouseholdMean = max(mean(totalPower)); 
% 'mean' averages each column => of each house

minHouseholdMean = min(mean(totalPower));

globalMeanConsumption2 = mean(mean(totalPower));

max(max(meanConsumption))
max(max(moyenneGlobaleQuartHoraire))

%check up of the max of the differences between the before and after 
%averages

diffDeMoyenneGlobale = abs(globalMeanConsumption2 - globalMeanConsumption)

meanConsumption2=zeros(1,1145);%prealloc
meanConsumption2=mean(totalPower);
diffDeMoyenneParMenage = abs(max(meanConsumption2 - meanConsumption))

moyenneGlobaleQuartHoraire2 = zeros(77733,1);
moyenneGlobaleQuartHoraire2 = mean(totalPower')';
diffDeMoyenneParQuartHoraire = abs(max(moyenneGlobaleQuartHoraire2 - moyenneGlobaleQuartHoraire))


%% Save the complete matrix with corrected data
   
    curPath = pwd;
    cd("./Output/")
    
    save('totalPowerFilledWithoutNaN.mat','totalPower');
        
    cd(curPath)


