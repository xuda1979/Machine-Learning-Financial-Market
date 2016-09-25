DownloadDataFX;  
results=zeros(15,5);
type='forex';
N=2700; %the smallest number of rows in all the historical data

if(2==1)
%%%input data of GSPC
GSPCVOLUM=csvread('C:\Company\historical\^GSPC.txt',1,5);
[rows,columns]=size(GSPCVOLUM);
GSPC=0.01*csvread('C:\Company\historical\^GSPC.txt',rows-N-1,1, [rows-N-1,1,rows-1,4]);
GSPCVOLUM=0.00000001*GSPCVOLUM((rows-N):rows,1:1);
 


%%%input data of FCHI
FCHIVOLUM=csvread('C:\Company\historical\^FCHI.txt',1,5);
[rows,columns]=size(FCHIVOLUM);
FCHI=0.01*csvread('C:\Company\historical\^FCHI.txt',rows-N-1,1, [rows-N-1,1,rows-1,4]);
FCHIVOLUM=0.00000001*FCHIVOLUM((rows-N):rows,1:1);


%%%input data of FTSE
FTSEVOLUM=csvread('C:\Company\historical\^FTSE.txt',1,5);
[rows,columns]=size(FTSEVOLUM);
FTSE=0.01*csvread('C:\Company\historical\^FTSE.txt',rows-N-1,1, [rows-N-1,1,rows-1,4]);
FTSEVOLUM=0.00000001*FTSEVOLUM((rows-N):rows,1:1);


%%%input data of GDAXI
GDAXIVOLUM=csvread('C:\Company\historical\^GDAXI.txt',1,5);
[rows,columns]=size(GDAXIVOLUM);
GDAXI=csvread('C:\Company\historical\^GDAXI.txt',rows-N-1,1, [rows-N-1,1,rows-1,4]);
GDAXIVOLUM=0.0001*GDAXIVOLUM((rows-N):rows,1:1);


%%%input data of HSI
HSIVOLUM=csvread('C:\Company\historical\^HSI.txt',1,5);
[rows,columns]=size(HSIVOLUM);
HSI=0.01*csvread('C:\Company\historical\^HSI.txt',rows-N-1,1, [rows-N-1,1,rows-1,4]);
HSIVOLUM=0.00000001*HSIVOLUM((rows-N):rows,1:1);

%%%input data of N225
N225VOLUM=csvread('C:\Company\historical\^N225.txt',1,5);
[rows,columns]=size(N225VOLUM);
N225=0.01*csvread('C:\Company\historical\^N225.txt',rows-N-1,1, [rows-N-1,1,rows-1,4]);
N225VOLUM=0.00001*N225VOLUM((rows-N):rows,1:1);


 

VIXVOLUM=csvread('C:\Company\historical\^VIX.txt',1,5);
[rows,columns]=size(VIXVOLUM);
VIX=csvread('C:\Company\historical\^VIX.txt',rows-N-1,1, [rows-N-1,1,rows-1,4]);

end

 

r=dir('C:\Company\historical\DataOnly\Forex');

for i=3:17
    path=['C:\Company\historical\DataOnly\Forex\' r(i).name];
AD=csvread(path,0,1);
[rows,columns]=size(AD);
name=['FOREX' int2str(i)];
v = genvarname(name);
if(i==3 || i==7 || i==10 || i==16)
     
 
   eval([v '=0.01*AD(rows-N:rows,1:4);']);
else
   eval([v '=AD(rows-N:rows,1:4);']); 
end
 end
%%% begin 

%%%input for all

%ALLOVER=[FCHI,FTSE,GDAXI,GSPC,HSI,N225];
%mubiao=0.01*csvread(['C:\Company\historical\^' symbol '.txt'],1,1);
 
%ALLOVERVOLUM=[FCHIVOLUM,FTSEVOLUM,GDAXIVOLUM,GSPCVOLUM,HSIVOLUM,N225VOLUM,VIX,FOREX3,FOREX4,FOREX5,FOREX6,FOREX7,FOREX8,FOREX9,FOREX10,FOREX11,FOREX12,FOREX13,FOREX14,FOREX15,FOREX16,FOREX17];
ALLOVERVOLUM=[FOREX3,FOREX4,FOREX5,FOREX6,FOREX7,FOREX8,FOREX9,FOREX10,FOREX11,FOREX12,FOREX13,FOREX14,FOREX15,FOREX16,FOREX17];

for i=3:17
    name=['FOREX' int2str(i)];
    v = genvarname(name);
     eval(['mubiao=' v]);
    
     
inputSeries = tonndata(ALLOVERVOLUM,false,false);
targetSeries = tonndata(mubiao,false,false);

% Create a Nonlinear Autoregressive Network with External Input
inputDelays = 1:16;
feedbackDelays = 1:16;
hiddenLayerSize = 128;

while(true)
   
net = narxnet(inputDelays,feedbackDelays,hiddenLayerSize);

% Prepare the Data for Training and Simulation
% The function PREPARETS prepares timeseries data for a particular network,
% shifting time by the minimum amount to fill input states and layer states.
% Using PREPARETS allows you to keep your original time series data unchanged, while
% easily customizing it for networks with differing numbers of delays, with
% open loop or closed loop feedback modes.
[inputs,inputStates,layerStates,targets] = preparets(net,inputSeries,{},targetSeries);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Train the Network
[net,tr] = train(net,inputs,targets,inputStates,layerStates);

% Test the Network
outputs = net(inputs,inputStates,layerStates);
errors = gsubtract(targets,outputs);
net.performFcn='mae';
performance = perform(net,targets,outputs);
if(i==3 || i==7 || i==10 || i==16)
peformance=100*performance;    
     
end

 

% Early Prediction Network
% For some applications it helps to get the prediction a timestep early.
% The original network returns predicted y(t+1) at the same time it is given y(t+1).
% For some applications such as decision making, it would help to have predicted
% y(t+1) once y(t) is available, but before the actual y(t+1) occurs.
% The network can be made to return its output a timestep early by removing one delay
% so that its minimal tap delay is now 0 instead of 1.  The new network returns the
% same outputs as the original network, but outputs are shifted left one timestep.
nets = removedelay(net);
nets.name = [net.name ' - Predict One Step Ahead'];
view(nets)
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
ys = nets(xs,xis,ais);

A=100*ys{:,N-14};
if(A(2)>=A(1) && A(2)>=A(3) && A(2)>=A(4) && A(3)<=A(1) && A(3)<=A(4))
    break;
end
 clear net;
 clear nets;
end
results(i-2,1:end)=[A',performance];
%path=['C:\Company\matlab files\' symbol 'net'];
namenet=[name 'net'];
save path namenet net;
clear net;
clear nets;
end
csvwrite('C:\\Company\\resultsFX.csv', results);
f = ftp('ftp.ipage.com','aatsyscom','DongFeng09$$');
try
delete(f,'resultsFX.csv');
catch exception
end
mput(f,'C:\\Company\\resultsFX.csv');
 close(f);
 