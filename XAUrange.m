path='C:\Users\yinxu\Desktop\XAUUSD_day\XAUUSD_day.csv';
data=csvread(path,1,3);

[m,n]=size(data);

s=0;
b=2000;
for i=(m-b+1):m
    s=s+(data(i,3)-data(i,2))/data(i,1);
    
end
s/b