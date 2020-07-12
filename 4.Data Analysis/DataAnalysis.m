close all; clc
%% check consumption and production order of magnitude
%PV prod ----------------------------------------------
pvSurf=0;
pvProdTot=0;
for i=1:size(A,2)
pvSurf = pvSurf + sum(A(i).outputData.randomScenarioParam.PV);
pvProdTot = pvProdTot + sum(A(i).outputData.nonOpti.PVpower)/4;
end
pvProdPerSqMeter = pvProdTot/pvSurf
%should be around 135 kWh/m²/year

%House Cons -------------------------------------------
HouseConsTot=0;
for i=1:size(A,2)
HouseConsTot = HouseConsTot + sum(A(i).outputData.nonOpti.consumedP)/4;
end
MeanConsPerHouse = HouseConsTot/(55*size(A,2))

%EV cons ----------------------------------------------
EVConsTot=0;
totEV=0;
for i=1:size(A,2)
EVConsTot = EVConsTot + sum(A(i).outputData.nonOpti.EVcons)/4;
totEV = totEV + sum(A(i).outputData.randomScenarioParam.EV(:,1));
end
ConsPerEV = EVConsTot / totEV
%should be around 3000 kWh/vehicle/year

%% Impact of components of the power
fullPVpower=zeros(1,35040);
fullconsumedP=zeros(1,35040);
fullEVcons=zeros(1,35040);
fullTotActivePower=zeros(1,35040);
for i=1:size(A,2)
    fullPVpower=fullPVpower + A(i).outputData.nonOpti.PVpower;
    fullconsumedP=fullconsumedP + A(i).outputData.nonOpti.consumedP;
    fullEVcons=fullEVcons + A(i).outputData.nonOpti.EVcons;
    fullTotActivePower=fullTotActivePower + A(i).outputData.nonOpti.totActivePower;
end
annualPVpower=fullPVpower/size(A,2);
annualconsumedP=fullconsumedP/size(A,2);
annualEVcons=fullEVcons/size(A,2);
annualTotActivePower=fullTotActivePower/size(A,2);

figure;
set(gcf, 'Position',  [300, 300, 700, 300])
plot(annualTotActivePower,'LineWidth',1.2)
hold on
plot(annualPVpower,'LineWidth',1.2)
plot(annualconsumedP,'LineWidth',1.2)
plot(annualEVcons,'LineWidth',1.2)
xlabel('time [1/4h]')
ylabel('active power [kW]')
legend('total','PV','consumption','EV')
legend('boxoff')
legend('Location','northwest')
xlim([1.488e4 1.5e4])


%% Effect of the optimisation
fullEVconsOpti=zeros(1,35040);
for i=1:size(A,2)
    fullEVconsOpti=fullEVconsOpti + A(i).outputData.Opti.EVcons;
end
annualEVconsOpti=fullEVconsOpti/size(A,2);

figure;
set(gcf, 'Position',  [300, 300, 700, 300])
plot(annualEVcons,'LineWidth',1.2,'Color','black')
hold on
plot(annualEVconsOpti,'LineWidth',1.2,'Color',[98 153 62]./256)
legend('nonOpti','Opti')
legend('boxoff')
xlabel('time [1/4h]')
ylabel('active power [W]')
xlim([1.522e4 1.542e4])


%% economical analysis
for i=1:size(A,2)
SavedMoneyFinal(i)=A(i).outputData.SavedMoney;
PriceGridOpti(i) = A(i).outputData.Opti.totalAmount;
PriceGridNonOpti(i) = A(i).outputData.nonOpti.totalAmount;
end

meanSavedMoney=mean(SavedMoneyFinal);
medianSavedMoney=median(SavedMoneyFinal);
varSavedMoney=var(SavedMoneyFinal);

figure;
set(gcf, 'Position',  [300, 300, 350, 300]);
histogram(PriceGridNonOpti,'facecolor',[98 153 62]./256);
%title('Distribution of the saved money')
xlabel('Cost to ugrade the grid []')
ylabel('occurences')

