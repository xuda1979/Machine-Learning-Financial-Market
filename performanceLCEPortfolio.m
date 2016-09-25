clear;
LL=1005;
b={'AAPL','ORCL','CSCO','INTC','QQQ','BAC','GE','F','C','SPY'};

l=500;
load 'AAPL_prediction_error';
load 'AAPL_gains';
 
X=AAPL_prediction_error;
G=AAPL_gains;
for i=2:10
symbol=char(b(i));   
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

 
 w=zeros(1,10);
 portfolio=zeros(10,LL-l);
 
 invest=0;
 
 
 daily_profit=zeros(1,LL-l);
 cum_profit=zeros(1,LL-l);
 GE=G+X;
 for i=(l+1):LL
      correlation= corrcoef(X((i-l):(i-1),1:10));
       standard_deviation=std(X((i-l):(i-1),1:10));
   w=((correlation\(transpose(GE(i,1:10)./standard_deviation)))/((GE(i,1:10)./standard_deviation)*(correlation\(transpose(GE(i,1:10)./standard_deviation)))))'./standard_deviation;
%       w=zeros(1,10);
%    w(9)=1;
    if(w*(GE(i,1:10)')<0)
        w=-w;         
    end
%      suiji=rand(1);
%      if(suiji>0.5)
%          w(9)=1;
%      else
%          w(9)=-1;
%      end
     
     invest=0;
     for j=1:10
         if(w(j)>=0)
             invest=invest+w(j);
         else
             invest=invest+4*abs(w(j))/3;
         end
             
     end
     
     for j=1:10
         if(w(j)>=0)
             portfolio(j,i)=w(j)/invest;
         else
             portfolio(j,i)=-4*abs(w(j))/(3*invest);
         end
             
     end
     
     
     
     
   
     
     
    
         
     if(invest ~=0 && GE(i,1:10)*(w')/invest>0.001)
         %&& GE(i,1:10)*(w')/(sqrt(w*cov(GE)*w'))>0)
     
     daily_profit(i-l)=G(i,1:10)*(w')/invest;
     end
   %   cum_profit(1)=daily_profit(1);
       if(i>l+1)
      
       if(daily_profit(i-l)>-0.00)
           cum_profit(i-l)=cum_profit(i-l-1)+daily_profit(i-l);
       else
           
       cum_profit(i-l)=cum_profit(i-l-1)-0.003;
            
             
       end
        
       
          
       end
     
 end
 save cum_profit;
 save daily_profit;
 
 save correlation;
 save standard_deviation;
 save portfolio;
 
 x=1:1:(LL-l);
 
plot(x,4*cum_profit)
xlabel('trading day')
ylabel('Cumulative Profit')
title('Non Compound Cumulative Profit in the 900 trading days from 2008 to 2012 ')
a=zeros(1,304);
for i=1:304
    a(i)=cum_profit(i+1)-cum_profit(i);
end
    
Sharpe=16*mean(a)/std(a)