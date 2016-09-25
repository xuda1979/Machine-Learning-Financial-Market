 
% Include Neural Network Toolbox dependencies.
% web([docroot '/toolbox/compiler/function.html'])
%#function network

clear;
 
M=71; %%%for training
a=clock;
computed=0;
trained=0;
load Emini15net net15;
load Emini15netopen netopen15;
N=netopen15.numInputDelays;
 

%%%%%%%%% during trading hours, update the computation result
while(1)     %%%%%run all the time now %%%%%%while(a(4) ~= 16 || a(5)>30 || a(5)<15)
    
    
 
a=clock;

if(rem(a(5),15)==13 && a(6)>55)
    
    trained=0;  
end
if( rem(a(5),3)==2 && a(6)>50) %%%%%%%after computation is done and recorded, the bool computed is set to
%%%%%%%be zero again
    computed= 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





while(computed==0) %%%%%%%trading hours computation

 %%%%%%%%simulate netopen15
 fclose('all');
 N=netopen15.numInputDelays;
  try
  ESVOLUM=0.01*csvread('C:\\Company\\historical.csv',0,5);
  


[rowNumber,columns]=size(ESVOLUM);
catch exceptions
  end
%ESVOLUM=ESVOLUM((rowNumber-N-1):(rowNumber-1),1:3); 
try
 
ES=0.01*csvread('C:\\Company\\historical.csv',0,1, [0,1,rowNumber-2,4]);


%%%read time
file=fopen('C:\\Company\\historical.csv');
xiao=textscan(file, '%s', 'delimiter', ',');
xiao=[xiao{:}];

SHIJIAN=double(zeros(rowNumber-1,1));
for i=1:rowNumber-1
    x=xiao(9*i-8);

y=textscan([x{:}], '%d', 'delimiter', ':');
if size([y{:}])== [4 1]
z=double([y{:}]);
 SHIJIAN(i)=double(z(2)+z(3)/60);
else
    z=-1;
        SHIJIAN(i)=-1;
end
   
  
end
 
 [rowSHIJIAN,columnSHIJIAN]=size(SHIJIAN); 
%%%read time over
mubiao=ES(rowNumber-N-1:rowNumber-1,1:1); 
 
shuru=[SHIJIAN(rowSHIJIAN-N:rowSHIJIAN,1:1),ES(rowNumber-N-1:rowNumber-1,2:3),ESVOLUM((rowNumber-N-1):(rowNumber-1),1:3)];
 
inputSeries = tonndata(shuru,false,false);
targetSeries = tonndata(mubiao,false,false);

 
[inputs,inputStates,layerStates,targets] = preparets(netopen15,inputSeries,{},targetSeries);
netopen15.adaptParam.passes = 10;
  adapt(netopen15,inputs,targets,inputStates,layerStates);
 
netsopen = removedelay(netopen15);
netsopen.name = [netopen15.name ' - Predict One Step Ahead'];
 
[xs,xis,ais,ts] = preparets(netsopen,inputSeries,{},targetSeries);
ys = netsopen(xs,xis,ais);
ys=ys(2);
 
ys=100*ys{:,1}';
open=ys;
    
    
    
%%%%simulate net15
 
 N=net15.numInputDelays;
shuru=[SHIJIAN(rowSHIJIAN-N:rowSHIJIAN),ESVOLUM((rowNumber-N-1):(rowNumber-1),1:3)];
mubiao=ES(rowNumber-N-1:rowNumber-1,2:4); 
inputSeries = tonndata(shuru,false,false);
targetSeries = tonndata(mubiao,false,false);

 
[inputs,inputStates,layerStates,targets] = preparets(net15,inputSeries,{},targetSeries);
 net15.adaptParam.passes = 100;
  adapt(net15,inputs,targets,inputStates,layerStates);
 
nets = removedelay(net15);
nets.name = [net15.name ' - Predict One Step Ahead'];
 
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);


