clear;
clc;
load FTSEnet net;
N=net.numInputDelays; %the smallest number of rows in all the historical

 
%%%input data of FTSE
SPYVOLUM=csvread('C:\Company\historical\^GSPC.csv',1,5,[1,5,N+1,5]);
SPYVOLUM=0.00000001*flipud(SPYVOLUM);
 
SPY=0.01*csvread('C:\Company\historical\^GSPC.csv',1,1,[1,1,N+1,4]);
 SPY=flipud(SPY);
 
 FTSEVOLUM=csvread('C:\Company\historical\^FTSE.csv',1,5,[1,5,N+1,5]);
FTSEVOLUM=0.00000001*flipud(FTSEVOLUM);
 
 FTSE100=0.01*csvread('C:\Company\historical\^FTSE.csv',1,1,[1,1,N+1,4]);
 FTSE100=flipud(FTSE100);
 
 
inputSeries = tonndata([FTSEVOLUM,SPY,SPYVOLUM],false,false);
targetSeries = tonndata(FTSE100,false,false);

 
[inputs,inputStates,layerStates,targets] = preparets(net,inputSeries,{},targetSeries);
 
 
 



nets = removedelay(net);
nets.name = [net.name ' - Predict One Step Ahead'];
 
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
ys = nets(xs,xis,ais);
[ys{:}]

 
file=fopen('C:\\Company\\historical\\^FTSE.csv');
xiao=textscan(file, '%s', 'delimiter', ',');
xiao=[xiao{:}];
x=xiao(8);

y=textscan([x{:}], '%d', 'delimiter', '-');
z=[y{:}];
z=double(z);
n=datenum(z(1),z(2),z(3));
[zhouji,libaiji]=weekday(n);

A=100*ys{:,N-15};
 
C=[zhouji-1,A']
csvwrite('C:\\Company\\result1DZ.csv', C);
f = ftp('ftp.ipage.com','aatsyscom','DongFeng09$$');
try
delete(f,'result1DZ.csv');
catch exception
end 
mput(f,'C:\Company\result1DZ.csv');
 close(f);
 clear;