
clear;

N=5000; %the smallest number of rows in all the historical data

VIX=csvread('C:\AATT\Data\^VIX.csv',1,4,[1,4,5001,4]);
VIX=flipud(VIX);
 
 
SP=csvread('C:\AATT\Data\^GSPC.csv',1,4,[1,4,5001,4]);
SP=flipud(SP);


rsp =SP(3:end)./SP(2:(end-1))-1;

vix1=VIX(2:(end-1));

dvix1=  VIX(2:(end-1))./VIX(1:(end-2)) -1;


t = table(vix1,dvix1,rsp,'VariableNames',{'vix','vix_change','sp500_return'});
 
fitlm(t)

scatter(dvix1,rsp)
hold

x=-0.1:0.0001:1;

y=-0.00085032+0.0058662*x;

plot(x,y);

xlabel('vix change')
ylabel('sp500 return')
title('daily return of S&P500 from 1990 to 2016')
 

