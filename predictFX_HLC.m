 
clear;
clc;
a={'EURUSD','USDJPY','GBPUSD','AUDUSD','USDCHF','USDCAD','EURJPY','EURGBP','GBPJPY'};
N=2000; %the smallest number of rows in all the historical data
L=1000;
xiaoshi=zeros(N,1);
shuru=[];
shuchu=[]; 
DataOpen=[];

 

for j=1:9
symbol=char(a(j)); 
path=['C:\Company\historical\HourlyFX\' symbol '.csv'];

 
symbolDataVOLUM=csvread(path,1,2,[1,2,N,2]);
symbolDataVOLUM=0.00001*symbolDataVOLUM;
 
 if(strcmp(symbol,'USDJPY')==0 || strcmp(symbol,'USDJPY')==0 )
symbolData=0.01*csvread(path,1,3,[1,3,N,6]);
 else
symbolData=csvread(path,1,3,[1,3,N,6]);
 end
 
symbolDataOpen=symbolData(1:end,1:1);
symbolDataClose=symbolData(1:end,2:2);
 
symbolData=symbolData(1:end,3:4);
 
 
shuru=[shuru,symbolDataVOLUM];
shuchu=[shuchu,symbolDataClose,symbolData];
DataOpen=[DataOpen,symbolDataOpen]; 

if(j==8)
   
 file=fopen(path);
 xiao=textscan(file, '%s', 'delimiter', '\n');
 xiao=[xiao{:}];
 for t=1:N
 q=textscan(char(xiao(t+1)),'%s', 'delimiter', ',');
 q=[q{:}];
 p=textscan(char(q(2)),'%d', 'delimiter', ':');
 p=[p{:}]; 
  xiaoshi(t)=p(1);
 end
end
 
end
 
shuru=[xiaoshi,shuru];

% Create a Nonlinear Autoregressive Network with External Input
inputDelays = 1:64;
feedbackDelays=1:64; 
hiddenLayerSize = 16;

for j=1:8
    
symbol=char(a(j));
name=[symbol '_prediction_error_FX'];
v = genvarname(name);

name1=[symbol '_gains_FX'];
gains = genvarname(name1);

name2=[symbol 'net_FX'];
FXnet = genvarname(name2);


eval([v '=zeros(L,1);']);
eval([gains '=zeros(L,1);']);
inputSeries = tonndata(shuru(1:(N-L),1:end),false,false);
targetSeries = tonndata(shuchu(1:(N-L),(3*j-2):(3*j)),false,false);


net = narxnet(inputDelays,feedbackDelays,hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
for i=1:(floor(L/50)+1)
 
[inputs,inputStates,layerStates,targets] = preparets(net,inputSeries,{},targetSeries);
 
[net,tr] = train(net,inputs,targets,inputStates,layerStates);
if(i==floor(L/50)+1)    
break;   
end

inputSeries = tonndata(shuru((1+50*(i)):(N-L+50*(i)),1:end),false,false);
targetSeries = tonndata(shuchu((1+50*(i)):(N-L+50*(i)),(3*j-2):(3*j)),false,false);
 
 
[xs,xis,ais,ts] = preparets(net,inputSeries,{},targetSeries);
ys = net(xs,xis,ais);

 
 
ys=[ys{:}];
 
 
eval([v '((50*i-49):(50*i))=(transpose(ys(1:1,(end-49):end))-shuchu((N-L+50*i-49):(N-L+50*i),(3*j-2):(3*j-2)))./DataOpen((N-L+50*i-49):(N-L+50*i),j:j);']);
  
 
 
 

 
end 
eval([gains '=shuchu((end-L+1):end,(3*j-2):(3*j-2))./DataOpen((end-L+1):end,j:j)-1;']); 
eval([FXnet '=net;']);
eval(['save ' v]);
eval(['save ' gains]);
eval(['save ' FXnet]);
clear net;
end

 
% system('shutdown -s');
  