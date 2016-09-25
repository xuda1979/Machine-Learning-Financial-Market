   
commission=0;
bidaskSpread=0.25;
multiplier=50;
frequency=15;
N=60*23.5*5*52; %the smallest number of rows in all the historical data
zhou=60*23.5*5;

 
NL=0;
position=0; 
newPosition=0;
c5=2;
c6=10;
spread=0.25;
stopTimes=0;
averagePrice=0;
trades=0;
%%%input data of GSPC
 
 
DataSet=csvread('C:\Company\historical\ES\ES.txt',0,1);
 
[m,n]=size(DataSet);

 
load Emini15netopen netopen15;

ES=DataSet((m-2*N+1):m,1:end);


a=1;
b=1;
c=2*N/frequency;
E15=zeros(c,6);
while a<=c
     
    E15(a,2)=ES(15*a-14,2);
    E15(a,6)=0;
    E15(a,3)=ES(frequency*a);
    E15(a,4)=ES(frequency*a);
    for i=0:(frequency-1)
    E15(a,3)=max(E15(a,3),ES(frequency*a-i));
    E15(a,4)=min(E15(a,4),ES(frequency*a-i));
    
    E15(a,6)=ES(frequency*a-i)+E15(a,6);
    end
    E15(a,5)=ES(frequency*a,5);
    t=ES(frequency*a,1);
    E15(a,1)= floor(t)+ (t-floor(t))*100/60;
   a=a+1; 
end
E15=0.001*E15;
S=zeros(1,52);
for i=1:52



E15VOLUM=E15((1+(i-1)*zhou/15):(0.5*c+(i-1)*zhou/15) ,6:end);
SHIJIAN=E15((1+(i-1)*zhou/15):(0.5*c+(i-1)*zhou/15),1:1); 
shuru=[SHIJIAN,E15((1+(i-1)*zhou/15):(0.5*c+(i-1)*zhou/15),3:4),E15VOLUM];
mubiao=E15((1+(i-1)*zhou/15):(0.5*c+(i-1)*zhou/15), 2:2);
 
 
inputSeries = tonndata(shuru,false,false);
targetSeries = tonndata(mubiao,false,false);

% Create a Nonlinear Autoregressive Network with External Input
 
 
[inputs,inputStates,layerStates,targets] = preparets(netopen15,inputSeries,{},targetSeries); 
 

% Train the Network
[netopen15,tr] = train(netopen15,inputs,targets,inputStates,layerStates);

 


%%%%%%%%% prediction
 

E15VOLUM=E15((0.5*c+(i-1)*zhou/15-127):(0.5*c+i*zhou/15-1),6:end);
SHIJIAN=E15((0.5*c+(i-1)*zhou/15-127):(0.5*c+i*zhou/15-1),1:1);
 
 
shuru=[SHIJIAN,E15((0.5*c+(i-1)*zhou/15-127):(0.5*c+i*zhou/15-1),3:4),E15VOLUM];
mubiao=E15((0.5*c+(i-1)*zhou/15-127):(0.5*c+i*zhou/15-1), 2:2);
 
inputSeries = tonndata(shuru,false,false);
targetSeries = tonndata(mubiao,false,false);
 
nets = removedelay(netopen15);
nets.name = [netopen15.name ' - Predict One Step Ahead'];
 
[xs,xis,ais,ts] = preparets(nets,inputSeries,{},targetSeries);
ysnet15open =nets(xs,xis,ais);
ysnet15open=[ysnet15open{:}];
%%%%%%%%end prediction

%%%%%%%%%%calculate P&L
for j=1:(zhou/15)
  
   if(E15(0.5*c+(i-1)*zhou/15+j, 2:2)>0.003+ysnet15open(j) && E15(0.5*c+(i-1)*zhou/15+j, 2:2)<0.012+ysnet15open(j))
       newPosition=-1;
   end
   
   if(E15(0.5*c+(i-1)*zhou/15+j, 2:2)+0.003<ysnet15open(j) && E15(0.5*c+(i-1)*zhou/15+j, 2:2)+0.012>ysnet15open(j))
       newPosition=1;
   end
   
    if((E15(0.5*c+(i-1)*zhou/15+j, 2:2)-averagePrice)*position<-0.002)
       newPosition=0;
   end
   
    if((newPosition ~=position && newPosition ~=0 && stopTimes<6) || (newPosition ~=position && newPosition==0))
    NL=-abs(newPosition-position)*commission+(1000*(E15(0.5*c+(i-1)*zhou/15+j, 2:2)-averagePrice)*position-spread*abs(position))*multiplier;
    averagePrice=E15(0.5*c+(i-1)*zhou/15+j, 2:2);
    trades=trades+1;
    if(newPosition==0)
    stopTimes=stopTimes+1;
    end
    end
    position=newPosition;
   
end


%%%%%%%%%% end calculate
S(1,i)=NL;
stopTimes=0; 
end

 

 