clear;
load('C:\Program Files (x86)\YLoader\data\netGSPCOPENLOW.mat');

file=urlread('http://finance.yahoo.com/q?s=^GSPC');
[mat idx] = regexp(file, '>Open:</th><td class="yfnc_tabledata1">(\d\,\d\d\d\.\d\d)</td>','tokens');
OPEN=0.01*str2double(mat{:}); 
[mat idx] = regexp(file, 's Range:</th><td class="yfnc_tabledata1"><span><span id="yfs_g00_\^gspc">(\d\,\d\d\d\.\d\d)','tokens');
LOW=0.01*str2double(mat{:}); 

 



N=7; %the smallest number of rows in all the historical data

VIXVOLUM=csvread('C:\Program Files (x86)\YLoader\data\^VIX.csv',0,5);
[rows,columns]=size(VIXVOLUM);
VIX=csvread('C:\Program Files (x86)\YLoader\data\^VIX.csv',rows-N-1,1, [rows-N-1,1,rows-1,4]);
 
%%%input data of GSPC
GSPCVOLUM=csvread('C:\Program Files (x86)\YLoader\data\^GSPC.csv',0,5);
[rows,columns]=size(GSPCVOLUM);
GSPC_HIGH=0.01*csvread('C:\Program Files (x86)\YLoader\data\^GSPC.csv',rows-N-1,2, [rows-N-1,2,rows-1,2]);
GSPC_CLOSE=0.01*csvread('C:\Program Files (x86)\YLoader\data\^GSPC.csv',rows-N-1,4, [rows-N-1,4,rows-1,4]);
GSPC=[GSPC_HIGH,GSPC_CLOSE];

GSPC_OPEN=0.01*csvread('C:\Program Files (x86)\YLoader\data\^GSPC.csv',rows-N,1, [rows-N,1,rows-1,1]);
GSPC_OPEN=[GSPC_OPEN',OPEN]';

GSPC_LOW=0.01*csvread('C:\Program Files (x86)\YLoader\data\^GSPC.csv',rows-N,3, [rows-N,3,rows-1,3]);
GSPC_LOW=[GSPC_LOW',LOW]';

 

GSPCVOLUM=0.00000001*GSPCVOLUM((rows-N):rows,1:1);
ALLOVERVOLUM=[GSPC_OPEN,GSPC_LOW, GSPCVOLUM,VIX];

 
inputSeries = tonndata(ALLOVERVOLUM,false,false);
targetSeries = tonndata(GSPC,false,false);

 
[inputs,inputStates,layerStates,targets] = preparets(net,inputSeries,{},targetSeries);

 
 
nets = removedelay(net);
nets.name = [net.name ' - Predict One Step Ahead'];
 
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
ys = nets(xs,xis,ais);
 

A=100*ys{:,N-6};
A=[100*OPEN, A(1),100*LOW,A(2)]';
B=csvread('C:\Company\result.csv', 1,0,[1,0,1,3]); 
C=[A,B']';
csvwrite('C:\Company\result.csv', C);
f = ftp('ftp.ipage.com','aatsyscom','DongFeng09$$');
delete(f,'result.csv');
mput(f,'C:\Company\result.csv');
 close(f);
save('C:\Program Files (x86)\YLoader\data\netGSPCOPENLOW.mat','net');