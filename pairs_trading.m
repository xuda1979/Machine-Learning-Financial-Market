clear;
pairs=32;
symbols={
'IBM', 'MSFT', 
'LVS', 'MGM',
'OXY', 'MRO', 
'C', 'GS',
'JNJ', 'PFE',
'KO', 'DPS',
 'GIS','UN',
'WMT', 'COST', 
'VALE', 'FCX',
'XOM', 'CVX',
'FDX', 'UPS',
'BAX', 'BCR',
 'DOW', 'HUN',
'HAL', 'CJSE',
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
'GOOG', 'YAHOO',
'DFS', 'V',
'NTRS', 'STT',
'RHHBY', 'SNY',
'COST', 'TGT',
'TGI', 'HON',
'TXN','MXIM',
'IR', 'LII'}

 
 
 
 
  d=day(date);
yue=month(date);
yue=yue-1;
nian=year(date);
 for i=1:pairs
    for j=1:2 

symbol=char(symbols(i,j));
URL=['http://ichart.finance.yahoo.com/table.csv?s=' symbol '&a=00&b=3&c=1977&d=0' int2str(yue) '&e=' int2str(d) '&f=' nian '&g=d&ignore=.csv'];
path=['C:\Company\historical\' symbol '.csv'];
urlwrite(URL, path); 
    end
 end
 
 
 L=1500;
 chuangkou=150;
 data=zeros(L,pairs,2);
 
 for i=1:pairs
     for j=1:2
     symbol=char(symbols(i,j));
 
     path=['C:\Company\historical\' symbol '.csv'];
     data(:,i,j)=flipud(csvread(path,1,4,[1,4,L,4]));
     end
     
 end
 
 PL=zeros(L,1);
 
 pingjun=zeros(pairs,1);
 fangcha=zeros(pairs,1);
 positions=zeros(pairs,2);
 chengjiaoPrices=zeros(pairs,2);
 numPairs=zeros(L-chuangkou,1);
 
 for days=(chuangkou+1):L
 for i=1:pairs
   cha=log(data((days-chuangkou):(days-1),i,1)/data(days-chuangkou,i,1))-log(data((days-chuangkou):(days-1),i,2)/data(days-chuangkou,i,2));
   pingjun(i)=mean(cha);  
   fangcha(i)=std(cha);
   if(data(day,i,1)/data(days-chugangkou,i,1)>data(day,i,2)/data(days-chugangkou,i,2)+pingjun(i)+fangcha(i))
      PL(days)=PL(days-1)+position(i,1)*(data(day,i,1)/data(days-chugangkou,i,1)-chengjiaoPrices(i,1))+position(i,2)*(data(day,i,2)/data(days-chugangkou,i,2)-chengjiaoPrices(i,2));
    
      chengjiaoPrices(i,1)=data(days,i,1)+0.0005*(1-positions(i,1));
      chengjiaoPrices(i,2)=data(days,i,2)-0.0005*(1+positions(i,2));
      if(positions(i,1)==0 && positions(i,2)==0)
      numPairs=numPairs+1;          
      end
      positions(i,1)=1;
      positions(i,2)=-1;
       
   end
 
    if(data(day,i,1)/data(days-chugangkou,i,1)<data(day,i,2)/data(days-chugangkou,i,2)+pingjun(i)-fangcha(i))
      PL(days)=PL(days-1)+position(i,1)*(data(day,i,1)/data(days-chugangkou,i,1)-chengjiaoPrices(i,1))+position(i,2)*(data(day,i,2)/data(days-chugangkou,i,2)-chengjiaoPrices(i,2));
    
      chengjiaoPrices(i,1)=data(days,i,1)-0.0005*(1+positions(i,1));
      chengjiaoPrices(i,2)=data(days,i,2)+0.0005*(1-positions(i,2));
      if(positions(i,1)==0 && positions(i,2)==0)
      numPairs=numPairs+1;          
      end
      positions(i,1)=-1;
      positions(i,2)=1;
    end
   
     if(abs(data(day,i,1)/data(days-chugangkou,i,1)-data(day,i,2)/data(days-chugangkou,i,2)-pingjun(i))<=fangcha(i))
       PL(days)=PL(days-1);  
         
     end
     
 end
 
 
 end
 
 x=1:1:(L-chuangkou);
 plot(x,PL((chuangkou+1):L));
 
 