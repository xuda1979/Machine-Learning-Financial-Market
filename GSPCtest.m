clear;
clc;
y=zeros(4,2500);
N=500;
VIX=csvread('C:\Company\historical\^VIXBacktesting.csv',1,1);
VIX=0.01*flipud(VIX);
 
 
%%%input data of GSPC
SPY=csvread('C:\Company\historical\^GSPCBacktesting.csv',1,1);
SPY=flipud(SPY);
%SPYVOLUM=csvread('C:\Company\historical\^GSPCBacktesting.csv',1,5);

%SPYVOLUM=0.00000001*flipud(SPYVOLUM);
 SPYVOLUM=0.00000001*SPY(1:end,5:5);
SPY=0.001*SPY(1:end,1:4);

% Create a Nonlinear Autoregressive Network with External Input
inputDelays = 1:16;
 
hiddenLayerSize = 32;
 
net = timedelaynet(inputDelays,hiddenLayerSize);
 % Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
net.performFcn='mse';
ALLOVERVOLUM=[SPYVOLUM,VIX];
 
for i=(540-N+1):540
i
inputSeries = tonndata([SPY((1+5*i):(2527+5*i),1:end),ALLOVERVOLUM((1+5*i):(2527+5*i),1:end)],false,false);
targetSeries = tonndata(SPY((1+5*i):(2527+5*i),1:end),false,false);

 
%while(true)
 
 

% Prepare the Data for Training and Simulation
% The function PREPARETS prepares timeseries data for a particular network,
% shifting time by the minimum amount to fill input states and layer states.
% Using PREPARETS allows you to keep your original time series data unchanged, while
% easily customizing it for networks with differing numbers of delays, with
% open loop or closed loop feedback modes.
[inputs,inputStates,layerStates,targets] = preparets(net,inputSeries,targetSeries);




[net,tr] = train(net,inputs,targets,inputStates,layerStates);

% Test the Network
outputs = net(inputs,inputStates,layerStates);
errors = gsubtract(targets,outputs);
net.performFcn='mse';
performance = perform(net,targets,outputs);
%end

 GSPCperformance=100*performance;



nets = removedelay(net);
nets.name = [net.name ' - Predict One Step Ahead'];
 
[xs,xis,ais,ts] = preparets(nets,inputSeries,targetSeries);
ys = nets(xs,xis,ais);
 ys=[ys{:}];
A=1000*ys(:,end);
%if(A(2)>=A(1) && A(2)>=A(3) && A(2)>=A(4) && A(3)<=A(1) && A(3)<=A(4) )
    y(1:4,((i-540+N-1)*5+1):(i-540+N)*5)=1000*ys(:,(end-4):end);
%    break;
%end
 
%end

 
end 
 save y;
 system('shutdown -s');
