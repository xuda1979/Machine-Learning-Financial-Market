clear;
d=day(date);
yue=month(date);
yue=yue-1;
nian=year(date);

symbol='GSPC';
URL=['http://ichart.finance.yahoo.com/table.csv?s=%5E' symbol '&d=' int2str(yue) '&e=' int2str(d) '&f=' nian '&g=d&a=0&b=3&c=1950&ignore=.csv'];
path=['C:\AATT\Data\^' symbol '.csv'];
urlwrite(URL, path);   


symbol='FTSE';
URL=['http://ichart.finance.yahoo.com/table.csv?s=%5E' symbol '&d=' int2str(yue) '&e=' int2str(d) '&f=' nian '&g=d&a=0&b=3&c=1950&ignore=.csv'];
path=['C:\AATT\Data\^' symbol '.csv'];
urlwrite(URL, path);   


symbol='FCHI';
URL=['http://ichart.finance.yahoo.com/table.csv?s=%5E' symbol '&d=' int2str(yue) '&e=' int2str(d) '&f=' nian '&g=d&a=0&b=3&c=1950&ignore=.csv'];
path=['C:\AATT\Data\^' symbol '.csv'];
urlwrite(URL, path); 

symbol='GDAXI';
URL=['http://ichart.finance.yahoo.com/table.csv?s=%5E' symbol '&d=' int2str(yue) '&e=' int2str(d) '&f=' nian '&g=d&a=0&b=3&c=1950&ignore=.csv'];
path=['C:\AATT\Data\^' symbol '.csv'];
urlwrite(URL, path); 
symbol='HSI';
URL=['http://ichart.finance.yahoo.com/table.csv?s=%5E' symbol '&d=' int2str(yue) '&e=' int2str(d) '&f=' nian '&g=d&a=0&b=3&c=1950&ignore=.csv'];
path=['C:\AATT\Data\^' symbol '.csv'];
urlwrite(URL, path); 

symbol='N225';
URL=['http://ichart.finance.yahoo.com/table.csv?s=%5E' symbol '&d=' int2str(yue) '&e=' int2str(d) '&f=' nian '&g=d&a=0&b=3&c=1950&ignore=.csv'];
path=['C:\AATT\Data\^' symbol '.csv'];
urlwrite(URL, path); 



symbol='VIX';
URL=['http://ichart.finance.yahoo.com/table.csv?s=%5E' symbol '&d=' int2str(yue) '&e=' int2str(d) '&f=' nian '&g=d&a=0&b=3&c=1950&ignore=.csv'];
path=['C:\AATT\Data\^' symbol '.csv'];
urlwrite(URL, path); 


symbol='000001.SS';
 
URL=['http://ichart.finance.yahoo.com/table.csv?s=' symbol '&a=00&b=4&c=2000&d=0' int2str(yue) '&e=' int2str(d) '&f=' nian '&g=d&ignore=.csv'];
path=['C:\AATT\Data\' symbol '.csv'];
urlwrite(URL, path); 

 

