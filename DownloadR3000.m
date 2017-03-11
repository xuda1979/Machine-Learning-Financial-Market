clear;
 

path='russell_3000_2011-06-27.csv';
file=fopen(path);
symbols=textscan(file,'%s','delimiter', ',');
 
symbols=[symbols{:}]; 
fclose('all'); 

zongshu=2975;
 
 
toTrade=zeros(zongshu,1);
d=day(date);
yue=month(date);
yue=yue-1;
nian=year(date);
 
symbol='^GSPC';
URL=['http://chart.finance.yahoo.com/table.csv?s=' symbol '&a=0&b=1&c=1980&d=' int2str(yue) '&e=' int2str(d) '&f=' int2str(nian) '&g=d&ignore=.csv'];
path=['../historical/' symbol '.csv'];
urlwrite(URL, path); 

for i=1:zongshu    
try
symbol=char(symbols(i,1));
URL=['http://chart.finance.yahoo.com/table.csv?s=' symbol '&a=0&b=1&c=1980&d=' int2str(yue) '&e=' int2str(d) '&f=' int2str(nian) '&g=d&ignore=.csv'];
path=['../historical/' symbol '.csv'];
urlwrite(URL, path); 
catch
end
end
 