sortedPriceGridOpti=sort(PriceGridOpti,'ascend');
sortedPriceGridNonOpti=sort(PriceGridNonOpti,'ascend');

quant999val=floor(999/1000*size(sortedPriceGridOpti,2));
quant99val=99/100*size(sortedPriceGridOpti,2);
quant95val=95/100*size(sortedPriceGridOpti,2);

quantile999opti=sortedPriceGridOpti(quant999val);
quantile99opti=sortedPriceGridOpti(quant99val);
quantile95opti=sortedPriceGridOpti(quant95val);

quantile999NonOpti=sortedPriceGridNonOpti(quant999val);
quantile99NonOpti=sortedPriceGridNonOpti(quant99val);
quantile95NonOpti=sortedPriceGridNonOpti(quant95val);

gain999=quantile999NonOpti-quantile999opti;
gain99=quantile99NonOpti-quantile99opti;
gain95=quantile95NonOpti-quantile95opti;

 
figure;
set(gcf, 'Position',  [300, 300, 350, 300]);
hold on;
plot(sortedPriceGridNonOpti,'LineWidth',1.2,'Color',[98 153 62]./256);
xlabel('sample')
ylabel('Cost to ugrade the grid []')
% xline(quant999val);
xline(quant99val,'LineWidth',1.2,'Color','black');
% xline(quant95val);


%% potential profit of additional flexibility
for i=1:size(A,2)
LinesEconomy12(i)=A(i).outputData.avoidedPeaks.monthly.LinesEconomy;
LinesEconomy52(i)=A(i).outputData.avoidedPeaks.weekly.LinesEconomy;
LinesEconomy365(i)=A(i).outputData.avoidedPeaks.daily.LinesEconomy;

TransfoEconomy12(i)=A(i).outputData.avoidedPeaks.monthly.TransfoEconomy;
TransfoEconomy52(i)=A(i).outputData.avoidedPeaks.weekly.TransfoEconomy;
TransfoEconomy365(i)=A(i).outputData.avoidedPeaks.daily.TransfoEconomy;
end

MeanLinesEconomy12 = mean(LinesEconomy12);
MeanLinesEconomy52 = mean(LinesEconomy52);
MeanLinesEconomy365 = mean(LinesEconomy365);

MeanTransfoEconomy12 = mean(TransfoEconomy12);
MeanTransfoEconomy52 = mean(TransfoEconomy52);
MeanTransfoEconomy365 = mean(TransfoEconomy365);

%% Max power comparison
for i=1:size(A,2)
TransformerMaxPowerOpti(i)=A(i).outputData.Opti.TransfoMaxPower;
TransformerMaxPowerNonOpti(i)=A(i).outputData.nonOpti.TransfoMaxPower;
end
GainInTransfoPower = TransformerMaxPowerNonOpti - TransformerMaxPowerOpti;

MeanTransformerMaxPowerOpti=mean(TransformerMaxPowerOpti);
MeanTransformerMaxPowerNonOpti=mean(TransformerMaxPowerNonOpti);
MedianTransformerMaxPowerOpti=median(TransformerMaxPowerOpti);
MedianTransformerMaxPowerNonOpti=median(TransformerMaxPowerNonOpti);
VarTransformerMaxPowerOpti=var(TransformerMaxPowerOpti);
VarTransformerMaxPowerNonOpti=var(TransformerMaxPowerNonOpti);

figure;
plot(TransformerMaxPowerOpti)

figure; 
set(gcf, 'Position',  [300, 300, 350, 300])
histogram(GainInTransfoPower,25)
xlabel('Power economy at the worse time [kW]')
ylabel('Occurences')

%% Plot un comparatif temporel de la puissance transfo 

fullTemporalTransfoPowerNonOpti=zeros(1,35040);
fullTemporalTransfoPowerOpti=zeros(1,35040);
for i=1:size(A,2)
fullTemporalTransfoPowerNonOpti=fullTemporalTransfoPowerNonOpti + A(i).outputData.nonOpti.Ptransfo;
fullTemporalTransfoPowerOpti=fullTemporalTransfoPowerOpti + A(i).outputData.Opti.Ptransfo;
end
TemporalTransfoPowerNonOpti = fullTemporalTransfoPowerNonOpti/size(A,2);
TemporalTransfoPowerOpti = fullTemporalTransfoPowerOpti/size(A,2);

