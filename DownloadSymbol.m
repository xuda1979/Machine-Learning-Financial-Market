function DownloadSymbol(symbol)

 
d=day(date);
yue=month(date);
yue=yue-1;
nian=year(date);

URL=['http://ichart.finance.yahoo.com/table.csv?s=' symbol '&a=00&b=3&c=1977&d=0' int2str(yue) '&e=' int2str(d) '&f=' nian '&g=d&ignore=.csv'];
path=['C:\Company\historical\' symbol '.csv'];
urlwrite(URL, path); 
