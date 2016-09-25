clear;
pairs=29;
symbols={
'IBM', 'MSFT', 
'LVS', 'MGM',
'OXY', 'MRO', 
'C', 'GS',
'JNJ', 'PFE',
% 'KO', 'DPS',
 'GIS','UN',
'WMT', 'COST', 
'VALE', 'FCX',
'XOM', 'CVX',
'FDX', 'UPS',
'BAX', 'BCR',
 'DOW', 'HUN',
% 'HAL', 'CJES',
'EXC', 'EE',
'SYT', 'DD',
'NOV', 'CAM',
'WMB', 'KMP',
'WFC', 'USB',
'CBS', 'DIS',
'T', 'VZ',
'BA', 'LMT',
'CAT', 'DE',
'JNPR', 'ERIC',
'GOOG', 'YHOO',
% 'DFS', 'V',
'NTRS', 'STT',
'RHHBY', 'SNY',
'COST', 'TGT',
'TGI', 'HON',
'TXN','MXIM',
'IR', 'LII'};

 
 
 
 
  d=day(date);
yue=month(date);
yue=yue-1;
nian=year(date);
 for i=25:pairs
    for j=1:2 

symbol=char(symbols(i,j));
URL=['http://ichart.finance.yahoo.com/table.csv?s=' symbol '&a=00&b=3&c=1977&d=0' int2str(yue) '&e=' int2str(d) '&f=' nian '&g=d&ignore=.csv'];
path=['C:\Company\historical\' symbol '.csv'];
urlwrite(URL, path); 
    end
 end
 
 
 L=1600;
 chuangkou=15;
 data=zeros(L,pairs,2);
 
 for i=1:pairs
     for j=1:2
     symbol=char(symbols(i,j));
 
     path=['C:\Company\historical\' symbol '.csv'];
     data(:,i,j)=flipud(csvread(path,1,4,[1,4,L,4]));
     end
     
 end
 
 PL=zeros(L,1);
 lambda=0.618;
 pingjun=zeros(pairs,1);
 fangcha=zeros(pairs,1);
 positions=zeros(pairs,2);
 chengjiaoPrices=zeros(pairs,2);
 numPairs=zeros(L,1);
 
 
 for i=1:pairs
     for j=1:2
       chengjiaoPrices(i,j)=data(1,i,j);  
     end
 end
 
for tianshu=(chuangkou+1):L
     PL(tianshu)=PL(tianshu-1);
     for i=1:pairs
         numPairs(tianshu)=numPairs(tianshu)+abs(positions(i,1));
     end
     
  for i=1:pairs
   cha=log(data((tianshu-chuangkou):(tianshu-1),i,1)/data(tianshu-chuangkou,i,1))-log(data((tianshu-chuangkou):(tianshu-1),i,2)/data(tianshu-chuangkou,i,2));
   pingjun(i)=mean(cha);  
   fangcha(i)=std(cha);
   
     if(abs(data(tianshu,i,1)/data(tianshu-chuangkou,i,1)-data(tianshu,i,2)/data(tianshu-chuangkou,i,2)-pingjun(i))<=5*fangcha(i))
   if(data(tianshu,i,1)/data(tianshu-chuangkou,i,1)>data(tianshu,i,2)/data(tianshu-chuangkou,i,2)+pingjun(i)+lambda*fangcha(i))
      PL(tianshu)=PL(tianshu)+positions(i,1)*(data(tianshu,i,1)-chengjiaoPrices(i,1))/chengjiaoPrices(i,1)+positions(i,2)*(data(tianshu,i,2)-chengjiaoPrices(i,2))/chengjiaoPrices(i,2);
    
      chengjiaoPrices(i,1)=data(tianshu,i,1)+0.01*(-1-positions(i,1));
      chengjiaoPrices(i,2)=data(tianshu,i,2)+0.01*(1-positions(i,2));
     
      positions(i,1)=-1;
      positions(i,2)=1;
       
   else
     if(data(tianshu,i,1)/data(tianshu-chuangkou,i,1)<data(tianshu,i,2)/data(tianshu-chuangkou,i,2)+pingjun(i)-lambda*fangcha(i))
   PL(tianshu)=PL(tianshu)+positions(i,1)*(data(tianshu,i,1)-chengjiaoPrices(i,1))/chengjiaoPrices(i,1)+positions(i,2)*(data(tianshu,i,2)-chengjiaoPrices(i,2))/chengjiaoPrices(i,2);
    
      chengjiaoPrices(i,1)=data(tianshu,i,1)+0.01*(1-positions(i,1));
      chengjiaoPrices(i,2)=data(tianshu,i,2)+0.01*(-1-positions(i,2));
     
      positions(i,1)=1;
      positions(i,2)=-1;
     else
   
       if(abs(data(tianshu,i,1)/data(tianshu-chuangkou,i,1)-data(tianshu,i,2)/data(tianshu-chuangkou,i,2)-pingjun(i))<=0.05*fangcha(i))
     PL(tianshu)=PL(tianshu)+positions(i,1)*(data(tianshu,i,1)-chengjiaoPrices(i,1))/chengjiaoPrices(i,1)+positions(i,2)*(data(tianshu,i,2)-chengjiaoPrices(i,2))/chengjiaoPrices(i,2);
    
      chengjiaoPrices(i,1)=data(tianshu,i,1)-0.01*positions(i,1);
      chengjiaoPrices(i,2)=data(tianshu,i,2)-0.01*positions(i,2);
      
      positions(i,1)=0;
      positions(i,2)=0;  
        end
     end
   end
 
  else
         PL(tianshu)=PL(tianshu)+positions(i,1)*(data(tianshu,i,1)-chengjiaoPrices(i,1))/chengjiaoPrices(i,1)+positions(i,2)*(data(tianshu,i,2)-chengjiaoPrices(i,2))/chengjiaoPrices(i,2);
    
      chengjiaoPrices(i,1)=data(tianshu,i,1)-0.01*positions(i,1);
      chengjiaoPrices(i,2)=data(tianshu,i,2)-0.01*positions(i,2);
      
      positions(i,1)=0;
      positions(i,2)=0;  
      end   
   end
 
 end

 
 x=1:1:(L-chuangkou);
 plot(x,PL((chuangkou+1):L));
 
 
 
 meiriPL=PL((chuangkou+1):L)-PL((chuangkou):(L-1));
 meriPL(1259)=-1;
 a=mean(meiriPL);
 b=std(meiriPL);
 Sharpe=16*a/b
 



%   L=1600;
%  chuangkou=15;
%  data=zeros(L,pairs,2);
%  
%  for i=1:pairs
%      for j=1:2
%      symbol=char(symbols(i,j));
%  
%      path=['C:\Company\historical\' symbol '.csv'];
%      data(:,i,j)=flipud(csvread(path,1,4,[1,4,L,4]));
%      end
%      
%  end
%  
%  PL=zeros(L,1);
%  lambda=0.618;
%  pingjun=zeros(pairs,1);
%  fangcha=zeros(pairs,1);
%  positions=zeros(pairs,2);
%  chengjiaoPrices=zeros(pairs,2);
%  numPairs=zeros(L,1);
%  
%  
%  for i=1:pairs
%      for j=1:2
%        chengjiaoPrices(i,j)=data(1,i,j);  
%      end
%  end
%  
% for tianshu=(chuangkou+1):L
%      PL(tianshu)=PL(tianshu-1);
%      for i=1:pairs
%          numPairs(tianshu)=numPairs(tianshu)+abs(positions(i,1));
%      end
%      
%   for i=1:pairs
%    cha=log(data((tianshu-chuangkou):(tianshu-1),i,1)/data(tianshu-chuangkou,i,1))-log(data((tianshu-chuangkou):(tianshu-1),i,2)/data(tianshu-chuangkou,i,2));
%    pingjun(i)=mean(cha);  
%    fangcha(i)=std(cha);
%    
%  
%    if(abs(data(tianshu,i,1)/data(tianshu-chuangkou,i,1)-data(tianshu,i,2)/data(tianshu-chuangkou,i,2)-pingjun(i))>lambda*fangcha(i))
%       if(positions(i,1)*(data(tianshu,i,1)-chengjiaoPrices(i,1))/chengjiaoPrices(i,1)+positions(i,2)*(data(tianshu,i,2)-chengjiaoPrices(i,2))/chengjiaoPrices(i,2)>0)
%       PL(tianshu)=PL(tianshu)+positions(i,1)*(data(tianshu,i,1)-chengjiaoPrices(i,1))/chengjiaoPrices(i,1)+positions(i,2)*(data(tianshu,i,2)-chengjiaoPrices(i,2))/chengjiaoPrices(i,2);  
%       chengjiaoPrices(i,1)=data(tianshu,i,1)+0.01*(-positions(i,1));
%       chengjiaoPrices(i,2)=data(tianshu,i,2)+0.01*(-positions(i,2));
%      
%       positions(i,1)=0;
%       positions(i,2)=0;   
%       end
%    end
%  
%  
%      if(abs(data(tianshu,i,1)/data(tianshu-chuangkou,i,1)-data(tianshu,i,2)/data(tianshu-chuangkou,i,2)-pingjun(i))<0.1*lambda*fangcha(i))   
%      r=rand(1);
%      
%      if(r>0.5)
%       PL(tianshu)=PL(tianshu)+positions(i,1)*(data(tianshu,i,1)-chengjiaoPrices(i,1))/chengjiaoPrices(i,1)+positions(i,2)*(data(tianshu,i,2)-chengjiaoPrices(i,2))/chengjiaoPrices(i,2);
%       chengjiaoPrices(i,1)=data(tianshu,i,1)+0.01*(1-positions(i,1));
%       chengjiaoPrices(i,2)=data(tianshu,i,2)+0.01*(-1-positions(i,2));
%       
%       positions(i,1)=1;
%       positions(i,2)=-1; 
%      else
%       PL(tianshu)=PL(tianshu)+positions(i,1)*(data(tianshu,i,1)-chengjiaoPrices(i,1))/chengjiaoPrices(i,1)+positions(i,2)*(data(tianshu,i,2)-chengjiaoPrices(i,2))/chengjiaoPrices(i,2);
%       chengjiaoPrices(i,1)=data(tianshu,i,1)+0.01*(-1-positions(i,1));
%       chengjiaoPrices(i,2)=data(tianshu,i,2)+0.01*(1-positions(i,2));
%       
%       positions(i,1)=-1;
%       positions(i,2)=1;  
%       
%       
%      end   
%      end
%  
%  end
% end
%  
%  x=1:1:(L-chuangkou);
%  plot(x,PL((chuangkou+1):L));
%  
%  
%  
%  meiriPL=PL((chuangkou+1):L)-PL((chuangkou):(L-1));
%  a=mean(meiriPL);
%  b=std(meiriPL);
%  Sharpe=16*a/b
%  
%  
%  