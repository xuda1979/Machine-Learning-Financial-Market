clear;
N=15; %the smallest number of rows in all the historical

load HSInet net;
%%%input data of FTSE
SPYVOLUM=csvread('C:\Company\historical\^GSPC.csv',1,5,[1,5,N+1,5]);
SPYVOLUM=0.00000001*flipud(SPYVOLUM);
 
SPY=0.01*csvread('C:\Company\historical\^GSPC.csv',1,1,[1,1,N+1,4]);
 SPY=flipud(SPY);
 
 HSI1VOLUM=csvread('C:\Company\historical\^HSI.csv',1,5,[1,5,N+1,5]);
 HSI1VOLUM=0.00000001*flipud(HSI1VOLUM);
 
 HSI1=0.01*csvread('C:\Company\historical\^HSI.csv',1,1,[1,1,N+1,4]);
 HSI1=flipud(HSI1);
 
 
inputSeries = tonndata([HSI1VOLUM,SPY,SPYVOLUM],false,false);
targetSeries = tonndata(HSI1,false,false);

 
[inputs,inputStates,layerStates,targets] = preparets(net,inputSeries,{},targetSeries);

 
 
nets = removedelay(net);
nets.name = [net.name ' - Predict One Step Ahead'];
 
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
ys = nets(xs,xis,ais);
 
file=fopen('C:\\Company\\historical\\^HSI.csv');
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
csvwrite('C:\\Company\\result1DHSI.csv', C);
f = ftp('ftp.ipage.com','aatsyscom','DongFeng09$$');
try
delete(f,'result1DHSI.csv');
catch exception
end 
mput(f,'C:\Company\result1DHSI.csv');
 close(f);


