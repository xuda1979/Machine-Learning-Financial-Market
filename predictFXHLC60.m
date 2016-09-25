clear;
clc;
 b=[1,4,2,10,3,509,510,517,518,60];
a={'EURUSD','USDJPY','GBPUSD','AUDUSD','USDCHF','EURJPY','EURGBP','GBPJPY','GBPCHF','AUDJPY'}; 
N=2000; %the smallest number of rows in all the historical data
L=0;
xiaoshi=zeros(N,1); 
shuru=[];
shuchu=[]; 
DataOpen=[];
d=day(date);
yue=month(date); 
nian=year(date);
    
    shijian=clock;
 

 j=6;
 URL=['http://www.dukascopy.com/freeApplets/exp/exp.php?fromD=' int2str(yue) '.' int2str(d) '.' int2str(nian) '&np=2000&interval=60&DF=m%2Fd%2FY&Stock=' int2str(b(j)) '&endSym=win&split=coma'];
path=['C:\Company\historical\HourlyFX\' char(a(j)) '60.csv'];
urlwrite(URL, path); 
 
symbol=char(a(j)); 
 
 
symbolDataVOLUM=csvread(path,1,2,[1,2,N,2]);
symbolDataVOLUM=0.001*symbolDataVOLUM;
 
 if(strcmp(symbol,'USDJPY')==0 || strcmp(symbol,'USDJPY')==0 || strcmp(symbol,'GBPJPY')==0 )
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
 
 
 
shuru=[xiaoshi,shuru];

% Create a Nonlinear Autoregressive Network with External Input
inputDelays = 1:6;
feedbackDelays=1:6; 
hiddenLayerSize = 16;

for j=6:6
    
symbol=char(a(j));
name=[symbol '_prediction_error_FX_HLC60'];
v = genvarname(name);

name1=[symbol '_gains_FX_HLC60'];
gains = genvarname(name1);

name2=[symbol 'net_FX_HLC60'];
FXnet = genvarname(name2);


eval([v '=zeros(L,3);']);
eval([gains '=zeros(L,3);']);
inputSeries = tonndata(shuru(1:(N-L),1:end),false,false);
targetSeries = tonndata(shuchu(1:(N-L),1:3),false,false);


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
targetSeries = tonndata(shuchu((1+50*(i)):(N-L+50*(i)),:),false,false);
 
 
[xs,xis,ais,ts] = preparets(net,inputSeries,{},targetSeries);
ys = net(xs,xis,ais);

 
 
ys=[ys{:}];
 
 for t=1:3
eval([v '((50*i-49):(50*i),t)=(transpose(ys(t,(end-49):end))-shuchu((N-L+50*i-49):(N-L+50*i),(3*j-3+t)))./DataOpen((N-L+50*i-49):(N-L+50*i),j:j);']);
  
 end
 
 

 
end 

for t=1:3
%eval([gains '(:,t)=shuchu((end-L+1):end,(3*j-3+t))./DataOpen((end-L+1):end,j:j)-1;']); 

end
eval([FXnet '=net;']);
%eval(['save ' v]);
%eval(['save ' gains]);
eval(['save ' FXnet]);
clear net;
end
%emailNote;
%sendmail('exutechnology@gmail.com','Update net_HLC60',' ', {'C:\Company\matlab files\EURJPYnet_FX_HLC60.mat'}); 
 
%system('shutdown -s');
  