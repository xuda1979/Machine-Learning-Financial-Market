clear;
N=200000; %the smallest number of rows in all the historical data

frequency=60;
 
%%%input data of GSPC
ESVOLUM=csvread('C:\Company\historical\ES\ES.txt',0,6);
[rows,columns]=size(ESVOLUM);
ES=0.01*csvread('C:\Company\historical\ES\ES.txt',rows-N-1,1, [rows-N-1,1,rows-1,5]);
ESVOLUM=0.01*ESVOLUM((rows-N):rows,1:1);

ES=[ES,ESVOLUM];



a=1;
b=1;
c=floor((N+1)/frequency);
E60=zeros(c,6);
while a<=floor(c)
     
    E60(a,2)=ES(frequency*a-frequency+1,2);
    E60(a,6)=0;
    E60(a,3)=ES(frequency*a);
    E60(a,4)=ES(frequency*a);
    for i=0:(frequency-1)
    E60(a,3)=max(E60(a,3),ES(frequency*a-i));
    E60(a,4)=min(E60(a,4),ES(frequency*a-i));
    
    E60(a,6)=ES(frequency*a-i)+E60(a,6);
    end
    E60(a,5)=ES(frequency*a,5);
    t=ES(frequency*a,1);
    E60(a,1)= floor(t);
   a=a+1; 
end


E60VOLUM=E60(1:c,6:end);
SHIJIAN=E60(1:c,1:1);
mubiao=E60(1:c,3:5);
 
shuru=[SHIJIAN,E60VOLUM];
inputSeries = tonndata(shuru,false,false);
targetSeries = tonndata(mubiao,false,false);

% Create a Nonlinear Autoregressive Network with External Input
inputDelays = 1:128;
feedbackDelays = 1:128;
hiddenLayerSize = 128;
net60 = narxnet(inputDelays,feedbackDelays,hiddenLayerSize);
 

%net60 = timedelaynet(inputDelays);
%net60.inputs{:}.size=5;
%net60.numLayers=3;
%net60.biasConnect=[1;1;1];
%net60.inputConnect=[1;0;0]; % net60.inputConnect=[1 1; 0 0; 0 0] for input number is 2
%net60.layerConnect=[0 0 0;1 0 0; 0 1 0];
%net60.outputConnect=[0 0 1];
%net60.layers{1}.size=32;
%net60.layers{2}.size=32;
%net60.layers{3}.size=3;


% Prepare the Data for Training and Simulation
% The function PREPARETS prepares timeseries data for a particular network,
% shifting time by the minimum amount to fill input states and layer states.
% Using PREPARETS allows you to keep your original time series data unchanged, while
% easily customizing it for networks with differing numbers of delays, with
% open loop or closed loop feedback modes.
[inputs,inputStates,layerStates,targets] = preparets(net60,inputSeries,{},targetSeries);

% Setup Division of Data for Training, Validation, Testing
net60.divideParam.trainRatio = 70/100;
net60.divideParam.valRatio = 15/100;
net60.divideParam.testRatio = 15/100;

% Train the Network
[net60,tr] = train(net60,inputs,targets,inputStates,layerStates);

% Test the Network
outputs = net60(inputs,inputStates,layerStates);
errors = gsubtract(targets,outputs);
performance = perform(net60,targets,outputs)

 
nets = removedelay(net60);
nets.name = [net60.name ' - Predict One Step Ahead'];
 
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
ys =nets(xs,xis,ais);
 
save Emini60net net60;










 