ys = nets(xs,xis,ais);
ys=ys(2);
[open,ys{:}'];
ys=100*ys{:,1}';



x=xiao(9*(rowNumber-1)-8);

y=textscan([x{:}], '%d', 'delimiter', ':');
z=[y{:}];
C=[z(2),z(3),open,ys];

if(a(6)==10)
    C
end
 
csvwrite('C:\\Company\\ESresult.csv', C);
if(a(5)-z(3)<=15 && a(5)-z(3)>=0)
computed=1;
else
    computed=0;
end

fclose('all');

if(computed==1)
try
    delete('C:\Company\historical.csv');
catch exceptions
end
end


catch exceptions
end
%catch exception
%break;
%end

end
%%%%%%%%%%%%%training
while(false)
 clear;
 load Emini15net net15;
 ESVOLUM=0.01*csvread('C:\Company\historical.csv',0,5);
  

[rowNumber,columns]=size(ESVOLUM);
ESVOLUM=ESVOLUM(1:(rowNumber-1),1:3); 
ES=0.01*csvread('C:\Company\historical.csv',0,2, [0,2,rowNumber-2,4]);
 

 %%%%%read time
    file=fopen('C:\\Company\\historical.csv');
xiao=textscan(file, '%s', 'delimiter', ',');
fclose('all');
xiao=[xiao{:}];

SHIJIAN=double(zeros(rowNumber-1,1));
for i=1:rowNumber-1
    x=xiao(9*i-8);

y=textscan([x{:}], '%d', 'delimiter', ':');
if size([y{:}])== [4 1]
z=double([y{:}]);
 SHIJIAN(i)=double(z(2)+z(3)/60);
else
    z=-1;
        SHIJIAN(i)=-1;
end
   
  
end
 
 [rowSHIJIAN,columnSHIJIAN]=size(SHIJIAN); 
 
 %%%read time over


shuru=[SHIJIAN,ESVOLUM];
mubiao=ES;
 
inputSeries = tonndata(shuru,false,false);
targetSeries = tonndata(mubiao,false,false);

 
[inputs,inputStates,layerStates,targets] = preparets(net15,inputSeries,{},targetSeries);
performance=1;
%%while(performance>0.08)
 net15.divideParam.trainRatio = 70/100;
net15.divideParam.valRatio = 15/100;
net15.divideParam.testRatio = 15/100;
[net15,tr] = train(net15,inputs,targets,inputStates,layerStates);
% Test the Network
outputs = net15(inputs,inputStates,layerStates);
errors = gsubtract(targets,outputs);
performance = perform(net15,targets,outputs)
%%%end
save Emini15net net15;
 end

%%%%%%%%%train netopen
while(false)
    clear;
    load Emini15netopen netopen15;
    
    ESVOLUM=0.01*csvread('C:\Company\historical.csv',0,5);
   [rowNumber,columns]=size(ESVOLUM);
   ESVOLUM=ESVOLUM(1:(rowNumber-1),1:3); 
    ES=0.01*csvread('C:\Company\historical.csv',0,1, [0,1,rowNumber-2,3]);
    
    
    %%%%%read time
    file=fopen('C:\\Company\\historical.csv');
xiao=textscan(file, '%s', 'delimiter', ',');
fclose('all');
xiao=[xiao{:}];

SHIJIAN=double(zeros(rowNumber-1,1));
for i=1:rowNumber-1
    x=xiao(9*i-8);

y=textscan([x{:}], '%d', 'delimiter', ':');
if size([y{:}])== [4 1]
z=double([y{:}]);
 SHIJIAN(i)=double(z(2)+z(3)/60);
else
    z=-1;
        SHIJIAN(i)=-1;
end
   
  
end
 
 [rowSHIJIAN,columnSHIJIAN]=size(SHIJIAN); 
 
 %%%read time over
 
shuru=[SHIJIAN, ES(1:end,2:3),ESVOLUM];
mubiao=ES(1:end,1:1);
  
inputSeries = tonndata(shuru,false,false);
targetSeries = tonndata(mubiao,false,false);

 
[inputs,inputStates,layerStates,targets] = preparets(netopen15,inputSeries,{},targetSeries);
performance=1;
 netopen15.divideParam.trainRatio = 70/100;
netopen15.divideParam.valRatio = 15/100;
netopen15.divideParam.testRatio = 15/100;
  
[netopen15,tr] = train(netopen15,inputs,targets,inputStates,layerStates);
% Test the Network
outputs = netopen15(inputs,inputStates,layerStates);
errors = gsubtract(targets,outputs);
performance = perform(netopen15,targets,outputs)
 
save Emini15netopen netopen15;

 
trained=1;
fclose('all');
end
 
 
while( rem(a(4),10)==1 && a(5)==2 && a(6)>50)
    
 try
    zhengliData('C:\Company\historicalBackup.csv');
  catch exception
 end 

   if(a(4)==0) 
 try
    zhengliData('C:\Company\historical60Backup.csv');
  catch exception
 end 
   end
end

while(a(4)==20 && a(5)==5 && a(6)<5)
compiled_network;
end


end

 





 
 
 


