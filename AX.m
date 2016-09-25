clear;
 

path='C:\Company\AX.csv';
file=fopen(path);
symbols=textscan(file,'%s %s','delimiter', ',');
 

 symbols=[symbols{:}]; 
 fclose('all'); 
 zongshu=2168;
 
 
toTrade=zeros(zongshu,1);
d=day(date);
yue=month(date);
yue=yue-1;
nian=year(date);
 

 for i=1:zongshu    
 try
symbol=char(symbols(i,1));
URL=['http://ichart.finance.yahoo.com/table.csv?s=' symbol '.AX&a=00&b=3&c=1977&d=0' int2str(yue) '&e=' int2str(d) '&f=' nian '&g=d&ignore=.csv'];
path=['C:\Company\historical\AX\' symbol '.csv'];
urlwrite(URL, path); 

 catch exception
 end
     
 end
 
 
 
 zongshu=2168;
 L=1000;
 
 datac=zeros(L,zongshu);
 datao=zeros(L,zongshu);
 datah=zeros(L,zongshu);
 datal=zeros(L,zongshu);
 datav=zeros(L,zongshu);
 
 
 
 j=1;
 
 

    
 for i=1:zongshu
    try  
      symbol=char(symbols(i,1));
 
     path=['C:\Company\historical\AX\' symbol '.csv'];
     datac(:,j)=flipud(csvread(path,1,4,[1,4,L,4]));
     datah(:,j)=flipud(csvread(path,1,2,[1,2,L,2]));
     datal(:,j)=flipud(csvread(path,1,3,[1,3,L,3]));
     datao(:,j)=flipud(csvread(path,1,1,[1,1,L,1]));
     datav(:,j)=flipud(csvread(path,1,5,[1,5,L,5]));
    if(datao(end,j)*datav(end,j)>100000 && datao(end,j)>5)
    
%     tradedSymbols{j}=symbols(i,1);  
%     vwaps(j)= 0.25*(datao(end,j)+datah(end,j)+datal(end,j)+datac(end,j));
 
 
        j=j+1;
 
     
    end
     catch exception
   end
 end
 
  zongshu=j-1;
%    cell2csv('C:\Company\AXtrade.csv', tradedSymbols,',');
%    
 
%  junjia=cell(1,zongshu);
%  for j=1:zongshu
%  
%  junjia{j}=cellstr(char(num2str(vwaps(j))));
%  end
% cell2csv('C:\Company\vwapAX.csv',junjia,',');
%  
%     
  

 
 
 l=1;
 teshu=0;
 duishu=5;
 commission=0.001;
 positions=zeros(zongshu,1);
 newPositions=zeros(zongshu,1);
 chengjiaoPrices=zeros(zongshu,1);
 PL=zeros(L-l+1,1);
 
  potData=zeros(L-l,zongshu);
  potDataStd=zeros(L-l,zongshu);
 
 for j=1:zongshu
     
  chengjiaoPrices(j)=datac(1,j);    
 end
 
 
 for j=1:zongshu
     
 for i=1:(L-l)
     
 
    potData(L-l-i+1,j)=4*datao(L-i+1,j)/((datah(L-i,j)+datal(L-i,j)+datao(L-i,j)+datac(L-i,j)))-1; 
 
    
 end
 
      
 end
 
 for i=1:(L-l)
     for j=1:zongshu
     potDataStd(i,j)=potData(i,j)/std(potData(max(1,(i-500)):max(1,(i-1)),j));
 
       
     end
 end
 
 
 
  for i=1:(L-l)
     for j=1:zongshu
       potData(i,j)=potDataStd(i,j);
 
       
     end
  end
 
 
  
 for i=1:(L-l)
     
 
        
 
     PL(i+1)=PL(i);
    newPositions=zeros(zongshu,1);
       
 
 ot=sort(potData(i,:)); 
 
 
 
 
 for j=1:zongshu
  
 
 for k=(1+teshu):(duishu+teshu)
     
     
    if(potData(i,j)==ot(k))
     newPositions(j)=1;   
 
    end
    
    if(potData(i,j)==ot(zongshu+1-k))
     newPositions(j)=-1;   
 
    end
  
 end
 
 
 
    if(newPositions(j) ~=positions(j))
%    if((positions(j)==0 && newPositions(j) ~=0 )|| (abs(newPositions(j)-positions(j))==2) ||(newPositions(j)==0 && sum(abs(positions))>20))
   PL(i+1)=PL(i+1)+ positions(j)*(datao(i+l,j)-chengjiaoPrices(j))/chengjiaoPrices(j)-commission*abs(positions(j));
    chengjiaoPrices(j)=datao(i+l,j)+commission*(newPositions(j))*datao(i+1,j); 
    
    positions(j)=newPositions(j);
    
    
    
   end
 
 
 end 
 
   newPositions=zeros(zongshu,1);
   
 
 
 
 
 for j=1:zongshu
 
    
    if(newPositions(j) ~=positions(j))
%    if((positions(j)==0 && newPositions(j) ~=0 )|| (abs(newPositions(j)-positions(j))==2) || (newPositions(j)==0 && sum(abs(positions))>20))
    PL(i+1)=PL(i+1)+ positions(j)*(datac(i+l,j)-chengjiaoPrices(j))/chengjiaoPrices(j)-commission*abs(positions(j));
    chengjiaoPrices(j)=datac(i+l,j)+commission*(newPositions(j))*datac(i+1,j); 
    
     positions(j)=newPositions(j);
    
    
    
    end
 
 
 end
 
 

 
 
end
 
 
 
 x=1:1:(L-l+1);
 plot(x,PL);
 xlabel('trading days')
ylabel('return')
title('Backtesting simulation of AATS Strategy')
 meiriPL=PL(2:(L-l+1))-PL(1:(L-l));
 
 
 
 a=mean(meiriPL((end-500):end));
 b=std(meiriPL((end-500):end));
 Sharpe=15.8*a/b
 
 
 
 
 
%  
 ( PL(end-400)-PL(end-600))/(200*duishu*2)
  ( PL(end)-PL(end-500))/(500*duishu*2)  
  (PL(end)-PL(end-250))/250
   mean(meiriPL)/(2*duishu)
  
   zuixiao=0;
   c=0;
   for i=500:998
       if(zuixiao>meiriPL(i))
           zuixiao=meiriPL(i);
       end
       if(meiriPL(i)/(2*duishu)<-0.0068)
        c=c+1;   
       end
   end
   
   zuixiao/(duishu*2)
 c
  
 buzhuan=0;
 kaishi=0;
 jieshu=0;
 for i=500:(L-1)
     for j=(i+1):L
         if(PL(j)<=PL(i))
%              if(PL(i)-PL(j)>buzhuan)
%                  kaishi=i;
%                  jieshu=j;
%              end
        buzhuan=max(buzhuan,j-i);
      
         end
     end
 end
 buzhuan
 
 lianxu=0;
 zuidalianxu=0;
 count=0;
 for i=500:(L-l)
   if(PL(i+1)<PL(i))
       lianxu=lianxu+1;
   else
       if(lianxu>=3)
           count=count+1;
       end
       lianxu=0;
   end
   
   zuidalianxu=max(zuidalianxu,lianxu);
     
 end
 zuidalianxu