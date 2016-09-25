clear;
clc;
DownloadDataFXHourly;
%a={'EURUSD','USDJPY','GBPUSD','AUDUSD','USDCHF','EURJPY','EURGBP','GBPJPY','GBPCHF','AUDJPY'}; 
a={'EURUSD','USDJPY','EURJPY','EURGBP','GBPJPY','AUDJPY'};
 
N=2000; %the smallest number of rows in all the historical data
 
 
shuru=[];
shuchu=[]; 
 

for j=1:6
symbol=char(a(j)); 
path=['C:\Company\historical\HourlyFX\' symbol '600.csv'];

 
symbolDataVOLUM=csvread(path,1,2,[1,2,N,2]);
symbolDataVOLUM=0.0001*symbolDataVOLUM;
 
%  if(strcmp(symbol,'USDJPY')==0 || strcmp(symbol,'EURJPY')==0 || strcmp(symbol,'GBPJPY')==0 || strcmp(symbol,'AUDJPY')==0)
% symbolData=0.01*csvread(path,1,3,[1,3,N,6]);
%  else
symbolData=csvread(path,1,3,[1,3,N,6]);
%  end
 
 
symbolDataClose=symbolData(1:end,2:2);
 
symbolData=symbolData(1:end,3:4);
 
 
shuru=[shuru,symbolDataVOLUM];
shuchu=[shuchu,symbolDataClose,symbolData];
 

 
 
end
 
 
% Create a Nonlinear Autoregressive Network with External Input
inputDelays = 1:3;
feedbackDelays=1:3; 
hiddenLayerSize = 8;

j=3;
symbol=char(a(j));
 
name2=[symbol 'net_FX_HLC600'];
FXnet = genvarname(name2);
 
 for i=1:(N-1)
     for s=1:6
    shuchu(end-i+1,(3*s-2):3*s)=shuchu(end-i+1,(3*s-2):3*s)-shuchu(end-i,3*s-2);
     end
 end
 shuchu=shuchu(2:end,:);
 shuru=shuru(2:end,:);
 
inputSeries = tonndata([shuru,shuchu(:,1:6),shuchu(:,8:end)],false,false);
targetSeries = tonndata(shuchu(:,7),false,false);


net = narxnet(inputDelays,feedbackDelays,hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
 
 
[inputs,inputStates,layerStates,targets] = preparets(net,inputSeries,{},targetSeries);
 
[net,tr] = train(net,inputs,targets,inputStates,layerStates);
ys=net(inputs,inputStates,layerStates);
 
eval([FXnet '=net;']);
 
eval(['save ' FXnet]);
clear net;
 