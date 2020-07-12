function [inputPower,randomScenario] = generateScenario(input)
%this funciton generates load and power injection profiles based on theb parameters given by the user

%% load house data
load('totalPowerFilledWithoutNaN.mat');
load('cloudCoverFactor.mat')

%% determination of the orientation of the neighborhood
GeographicalOrientation = randi(4);
randomScenario.GeographicalOrientation = GeographicalOrientation;

%% set start and end time
Ts = 900;  % sampling rate is set to 900s (15min) !
startDay = input.startTime;             %first sample of the day is 00:00
endDay= input.endTime;                  %last sample of the day is 23:45   => exemple : write endDate=1 to stop at the end of day1
currentDay=startDay-1;                  %[day]. Julian day of the year (1-365)
Ndays=endDay-startDay+1;
Nsamples = Ndays*24*60*60/Ts;

%% setup irradiance parameters
input.irrad.Ts = Ts;
irradiance = solarIrradiance(input.irrad);
%% setup cloud cover parameters
cc_mean=input.irrad.ccmean;

%% computation of the final irradiance
totIrrad=zeros(Nsamples,1);
totradiation=0;
for i=1:Nsamples
    if ~mod(i-1,(24*60*60/Ts))
        if currentDay == 365
            currentDay = 1;
        else
            currentDay = currentDay +1;
        end
    end
    cc=cc_mean*YfitCC(i)+rand*0.02;
    totIrrad(i,1) = irradiance.sample(i,currentDay,cc);
    totradiation=totradiation+(totIrrad(i,1)/4);
end

%% generate parameters for PV installation
probaPV=zeros(1,input.nLoadNodes+1);
PVpower=zeros(input.nNodes,Nsamples);
randomScenario.PV=zeros(input.nLoadNodes+1,1);
for i=2:input.nLoadNodes+1
    probaPV(i)=input.matProbaDependingOnOrientation(GeographicalOrientation,input.HouseOrientation(i))*input.PvPenetrationRate;
    statisticComparison=rand;
    if statisticComparison < probaPV(i)
        PVsurface = 14+randi(36);
        randomScenario.PV(i)=PVsurface;
        PVpower(i,:) = -totIrrad'.*input.PvRdt.*input.PvRp.*PVsurface/3;   %/3 because monophase charge
    end
end

%% setup consumption data
consumedP = zeros(input.nNodes,Nsamples);
consumedQ = zeros(input.nNodes,Nsamples);
HouseConsDataRange=HouseConsData(1:Nsamples,1:1145);
randomScenario.consumption=zeros(input.nLoadNodes+1,1);
for i=2:input.nLoadNodes+1                                 % (1 is slack bus)
    randomizedIndex = randi(size(HouseConsDataRange,2));
    consumedP(i,:) = HouseConsDataRange(:,randomizedIndex)*4000/3;  % to put data in W (originally in kWh/15min)   /3 because monophase charge
    randomScenario.consumption(i)=randomizedIndex;
end
consumedQ = consumedP.*tan(acos(input.residentialpf));

%% setup v2g model
NumberHouseholds1car = round(input.EV.PenetrationRate * 25);
NumberHouseholds2car = round(input.EV.PenetrationRate * 19);

NumberEletricVehiclesPerHouse=zeros(1,input.nLoadNodes);
for j=1:NumberHouseholds1car
    NumberEletricVehiclesPerHouse(j) = 1;
end
for j=NumberHouseholds1car+1:NumberHouseholds1car+NumberHouseholds2car
    NumberEletricVehiclesPerHouse(j) = 2;
end

NumberEletricVehiclesPerHouse=NumberEletricVehiclesPerHouse(randperm(input.nLoadNodes));
NumberEletricVehiclesPerHouseWithSlack = [0,NumberEletricVehiclesPerHouse];

ProfilsConsoVehicules24hRAW = load('ProfilsConsoVehicules24hRAW.mat');
ProfilsConsoVehicules24hOptimized = load('ProfilsConsoVehicules24hOptimized.mat');

ProfilsConsoVehiculesNjoursRAW=zeros(20,96*Ndays);
ProfilsConsoVehiculesNjoursOptimized=zeros(20,96*Ndays);
for i=1:Ndays
    ProfilsConsoVehiculesNjoursRAW(:,1+96*(i-1):96*i)= ProfilsConsoVehicules24hRAW(:,:);
    ProfilsConsoVehiculesNjoursOptimized(:,1+96*(i-1):96*i)= ProfilsConsoVehicules24hOptimized(:,:);
end



EVconsRAW=zeros(input.nNodes,Nsamples);
EVconsOptimized=zeros(input.nNodes,Nsamples);
randomScenario.EV=zeros(input.nLoadNodes+1,3);
for i=2:input.nLoadNodes+1
    if NumberEletricVehiclesPerHouseWithSlack(i) == 1
        IDprofiltype = randi(20);
        EVconsRAW(i,:) = ProfilsConsoVehiculesNjoursRAW(IDprofiltype,:)*1000/3;
        
        EVconsOptimized(i,:) = ProfilsConsoVehiculesNjoursOptimized(IDprofiltype,:)*1000/3;
        
        randomScenario.EV(i,1)=1;
        randomScenario.EV(i,2)=IDprofiltype;
    elseif NumberEletricVehiclesPerHouseWithSlack(i) == 2
        IDprofiltype1 = randi(20);
        IDprofiltype2 = randi(20);
        EVconsRAW(i,:) = (ProfilsConsoVehiculesNjoursRAW(IDprofiltype1,:) + ProfilsConsoVehiculesNjoursRAW(IDprofiltype2,:))*1000/3; %/3 because monophase equiv of delta connected load
        
        EVconsOptimized(i,:) = (ProfilsConsoVehiculesNjoursOptimized(IDprofiltype1,:) + ProfilsConsoVehiculesNjoursOptimized(IDprofiltype2,:))*1000/3;
        
        randomScenario.EV(i,1)=2;
        randomScenario.EV(i,2)=IDprofiltype1;
        randomScenario.EV(i,3)=IDprofiltype2;
    else
        %skip : no electric car in this house
    end
    
end



%% return
inputPower.nonOpti.PVpower=PVpower./1e6;
inputPower.nonOpti.consumedP=consumedP./1e6;
inputPower.nonOpti.EVcons=EVconsRAW./1e6;
inputPower.nonOpti.totActivePower=(PVpower+consumedP+EVconsRAW)./1e6;
inputPower.nonOpti.totReactivePower=consumedQ./1e6;

inputPower.Opti.PVpower=PVpower./1e6;
inputPower.Opti.consumedP=consumedP./1e6;
inputPower.Opti.EVcons=EVconsOptimized./1e6;
inputPower.Opti.totActivePower=(PVpower+consumedP+EVconsOptimized)./1e6;
inputPower.Opti.totReactivePower=consumedQ./1e6;




end

