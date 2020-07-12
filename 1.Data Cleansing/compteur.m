%% Quantifies and qualifies missing / aberrant data

clc; clear; close all;

load Input\totalPowerWithNaN.mat

puissancemacplausible=7.4/4;% reminder: it's on 15min so it corresponds to 7.4kW
countErrorMeasureTooHigh = 0;
countErrorMeasureTooLow = 0;
countNaN = 0;

for i=1:77733 %77733
    for j=1:1145 %1145
        if (totalPower(i,j)>puissancemacplausible) %if the value is NaN it will not fit in the 'if'
            countErrorMeasureTooHigh = countErrorMeasureTooHigh + 1; 
        elseif (totalPower(i,j)<0)
            countErrorMeasureTooLow = countErrorMeasureTooLow + 1; 
        end
        
        if isnan(totalPower(i,j))
            countNaN = countNaN+1;
        end
    end
end        

maxValue = max(max(totalPower))
minValue = min(min(totalPower))

disp('pourcentage de valeurs manquantes exprimées en %')
propNaNvalues = countNaN / (77733*1145) *100
propTooHighValues = countErrorMeasureTooHigh / (77733*1145) *100
propTooLowValues = countErrorMeasureTooLow / (77733*1145) *100

%%
countNaNperHousehold = zeros(1,1145);

for i=1:77733 %77733
    for j=1:1145 %1145
        if isnan(totalPower(i,j))
            countNaNperHousehold(j) = countNaNperHousehold(j)+1;
        end
    end
end    

disp('percentage of missing values for the house that lost the most data expressed as %.')
max(countNaNperHousehold) / (77733) *100

NombreDeDonneesParMaison = 77733-countNaNperHousehold;

figure;
scatter(1:1145,NombreDeDonneesParMaison);

figure;
plot(1:1145,sort(NombreDeDonneesParMaison));



