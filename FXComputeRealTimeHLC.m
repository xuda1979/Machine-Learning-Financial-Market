clear;
clc;
a={'EURUSD','USDJPY','GBPUSD','AUDUSD','USDCHF','EURJPY','EURGBP','GBPJPY','GBPCHF','AUDJPY'};
b=[1,4,2,10,3,509,510,517,518,60];
updated=0;
NN=64;
hourFX=zeros(NN,1);
shuru=[];
shuchu=[]; 
DataOpen=[];

while(true)

d=day(date);
yue=month(date); 
nian=year(date);
    
    shijian=clock;
    
     if(shijian(5)==58)
         
         updated=0;
     end
 
if(shijian(5)<=5 && updated==0)  
 

 

 
 
try
 
 
NN=64;
hourFX=zeros(NN,1);
shuru=[];
shuchu=[]; 
DataOpen=[];

for j=1:10
    URL=['http://www.dukascopy.com/freeApplets/exp/exp.php?fromD=' int2str(yue) '.' int2str(d) '.' int2str(nian) '&np=250&interval=3600&DF=m%2Fd%2FY&Stock=' int2str(b(j)) '&endSym=win&split=coma'];
path=['C:\Company\historical\HourlyFX\' char(a(j)) '.csv'];
urlwrite(URL, path); 
symbol=char(a(j)); 
path=['C:\Company\historical\HourlyFX\' symbol '.csv'];

 
symbolDataVOLUM=csvread(path,250-NN+1,2,[250-NN+1,2,250,2]);
symbolDataVOLUM=0.00001*symbolDataVOLUM;
 
 if(strcmp(symbol,'USDJPY')==0 || strcmp(symbol,'USDJPY')==0 || strcmp(symbol,'GBPJPY')==0 || strcmp(symbol,'AUDJPY')==0)
symbolData=0.01*csvread(path,250-NN+1,3,[250-NN+1,3,250,6]);
 else
symbolData=csvread(path,250-NN+1,3,[250-NN+1,3,250,6]);
 end
 
symbolDataOpen=symbolData(1:end,1:1);
symbolDataClose=symbolData(1:end,2:2);
 
symbolData=symbolData(1:end,3:4);
 
 
shuru=[shuru,symbolDataVOLUM];
shuchu=[shuchu,symbolDataClose,symbolData];
DataOpen=[DataOpen,symbolDataOpen]; 

if(j==8)
   
 file=fopen(path);
 xiaoFX=textscan(file, '%s', 'delimiter', '\n');
 xiaoFX=[xiaoFX{:}];
 for t=1:NN
 q=textscan(char(xiaoFX(t+251-NN)),'%s', 'delimiter', ',');
 q=[q{:}];
 p=textscan(char(q(2)),'%d', 'delimiter', ':');
 p=[p{:}]; 
  hourFX(t)=p(1);
 end
end
 
end
shurureal=[hourFX,shuru];
shuchureal=shuchu(1:end,16:18);
 
load EURJPYnet_FX_HLC;
nets = removedelay(EURJPYnet_FX_HLC);
clear EURJPYnet_FX_HLC;
 
inputSeries = tonndata(shurureal,false,false);
targetSeries = tonndata(shuchureal,false,false);

 
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
ys = nets(xs,xis,ais);

 
 
ys=100*[ys{:,end:end}]';
 
 
csvwrite('C:\\Company\\resultEURJPY_HLC.csv', [hourFX(end),ys]);

updated=1;
 
catch exception
    
  updated=0;  
end
  

 


 
 
 
 


end


end

