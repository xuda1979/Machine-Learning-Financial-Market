function predictSymbolUpdate(symbol)
 if(strcmp(symbol,'SPY')==0)
N=2000; %the smallest number of rows in all the historical data
 
 
netname=[symbol 'net'];
netv = genvarname(netname);
 

path=['C:\Company\historical\' symbol '.csv'];

 
symbolDataVOLUM=csvread(path,2,5,[2,5,N+1,5]);
symbolDataVOLUM=0.00000001*flipud(symbolDataVOLUM);
 
symbolData=0.01*csvread(path,1,1,[1,1,N+1,4]);

symbolDataOpen=symbolData(1:(end-1),1:1);
symbolDataOpen=flipud(symbolDataOpen);

%symbolData=flipud(symbolData);
symbolDataClose=symbolData(2:end,4:4);
symbolDataClose=flipud(symbolDataClose);

symbolDataCloseTarget=symbolData(1:(end-1),4:4);
symbolDataCloseTarget=flipud(symbolDataCloseTarget);


symbolData=symbolData(2:end,2:3);
symbolData=flipud(symbolData);



VIX=csvread('C:\Company\historical\^VIX.csv',1,1,[1,1,N+1,4]);
VIXOpen=VIX(1:(end-1),1:1);
VIXOpen=flipud(VIXOpen);
 
VIX=VIX(2:end,2:4);
VIX=flipud(VIX);

 
 
%%%input data of GSPC
SPYVOLUM=csvread('C:\Company\historical\SPY.csv',2,5,[2,5,N+1,5]);
SPYVOLUM=0.00000001*flipud(SPYVOLUM);
 
SPY=0.01*csvread('C:\Company\historical\SPY.csv',1,1,[1,1,N+1,4]);
SPYOpen=SPY(1:(end-1),1:1);
SPYOpen=flipud(SPYOpen);
 
SPY=SPY(2:end,2:4);
SPY=flipud(SPY);



% Create a Nonlinear Autoregressive Network with External Input
inputDelays = 1:16;
feedbackDelays=1:16; 
hiddenLayerSize = 32;
net = narxnet(inputDelays,feedbackDelays,hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
 
shuru=[symbolDataOpen,symbolData,symbolDataVOLUM,SPYOpen,SPY,SPYVOLUM,VIXOpen,VIX];

 
 
  

inputSeries = tonndata(shuru(1:(N),1:end),false,false);
targetSeries = tonndata(symbolDataClose(1:(N),1:end),false,false);
 
 
[inputs,inputStates,layerStates,targets] = preparets(net,inputSeries,{},targetSeries);
 
[net,tr] = train(net,inputs,targets,inputStates,layerStates);
 
 
eval([netv '=net;']);
eval(['save ' netv]);
 

 else
     errorMessage='symbol cant be spy'
 end
 