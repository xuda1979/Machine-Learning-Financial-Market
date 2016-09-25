function ys=compiled_network
% Include Neural Network Toolbox dependencies.
% web([docroot '/toolbox/compiler/function.html'])
%#function network


N=15;
a=clock;
computed=0;
trained=0;
load Emini3net net;

%%%%%%%%% during trading hours, update the computation result
while(1)     %%%%%run all the time now %%%%%%while(a(4) ~= 16 || a(5)>30 || a(5)<15)
trained=0;   
a=clock;

if( (a(4) ~= 16 || a(5)>30 || a(5)<15)&& rem(a(5),3)==1 && a(6)>1 && a(6)<4) %%%%%%%after computation is done and recorded, the bool computed is set to
%%%%%%%be zero again
    computed= 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while(computed==0 && rem(a(5),3)==0 &&  a(6)>13 && (a(4) ~= 16 || a(5)>30 || a(5)<15)) %%%%%%%trading hours computation

 
try
  ESVOLUM=0.01*csvread('C:\Company\historical.csv',0,5);
catch exception
        break;
end
 


[rowNumber,columns]=size(ESVOLUM);
ESVOLUM=ESVOLUM((rowNumber-N-1):(rowNumber-1),1:3); 

ES=0.01*csvread('C:\Company\historical.csv',rowNumber-N-2,2, [rowNumber-N-2,2,rowNumber-2,4]);

 
inputSeries = tonndata(ESVOLUM,false,false);
targetSeries = tonndata(ES,false,false);

 
[inputs,inputStates,layerStates,targets] = preparets(net,inputSeries,{},targetSeries);

 
 
nets = removedelay(net);
nets.name = [net.name ' - Predict One Step Ahead'];
 
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
ys = nets(xs,xis,ais);
[ys{:}]
ys=100*ys{:,N-14}';

C=[a(5)+3,ys];
 
csvwrite('C:\Company\ESresult.csv', C);
computed=1;
end

while(trained==0 && a(6)>14 && a(6)<20 && a(5)==16 && a(4)==16 )
    try
ESVOLUM=0.01*csvread('C:\Company\historical.csv',0,5);
    catch exception
          
        break;
         
    end

[rowNumber,columns]=size(ESVOLUM);
ESVOLUM=ESVOLUM(1:(rowNumber-1),1:3); 
ES=0.01*csvread('C:\Company\historical.csv',0,2, [0,2,rowNumber-2,4]);
ES=ES(1:(rowNumber-1),1:end); 

 
inputSeries = tonndata(ESVOLUM,false,false);
targetSeries = tonndata(ES,false,false);

 
[inputs,inputStates,layerStates,targets] = preparets(net,inputSeries,{},targetSeries);
[net,tr] = train(net,inputs,targets,inputStates,layerStates);
save Emini3net net;
trained=1;
end



end




 





 
 
 


