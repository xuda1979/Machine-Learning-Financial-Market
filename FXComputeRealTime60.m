clear;
clc;
a={'EURUSD','USDJPY','GBPUSD','AUDUSD','USDCHF','EURJPY','EURGBP','GBPJPY','GBPCHF','AUDJPY'};
b=[1,4,2,10,3,509,510,517,518,60];
 
updated=0;
NN=6;
hourFX=zeros(NN,1);
shuru=[];
shuchu=[]; 
DataOpen=[];

while(true)

d=day(date);
yue=month(date); 
nian=year(date);
    
    shijian=clock;
    
     if(  shijian(6)>=50 && shijian(6)<58 )
         
         updated=0;
     end
 
if(shijian(6)<=5 && rem(shijian(5),3)==0 && updated==0)  
 

 

 
 
%try
 
 
NN=6;
hourFX=zeros(NN,1);
minuteFX=zeros(NN,1);
shuru=[];
shuchu=[]; 
DataOpen=[];
j=6;
 
    URL=['http://www.dukascopy.com/freeApplets/exp/exp.php?fromD=' int2str(yue) '.' int2str(d) '.' int2str(nian) '&np=250&interval=60&DF=m%2Fd%2FY&Stock=' int2str(b(j)) '&endSym=win&split=coma'];
path=['C:\Company\historical\HourlyFX\' char(a(j)) '60.csv'];
urlwrite(URL, path); 
 
 symbol=char(a(j));
symbolDataVOLUM=csvread(path,250-NN+1,2,[250-NN+1,2,250,2]);
symbolDataVOLUM=0.001*symbolDataVOLUM;
 
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

 
   
 file=fopen(path);
 xiaoFX=textscan(file, '%s', 'delimiter', '\n');
 xiaoFX=[xiaoFX{:}];
 for t=1:NN
 q=textscan(char(xiaoFX(t+251-NN)),'%s', 'delimiter', ',');
 q=[q{:}];
 p=textscan(char(q(2)),'%d', 'delimiter', ':');
 p=[p{:}]; 
  hourFX(t)=p(1);
  minuteFX(t)=p(2);
 end
 fclose('all');
 
 
 
shurureal=[hourFX,shuru];
shuchureal=shuchu(1:end,1:3);
 


load EURJPYnet_FX_HLC60;
nets = removedelay(EURJPYnet_FX_HLC60);
clear EURJPYnet_FX_HLC60;
 
inputSeries = tonndata(shurureal,false,false);
targetSeries = tonndata(shuchureal,false,false);

 
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
ys = nets(xs,xis,ais);

 
 
ys=100*[ys{end:end}]';

 
 
 csvwrite('C:\\Company\\resultEURJPY_HLC60.csv', [hourFX(end),minuteFX(end),ys]);

updated=1;
 
%catch exception
    
 %updated=0;  
%end
  

 


 
 
 
 


end

if(rem(shijian(4),4)==0 && shijian(5)==5 && shijian(6)>10)
    
    predictFXHLC60;
    clear EURJPYnet_FX_HLC60;
end
end

