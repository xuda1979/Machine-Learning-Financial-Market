clear;
LL=1000;
 
b={'EURUSD','USDJPY','GBPUSD','AUDUSD','USDCHF','USDCAD','EURJPY','EURGBP'};
l=500;
 X=[];
 G=[];
for i=1:8
symbol=char(b(i));   
name=[symbol '_prediction_error_FX'];
v = genvarname(name);

name1=[symbol '_gains_FX'];
gains = genvarname(name1);

eval(['load ' v ]);
eval(['load ' gains]);
eval(['X=[X,' v '];']);
eval(['G=[G,' gains '];']);
end

% correlation_FX= corrcoef(X);

 
 w=zeros(1,8);
 wp=zeros(1,8);
 portfolio_FX=zeros(8,LL-l);
 
 invest=0;
 
 
 daily_profit_FX=zeros(1,LL-l);
 cum_profit_FX=zeros(1,LL-l);
 GE=G+X;
 for i=(l+1):LL
      correlation_FX= corrcoef(X((i-l):(i-1),1:8));
       standard_deviation_FX=std(X((i-l):(i-1),1:8));
     w=((correlation_FX\(transpose(GE(i,1:8)./standard_deviation_FX)))/((GE(i,1:8)./standard_deviation_FX)*(correlation_FX\(transpose(GE(i,1:8)./standard_deviation_FX)))))'./standard_deviation_FX;
     if(w*(GE(i,1:8)')<0)
        w=-w;         
     end
     invest=0;
     for j=1:8
     
             invest=invest+w(j);
          
             
     end
     
     for j=1:8
      
             portfolio_FX(j,i)=w(j)/invest;
          
             
     end
     
     
     
     
   
     
     
    
         
     if(invest ~=0)
         %&& GE(i,1:8)*(w')/(sqrt(w*cov(GE)*w'))>0)
     w=w/invest;
     daily_profit_FX(i-l)=G(i,1:8)*(w');
     
     end
   %   cum_profit_FX(1)=daily_profit_FX(1);
     if(i>l+1)
         
         investchange=0;
         for j=1:8
      
                 investchange=investchange+abs(w(j)-wp(j));             
         end
      
        if(daily_profit_FX(i-l)>-0.001)
           cum_profit_FX(i-l)=cum_profit_FX(i-l-1)+daily_profit_FX(i-l)-0.0001*investchange;
        else
           
          cum_profit_FX(i-l)=cum_profit_FX(i-l-1)-0.001-0.0001*investchange;
            
             
        end
        
       
          
     end
     wp=w;
 end
 save cum_profit_FX;
 save daily_profit_FX;
 
 save correlation_FX;
 save standard_deviation_FX;
 save portfolio_FX;
 
 x=1:1:(LL-l);
 
plot(x,40*cum_profit_FX)
xlabel('trading hour')
ylabel('Cumulative Profit')
title('Non Compound Cumulative Profit  of FX trading ')
a_FX=zeros(1,L-l);
a_FX(1)=cum_profit_FX(1);
for i=2:(LL-l)
    a_FX(i)=cum_profit_FX(i+1)-cum_profit_FX(i);
end
    
Sharpe=77.45*mean(a_FX)/std(a_FX)