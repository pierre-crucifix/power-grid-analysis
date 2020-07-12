%% Reorganize date and time data structure
% Script for loading thoeretical consumption data measure points of houses 
% in .mat format structured as "01-Jan-2011 00:00:00" and saving it in .mat
% format in the following form : "2011-01-01 00:00:00" (form used in the
% data set retrieved from smart meters).
%

clc; clear; close all;

load Input/refTime.mat
refTimeMatrix = table2array(refTime);
refTimeOrderedMatrix = strings(77733,1); %preallocation - ...
                        %...equivalent to zeros(77733,1) but for strings

splitDateTimeMatrix = strings(77733,2);
splitDayMonthYearMatrix = strings(77733,3);

IDmonth = " "; %preallocation



for i=1:77733 %number of quarter hours of measurements
   splitDateTimeMatrix(i,:)=strsplit(refTimeMatrix(i),' ');
   %["01-Jan-2011", "00:00:00"]
   splitDayMonthYearMatrix(i,:)=strsplit(splitDateTimeMatrix(i),'-');
   %["01", "Jan", "2011"]
   
   IDmonth = Month2ID(splitDayMonthYearMatrix(i,2)); 
   %Reads "Jan" and will return "01", same for the other months of the year
   
   refTimeOrderedMatrix(i) = strcat(splitDayMonthYearMatrix(i,3), "-", IDmonth, "-", splitDayMonthYearMatrix(i,1), " ", splitDateTimeMatrix(i,2));
end

%% Save data
saveFile = ["orderedRefTime.mat"];


curPath = pwd;
cd("./Output/")
save(saveFile,'refTimeOrderedMatrix');
cd(curPath)

%% Sub-function called above

function IDmonth = Month2ID(string)
% Sub-function :
% Reads "Jan" and will return "01", same for the other months of the year
if string =="Jan"
    IDmonth= "01";
elseif string =="Feb"
    IDmonth= "02";
elseif string =="Mar"
    IDmonth= "03";
elseif string =="Apr"
    IDmonth= "04";
elseif string =="May"
    IDmonth= "05";
elseif string =="Jun"
    IDmonth= "06";
elseif string =="Jul"
    IDmonth= "07";
elseif string =="Aug"
    IDmonth= "08";
elseif string =="Sep"
    IDmonth= "09";
elseif string =="Oct"
    IDmonth= "10";
elseif string =="Nov"
    IDmonth= "11";
elseif string =="Dec"
    IDmonth= "12";
else
    msg = 'There is at least one data where the month does not correspond to the abbreviation of an existing month, treat this problem';
    error(msg)
end
end