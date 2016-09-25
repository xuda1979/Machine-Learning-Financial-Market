clear;
clc;
N=1;
r=dir('C:\Company\historical\DataOnly\Forex');

a={'AUDJPY','AUDUSD','AUDCAD','GBPCHF','GBPJPY','EURAUD','EURCAD','EURJPY','EURCHF','EURGBP','EURUSD','USDCHF','USDCAD','USDJPY','GBPUSD'};
for i=3:17
    name=['FX' int2str(i)];
    path=['C:\Company\historical\DataOnly\Forex\' r(i).name];
AD=csvread(path,0,1);
[rows,columns]=size(AD);

v = genvarname(name);
if(i==3 || i==6 || i==7 || i==10 || i==15 || i==16)
     
 
   eval([v '=0.01*AD(rows-N:rows,1:4);']);
else
   eval([v '=AD(rows-N:rows,1:4);']); 
end
end

range=zeros(15,1);
range_std=zeros(15,1);
 
for j=3:17
    
    eval(['range(j-2)=mean((FX' int2str(j) '(:,2)-FX' int2str(j) '(:,3))./FX' int2str(j) '(:,1));'] );
       eval(['range_std(j-2)=std((FX' int2str(j) '(:,2)-FX' int2str(j) '(:,3))./FX' int2str(j) '(:,1));'] );
    if(range(j-2)>0.005)
        
        char(a(j-2))
        range(j-2)
        range_std(j-2)
    end
    
end
j=8;
 eval(['a=((FX' int2str(j) '(:,2)-FX' int2str(j) '(:,3))./FX' int2str(j) '(:,1));'] );
hist(10000*a,0:1:200)