clc;
clear;
load TESTCOMPILE net;
N=16;
X=zeros(6,100)';
T=zeros(4,100)';
inputSeries = tonndata(X,false,false);
targetSeries = tonndata(T,false,false);
%net = narxnet(1:16,1:16,32);
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


%[Xs,Xi,Ai,Ts] = preparets(net,inputSeries,{},targetSeries)
% net = train(net,Xs,Ts,Xi,Ai);

%view(net)
%Y = net(Xs,Xi,Ai);
nets = removedelay(net);
nets.name = [net.name ' - Predict One Step Ahead'];
 
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
ys = nets(xs,xis,ais)
%perf = perform(net,Ts,Y)
%save TESTCOMPILE net;