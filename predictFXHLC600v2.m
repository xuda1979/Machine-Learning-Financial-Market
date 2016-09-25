clear;
clc;
DownloadDataFXHourly;
%a={'EURUSD','USDJPY','GBPUSD','AUDUSD','USDCHF','EURJPY','EURGBP','GBPJPY','GBPCHF','AUDJPY'}; 
a={'EURJPY'};
 
N=2000; %the smallest number of rows in all the historical data
 
xiaoshi=zeros(N,1);
shuru=[];
shuchu=[]; 
DataOpen=[];

 

  j=1;
symbol=char(a(j)); 
path=['C:\Company\historical\HourlyFX\' symbol '3600.csv'];
 
 
symbolData=csvread(path,1,3,[1,3,N,6]);
 
 
 
symbolDataClose=symbolData(1:end,2:2);
 
symbolData=symbolData(1:end,3:4);
 
 
 
shuchu=[shuchu,symbolDataClose,symbolData];
 

 
 
for i=1:(N-1)
    
   shuchu(end-i+1,:)=shuchu(end-i+1,:)-shuchu(end-i,1);
    
    
end
 
 shuru=shuru(2:end,:);
 shuchu=shuchu(2:end,:);

 
% Create a Nonlinear Autoregressive Network with External Input
inputDelays = 1:16; 
hiddenLayerSize = 8;
 
name2=[symbol 'net_FX_HLC600'];
FXnet = genvarname(name2);


 
 targetSeries = tonndata(shuchu,false,false);


net = narnet(inputDelays,hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
 
 
[inputs,inputStates,layerStates,targets] = preparets(net,{},{},targetSeries);

net.layers{1}.transferFcn='netinv';

 
[net,tr] = train(net,inputs,targets,inputStates,layerStates);
 
 
eval([FXnet '=net;']);
 
eval(['save ' FXnet]);
clear net;
 
 