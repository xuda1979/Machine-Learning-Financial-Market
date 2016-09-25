clear;
clc;
a={'USDJPY','EURJPY','GBPJPY','AUDJPY'};
b=[4,509,517,60];
N=1998; %the smallest number of rows in all the historical data
L=0;
xiaoshi=zeros(N,1); 
shuru=[];
shuchu=[]; 
DataOpen=[];
d=day(date);
yue=month(date); 
nian=year(date);
    
    shijian=clock;
 

 for j=1:4
 URL=['http://www.dukascopy.com/freeApplets/exp/exp.php?fromD=' int2str(yue) '.' int2str(d) '.' int2str(nian) '&np=2000&interval=60&DF=m%2Fd%2FY&Stock=' int2str(b(j)) '&endSym=win&split=coma'];
path=['C:\Company\historical\HourlyFX\' char(a(j)) '60.csv'];
urlwrite(URL, path); 
 
symbol=char(a(j)); 
 
 
symbolDataVOLUM=csvread(path,1,2,[1,2,N,2]);
symbolDataVOLUM=0.0001*symbolDataVOLUM;
 
if(strcmp(symbol,'USDJPY')==0 || strcmp(symbol,'USDJPY')==0 || strcmp(symbol,'GBPJPY')==0 || strcmp(symbol,'AUDJPY')==0)
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
 
 end

shuru180=zeros(1998/3,4);
shuchu180=zeros(1998/3,3);

for k=1:(1998/3)
    
    for s=1:4
    shuru180(k,s)=sum(shuru((3*k-2):(3*k),s));
    end
    shuchu180(k,1)=shuchu(3*k,10);
    shuchu180(k,2)=min(min(shuchu(3*k-2,11),shuchu(3*k-1,11)),shuchu(3*k,11));
    shuchu180(k,3)=max(max(shuchu(3*k-2,12),shuchu(3*k-1,12)),shuchu(3*k,12));
    
    
end
 
 
 

% Create a Nonlinear Autoregressive Network with External Input
inputDelays = 1:5;
feedbackDelays=1:5; 
hiddenLayerSize = 16;

for j=4:4
    
symbol=char(a(j));
 

name2=[symbol 'net_FX_HLC180'];
FXnet = genvarname(name2);

 


net = narxnet(inputDelays,feedbackDelays,hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
 
inputSeries = tonndata(shuru180,false,false);
targetSeries = tonndata(shuchu180,false,false);
 
[inputs,inputStates,layerStates,targets] = preparets(net,inputSeries,{},targetSeries);
 
[net,tr] = train(net,inputs,targets,inputStates,layerStates);
 
eval([FXnet '=net;']);
 
eval(['save ' FXnet]);
clear net;
end
%emailNote;
%sendmail('exutechnology@gmail.com','Update net_HLC60',' ', {'C:\Company\matlab files\EURJPYnet_FX_HLC60.mat'}); 
 
%system('shutdown -s');
  