clear;
N=90000; %the smallest number of rows in all the historical data

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
     
    E60(a,2)=ES(60*a-14,2);
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
 


 
 
shuru=[SHIJIAN,E60(1:c,3:4),E60VOLUM];
mubiao=E60(1:c, 2:2);
 
inputSeries = tonndata(shuru,false,false);
targetSeries = tonndata(mubiao,false,false);

% Create a Nonlinear Autoregressive Network with External Input
inputDelays = 1:128;
 feedbackDelays = 1:128;
hiddenLayerSize = 128;
netopen60 = narxnet(inputDelays,feedbackDelays,hiddenLayerSize);

 

% Prepare the Data for Training and Simulation
% The function PREPARETS prepares timeseries data for a particular network,
% shifting time by the minimum amount to fill input states and layer states.
% Using PREPARETS allows you to keep your original time series data unchanged, while
% easily customizing it for networks with differing numbers of delays, with
% open loop or closed loop feedback modes.
[inputs,inputStates,layerStates,targets] = preparets(netopen60,inputSeries,{},targetSeries);

% Setup Division of Data for Training, Validation, Testing
netopen60.divideParam.trainRatio = 70/100;
netopen60.divideParam.valRatio = 15/100;
netopen60.divideParam.testRatio = 15/100;

% Train the Network
[netopen60,tr] = train(netopen60,inputs,targets,inputStates,layerStates);

% Test the Network
outputs = netopen60(inputs,inputStates,layerStates);
errors = gsubtract(targets,outputs);
performance = perform(netopen60,targets,outputs)

 
nets = removedelay(netopen60);
nets.name = [netopen60.name ' - Predict One Step Ahead'];
 
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
ys =nets(xs,xis,ais);
 
save Emini60netopen netopen60;










 