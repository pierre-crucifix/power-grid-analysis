%Used to generate the deterministic part of the cloud cover profile
Xfit=1:35040;
YfitCC=zeros(1,35040);
pointsX=0:12;
pointsY=[1.145 1.139 1.052 1.056 0.920 0.961 0.920 0.848 0.860 0.962 0.985 1.152 1.145];
monthSeparation=[1 2976 5664 8640 11520 14496 17376 20352 23328 26208 29184 32064 35040];

for i=1:12
    p=polyfit(monthSeparation(i:i+1),pointsY(i:i+1),1);
    YfitCC(monthSeparation(i):monthSeparation(i+1))=polyval(p,Xfit(monthSeparation(i):monthSeparation(i+1)));
end
plot(Xfit,YfitCC)