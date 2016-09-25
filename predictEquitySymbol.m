 clear;
 clc;
 DownloadLCE;
 symbol='C';
N=3000; %the smallest number of rows in all the historical data
 
 
 
name=[symbol 'net_1D'];
FXnet = genvarname(name);
 
 

path=['C:\Company\historical\' symbol '.csv'];

 
symbolDataVOLUM=csvread(path,2,5,[2,5,N+1,5]);
symbolDataVOLUM=0.00000001*flipud(symbolDataVOLUM);
 
symbolData=0.01*csvread(path,1,1,[1,1,N+1,4]);

symbolDataOpen=symbolData(1:(end-1),1:1);
symbolDataOpen=flipud(symbolDataOpen);

%symbolData=flipud(symbolData);
symbolDataClose=symbolData(2:end,4:4);
symbolDataClose=flipud(symbolDataClose);

 


symbolData=symbolData(2:end,2:3);
symbolData=flipud(symbolData);

 



% Create a Nonlinear Autoregressive Network with External Input
inputDelays = 1:10;
feedbackDelays=1:10; 
hiddenLayerSize = 10;
net = narxnet(inputDelays,feedbackDelays,hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
 
shuru= [symbolDataOpen,symbolDataVOLUM];

shuchu=[symbolDataClose,symbolData];

 
 
  

inputSeries = tonndata(shuru,false,false);
targetSeries = tonndata(shuchu,false,false);
 
 
[inputs,inputStates,layerStates,targets] = preparets(net,inputSeries,{},targetSeries);
 
[net,tr] = train(net,inputs,targets,inputStates,layerStates);
eval([FXnet '=net;']);
 
eval(['save ' FXnet]);
 
  
 
 
 

  
 
 