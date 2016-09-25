function qian=duosuan(stoploss)

data=csvread('C:\Company\historical\HourlyFX\EURJPY.csv',1,3);

qian=0;
for i=1:250
    
    if(data(i,2)>data(i,1) && data(i,1)-data(i,3)>stoploss)
        
        qian=qian+data(i,2)-data(i,1)+stoploss;
    end
    
     if(data(i,2)<data(i,1) && data(i,4)-data(i,1)>stoploss)
        
        qian=qian+data(i,1)-data(i,2)+stoploss;
    end
    
end

 

qian=qian/250