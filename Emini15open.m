clear;
N=90000; %the smallest number of rows in all the historical data

frequency=15;
 
%%%input data of GSPC
ESVOLUM=csvread('C:\Company\historical\ES\ES.txt',0,6);
[rows,columns]=size(ESVOLUM);
ES=0.01*csvread('C:\Company\historical\ES\ES.txt',rows-N-1,1, [rows-N-1,1,rows-1,5]);
ESVOLUM=0.01*ESVOLUM((rows-N):rows,1:1);

ES=[ES,ESVOLUM];



a=1;
b=1;
c=floor((N+1)/frequency);
E15=zeros(c,6);
while a<=floor(c)
     
    E15(a,2)=ES(15*a-14,2);
    E15(a,6)=0;
    E15(a,3)=ES(frequency*a);
    E15(a,4)=ES(frequency*a);
    for i=0:(frequency-1)
    E15(a,3)=max(E15(a,3),ES(frequency*a-i));
    E15(a,4)=min(E15(a,4),ES(frequency*a-i));
    
    E15(a,6)=ES(frequency*a-i)+E15(a,6);
    end
    E15(a,5)=ES(frequency*a,5);
    t=ES(frequency*a,1);
    E15(a,1)= floor(t)+ (t-floor(t))*100/60;
   a=a+1; 
end

E15VOLUM=E15(1:c,6:end);
SHIJIAN=E15(1:c,1:1);
 


 
 
shuru=[SHIJIAN,E15(1:c,3:4),E15VOLUM];
mubiao=E15(1:c, 2:2);
 
inputSeries = tonndata(shuru,false,false);
targetSeries = tonndata(mubiao,false,false);

% Create a Nonlinear Autoregressive Network with External Input
inputDelays = 1:128;
 feedbackDelays = 1:128;
hiddenLayerSize = 128;
netopen15 = narxnet(inputDelays,feedbackDelays,hiddenLayerSize);

 

% Prepare the Data for Training and Simulation
% The function PREPARETS prepares timeseries data for a particular network,
% shifting time by the minimum amount to fill input states and layer states.
% Using PREPARETS allows you to keep your original time series data unchanged, while
% easily customizing it for networks with differing numbers of delays, with
% open loop or closed loop feedback modes.
[inputs,inputStates,layerStates,targets] = preparets(netopen15,inputSeries,{},targetSeries);

% Setup Division of Data for Training, Validation, Testing
netopen15.divideParam.trainRatio = 70/100;
netopen15.divideParam.valRatio = 15/100;
netopen15.divideParam.testRatio = 15/100;

% Train the Network
[netopen15,tr] = train(netopen15,inputs,targets,inputStates,layerStates);

% Test the Network
outputs = netopen15(inputs,inputStates,layerStates);
errors = gsubtract(targets,outputs);
performance = perform(netopen15,targets,outputs)

 
nets = removedelay(netopen15);
nets.name = [netopen15.name ' - Predict One Step Ahead'];
 
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
ys =nets(xs,xis,ais);
 
save Emini15netopen netopen15;










 