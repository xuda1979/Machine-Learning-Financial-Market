clear;
clc;
DownloadLCE;
DownloadData;

a={'AAPL','ORCL','CSCO','INTC','QQQ','BAC','GE','F','C','SPY'};
opens=zeros(1,12);
M=30;

 

for s=1:10
 
VIX=csvread('C:\Company\historical\^VIX.csv',1,1,[1,1,M+1,4]);
VIXOpen=[opens(12);VIX(1:(end-1),1:1)];
VIXOpen=flipud(VIXOpen);
 
VIX=VIX(1:end,2:4);
VIX=flipud(VIX);

 
 
%%%input data of GSPC
SPYVOLUM=csvread('C:\Company\historical\SPY.csv',1,5,[1,5,M+1,5]);
SPYVOLUM=0.00000001*flipud(SPYVOLUM);
 
SPY=0.01*csvread('C:\Company\historical\SPY.csv',1,1,[1,1,M+1,4]);
SPYOpen=[opens(11);SPY(1:(end-1),1:1)];
SPYOpen=flipud(SPYOpen);
 
SPY=SPY(1:end,2:4);
SPY=flipud(SPY);
 
 


 path=['C:\Company\historical\' symbol '.csv'];  
symbolDataVOLUM=csvread(path,1,5,[1,5,M+1,5]);
symbolDataVOLUM=0.00000001*flipud(symbolDataVOLUM);
 

symbolData=0.01*csvread(path,1,1,[1,1,M+1,4]);

symbolDataOpen=[opens(12);symbolData(1:(end-1),1:1)];
symbolDataOpen=flipud(symbolDataOpen);

 
%symbolData=flipud(symbolData);
symbolDataClose=symbolData(1:end,4:4);
symbolDataClose=flipud(symbolDataClose);

 
 
symbolData=symbolData(1:end,2:3);
 
symbolData=flipud(symbolData);
 

shuru=[symbolDataOpen,symbolData,symbolDataVOLUM,SPYOpen,SPY,SPYVOLUM,VIXOpen,VIX];
inputSeriesUpdate = tonndata(shuru,false,false);
targetSeriesUpdate = tonndata(symbolDataClose,false,false);

 
   symbolUpdate=char(a(s));
   netname=[symbolUpdate 'net'];
   netv = genvarname(netname); 

   eval(['load ' netv ';']);
 
   
   eval(['net=' netv ';']);
   eval(['clear ' netv ';']);
   
[xs,xis,ais,ts] = preparets(net,inputSeriesUpdate,{},targetSeriesUpdate);
ys = net(xs,xis,ais);

 
 
 

name=[symbolUpdate '_prediction_error'];
v = genvarname(name);

name1=[symbolUpdate '_gains'];
gains = genvarname(name1);
eval(['load ' name]);
eval(['load ' name1]);
eval([v '=[' v ';(transpose(ys((end-4):end))-(symbolDataClose((end-4):end)))./(symbolDataOpen((end-5):(end-1)))];']); 
eval([gains '=[' gains '; (symbolDataClose((end-4):end))./(symbolDataOpen((end-5):(end-1)))-1];']);
eval(['save ' v ]);
eval(['save ' gains]);
 
end

clear;

aa={'AAPL','ORCL','CSCO','INTC','QQQ','BAC','GE','F','C','SPY'};
load 'AAPL_prediction_error';
load 'AAPL_gains';

X=AAPL_prediction_error;
 
for ss=2:10
symbol=char(aa(ss));   
name=[symbol '_prediction_error'];
v = genvarname(name);

name1=[symbol '_gains'];
gains = genvarname(name1);

eval(['load ' v ]);
 
eval(['X=[X,' v '];']);
 
end
 
 
correlation= corrcoef(X((end-799):end,1:10));
standard_deviation=std(X((end-799):end,1:10));
save correlation;
save standard_deviation;










clear;
aaa={'AAPL','ORCL','CSCO','INTC','QQQ','BAC','GE','F','C','SPY'};
for ss=1:9
    
   predictSymbolUpdate(char(aaa(ss)));
end
predictSPYUpdate;