figure;
set(gcf, 'Position',  [300, 300, 350, 300])
plot(TemporalTransfoPowerNonOpti,'LineWidth',1.2,'Color','black')
hold on
plot(TemporalTransfoPowerOpti,'LineWidth',1.2,'Color',[98 153 62]./256)
legend('nonOpti','Opti')
xlabel('time [1/4h]')
ylabel('active power [kW]')


figure;
set(gcf, 'Position',  [300, 300, 350, 300])
plot(TemporalTransfoPowerNonOpti,'LineWidth',1.2,'Color','black')
hold on
plot(TemporalTransfoPowerOpti,'LineWidth',1.2,'Color',[98 153 62]./256)
legend('nonOpti','Opti')
xlabel('time [1/4h]')
ylabel('active power [kW]')
xlim([1.545e4 1.56e4])

%% histogramme du nombre de lignes à upgrade
for i=1:size(A,2)
numberOfLinesToUpgradeNonOpti(i)=sum(A(i).outputData.nonOpti.linesToUpgrade);
numberOfLinesToUpgradeOpti(i)=sum(A(i).outputData.Opti.linesToUpgrade);
economisedLines(i)=numberOfLinesToUpgradeNonOpti(i)-numberOfLinesToUpgradeOpti(i);
end
figure; 
set(gcf, 'Position',  [300, 300, 350, 300])
histogram(economisedLines)
xlabel('Number of lines upgrade avoided')
ylabel('Occurences')

%% calcul du nombre d'occurence (/2500) pour les branches 57, 68 et 90 doivent etre remplacées (opti VS non opti)
occurences57breaksNonOpti=0;
occurences68breaksNonOpti=0;
occurences90breaksNonOpti=0;
occurences57breaksOpti=0;
occurences68breaksOpti=0;
occurences90breaksOpti=0;
for i=1:size(A,2)
occurences57breaksNonOpti= occurences57breaksNonOpti+A(i).outputData.nonOpti.linesToUpgrade(57);
occurences68breaksNonOpti= occurences68breaksNonOpti+A(i).outputData.nonOpti.linesToUpgrade(68);
occurences90breaksNonOpti= occurences90breaksNonOpti+A(i).outputData.nonOpti.linesToUpgrade(90);
occurences57breaksOpti= occurences57breaksOpti+A(i).outputData.Opti.linesToUpgrade(57);
occurences68breaksOpti= occurences68breaksOpti+A(i).outputData.Opti.linesToUpgrade(68);
occurences90breaksOpti= occurences90breaksOpti+A(i).outputData.Opti.linesToUpgrade(90);
end

%% Plot un comparatif temporel du courant !
%+ moment le plus limite (max) => montrer le gain a ce moment la
fullTemporalbranch68currentNonOpti=zeros(1,35040);
fullTemporalbranch68currentOpti=zeros(1,35040);
for i=1:size(A,2)
fullTemporalbranch68currentNonOpti=fullTemporalbranch68currentNonOpti + A(i).outputData.nonOpti.branch68current;
fullTemporalbranch68currentOpti=fullTemporalbranch68currentOpti + A(i).outputData.Opti.branch68current;
end
Temporalbranch68currentNonOpti = fullTemporalbranch68currentNonOpti/size(A,2);
Temporalbranch68currentOpti = fullTemporalbranch68currentOpti/size(A,2);

figure;
set(gcf, 'Position',  [300, 300, 700, 300])
plot(Temporalbranch68currentNonOpti,'LineWidth',1.2,'Color','black')
hold on
plot(Temporalbranch68currentOpti,'LineWidth',1.2,'Color',[98 153 62]./256)
legend('nonOpti','Opti')
legend('boxoff')
xlim([1.535e4 1.56e4])
xlabel('time [1/4h]')
ylabel('Current [A]')

