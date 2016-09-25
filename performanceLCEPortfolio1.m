L=1000;
a={'AAPL','ORCL','CSCO','INTC','QQQ','BAC','GE','F','C','SPY'};


load 'AAPL_prediction_error';
load 'AAPL_gains';

X=AAPL_prediction_error;
G=AAPL_gains;
for i=2:10
symbol=char(a(i));   
name=[symbol '_prediction_error'];
v = genvarname(name);

name1=[symbol '_gains'];
gains = genvarname(name1);

eval(['load ' v ]);
eval(['load ' gains]);
eval(['X=[X,' v '];']);
eval(['G=[G,' gains '];']);
end

% correlation= corrcoef(X);
 standard_deviation=std(X);
 
 w=zeros(1,10);
 portfolio=zeros(10,L-100);
 
 invest=0;
 
 
 daily_profit=zeros(1,L-100);
 cum_profit=zeros(1,L-100);
 GE=G+X;
 for i=101:L
      correlation= corrcoef(X((100*floor((i-100-1)/100)+1):(100*floor((i-100-1)/100)+100),1:10));
     w=((correlation\(transpose(GE(i,1:10)./standard_deviation)))/((GE(i,1:10)./standard_deviation)*(correlation\(transpose(GE(i,1:10)./standard_deviation)))))'./standard_deviation;
     if(w*(GE(i,1:10)')<0)
        w=-w;         
     end
     invest=0;
     for j=1:10
         if(w(j)>=0)
             invest=invest+w(j);
         else
             invest=invest+2*abs(w(j))/3;
         end
             
     end
     
     for j=1:10
        
             portfolio(j,i)=w(j)/invest;
          
             
     end
     
     
     
     
   
     
     
    
         
     if(invest ~=0 && GE(i,1:10)*(w')/(sqrt(w*cov(GE)*w'))>0.6)
     
     daily_profit(i-100)=G(i,1:10)*(w')/invest;
     end
      cum_profit(1)=daily_profit(1);
     if(i>101)
         if(daily_profit(i-100)>-0.01)
           cum_profit(i-100)=cum_profit(i-101)+daily_profit(i-100)-0.0003;
         else
           cum_profit(i-100)=cum_profit(i-101)-0.0103;
         end
     end
     
 end
 save cum_profit;
 save daily_profit;
 
 save correlation;
 save standard_deviation;
 save portfolio;
 
 x=1:1:(L-100);
 
plot(x,4*cum_profit)
xlabel('trading day')
ylabel('Cumulative Profit')
title('Non Compound Cumulative Profit in the 900 trading days from 2008 to 2012(Copyright ')