clear;
load NNKnet net;
N=net.numInputDelays-1; %the smallest number of rows in all the historical

 
%%%input data of FTSE
SPYVOLUM=csvread('C:\Company\historical\^GSPC.csv',1,5,[1,5,N+1,5]);
SPYVOLUM=0.00000001*flipud(SPYVOLUM);
 
SPY=0.01*csvread('C:\Company\historical\^GSPC.csv',1,1,[1,1,N+1,4]);
 SPY=flipud(SPY);
 
 NNKVOLUM=csvread('C:\Company\historical\^N225.csv',1,5,[1,5,N+1,5]);
 NNKVOLUM=0.00000001*flipud(NNKVOLUM);
 
 NNK=0.01*csvread('C:\Company\historical\^N225.csv',1,1,[1,1,N+1,4]);
 NNK=flipud(NNK);
 
 
inputSeries = tonndata([NNKVOLUM,SPY,SPYVOLUM],false,false);
targetSeries = tonndata(NNK,false,false);

 

% Prepare the Data for Training and Simulation
% The function PREPARETS prepares timeseries data for a particular network,
% shifting time by the minimum amount to fill input states and layer states.
% Using PREPARETS allows you to keep your original time series data unchanged, while
% easily customizing it for networks with differing numbers of delays, with
% open loop or closed loop feedback modes.
[inputs,inputStates,layerStates,targets] = preparets(net,inputSeries,{},targetSeries);

 



nets = removedelay(net);
nets.name = [net.name ' - Predict One Step Ahead'];
 
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
ys = nets(xs,xis,ais);
 
file=fopen('C:\\Company\\historical\\^N225.csv');
xiao=textscan(file, '%s', 'delimiter', ',');
xiao=[xiao{:}];
x=xiao(8);

y=textscan([x{:}], '%d', 'delimiter', '-');
z=[y{:}];
z=double(z);
n=datenum(z(1),z(2),z(3));
[zhouji,libaiji]=weekday(n);

A=100*ys{:,N-net.numInputDelays+2};
 
C=[zhouji-1,A'];
csvwrite('C:\\Company\\result1DN.csv', C);
f = ftp('ftp.ipage.com','aatsyscom','DongFeng09$$');
try
delete(f,'result1DN.csv');
catch exception
end 
mput(f,'C:\Company\result1DN.csv');
 close(f);
 
clear;