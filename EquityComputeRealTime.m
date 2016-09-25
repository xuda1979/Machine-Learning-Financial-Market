clear;
clc;
updated=0;
N=1;
GEUpdate=zeros(1,N);

M=1;

while(true)
    updated=0;
    
    a=clock;
    
    if(a(4)==12 && a(5)==0 && a(6)<10)
        updated=0;
        DownloadLCE;
        DownloadData;
    end
     a=clock;
if(a(4)==13 && a(5)==30 && updated==0)  
      updated=1;



try
    
opens=csvread('C:\\Company\\morningOpens.csv',0,0);

if(opens(1)+1 ~=weekday(today))
    
updated=0;    
end





for j=1:2
    if(opens(j)==0)
        updated=0;
    end
    
end

for t=2:2
    opens(t)=0.01*opens(t);
end

if(updated==1)
bb={'AAPL','ORCL','CSCO','INTC','QQQ','BAC','GE','F','C','SPY','VIX'};

 
 

for t=2:2
 
 
path=['C:\Company\historical\' symbol '.csv'];   
symbolDataVOLUM=csvread(path,1,5,[1,5,M+1,5]);
symbolDataVOLUM=0.00000001*flipud(symbolDataVOLUM);
 
symbolDataReal=0.01*csvread(path,1,1,[1,1,M+1,4]);
 
symbolDataOpen=[opens(t);symbolDataReal(1:(end-1),1:1)];
symbolDataOpen=flipud(symbolDataOpen);
 
%symbolData=flipud(symbolData);
symbolDataClose=symbolDataReal(1:end,4:4);
symbolDataClose=flipud(symbolDataClose);

 


symbolDataReal=symbolDataReal(1:end,2:3);
symbolDataReal=flipud(symbolDataReal);

shuru=[symbolDataOpen,symbolDataVOLUM];
inputSeriesUpdate = tonndata(shuru,false,false);
tarGEUpdatetSeriesUpdate = tonndata([symbolDataClose,symbolDataReal],false,false);


 
   netname=[symbol 'net_1D'];
   netv = genvarname(netname); 

   eval(['load ' netname ';']);
   eval(['net=' netname ';']);
   eval(['clear ' netname ';']);
 
nets = removedelay(net);
nets.name = [net.name ' - Predict One Step Ahead'];
   
[xs,xis,ais,ts] = preparets(nets,inputSeriesUpdate,{},tarGEUpdatetSeriesUpdate);
ys = nets(xs,xis,ais);

  
 
ys=[ys{:,end}]';
 
    
 
end
 
 
file=fopen('C:\\Company\\historical\\SPY.csv');
xiao=textscan(file, '%s', 'delimiter', ',');
xiao=[xiao{:}];
x=xiao(8);

y=textscan([x{:}], '%d', 'delimiter', '-');
z=[y{:}];
z=double(z);
n=datenum(z(1),z(2),z(3));
[zhouji,libaiji]=weekday(n);

if(zhouji==6)
   zhouji=1; 
end
 
a=clock;
 

csvwrite('C:\\Company\\result1D_PO.csv', [zhouji,ys]);



end

catch exception
    updated=0;
    a=clock;
end
end

if(a(4)==13 && a(5)==35)
    break;
end
end

