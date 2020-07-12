clear all; close all; clc

%rng(1); %pour controler les phénomènes aléatoires
tic
load('./data/Grid_topology/formatedLinesDataAC.mat')
load('./data/Grid_topology/Linesprice.mat')
coutparligne = table2array(Linesprice);

define_constants;


input.startTime=1;  
input.endTime=365;
input.nNodes=112;
input.nLoadNodes=55;
input.centralLines=[57 59 61 62 63 64 66 67 68 69 70 72 74 75 76 77 79 80 81 82 84 86 88 89 90 91 93 94 95 96 97 100 102 103 105 107 109 111];
%--------------------------
input.irrad.lat=50;
input.irrad.t=0.75;
input.irrad.p=101.325;
input.irrad.ccmean=0.4;
input.irrad.ccvar=0.1567;
input.irrad.N=96;
input.irrad.Aobs=1;
%--------------------------
input.PvPenetrationRate=0.2;%.2;
input.PvRp=0.75;
input.PvRdt=0.15;
%--------------------------
input.residentialpf=0.97;
%--------------------------
input.EV.PenetrationRate=0.3;%.35;
%--------------------------
input.centralLineLimit=400;
input.normalLineLimit=150;
input.transfoRatedPower=200;
input.priceTranfo=10;
input.priceOLTC=50;
%--------------------------
input.safetyMargin=0.05;


