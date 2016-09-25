clear;
clc;
a={'EURJPY'};
b=[509];
 
updated=0;
NN=17;
hourFX=zeros(NN,1);
shuru=[];
shuchu=[]; 
DataOpen=[];

while(true)

d=day(date);
yue=month(date); 
nian=year(date);
    
    shijian=clock;
    
     if(  shijian(6)>=10 )
         
         updated=0;
     end
 
if(shijian(6)<=5 && rem(shijian(5),3)==0  && updated==0)  
 

 

 
 
 try
 
 
NN=130;
hourFX=zeros(NN,1);
minuteFX=zeros(NN,1);
 
shuchu=[]; 
DataOpen=[];
for j=1:1
 
    URL=['http://www.dukascopy.com/freeApplets/exp/exp.php?fromD=' int2str(yue) '.' int2str(d) '.' int2str(nian) '&np=250&interval=3600&DF=m%2Fd%2FY&Stock=' int2str(b(j)) '&endSym=win&split=coma'];
path=['C:\Company\historical\HourlyFX\' char(a(j)) '60.csv'];
urlwrite(URL, path); 
 
 symbol=char(a(j));
 
symbolData=csvread(path,250-NN+1,3,[250-NN+1,3,250,6]);
 
 
symbolDataOpen=symbolData(1:end,1:1);
symbolDataClose=symbolData(1:end,2:2);
 
symbolData=symbolData(1:end,3:4);
 
 
 
shuchu=[shuchu,symbolDataClose,symbolData];
 

 
   if(j==1)
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
   end
 fclose('all');
end
 
 
shuchu180=zeros(17,3);

% for k=1:13
%    
%     shuchu180(k,1)=shuchu(10*k,1);
%     di=shuchu(10*k,2);
%     gao=shuchu(10*k,3);
%     
%     for t=1:9
%         
%         di=min(di,shuchu(10*k-t,2));
%         gao=min(gao,shuchu(10*k-t,3));
%     end
%     shuchu180(k,2)=di;
%     shuchu180(k,3)=gao;
%     
%     
% end

 
for i=1:16
    
   shuchu180(end-i+1,:)=shuchu(end-i+1,:)-shuchu(end-i,1);
    
    
end
 
 
 shuchu180=shuchu180(2:end,:);

load EURJPYnet_FX_HLC600;
nets = removedelay(EURJPYnet_FX_HLC600);
clear EURJPYnet_FX_HLC600;
 
 
targetSeries = tonndata(shuchu180,false,false);

 
[xs,xis,ais,ts] = preparets(nets,{},{},targetSeries);
ys = nets(xs,xis);

 
 
ys=[ys{end:end}]';

 
 
 csvwrite('C:\\Company\\resultEURJPY_HLC180.csv', [hourFX(end),minuteFX(end),ys]);

updated=1;
 
catch exception
    
 updated=0;  
end
  

 


 
 
 
 


end

if(rem(shijian(4),4)==0 && shijian(5)==5 && shijian(6)>55)
    
    predictFXHLC600v2;
    clear EURJPYnet_FX_HLC600;
    updated=0;
end
end

