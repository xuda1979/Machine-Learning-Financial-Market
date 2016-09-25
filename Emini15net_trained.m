function output=Emini15net_trained(input)  %%% input are high, low close, time, etc... more over the last row should be zeros


 
load 'C:\Company\matlab files\Emini15net' net15;

if ischar(input)
input=str2num(input);
end


shuru=input(1:end,4:end);
mubiao=input(1:end,1:3);




inputSeries = tonndata(shuru,false,false);
targetSeries = tonndata(mubiao,false,false);


[xs,xis,ais,ts] = preparets(net15,inputSeries,{},targetSeries);
 ys = net15(xs,xis,ais);
output= [ys{end}]


