clear;
 

path='C:\Users\eddy\Documents\GitHub\Matlab\russell_3000_2011-06-27.csv';
file=fopen(path);
symbols=textscan(file,'%s','delimiter', ',');
 
symbols=[symbols{:}]; 
fclose('all'); 
 
zongshu=2972;
data = struct;
validSymbols={};
tic
for i=1:zongshu
    try
    symbol= char(symbols(i));
    v = genvarname(symbol);
    
    eval([v '=getGoogleDailyData({''' symbol '''},''01/01/2000'', ''07/029/2017'', ''mm/dd/yyyy'');']);
      
    eval([' f = fieldnames(' v ');']);
    for j = 1:length(f)
        eval([ 'data.(f{j}) = ' v '.(f{j});']);
    end
    validSymbols{end+1} = symbol;
    catch
    end
end
toc
 

[data,dividend]= getGoogleDailyData(symbols,'01/01/2010', '07/29/2017', 'mm/dd/yyyy');
    


%  
% toTrade=zeros(zongshu,1);
% d=day(date);
% yue=month(date);
% yue=yue-1;
% nian=year(date);
%  
% symbol='^GSPC';
% URL=['http://chart.finance.yahoo.com/table.csv?s=' symbol '&a=0&b=1&c=1980&d=' int2str(yue) '&e=' int2str(d) '&f=' nian '&g=d&ignore=.csv'];
% path=['C:\Users\eddy\Documents\GitHub\Matlab\historical\' symbol '.csv'];
% urlwrite(URL, path); 
% 
% for i=1:zongshu    
% try
% symbol=char(symbols(i,1));
% URL=['http://chart.finance.yahoo.com/table.csv?s=' symbol '&a=0&b=1&c=1980&d=' int2str(yue) '&e=' int2str(d) '&f=' nian '&g=d&ignore=.csv'];
% path=['C:\Users\eddy\Documents\GitHub\Matlab\historical\' symbol '.csv'];
% urlwrite(URL, path); 
% catch
% end
% end
 













