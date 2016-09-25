clear;
clc;
%a={'EURUSD','USDJPY','GBPUSD','AUDUSD','USDCHF','EURJPY','EURGBP','GBPJPY','GBPCHF','AUDJPY'};
%b=[1,4,2,10,3,509,510,517,518,60];
a={'USDJPY','EURJPY','GBPJPY','AUDJPY'};
b=[4,509,517,60];
updated=0;
NN=3;
 
hourFX1=zeros(NN,1);
shuru=[];
shuchu=[]; 
DataOpen=[];

while(true)

d=day(date);
yue=month(date); 
nian=year(date);
    
    shijian=clock;
    
     if( rem(shijian(5),10)==8)
         
         updated=0;
     end
 
if(rem(shijian(5),10)==0 && updated==0)   
 
try
 
NN=3;
 
hourFX1=zeros(NN,1);
minuteFX1=zeros(NN,1);
shuru=[];
shuchu=[]; 
DataOpen=[];

 

for j=1:4
    URL=['http://www.dukascopy.com/freeApplets/exp/exp.php?fromD=' int2str(yue) '.' int2str(d) '.' int2str(nian) '&np=250&interval=600&DF=m%2Fd%2FY&Stock=' int2str(b(j)) '&endSym=win&split=coma'];
path=['C:\Company\historical\HourlyFX\' char(a(j)) '600.csv'];
urlwrite(URL, path); 
 
 symbol=char(a(j));
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

if(j==4)
   
 file=fopen(path);
 xiaoFX1=textscan(file, '%s', 'delimiter', '\n');
 xiaoFX1=[xiaoFX1{:}];
 for t=1:NN
 q1=textscan(char(xiaoFX1(t+251-NN)),'%s', 'delimiter', ',');
 q1=[q1{:}];
 p1=textscan(char(q1(2)),'%d', 'delimiter', ':');
 p1=[p1{:}]; 
  hourFX1(t)=p1(1);
  minuteFX1(t)=p1(2);
 end
end
 
end



 





%%%%%%%%%%%for EURJPY
 
shurureal=shuru;
shuchureal=shuchu(1:end,4:6);
 
 


load EURJPYnet_FX_HLC600;
nets = removedelay(EURJPYnet_FX_HLC600);
clear EURJPYnet_FX_HLC600;
 
inputSeries = tonndata(shurureal,false,false);
targetSeries = tonndata(shuchureal,false,false);

 
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
ys = nets(xs,xis,ais);

 
 
ys=100*[ys{end:end}]';

 
 
 csvwrite('C:\\Company\\resultEURJPY_HLC600.csv', [hourFX1(end),minuteFX1(end),ys]);
 
 
%   %%%%%%%for AUDJPY
%  
% 
%  hourFX1=zeros(NN,1);
% minuteFX1=zeros(NN,1);
% shuru=[];
% shuchu=[]; 
% DataOpen=[];
% 
% for j=1:4    
% symbol=char(a(j));
% symbolDataVOLUM=csvread(path,250-NN+1,2,[250-NN+1,2,250,2]);
% symbolDataVOLUM=0.00001*symbolDataVOLUM;
%  
%  if(strcmp(symbol,'USDJPY')==0 || strcmp(symbol,'USDJPY')==0 || strcmp(symbol,'GBPJPY')==0 || strcmp(symbol,'AUDJPY')==0)
% symbolData=0.01*csvread(path,250-NN+1,3,[250-NN+1,3,250,6]);
%  else
% symbolData=csvread(path,250-NN+1,3,[250-NN+1,3,250,6]);
%  end
%  
% symbolDataOpen=symbolData(1:end,1:1);
% symbolDataClose=symbolData(1:end,2:2);
%  
% symbolData=symbolData(1:end,3:4);
%  
%  
% shuru=[shuru,symbolDataVOLUM];
% shuchu=[shuchu,symbolDataClose,symbolData];
% DataOpen=[DataOpen,symbolDataOpen]; 
% 
% if(j==4)
%    
%  file=fopen(path);
%  xiaoFX1=textscan(file, '%s', 'delimiter', '\n');
%  xiaoFX1=[xiaoFX1{:}];
%  for t=1:NN
%  q1=textscan(char(xiaoFX1(t+251-NN)),'%s', 'delimiter', ',');
%  q1=[q1{:}];
%  p1=textscan(char(q1(2)),'%d', 'delimiter', ':');
%  p1=[p1{:}]; 
%   hourFX1(t)=p1(1);
%   minuteFX1(t)=p1(2);
%  end
% end
%  
% end
% 
% shurureal=shuru;
% shuchureal=shuchu(1:end,10:12);
%  
% 
% 
% load AUDJPYnet_FX_HLC600;
% nets = removedelay(AUDJPYnet_FX_HLC600);
% clear AUDJPYnet_FX_HLC600;
%  
% inputSeries = tonndata(shurureal,false,false);
% targetSeries = tonndata(shuchureal,false,false);
% 
%  
% [xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
% ys = nets(xs,xis,ais);
% 
%  
%  
% ys=100*[ys{end:end}]';
% 
%  
%  
%  csvwrite('C:\\Company\\resultAUDJPY_HLC600.csv', [hourFX1(end),minuteFX1(end),ys]);
 

updated=1;
 fclose('all');
catch exception
    
 updated=0;  
end
   
 
 


end

if(rem(shijian(4),4)==0 && shijian(5)==5 && shijian(6)<10)
    
    predictFXHLC600;
    clear EURJPYnet_FX_HLC600;
%     clear AUDJPYnet_FX_HLC600;
end
end

