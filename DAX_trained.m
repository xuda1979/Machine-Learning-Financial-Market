clear;
N=15; %the smallest number of rows in all the historical

load DAXnet net;
%%%input data of FTSE
SPYVOLUM=csvread('C:\Company\historical\^GSPC.csv',1,5,[1,5,N+1,5]);
SPYVOLUM=0.00000001*flipud(SPYVOLUM);
 
SPY=0.01*csvread('C:\Company\historical\^GSPC.csv',1,1,[1,1,N+1,4]);
 SPY=flipud(SPY);
 
 DAX1VOLUM=csvread('C:\Company\historical\^GDAXI.csv',1,5,[1,5,N+1,5]);
 DAX1VOLUM=0.00000001*flipud(DAX1VOLUM);
 
 DAX1=0.01*csvread('C:\Company\historical\^GDAXI.csv',1,1,[1,1,N+1,4]);
 DAX1=flipud(DAX1);
 
 
inputSeries = tonndata([DAX1VOLUM,SPY,SPYVOLUM],false,false);
targetSeries = tonndata(DAX1,false,false);

 
[inputs,inputStates,layerStates,targets] = preparets(net,inputSeries,{},targetSeries);

 
 



nets = removedelay(net);
nets.name = [net.name ' - Predict One Step Ahead'];
 
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
ys = nets(xs,xis,ais);
 
file=fopen('C:\\Company\\historical\\^GDAXI.csv');
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
csvwrite('C:\\Company\\result1DDAX.csv', C);
f = ftp('ftp.ipage.com','aatsyscom','DongFeng09$$');
try
delete(f,'result1DDAX.csv');
catch exception
end 
mput(f,'C:\Company\result1DDAX.csv');
 close(f);
 