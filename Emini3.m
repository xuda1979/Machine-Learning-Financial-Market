clear;
N=30000; %the smallest number of rows in all the historical data

 
 
%%%input data of GSPC
ESVOLUM=csvread('C:\Program Files (x86)\YLoader\data\ES.csv',0,4);
[rows,columns]=size(ESVOLUM);
ES=0.01*csvread('C:\Program Files (x86)\YLoader\data\ES.csv',rows-N-1,0, [rows-N-1,0,rows-1,3]);
ESVOLUM=0.01*ESVOLUM((rows-N):rows,1:1);

ES=[ES,ESVOLUM];



a=1;
b=1;
c=floor((N+1)/3);
E3=zeros(c,5);
while a<=floor(c)
     
    E3(a,1)=ES(3*a-2,1);
    E3(a,2)=max(ES(3*a,1),max(ES(3*a-1,2),ES(3*a-2,3)));
    E3(a,3)=min(ES(3*a,1),min(ES(3*a-1,2),ES(3*a-2,3)));
    E3(a,4)=ES(3*a,4);
    E3(a,5)=ES(3*a-2,5)+ES(3*a-1,5)+ES(3*a,5);
   a=a+1; 
end


E3VOLUM=E3(1:c,5:end);
E3=E3(1:c,2:4);
 
inputSeries = tonndata(E3VOLUM,false,false);
targetSeries = tonndata(E3,false,false);

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

% Train the Network
[net,tr] = train(net,inputs,targets,inputStates,layerStates);

% Test the Network
outputs = net(inputs,inputStates,layerStates);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs)

 
nets = removedelay(net);
nets.name = [net.name ' - Predict One Step Ahead'];
 
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
ys = 100*nets(xs,xis,ais);
 
save Emini3net net;










 