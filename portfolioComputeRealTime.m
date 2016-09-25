clear;
clc;
updated=0;
GEUpdate=zeros(1,10);

M=16;

while(true)
    updated=0;
    
    a=clock;
    
    if(a(4)==8 && a(5)==0 && a(6)<10)
        updated=0;
        DownloadLCE;
        DownloadData;
    end
     a=clock;
if(a(4)==9 && a(5)==30 && updated==0)  
      updated=1;



try
    
opens=csvread('C:\\Company\\morningOpens.csv',0,0,[0,0,0,11]);

if(opens(1)+1 ~=weekday(today))
    
updated=0;    
end





for j=1:12
    if(opens(j)==0)
        updated=0;
    end
    
end

for t=2:11
    opens(t)=0.01*opens(t);
end

if(updated==1)
bb={'AAPL','ORCL','CSCO','INTC','QQQ','BAC','GE','F','C','SPY','VIX'};

 
 

for t=2:11
 
 
VIX=csvread('C:\Company\historical\^VIX.csv',1,1,[1,1,M+1,4]);
VIXOpen=[opens(12);VIX(1:(end-1),1:1)];
VIXOpen=flipud(VIXOpen);
 
VIX=VIX(1:end,2:4);
VIX=flipud(VIX);

 
 
%%%input data of GSPC
SPYVOLUM=csvread('C:\Company\historical\SPY.csv',1,5,[1,5,M+1,5]);
SPYVOLUM=0.00000001*flipud(SPYVOLUM);
 
SPY=0.01*csvread('C:\Company\historical\SPY.csv',1,1,[1,1,M+1,4]);
SPYOpen=[opens(11);SPY(1:(end-1),1:1)];
SPYOpen=flipud(SPYOpen);
 
SPY=SPY(1:end,2:4);
SPY=flipud(SPY);

symbol=char(bb(t-1));
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

shuru=[symbolDataOpen,symbolDataReal,symbolDataVOLUM,SPYOpen,SPY,SPYVOLUM,VIXOpen,VIX];
inputSeriesUpdate = tonndata(shuru,false,false);
tarGEUpdatetSeriesUpdate = tonndata(symbolDataClose,false,false);


 
   netname=[symbol 'net'];
   netv = genvarname(netname); 

   eval(['load ' netname ';']);
   eval(['net=' netname ';']);
   eval(['clear ' netname ';']);
 
nets = removedelay(net);
nets.name = [net.name ' - Predict One Step Ahead'];
   
[xs,xis,ais,ts] = preparets(nets,inputSeriesUpdate,{},tarGEUpdatetSeriesUpdate);
ys = nets(xs,xis,ais);

  
 
ys=[ys{:}];
GEUpdate(t-1)=ys(end);
    
 
end
 
GEUpdate=GEUpdate./opens(2:11)-1;
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
load correlation;
load standard_deviation;
a=clock;
w=((correlation\(transpose(GEUpdate./standard_deviation)))/((GEUpdate./standard_deviation)*(correlation\(transpose(GEUpdate./standard_deviation)))))'./standard_deviation;
invest=0;
for p=1:10
    
    if(w(p)>0)
        invest=invest+abs(w(p));
    end
    
     if(w(p)<0)
        invest=invest+4*abs(w(p))/3;
    end
    
end
w=w/invest;

csvwrite('C:\\Company\\result1D_PO.csv', [zhouji,w]);



end

catch exception
    updated=0;
    a=clock;
end
end


end

