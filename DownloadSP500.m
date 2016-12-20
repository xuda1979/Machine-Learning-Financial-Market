clear;
 

path='C:\Users\eddy\Documents\GitHub\Matlab\sp500.csv';
file=fopen(path);
symbols=textscan(file,'%s %s %s','delimiter', ',');
 
symbols=[symbols{:}]; 
fclose('all'); 

zongshu=505;
 
 
toTrade=zeros(zongshu,1);
d=day(date);
yue=month(date);
yue=yue-1;
nian=year(date);
 

for i=1:zongshu    
symbol=char(symbols(i,1));
URL=['http://chart.finance.yahoo.com/table.csv?s=AAPL&a=0&b=1&c=1980&d=' int2str(yue) '&e=' int2str(d) '&f=' nian '&g=d&ignore=.csv'];
path=['C:\Users\eddy\Documents\GitHub\Matlab\historical\' symbol '.csv'];
urlwrite(URL, path); 
end
 