clc;
s=0;
for i=500:900
if(daily_profit(i)<-0.001  && daily_profit(i)<0.00)
s=s+1;
end
end
s