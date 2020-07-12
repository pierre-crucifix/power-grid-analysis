% parts can be commented to get different maps
% plot with and without labels shouldnt be used a the same time

clear all;
close all; 
clc;

load('formatedBussesData.mat');
load('formatedLinesDataAC.mat');
load('initalGridData.mat')
load('BussesCoords')

figure;
hold on


% plot initial grid--------------------------------------------------------------------------------
for k=1:size(initialLines,1)
    xBusses = [initialBusses(initialLines(k,1),2) initialBusses(initialLines(k,2),2)];
    yBusses = [initialBusses(initialLines(k,1),3) initialBusses(initialLines(k,2),3)];
    initialLinesPlot(k) = plot(xBusses,yBusses,'Color',[0.6 0.6 0.6],'LineWidth',1.2);
end

%% plot simplified lines----------------------------------------------------------------------------------
for j=1:size(Lines,1)
    xBusses = [BussesCoords(Lines(j,1),2) BussesCoords(Lines(j,2),2)];
    yBusses = [BussesCoords(Lines(j,1),3) BussesCoords(Lines(j,2),3)];
    simplifiedLinesPlot(j) = plot(xBusses,yBusses,'Color',[0 0.4470 0.7410],'LineWidth',1.5);
end

%% plot simplified busses with labels-------------------------------------------------------------------
labels = Busses(:,1);
for i=1:size(BussesCoords(:,1))
    labelpoints(BussesCoords(i,2),BussesCoords(i,3),labels(i,1),'FontSize', 10)
    if i==1
    substation(i) = plot(BussesCoords(i,2),BussesCoords(i,3),'s','MarkerSize',10,'MarkerFaceColor','blue','MarkerEdgeColor','blue');
    elseif i<57
    loadpoint(i) = plot(BussesCoords(i,2),BussesCoords(i,3),'^','MarkerSize',6,'MarkerFaceColor','red','MarkerEdgeColor','red');
    else
    normalbus(i) = plot(BussesCoords(i,2),BussesCoords(i,3),'.','MarkerSize',12,'Color',[0 0.4470 0.7410]);
    end
end

%% plot simplified busses without labels-------------------------------------------------------------------
for i=1:size(BussesCoords(:,1))
    plot(BussesCoords(i,2),BussesCoords(i,3))
    if i==1
    substationPlot(i) = plot(BussesCoords(i,2),BussesCoords(i,3),'s','MarkerSize',10,'MarkerFaceColor','blue','MarkerEdgeColor','blue');
    elseif i==2
    loadpoint(1) = plot(BussesCoords(i,2),BussesCoords(i,3),'^','MarkerSize',6,'MarkerFaceColor','red','MarkerEdgeColor','red');
    elseif i<57 && i>2
    plot(BussesCoords(i,2),BussesCoords(i,3),'^','MarkerSize',6,'MarkerFaceColor','red','MarkerEdgeColor','red');
    else
    normalbus(i) = plot(BussesCoords(i,2),BussesCoords(i,3),'.','MarkerSize',12,'Color',[0 0.4470 0.7410]);
    end
end
dataforlegend = [substationPlot(1) loadpoint(1) initialLinesPlot(1) simplifiedLinesPlot(1)];
legend(dataforlegend,'cabine de transformation','maisons','lignes initiales','lignes simplifiées')
legend('boxoff')





