 clc;
clear;
load GSPCnet net;
N=16;
VIX=csvread('C:\Company\historical\^VIX.csv',1,1,[1,1,N+1,4]);
VIX=flipud(VIX);
 
 
%%%input data of GSPC
SPYVOLUM=csvread('C:\Company\historical\^GSPC.csv',1,5,[1,5,N+1,5]);
SPYVOLUM=0.00000001*flipud(SPYVOLUM);
 
SPY=0.01*csvread('C:\Company\historical\^GSPC.csv',1,1,[1,1,N+1,4]);
 SPY=flipud(SPY);
ALLOVERVOLUM=[SPYVOLUM,VIX];
inputSeries = tonndata([SPY,ALLOVERVOLUM],false,false);
targetSeries = tonndata(SPY,false,false);

 
[xs,xis,ais,ts] = preparets(net,inputSeries,targetSeries);
 
 
 ys = net(xs,xis,ais);
 [ys{:}]


 


 SPY=[SPY',zeros(4,1)]';
 ALLOVERVOLUM=[ALLOVERVOLUM',zeros(5,1)]';
inputSeries = tonndata([SPY,ALLOVERVOLUM],false,false);
targetSeries = tonndata(SPY,false,false);
[xs,xis,ais,ts] = preparets(net,inputSeries,targetSeries);
 ys = net(xs,xis,ais);
 [ys{:}]


file=fopen('C:\\Company\\historical\\^GSPC.csv');
xiao=textscan(file, '%s', 'delimiter', ',');
xiao=[xiao{:}];
x=xiao(8);

y=textscan([x{:}], '%d', 'delimiter', '-');
z=[y{:}];
z=double(z);
n=datenum(z(1),z(2),z(3));
[zhouji,libaiji]=weekday(n);

A=100*ys{end};
A
%B=double(csvread('C:\\Company\\result1D.csv', 1,0,[1,0,1,3])); 
C=[zhouji-1,A'];
csvwrite('C:\\Company\\result1D.csv', C);
f = ftp('ftp.ipage.com','aatsyscom','DongFeng09$$');
try
delete(f,'result1D.csv');
catch exception
end
mput(f,'C:\\Company\\result1D.csv');
 close(f);
 
save GSPCnet net;
 emailNote;