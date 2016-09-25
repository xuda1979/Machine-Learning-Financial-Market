 
% Include Neural Network Toolbox dependencies.
% web([docroot '/toolbox/compiler/function.html'])
%#function network

clear;
N=15;
a=clock;
computed=0;
trained=0;
load Emini1Hnet net1H;
load Emini1Hnetopen netopen1H;

%%%%%%%%% during trading hours, update the computation result
while(1)     %%%%%run all the time now %%%%%%while(a(4) ~= 16 || a(5)>30 || a(5)<15)
trained=0;   
a=clock;

if(a(5)==59) %%%%%%%after computation is done and recorded, the bool computed is set to
%%%%%%%be zero again
    computed= 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





while(computed==0 && a(5)~=59) %%%%%%%trading hours computation

 %%%%%%%%simulate netopen
 
 try
  ESVOLUM=0.01*csvread('C:\\Company\\historical60.csv',0,5);
catch exception
        break;
end
 


[rowNumber,columns]=size(ESVOLUM);
ESVOLUM=ESVOLUM((rowNumber-N-1):(rowNumber-1),1:3); 

ES=0.01*csvread('C:\\Company\\historical60.csv',rowNumber-N-2,1, [rowNumber-N-2,1,rowNumber-2,4]);
file=fopen('C:\\Company\\historical60.csv');
xiao=textscan(file, '%s', 'delimiter', ',');
xiao=[xiao{:}];

XIAOSHI=zeros(N+1,1);
for i=(rowNumber-N-1):(rowNumber-1)
     y=xiao(9*i-8);
     y=[y{:}];
     y=textscan(y,'%d');
 
     y=[y{:}];
     a=y(2)
     
    XIAOSHI(i-rowNumber+N+2)= a;
end
mubiao=ES(1:(N+1),1:1); 
 
shuru=[ES(1:(N+1),2:3),ESVOLUM,XIAOSHI];
 
inputSeries = tonndata(shuru,false,false);
targetSeries = tonndata(mubiao,false,false);

 
[inputs,inputStates,layerStates,targets] = preparets(netopen1H,inputSeries,{},targetSeries);

 
 
netsopen = removedelay(netopen1H);
netsopen.name = [netopen1H.name ' - Predict One Step Ahead'];
 
[xs,xis,ais,ts] = preparets(netsopen,inputSeries,{},targetSeries);
ys = netsopen(xs,xis,ais);
 
ys=100*ys{:,1}';
open=ys;
    
    
    
%%%%simulate net
 
 
shuru=[ESVOLUM,XIAOSHI];
mubiao=ES(1:(N+1),2:4); 
inputSeries = tonndata(shuru,false,false);
targetSeries = tonndata(mubiao,false,false);

 
[inputs,inputStates,layerStates,targets] = preparets(net1H,inputSeries,{},targetSeries);

 
 
nets = removedelay(net1H);
nets.name = [net1H.name ' - Predict One Step Ahead'];
 
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
ys = nets(xs,xis,ais);
[open,ys{:}']
ys=100*ys{:,1}';

C=[a(4)+1,open,ys];
 
csvwrite('C:\\Company\\ESresult.csv', C);
computed=1;
end

while(trained==0 && a(5)==55 )
 
    try
ESVOLUM=0.01*csvread('C:\Company\historical60.csv',0,5);
    catch exception
          
        break;
         
    end

[rowNumber,columns]=size(ESVOLUM);
ESVOLUM=ESVOLUM(1:(rowNumber-1),1:3); 
ES=0.01*csvread('C:\Company\historical60.csv',0,2, [0,2,rowNumber-2,4]);
ES=ES(1:(rowNumber-1),1:end); 






shuru=ESVOLUM;
mubiao=ES;

 k=0;
 for i=1:(rowNumber-1)
     if shuru(i,1)==-0.0100
         k=i;
     end
         
 end
 
if k ~= rowNumber-1 
 shuru=shuru((k+1):end,1:end);
 mubiao=mubiao((k+1):end,1:end);
 XIAOSHI=zeros(rowNumber-1-k,1);
 for i=(k+1):(rowNumber-1)
     y=xiao(9*i-8);
     y=[y{:}];
     y=textscan(y,'%d');
 
     y=[y{:}];
     a=y(2);
     
    XIAOSHI(i-rowNumber+N+2)= a;
 end
 
 end
 
 [rowNumber,column]=size(shuru);
 if(rowNumber>=N)
     
inputSeries = tonndata([shuru,XIAOSHI],false,false);
targetSeries = tonndata(mubiao,false,false);

 
[inputs,inputStates,layerStates,targets] = preparets(net1H,inputSeries,{},targetSeries);
performance=1;
%%while(performance>0.08)
[net1H,tr] = train(net1H,inputs,targets,inputStates,layerStates);
% Test the Network
outputs = net1H(inputs,inputStates,layerStates);
errors = gsubtract(targets,outputs);
performance = perform(net1H,targets,outputs)
%%%end
save Emini1Hnet net1H;
 end

%%%%%%%%%train netopen
   
ESVOLUM=0.01*csvread('C:\Company\historical60.csv',0,5);
   
[rowNumber,columns]=size(ESVOLUM);
ESVOLUM=ESVOLUM(1:(rowNumber-1),1:3); 
ES=0.01*csvread('C:\Company\historical60.csv',0,1, [0,1,rowNumber-2,3]);
 
shuru=[ES(1:end,2:3),ESVOLUM];
mubiao=ES(1:end,1:1);
 k=0;
 for i=1:(rowNumber-1)
     if shuru(i,1)==-0.0100
         k=i;
     end
         
 end
 
 if k ~= rowNumber-1 
 shuru=shuru((k+1):end,1:end);
 mubiao=mubiao((k+1):end,1:end);
  XIAOSHI=zeros(rowNumber-1-k,1);
 for i=(k+1):(rowNumber-1)
     y=xiao(9*i-8);
     y=[y{:}];
     y=textscan(y,'%d');
 
     y=[y{:}];
     a=y(2);
     
    XIAOSHI(i-rowNumber+N+2)= a;
 end
 end
 
 
 
 [rowNumber,column]=size(shuru);
 if(rowNumber>=N)
inputSeries = tonndata([shuru,XIAOSHI],false,false);
targetSeries = tonndata(mubiao,false,false);

 
[inputs,inputStates,layerStates,targets] = preparets(netopen1H,inputSeries,{},targetSeries);
performance=1;
 
[netopen1H,tr] = train(netopen1H,inputs,targets,inputStates,layerStates);
% Test the Network
outputs = netopen1H(inputs,inputStates,layerStates);
errors = gsubtract(targets,outputs);
performance = perform(netopen1H,targets,outputs)
 
save Emini1Hnetopen netopen1H;


trained=1;
 end
end



end




 





 
 
 


