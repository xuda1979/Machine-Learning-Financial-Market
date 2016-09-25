
a={'EURUSD','USDJPY','GBPUSD','AUDUSD','USDCHF','USDCAD','EURJPY','EURGBP'};
b=[1,4,2,10,3,9,509,510];
d=day(date);
yue=month(date); 
nian=year(date);

for i=1:8
    URL=['http://www.dukascopy.com/freeApplets/exp/exp.php?fromD=' int2str(yue) '.' int2str(d) '.' int2str(nian) '&np=250&interval=3600&DF=m%2Fd%2FY&Stock=' int2str(b(i)) '&endSym=win&split=coma'];
apath=['C:\Company\historical\HourlyFX\' char(a(i)) 'temp.csv'];
urlwrite(URL, apath); 
 path=['C:\Company\historical\HourlyFX\' char(a(i)) '.csv'];
 zhengliData2(path,apath);
 delete(apath);
end
 