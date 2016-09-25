function ys=Emininet_trained(input)

clear;
N=15;
 
load Emini3net net;
 ES=input(1:end,1:4);
 ESVOLUM=input(1:end,5:end);
 
 mubiao=ES((rowNumber-N-1):(rowNumber-1),2:4); 
inputSeries = tonndata(ESVOLUM,false,false);
targetSeries = tonndata(mubiao,false,false);

 
[inputs,inputStates,layerStates,targets] = preparets(net,inputSeries,{},targetSeries);

 
 
nets = removedelay(net);
nets.name = [net.name ' - Predict One Step Ahead'];
 
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
ys = nets(xs,xis,ais);
 
ys=100*ys{:,N-14}'