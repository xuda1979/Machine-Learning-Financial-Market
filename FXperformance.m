clear;

a={'EURUSD','USDJPY','GBPUSD','AUDUSD','USDCHF','EURJPY','EURGBP','GBPJPY','GBPCHF','AUDJPY'};
b=[1,4,2,10,3,509,510,517,518,60];
d=day(date);
yue=month(date); 
nian=year(date);

 
for i=1:10
URL=['http://www.dukascopy.com/freeApplets/exp/exp.php?fromD=' int2str(yue) '.' int2str(d) '.' int2str(nian) '&np=2000&interval=3600&DF=m%2Fd%2FY&Stock=' int2str(b(i)) '&endSym=win&split=coma'];
path=['C:\Company\historical\HourlyFX\' char(a(i)) '.csv'];
urlwrite(URL, path); 
 
 
 
end
 
 

data=csvread('C:\Company\historical\HourlyFX\EURJPY.csv',1,3);

cum_profit=0;
[m,n]=size(data);
step_profit=zeros(m,1);

previous_position=0;
position=0;

stoploss=0.0009;
for i=1:m
    
  position=randi([0,1],1);
  if(position==0)
      
     position=-1;
     
  end
  
  if(previous_position ~=0)
      
     position=previous_position;
  end
  
 
  
  if(position==1)
  if(data(i,3)>data(i,1)*(1-stoploss))
      
      step_profit(i)=data(i,2)-data(i,1)-0.01*abs(position-previous_position);
      
  else
       step_profit(i)=-data(i,1)*stoploss-0.01;
      position=0;
  end
  
  end
  
  if(position==-1)
    if( data(i,4)<data(i,1)*(1+stoploss))
      
      step_profit(i)=data(i,1)-data(i,2)-0.01*abs(position-previous_position);
      
    else
       step_profit(i)=-data(i,1)*stoploss-0.01;
       position=0;
    end
    
  end
    
    
    previous_prosition=position;
    
    
    
    
    
    
    
end
Sharpe= 78*mean(step_profit)/std(step_profit)