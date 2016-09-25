 
s=0;
ma=0;
for i=1:900
if(daily_profit(i)<0)
s=s+daily_profit(i);
else
ma=min(ma,s);    
s=0;
end
end