%% Plot un comparatif temporel de la tension !
fullTemporalbus56voltageNonOpti=zeros(1,35040);
fullTemporalbus56voltageOpti=zeros(1,35040);
for i=1:size(A,2)
fullTemporalbus56voltageNonOpti=fullTemporalbus56voltageNonOpti + A(i).outputData.nonOpti.bus56voltage;
fullTemporalbus56voltageOpti=fullTemporalbus56voltageOpti + A(i).outputData.Opti.bus56voltage;
end
Temporalbus56voltageNonOpti = fullTemporalbus56voltageNonOpti/size(A,2);
Temporalbus56voltageOpti = fullTemporalbus56voltageOpti/size(A,2);

figure;
set(gcf, 'Position',  [300, 300, 700, 300])
plot(Temporalbus56voltageNonOpti,'LineWidth',1.2,'Color','black')
hold on
plot(Temporalbus56voltageOpti,'LineWidth',1.2,'Color',[98 153 62]./256)
legend('nonOpti','Opti')
xlim([1.535e4 1.56e4])
xlabel('time [1/4h]')
ylabel('Voltage [pu]')

%% Nombre de problèmes de tension
amountOfVoltageTroubleNonOpti=0;
amountOfVoltageTroubleOpti=0;
for i=1:size(A,2)
amountOfVoltageTroubleNonOpti=amountOfVoltageTroubleNonOpti + A(i).outputData.nonOpti.voltageTrouble;
amountOfVoltageTroubleOpti=amountOfVoltageTroubleNonOpti + A(i).outputData.Opti.voltageTrouble;
end
amountOfVoltageTroubleNonOpti;
amountOfVoltageTroubleOpti;

%% gain lie a la flexibilite additionnelle
gainMonthly = 0;
gainWeekly = 0;
gainDaily = 0;
for i=1:size(A,2)
gainMonthly(i) = A(i).outputData.avoidedPeaks.monthly.LinesEconomy;
gainWeekly(i) = A(i).outputData.avoidedPeaks.weekly.LinesEconomy;
gainDaily(i) = A(i).outputData.avoidedPeaks.daily.LinesEconomy;
end

MeangainMonthly=mean(gainMonthly);
MeangainWeekly=mean(gainWeekly);
MeangainDaily=mean(gainDaily);

figure; 
set(gcf, 'Position',  [300, 300, 200, 300])
histogram(gainMonthly)
xlabel('economy []')
ylabel('Occurences')

figure; 
set(gcf, 'Position',  [300, 300, 200, 300])
histogram(gainWeekly)
xlabel('economy []')
ylabel('Occurences')

figure; 
set(gcf, 'Position',  [300, 300, 200, 300])
histogram(gainDaily)
xlabel('economy []')
ylabel('Occurences')

%% représentation du gain sur branch57
fullbranch57current=zeros(1,35040);
for i=1:size(A,2)
fullbranch57current = fullbranch57current + A(i).outputData.Opti.branch57current;
end
meanBranch57current=fullbranch57current/size(A,2);

sortedMeanBranch57current=sort(meanBranch57current,'descend');

figure; 
set(gcf, 'Position',  [300, 300, 750, 300])
plot(sortedMeanBranch57current,'LineWidth',1.2,'Color',[98 153 62]./256)
yline(400,'LineWidth',1.2,'Color','red')
xline(12,'LineWidth',1.2,'Color','black');
xline(52,'LineWidth',1.2,'Color','black');
xline(365,'LineWidth',1.2,'Color','black');
xlim([0 700]);
xlabel('samples')
ylabel('Currents [A]')
legend('sorted current peaks','current limit','number of efforts')
legend('boxoff')

%% calcul du nombre d'efforts necessaires
WorseScenario=find(TransformerMaxPowerNonOpti==MaxTransfoPowerAbsolute);
limitValue = 400;
for i=1:size(A,2)
sortedBranch57current=sort(A(i).outputData.Opti.branch57current,'descend');
effortsNeeded(i) = find(sortedBranch57current<limitValue,1,'first');
end

figure; 
set(gcf, 'Position',  [300, 300, 750, 300])
histogram(effortsNeeded)
xlabel('number of peaks that need to be avoided')
ylabel('Occurences')




