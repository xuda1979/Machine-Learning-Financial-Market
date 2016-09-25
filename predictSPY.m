
symbol='SPY'; 
N=3000; %the smallest number of rows in all the historical data
L=1000;
 
name=[symbol '_prediction_error'];
v = genvarname(name);

name1=[symbol '_gains'];
gains = genvarname(name1);

eval([v '=zeros(L,1);']);
eval([gains '=zeros(L,1);']);

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

 
eval([gains '=symbolDataCloseTarget((end-L+1):end)./symbolDataOpen((end-L+1):end)-1;']);
  

inputSeries = tonndata(shuru(1:(N-L),1:end),false,false);
targetSeries = tonndata(symbolDataClose(1:(N-L),1:end),false,false);
for i=1:(floor(L/5))
 
[inputs,inputStates,layerStates,targets] = preparets(net,inputSeries,{},targetSeries);
 
[net,tr] = train(net,inputs,targets,inputStates,layerStates);

inputSeries = tonndata(shuru((1+5*(i)):(N-L+5*(i)),1:end),false,false);
targetSeries = tonndata(symbolDataClose((1+5*(i)):(N-L+5*(i)),1:end),false,false);
nets = removedelay(net);
nets.name = [net.name ' - Predict One Step Ahead'];
 
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
ys = nets(xs,xis,ais);

 
 
ys=[ys{:}];
 
 
eval([v '((5*i-4):(5*i))=(transpose(ys((end-4):end))-symbolDataCloseTarget((N-L+5*i-4):(N-L+5*i)))./symbolDataOpen((N-L+5*i-5):(N-L+5*i-1));']);
  
 
 
 

 
end 
 
 
eval(['save ' v]);
eval(['save ' gains]);
  