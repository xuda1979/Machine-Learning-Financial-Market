clear;
path='C:\Company\sp1500.csv';

% path='C:\Company\russell2000.csv';
file=fopen(path);

 symbols=textscan(file,'%s%s','delimiter', ',');
%    symbols=textscan(file,'%s');

 symbols=[symbols{:}] 
 fclose('all'); 
 zongshu=1500;
 
 
toTrade=zeros(zongshu,1);
d=day(date);
yue=month(date);
yue=yue-1;
nian=year(date);

% symbol='GSPC';
% URL=['http://ichart.finance.yahoo.com/table.csv?s=%5E' symbol '&d=' int2str(yue) '&e=' int2str(d) '&f=' nian '&g=d&a=0&b=3&c=1950&ignore=.csv'];
% path=['C:\Company\historical\' symbol '.csv'];
% urlwrite(URL, path);  

 for i=1:zongshu    
 try
symbol=char(symbols(i,1));
URL=['http://ichart.finance.yahoo.com/table.csv?s=' symbol '&a=00&b=3&c=1977&d=0' int2str(yue) '&e=' int2str(d) '&f=' nian '&g=d&ignore=.csv'];
path=['C:\Company\historical\' symbol '.csv'];
urlwrite(URL, path); 

 catch exception
 end
     
 end
 
 
 
 zongshu=1500;
 L=1000;
 
 datac=zeros(L,zongshu);
 datao=zeros(L,zongshu);
 datah=zeros(L,zongshu);
 datal=zeros(L,zongshu);
 datav=zeros(L,zongshu);
 
%      symbol='GSPC';
%      path=['C:\Company\historical\' symbol '.csv'];
%      datacG=flipud(csvread(path,1,4,[1,4,L,4]));
%      datahG=flipud(csvread(path,1,2,[1,2,L,2]));
%      datalG=flipud(csvread(path,1,3,[1,3,L,3]));
%      dataoG=flipud(csvread(path,1,1,[1,1,L,1]));
%      datavG=flipud(csvread(path,1,5,[1,5,L,5]));
 
 
 j=1;
 
 
%          tradedSymbols=cell(1,zongshu); 
%          vwaps=cell(1,zongshu);

    
 for i=1:zongshu
    try  
      symbol=char(symbols(i,1));
 
     path=['C:\Company\historical\' symbol '.csv'];
     datac(:,j)=flipud(csvread(path,1,4,[1,4,L,4]));
     datah(:,j)=flipud(csvread(path,1,2,[1,2,L,2]));
     datal(:,j)=flipud(csvread(path,1,3,[1,3,L,3]));
     datao(:,j)=flipud(csvread(path,1,1,[1,1,L,1]));
     datav(:,j)=flipud(csvread(path,1,5,[1,5,L,5]));
    if(datao(end,j)*datav(end,j)>600000 && datao(end,j)>10)
    
    tradedSymbols{j}=symbols(i,1);  
    vwaps(j)= 0.25*(datao(end,j)+datah(end,j)+datal(end,j)+datac(end,j));
 
 
        j=j+1;
 
     
    end
     catch exception
   end
 end
 
  zongshu=j-1;
   cell2csv('C:\Company\russell2000trade.csv', tradedSymbols,',');
   
 
 junjia=cell(1,zongshu);
 for j=1:zongshu
 
 junjia{j}=cellstr(char(num2str(vwaps(j))));
 end
cell2csv('C:\Company\vwap.csv',junjia,',');
%  
%     
  

 
 
 l=1;
 teshu=0;
 duishu=6;
 commission=0.0008;
 positions=zeros(zongshu,1);
 newPositions=zeros(zongshu,1);
 chengjiaoPrices=zeros(zongshu,1);
 PL=zeros(L-l+1,1);
 
%  pcData=zeros(L-l,zongshu);
%   
%  pchlData=zeros(L-l,zongshu);
%   pchData=zeros(L-l,zongshu);
%    pclData=zeros(L-l,zongshu);
%  poData=zeros(L-l,zongshu);
%  pohlData=zeros(L-l,zongshu);
%   pohData=zeros(L-l,zongshu);
%    polData=zeros(L-l,zongshu);
%    pomData=zeros(L-l,zongshu);
%  pcmData=zeros(L-l,zongshu);
%  pctData=zeros(L-l,zongshu);
  potData=zeros(L-l,zongshu);
  potDataStd=zeros(L-l,zongshu);
%  pctDataStd=zeros(L-l,zongshu);
 
%  pctDataG=zeros(L-l,zongshu);
%  potDataG=zeros(L-l,zongshu);
%  potDataStdG=zeros(L-l,zongshu);
%  pctDataStdG=zeros(L-l,zongshu);
 for j=1:zongshu
     
  chengjiaoPrices(j)=datac(1,j);    
 end
 
 
 for j=1:zongshu
     
 for i=1:(L-l)
     
%     pcData(L-l+1-i,j)=datac(L-i+1,j)/datac(L-i-l+1,j)-1; 
%      
%     pchData(L-l-i+1,j)=datac(L-i+1,j)/datah(L-i+1,j)-1; 
%     pclData(L-l-i+1,j)=datac(L-i+1,j)/datal(L-i+1,j)-1; 
%      if((datah(L-i+1,j)-datal(L-i+1,j))~=0)
%     pchlData(L-l-i+1,j)=(datac(L-i+1,j)-datal(L-i+1,j))/(datah(L-i+1,j)-datal(L-i+1,j)); 
%     else
%     pchlData(L+1-i,j)=0.5;    
%      end
%     
%     pcmData(L-l-i+1,j)=datac(L-i+1,j)/(datah(L-i+1,j)+datal(L-i+1,j)); 
%     pctData(L-l-i+1,j)=4*datac(L-i+1,j)/((datah(L-i+1,j)+datal(L-i+1,j)+datao(L-i+1,j)+datac(L-i+1,j)))-1; 
% %   pctData(L-l-i+1,j)=8*datac(L-i+1,j)/((datah(L-i+1,j)+datal(L-i+1,j)+datao(L-i+1,j)+datac(L-i+1,j))+(datah(L-i,j)+datal(L-i,j)+datao(L-i,j)+datac(L-i,j)))-1; 
%     if((datah(L-i,j)-datal(L-i,j)) ~=0)
%     pohlData(L-l-i+1,j)=(datao(L-i+1,j)-datal(L-i,j))/(datah(L-i,j)-datal(L-i,j)); 
%     else
%      pohlData(L-l+1-i,j)=0;   
%     end
%     pomData(L-l-i+1,j)=datao(L-i+1,j)/(datah(L-i,j)+datal(L-i,j)); 
%     potData(L-l-i+1,j)=4*datao(L-i+1,j)/((datah(L-i,j)+datal(L-i,j)+datao(L-i,j)+datac(L-i,j)))-1; 
    potData(L-l-i+1,j)=4*datao(L-i+1,j)/((datah(L-i,j)+datal(L-i,j)+datao(L-i,j)+datac(L-i,j)))-1; 
%       potDataG(L-l-i+1,j)=(datao(L-i+1,j)/dataoG(L-i+1))/(((datah(L-i,j)+datal(L-i,j)+datao(L-i,j)+datac(L-i,j)))/((datahG(L-i)+datalG(L-i)+dataoG(L-i)+datacG(L-i))))-1; 
%     poData(L-l+1-i,j)=datao(L-i+1,j)/datao(L-i-l+1,j)-1; 
%     
%    
%     
%     
%     pohData(L-l-i+1,j)=datao(L-i+1,j)/datah(L-i,j)-1; 
%     polData(L-l-i+1,j)=datao(L-i+1,j)/datal(L-i,j)-1; 
%     
    
 end
 
      
 end
 
 biaozhuncha=zeros(1,zongshu);
 chacha=cell(1,zongshu);
 for j=1:zongshu
 biaozhuncha(j)=std(potData((end-499):end,j));
 chacha{j}=cellstr(char(num2str((biaozhuncha(j)))));
 end
cell2csv('C:\Company\sigma.csv',chacha,',');
 
 for i=1:(L-l)
     for j=1:zongshu
     potDataStd(i,j)=potData(i,j)/std(potData(max(1,(i-500)):max(1,(i-1)),j));
%      pctDataStd(i,j)=pctData(i,j)/std(pctData(max(1,(i-506)):max(1,(i-7)),j));
       
  
       
     end
 end
 
 
 
  for i=1:(L-l)
     for j=1:zongshu
       potData(i,j)=potDataStd(i,j);
%        pctData(i,j)=pctDataStd(i,j);
       
     end
  end
 
%   for i=1:(L-l)
%      for j=1:zongshu
%      potDataStdG(i,j)=potDataG(i,j)/std(potDataG(max(1,(i-500)):max(1,(i-1)),j));
%  
%        
%   
%        
%      end
%  end
 
%  
%  
%   for i=1:(L-l)
%      for j=1:zongshu
%        potDataG(i,j)=potDataStdG(i,j);
%  
%        
%      end
%  end
  
  
 for i=1:(L-l)
     
 
        
 
     PL(i+1)=PL(i);
    newPositions=zeros(zongshu,1);
       
%  
%  ohl=sort(pohlData(i,:));
%  chl=sort(pchlData(i,:));
%   oh=sort(pohData(i,:));
%  ch=sort(pchData(i,:));
%   ol=sort(polData(i,:));
%  cl=sort(pclData(i,:));
%  oo=sort(poData(i,:));
%  cc=sort(pcData(i,:));
%  cm=sort(pcmData(i,:));
%  om=sort(pomData(i,:));
%   ct=sort(pctData(i,:));
 ot=sort(potData(i,:)); 
%   otG=sort(potDataG(i,:));
 
 
 
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
 
 
%   for k= (1+teshu):(duishu+teshu)
%      if(abs(ct(k)-ct(zongshu+1-k))>0.0)
%     if(pctData(i,j)==ct(zongshu+1-k) )
%      newPositions(j)=-1; 
%  
%     end
%     
%     if(pctData(i,j)==ct(k) )
%       newPositions(j)=1;   
%     end 
%      
%       
%      end
%   end
  
 
    
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