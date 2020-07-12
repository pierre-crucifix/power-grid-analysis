% !!! uncomment the right prat to choose one the the cases !!!
clear all; clc;

dataSet1 = [1:609 667:1309 1334:2000 8001:8100 8201:8500 20001:20181];
dataSet2 = [2001:2613 2667:3305 3334:4000 8101:8200 11001:11300 20501:20681];
dataSet3 = [4001:4603 4667:5315 5334:5972 9001:9400 21001:21209];
dataSet4 = [6001:6595 6667:7257 7334:7995 10001:10400 21501:21752];


%% case 1 (20% PV - 30% EV) 
for i=1:size(dataSet1,2)
    number=num2str(dataSet1(i));
    name=strcat('scenario',number,'.mat');
    A(i)=load(name);

end

%% case 2 (30% PV - 45% EV)
for i=1:size(dataSet2,2)
    number=num2str(dataSet2(i));
    name=strcat('scenario',number,'.mat');
%     A(i)=matfile(name,'Writable',false);
    A(i)=load(name);

end

%% case 3 (40% PV - 60% EV)
for i=1:size(dataSet3,2)
    number=num2str(dataSet3(i));
    name=strcat('scenario',number,'.mat');
    %A(i)=matfile(name,'Writable',false);
    A(i)=load(name);

end

%% case 4 (50% PV - 80% EV)
for i=1:size(dataSet4,2)
    number=num2str(dataSet4(i));
    name=strcat('scenario',number,'.mat');
    A(i)=load(name);

end
