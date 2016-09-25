clear;
N=5000; %the smallest number of rows in all the historical

load HSInet net;
%%%input data of FTSE
SPYVOLUM=csvread('C:\Company\historical\^GSPC.csv',1,5,[1,5,5001,5]);
SPYVOLUM=0.00000001*flipud(SPYVOLUM);
 
SPY=0.01*csvread('C:\Company\historical\^GSPC.csv',1,1,[1,1,5001,4]);
 SPY=flipud(SPY);
 
 HSI1VOLUM=csvread('C:\Company\historical\^HSI.csv',1,5,[1,5,5001,5]);
 HSI1VOLUM=0.00000001*flipud(HSI1VOLUM);
 
 HSI1=0.01*csvread('C:\Company\historical\^HSI.csv',1,1,[1,1,5001,4]);
 HSI1=flipud(HSI1);
 
 
inputSeries = tonndata([HSI1VOLUM,SPY,SPYVOLUM],false,false);
targetSeries = tonndata(HSI1,false,false);

% Create a Nonlinear Autoregressive Network with External Input
inputDelays = 1:16;
feedbackDelays = 1:16;
hiddenLayerSize = 32;
net = narxnet(inputDelays,feedbackDelays,hiddenLayerSize);

% Prepare the Data for Training and Simulation
% The function PREPARETS prepares timeseries data for a particular network,
% shifting time by the minimum amount to fill input states and layer states.
% Using PREPARETS allows you to keep your original time series data unchanged, while
% easily customizing it for networks with differing numbers of delays, with
% open loop or closed loop feedback modes.
[inputs,inputStates,layerStates,targets] = preparets(net,inputSeries,{},targetSeries);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

performance=10;
while(true)
 
% Train the Network
[net,tr] = train(net,inputs,targets,inputStates,layerStates);

% Test the Network
outputs = net(inputs,inputStates,layerStates);
errors = gsubtract(targets,outputs);
net.performFcn='mae';
performance = perform(net,targets,outputs);
 

HSIperformance=100*performance

nets = removedelay(net);
nets.name = [net.name ' - Predict One Step Ahead'];
 
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
ys = nets(xs,xis,ais);
A=100*ys{:,N-14};
if(A(2)>=A(1) && A(2)>=A(3) && A(2)>=A(4) && A(3)<=A(1) && A(3)<=A(4))
    break;
end
clear net;
clear nets;
end
 
file=fopen('C:\\Company\\historical\\^HSI.csv');
xiao=textscan(file, '%s', 'delimiter', ',');
xiao=[xiao{:}];
x=xiao(8);

y=textscan([x{:}], '%d', 'delimiter', '-');
z=[y{:}];
z=double(z);
n=datenum(z(1),z(2),z(3));
[zhouji,libaiji]=weekday(n);

 
 
C=[zhouji-1,A',HSIperformance];
csvwrite('C:\\Company\\result1DHSI.csv', C);
f = ftp('ftp.ipage.com','aatsyscom','DongFeng09$$');
try
delete(f,'result1DHSI.csv');
catch exception
end 
mput(f,'C:\Company\result1DHSI.csv');
 close(f);


