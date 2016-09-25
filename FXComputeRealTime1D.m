clear;
clc;
a={'EURUSD','USDJPY','EURJPY','EURGBP','GBPJPY','AUDJPY'};
b=[1,4,509,510,517,60];
 
updated=0;
NN=1584;
hourFX=zeros(NN,1);
shuru=[];
shuchu=[]; 
DataOpen=[];

while(true)

d=day(date);
yue=month(date); 
nian=year(date);
    
    shijian=clock;
    
     if( rem(shijian(5),10)==9 && shijian(6)>=50)
         
         updated=0;
     end
 
if(rem(shijian(5),10)<9 && shijian(6)<15 && updated==0)  
 

 

 
 
 try
 
 
NN=1584;
hourFX=zeros(NN,1);
minuteFX=zeros(NN,1);
shuru=[];
shuchu=[]; 
DataOpen=[];
for j=3:3
 
    URL=['http://www.dukascopy.com/freeApplets/exp/exp.php?fromD=' int2str(yue) '.' int2str(d) '.' int2str(nian) '&np=2000&interval=600&DF=m%2Fd%2FY&Stock=' int2str(b(j)) '&endSym=win&split=coma'];
path=['C:\Company\historical\HourlyFX\' char(a(j)) '600.csv'];
urlwrite(URL, path); 
 
 symbol=char(a(j));
symbolDataVOLUM=csvread(path,2000-NN+1,2,[2000-NN+1,2,2000,2]);
% symbolDataVOLUM=symbolDataVOLUM;
 
%  if(strcmp(symbol,'USDJPY')==0 || strcmp(symbol,'EURJPY')==0 || strcmp(symbol,'GBPJPY')==0 || strcmp(symbol,'AUDJPY')==0)
% symbolData=0.01*csvread(path,250-NN+1,3,[250-NN+1,3,250,6]);
%  else
symbolData=csvread(path,2000-NN+1,3,[2000-NN+1,3,2000,6]);
%  end
 
 
symbolDataClose=symbolData(1:end,2:2);
 
symbolData=symbolData(1:end,3:4);
 
 
shuru=[shuru,symbolDataVOLUM];
shuchu=[shuchu,symbolDataClose,symbolData];
 

 
 if(j==3)
 file=fopen(path);
 xiaoFX=textscan(file, '%s', 'delimiter', '\n');
 xiaoFX=[xiaoFX{:}];
 for t=1:NN
 q=textscan(char(xiaoFX(t+2001-NN)),'%s', 'delimiter', ',');
 q=[q{:}];
 p=textscan(char(q(2)),'%d', 'delimiter', ':');
 p=[p{:}]; 
  hourFX(t)=p(1);
  minuteFX(t)=p(2);
 end
 end
 
 fclose('all');
end
 
shuru180=zeros(11,1);
shuchu180=zeros(11,3);

for k=1:11
     for s=1:1
    shuru180(k,s)=0.000001*sum(shuru((114*k-113):(114*k),s));
   
 
    shuchu180(k,3*(s-1)+1)=shuchu(114*k,3*(s-1)+1);
    di=shuchu(114*k,3*(s-1)+2);
    gao=shuchu(114*k,3*s);
    
    
    for t=1:113
        
        di=min(di,shuchu(114*k-t,3*(s-1)+2));
        gao=max(gao,shuchu(114*k-t,3*s));
    end
    shuchu180(k,3*(s-1)+2)=di;
    shuchu180(k,3*s)=gao;
     end
    
    
end


 for i=1:10
     for s=1:1
    shuchu180(end-i+1,(3*s-2):3*s)=shuchu180(end-i+1,(3*s-2):3*s)-shuchu180(end-i,3*s-2);
     end
 end
 shuchu180=shuchu180(2:end,:);
 shuru180=shuru180(2:end,:);




load EURJPYnet_FX_HLC1D;
nets = removedelay(EURJPYnet_FX_HLC1D);
clear EURJPYnet_FX_HLC1D;
 
inputSeries = tonndata(shuru180 ,false,false);
targetSeries = tonndata(shuchu180,false,false);
 
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
ys = nets(xs,xis,ais);

 
 
ys=[ys{end:end}]';

 
 
 csvwrite('C:\\Company\\resultEURJPY_HLC1D.csv', [d,hourFX(end),minuteFX(end),ys]);

updated=1;
 
catch exception
    
 updated=0;  
end
  

 


 
 
 
 


end

if(shijian(4)==0 && shijian(5)==5 && shijian(6)>55)
    try
   % predictFXHLC1D;
    catch exception
    end
    clear EURJPYnet_FX_HLC1D;
    updated=0;
   
end
end

