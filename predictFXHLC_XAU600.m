clear;
clc;
clear;
a={'XAUUSD'};
b=[333];
d=day(date);
yue=month(date); 
nian=year(date);

 
for i=1:1
URL=['http://www.dukascopy.com/freeApplets/exp/exp.php?fromD=' int2str(yue) '.' int2str(d) '.' int2str(nian) '&np=2000&interval=600&DF=m%2Fd%2FY&Stock=' int2str(b(i)) '&endSym=win&split=coma'];
path=['C:\Company\historical\HourlyFX\' char(a(i)) '600.csv'];
urlwrite(URL, path); 
 
 
 
end
 
 
N=2000; %the smallest number of rows in all the historical data
L=0;
xiaoshi=zeros(N,1);
shuru=[];
shuchu=[]; 
DataOpen=[];

 j=1;
symbol=char(a(j)); 
path=['C:\Company\historical\HourlyFX\' symbol '600.csv'];

 
symbolDataVOLUM=csvread(path,1,2,[1,2,N,2]);
symbolDataVOLUM=symbolDataVOLUM;
 
 
symbolData=0.001*csvread(path,1,3,[1,3,N,6]);
 
 
symbolDataOpen=symbolData(1:end,1:1);
symbolDataClose=symbolData(1:end,2:2);
 
symbolData=symbolData(1:end,3:4);
 
 
shuru=[shuru,symbolDataVOLUM];
shuchu=[shuchu,symbolDataClose,symbolData];
DataOpen=[DataOpen,symbolDataOpen]; 

 
 
 
% Create a Nonlinear Autoregressive Network with External Input
inputDelays = 1:3;
feedbackDelays=1:3; 
hiddenLayerSize = 16;
 
   
symbol=char(a(j));
 

name2=[symbol 'net_FX_HLC600'];
FXnet = genvarname(name2);

 
inputSeries = tonndata(shuru(1:(N-L),1:end),false,false);
targetSeries = tonndata(shuchu(1:(N-L),(3*j-2):(3*j)),false,false);


net = narxnet(inputDelays,feedbackDelays,hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
 
 
[inputs,inputStates,layerStates,targets] = preparets(net,inputSeries,{},targetSeries);
 
[net,tr] = train(net,inputs,targets,inputStates,layerStates);
 
 
 
eval([FXnet '=net;']);
 
eval(['save ' FXnet]);
clear net;
 
%emailNote;
%sendmail('exutechnology@gmail.com','Update net_HLC600',' ', {'C:\Company\matlab files\EURJPYnet_FX_HLC600.mat'}); 
 
%system('shutdown -s');
  