for iter=1:2
    
    mpcNonOpti = loadcase('IEEE_EU_LV_testfeeder.m');
    mpcOpti = loadcase('IEEE_EU_LV_testfeeder.m');
    %%generate random scenarios
    [inputPower,randomScenario] = generateScenario(input);
    
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Power Flow calculations%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    outputResults.nonOpti.bus.pd=zeros(112,size(inputPower.nonOpti.totActivePower,2));
    outputResults.nonOpti.bus.qd=zeros(112,size(inputPower.nonOpti.totActivePower,2));
    outputResults.nonOpti.bus.vm=zeros(112,size(inputPower.nonOpti.totActivePower,2));
    outputResults.nonOpti.bus.va=zeros(112,size(inputPower.nonOpti.totActivePower,2));
    outputResults.nonOpti.gen.pg=zeros(1,size(inputPower.nonOpti.totActivePower,2));
    outputResults.nonOpti.gen.qg=zeros(1,size(inputPower.nonOpti.totActivePower,2));
    outputResults.nonOpti.gen.vg=zeros(1,size(inputPower.nonOpti.totActivePower,2));
    outputResults.nonOpti.branch.pf=zeros(112,size(inputPower.nonOpti.totActivePower,2));
    outputResults.nonOpti.branch.pt=zeros(112,size(inputPower.nonOpti.totActivePower,2));
    outputResults.nonOpti.branch.qf=zeros(112,size(inputPower.nonOpti.totActivePower,2));
    outputResults.nonOpti.branch.qt=zeros(112,size(inputPower.nonOpti.totActivePower,2));
    
    outputResults.Opti.bus.pd=zeros(112,size(inputPower.nonOpti.totActivePower,2));
    outputResults.Opti.bus.qd=zeros(112,size(inputPower.nonOpti.totActivePower,2));
    outputResults.Opti.bus.vm=zeros(112,size(inputPower.nonOpti.totActivePower,2));
    outputResults.Opti.bus.va=zeros(112,size(inputPower.nonOpti.totActivePower,2));
    outputResults.Opti.gen.pg=zeros(1,size(inputPower.nonOpti.totActivePower,2));
    outputResults.Opti.gen.qg=zeros(1,size(inputPower.nonOpti.totActivePower,2));
    outputResults.Opti.gen.vg=zeros(1,size(inputPower.nonOpti.totActivePower,2));
    outputResults.Opti.branch.pf=zeros(112,size(inputPower.nonOpti.totActivePower,2));
    outputResults.Opti.branch.pt=zeros(112,size(inputPower.nonOpti.totActivePower,2));
    outputResults.Opti.branch.qf=zeros(112,size(inputPower.nonOpti.totActivePower,2));
    outputResults.Opti.branch.qt=zeros(112,size(inputPower.nonOpti.totActivePower,2));
    
    OPT = mpoption('out.all',0,'verbose',0);
    
    
    for i=1:size(inputPower.nonOpti.totActivePower,2)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NON OPTIMIZED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        mpcNonOpti.bus(:,3)=inputPower.nonOpti.totActivePower(:,i)*(1+input.safetyMargin);
        mpcNonOpti.bus(:,4)=inputPower.nonOpti.totReactivePower(:,i)*(1+input.safetyMargin);
        resultsNonOpti = runpf(mpcNonOpti,OPT);
        
        outputResults.nonOpti.bus.pd(:,i)=resultsNonOpti.bus(:,3)*1000;
        outputResults.nonOpti.bus.qd(:,i)=resultsNonOpti.bus(:,4)*1000;
        outputResults.nonOpti.bus.vm(:,i)=resultsNonOpti.bus(:,8);
        outputResults.nonOpti.bus.va(:,i)=resultsNonOpti.bus(:,9);
        outputResults.nonOpti.gen.pg(1,i)=resultsNonOpti.gen(1,2)*1000;
        outputResults.nonOpti.gen.qg(1,i)=resultsNonOpti.gen(1,3)*1000;
        outputResults.nonOpti.gen.vg(1,i)=resultsNonOpti.gen(1,6);
        outputResults.nonOpti.branch.pf(:,i)=resultsNonOpti.branch(:,14)*1000;
        outputResults.nonOpti.branch.pt(:,i)=resultsNonOpti.branch(:,16)*1000;
        outputResults.nonOpti.branch.qf(:,i)=resultsNonOpti.branch(:,15)*1000;
        outputResults.nonOpti.branch.qt(:,i)=resultsNonOpti.branch(:,17)*1000;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OPTIMIZED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        mpcOpti.bus(:,3)=inputPower.Opti.totActivePower(:,i)*(1+input.safetyMargin);
        mpcOpti.bus(:,4)=inputPower.Opti.totReactivePower(:,i)*(1+input.safetyMargin);
        resultsOpti = runpf(mpcOpti,OPT);
        
        outputResults.Opti.bus.pd(:,i)=resultsOpti.bus(:,3)*1000;
        outputResults.Opti.bus.qd(:,i)=resultsOpti.bus(:,4)*1000;
        outputResults.Opti.bus.vm(:,i)=resultsOpti.bus(:,8);
        outputResults.Opti.bus.va(:,i)=resultsOpti.bus(:,9);
        outputResults.Opti.gen.pg(1,i)=resultsOpti.gen(1,2)*1000;
        outputResults.Opti.gen.qg(1,i)=resultsOpti.gen(1,3)*1000;
        outputResults.Opti.gen.vg(1,i)=resultsOpti.gen(1,6);
        outputResults.Opti.branch.pf(:,i)=resultsOpti.branch(:,14)*1000;
        outputResults.Opti.branch.pt(:,i)=resultsOpti.branch(:,16)*1000;
        outputResults.Opti.branch.qf(:,i)=resultsOpti.branch(:,15)*1000;
        outputResults.Opti.branch.qt(:,i)=resultsOpti.branch(:,17)*1000;
        
    end
    
    
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% compute currents and spot overload %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    ipNonOpti=zeros(input.nNodes,size(outputResults.nonOpti.branch.pf,2));
    iqNonOpti=zeros(input.nNodes,size(outputResults.nonOpti.branch.pf,2));
    outputResults.nonOpti.branch.iTot=zeros(input.nNodes,size(outputResults.nonOpti.branch.pf,2));
    outputResults.nonOpti.branch.overload=false(input.nNodes,size(outputResults.nonOpti.branch.pf,2));
    outputResults.nonOpti.branch.toUpgrade=false(input.nNodes,1);
    troubleNonOpti=false;
    undervoltages09NonOpti=zeros(1,size(outputResults.nonOpti.branch.pf,2));
    
    ipOpti=zeros(input.nNodes,size(outputResults.Opti.branch.pf,2));
    iqOpti=zeros(input.nNodes,size(outputResults.Opti.branch.pf,2));
    outputResults.Opti.branch.iTot=zeros(input.nNodes,size(outputResults.Opti.branch.pf,2));
    outputResults.Opti.branch.overload=false(input.nNodes,size(outputResults.Opti.branch.pf,2));
    outputResults.Opti.branch.toUpgrade=false(input.nNodes,1);
    troubleOpti=false;
    undervoltages09Opti=zeros(1,size(outputResults.Opti.branch.pf,2));
    
    
    for i=2:input.nNodes
        for j=1:size(outputResults.nonOpti.branch.pf,2)
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NON OPTIMIZED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %----------------------Compute Current-----------------------------
            ipNonOpti(i,j) = outputResults.nonOpti.branch.pf(i,j) / (outputResults.nonOpti.bus.vm(Lines(i,1),j)*mpcNonOpti.bus(i,10));
            iqNonOpti(i,j) = outputResults.nonOpti.branch.qf(i,j) / (outputResults.nonOpti.bus.vm(Lines(i,1),j)*mpcNonOpti.bus(i,10));
            if outputResults.nonOpti.branch.pf(i,j)>=0
                outputResults.nonOpti.branch.iTot(i,j)=sqrt(ipNonOpti(i,j)^2+iqNonOpti(i,j)^2);
            else
                outputResults.nonOpti.branch.iTot(i,j)=-sqrt(ipNonOpti(i,j)^2+iqNonOpti(i,j)^2);
            end
            
            %----------------------Spot Over load------------------------------
            if ismember(i,input.centralLines)
                if abs(outputResults.nonOpti.branch.iTot(i,j))>input.centralLineLimit/3
                    outputResults.nonOpti.branch.overload(i,j)=true;
                    outputResults.nonOpti.branch.toUpgrade(i)=true;
                end
            else
                if abs(outputResults.nonOpti.branch.iTot(i,j))>input.normalLineLimit/3
                    outputResults.nonOpti.branch.overload(i,j)=true;
                    outputResults.nonOpti.branch.toUpgrade(i)=true;
                end
            end
            
            %----------------------Spot undervoltage----------------------------
            if outputResults.nonOpti.bus.vm(i,j)<0.85
                troubleNonOpti=true;
            elseif outputResults.nonOpti.bus.vm(i,j)<=0.9
                undervoltages09NonOpti(j)=1;
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OPTIMIZED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %----------------------Compute Current-----------------------------
            ipOpti(i,j) = outputResults.Opti.branch.pf(i,j) / (outputResults.Opti.bus.vm(Lines(i,1),j)*mpcOpti.bus(i,10));
            iqOpti(i,j) = outputResults.Opti.branch.qf(i,j) / (outputResults.Opti.bus.vm(Lines(i,1),j)*mpcOpti.bus(i,10));
            if outputResults.Opti.branch.pf(i,j)>=0
                outputResults.Opti.branch.iTot(i,j)=sqrt(ipOpti(i,j)^2+iqOpti(i,j)^2);
            else
                outputResults.Opti.branch.iTot(i,j)=-sqrt(ipOpti(i,j)^2+iqOpti(i,j)^2);
            end
            
            %----------------------Spot Over load------------------------------
            if ismember(i,input.centralLines)
                if abs(outputResults.Opti.branch.iTot(i,j))>input.centralLineLimit/3
                    outputResults.Opti.branch.overload(i,j)=true;
                    outputResults.Opti.branch.toUpgrade(i)=true;
                end
            else
                if abs(outputResults.Opti.branch.iTot(i,j))>input.normalLineLimit/3
                    outputResults.Opti.branch.overload(i,j)=true;
                    outputResults.Opti.branch.toUpgrade(i)=true;
                end
            end
            
            %----------------------Spot undervoltage----------------------------
            if outputResults.Opti.bus.vm(i,j)<0.85
                troubleOpti=true;
            elseif outputResults.Opti.bus.vm(i,j)<=0.9
                undervoltages09Opti(j)=1;
            end
            
            
        end
        %--------------------- spot generalized slight undervoltage --------------------------
        undervoltage09RateNonOpti=sum(undervoltages09NonOpti)/size(outputResults.nonOpti.branch.pf,2);
        if undervoltage09RateNonOpti>0.05
            troubleNonOpti=true;
        end
        
        undervoltage09RateOpti=sum(undervoltages09Opti)/size(outputResults.Opti.branch.pf,2);
        if undervoltage09RateOpti>0.05
            troubleOpti=true;
        end
        
    end
    outputResults.nonOpti.voltage_trouble=troubleNonOpti;
    outputResults.Opti.voltage_trouble=troubleOpti;
    
    
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% compute price of the grid upgrade %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NON OPTIMIZED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    TransfoNonOptiMaxP=max(abs(outputResults.nonOpti.gen.pg))*3;
    TransfoNonOptiMaxQ=max(abs(outputResults.nonOpti.gen.qg))*3;
    TransfoNonOptiMaxApparentPower=sqrt(TransfoNonOptiMaxP^2+TransfoNonOptiMaxQ^2);
    outputResults.nonOpti.totalAmount=cout(outputResults.nonOpti.branch.toUpgrade, coutparligne, TransfoNonOptiMaxApparentPower,outputResults.nonOpti.voltage_trouble, input.transfoRatedPower, input.priceTranfo, input.priceOLTC);  %divide rated power by three because we only simulate one of the three lines
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OPTIMIZED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    TransfoOptiMaxP=max(abs(outputResults.Opti.gen.pg))*3;
    TransfoOptiMaxQ=max(abs(outputResults.Opti.gen.qg))*3;
    TransfoOptiMaxApparentPower=sqrt(TransfoOptiMaxP^2+TransfoOptiMaxQ^2);
    outputResults.Opti.totalAmount=cout(outputResults.Opti.branch.toUpgrade, coutparligne, TransfoOptiMaxApparentPower,outputResults.Opti.voltage_trouble, input.transfoRatedPower, input.priceTranfo, input.priceOLTC);  %divide rated power by three because we only simulate one of the three lines
    
    outputResults.SavedMoney = outputResults.nonOpti.totalAmount - outputResults.Opti.totalAmount;
    
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Data to be saved %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    outputData.nonOpti.linesToUpgrade=outputResults.nonOpti.branch.toUpgrade;
    outputData.Opti.linesToUpgrade=outputResults.Opti.branch.toUpgrade;
    outputData.nonOpti.TransfoMaxPower=TransfoNonOptiMaxApparentPower;
    outputData.Opti.TransfoMaxPower=TransfoOptiMaxApparentPower;
    outputData.nonOpti.voltageTrouble=outputResults.nonOpti.voltage_trouble;
    outputData.Opti.voltageTrouble=outputResults.Opti.voltage_trouble;
    %--
    outputData.nonOpti.totalAmount=outputResults.nonOpti.totalAmount;
    outputData.Opti.totalAmount=outputResults.Opti.totalAmount;
    outputData.SavedMoney=outputResults.SavedMoney;
    %--
    outputData.nonOpti.Ptransfo=outputResults.nonOpti.gen.pg*3;
    outputData.Opti.Ptransfo=outputResults.Opti.gen.pg*3;
    outputData.nonOpti.Qtransfo=outputResults.nonOpti.gen.qg*3;
    outputData.Opti.Qtransfo=outputResults.Opti.gen.qg*3;
    %--
    outputData.nonOpti.PVpower=sum(inputPower.nonOpti.PVpower)*3*1000;
    outputData.nonOpti.consumedP=sum(inputPower.nonOpti.consumedP)*3*1000;
    outputData.nonOpti.EVcons=sum(inputPower.nonOpti.EVcons)*3*1000;
    outputData.nonOpti.totActivePower=sum(inputPower.nonOpti.totActivePower)*3*1000;
    outputData.nonOpti.totReactivePower=sum(inputPower.nonOpti.totReactivePower)*3*1000;
    outputData.Opti.PVpower=sum(inputPower.Opti.PVpower)*3*1000;
    outputData.Opti.consumedP=sum(inputPower.Opti.consumedP)*3*1000;
    outputData.Opti.EVcons=sum(inputPower.Opti.EVcons)*3*1000;
    outputData.Opti.totActivePower=sum(inputPower.Opti.totActivePower)*3*1000;
    outputData.Opti.totReactivePower=sum(inputPower.Opti.totReactivePower)*3*1000;
    %--
    outputData.randomScenarioParam=randomScenario;
    %--
    outputData.nonOpti.branch57current=outputResults.nonOpti.branch.iTot(57,:)*3;
    outputData.nonOpti.branch68current=outputResults.nonOpti.branch.iTot(68,:)*3;
    outputData.nonOpti.branch90current=outputResults.nonOpti.branch.iTot(90,:)*3;
    outputData.nonOpti.bus56voltage=outputResults.nonOpti.bus.vm(56,:);
    outputData.nonOpti.bus89voltage=outputResults.nonOpti.bus.vm(89,:);
    outputData.Opti.branch57current=outputResults.Opti.branch.iTot(57,:)*3;
    outputData.Opti.branch68current=outputResults.Opti.branch.iTot(68,:)*3;
    outputData.Opti.branch90current=outputResults.Opti.branch.iTot(90,:)*3;
    outputData.Opti.bus56voltage=outputResults.Opti.bus.vm(56,:);
    outputData.Opti.bus89voltage=outputResults.Opti.bus.vm(89,:);
    
    Iter_number=num2str(iter);
    name=strcat('./saved_data/scenario',Iter_number,'.mat');
    disp(name)
    save(name,'outputData');
    
end

toc
