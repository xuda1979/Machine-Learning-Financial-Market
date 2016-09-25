
%a={'EURUSD','USDJPY','GBPUSD','AUDUSD','USDCHF','EURJPY','EURGBP','GBPJPY','GBPCHF','AUDJPY'};
%b=[1,4,2,10,3,509,510,517,518,60];
clear;
a={'USDJPY','EURJPY','GBPJPY','AUDJPY'};
b=[4,509,517,60];
d=day(date);
yue=month(date); 
nian=year(date);

 
for i=1:4
URL=['http://www.dukascopy.com/freeApplets/exp/exp.php?fromD=' int2str(yue) '.' int2str(d) '.' int2str(nian) '&np=2000&interval=3600&DF=m%2Fd%2FY&Stock=' int2str(b(i)) '&endSym=win&split=coma'];
path=['C:\Company\historical\HourlyFX\' char(a(i)) '3600.csv'];
urlwrite(URL, path); 
 
 
 
end
 
 