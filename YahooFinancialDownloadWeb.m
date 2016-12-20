clear;
zongshu=2975;
path='C:\Users\eddy\Documents\GitHub\Matlab\russell_3000_2011-06-27.csv';
file=fopen(path);
symbols=textscan(file,'%s','delimiter', ',');
 
symbols=[symbols{:}]; 
fclose('all'); 

data = zeros(40, zongshu);

for s=1:zongshu

symbol=char(symbols(s));
%url=['http://finance.yahoo.com/quote/IBM/key-statistics?p=IBM'];
url=['https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22MSFT%22)&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys'];
result=urlread(url);
DOMnode = xmlread(url);
xRoot = DOMnode.getDocumentElement;
schema = char(xRoot.getAttribute('xsi:noNamespaceSchemaLocation'));
allListitems = DOMnode.getElementsByTagName('quote');


for k = 0:allListitems.getLength-1
  
   thisListitem = allListitems.item(k);
   
   % Get the label element. In this file, each
   % listitem contains only one label.
   thisList = thisListitem.getElementsByTagName('Open');
   thisElement = thisList.item(0);
   Open = char(thisElement.getFirstChild.getData)
 
   
   thisList = thisListitem.getElementsByTagName('PriceBook');
   thisElement = thisList.item(0);
   PriceBook = char(thisElement.getFirstChild.getData)
   
    
   thisList = thisListitem.getElementsByTagName('PEGRatio');
   thisElement = thisList.item(0);
   PEGRatio = char(thisElement.getFirstChild.getData)
  
   thisList = thisListitem.getElementsByTagName('EBITDA');
   thisElement = thisList.item(0);
   EBITDA = char(thisElement.getFirstChild.getData)

    
   thisList = thisListitem.getElementsByTagName('ShortRatio');
   thisElement = thisList.item(0);  
   ShortRatio = char(thisElement.getFirstChild.getData) 
   
   
   thisList = thisListitem.getElementsByTagName('MarketCapitalization');
   thisElement = thisList.item(0);  
   MarketCapitalization = char(thisElement.getFirstChild.getData) 
 
   
%    % Check whether this is the label you want.
%    % The text is in the first child node.
%    if strcmp(thisElement.getFirstChild.getData, findLabel)
%        thisList = thisListitem.getElementsByTagName('Open');
%        thisElement = thisList.item(0);
%        findCbk = char(thisElement.getFirstChild.getData);
%        break;
%    end
%    
end
 
   data(1,s) = PriceBook;
   data(2,s) = MarketCapitalization;
   data(3,s) = PEGRatio;
   

end