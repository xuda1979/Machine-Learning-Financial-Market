clear;
%%%% read data from file
path='C:\Users\eddy\Documents\GitHub\Matlab\russell_3000_2011-06-27.csv';
file=fopen(path);
symbols=textscan(file,'%s','delimiter', ',');
 
symbols=[symbols{:}]; 
fclose('all'); 

zongshu=2975;
L=1000;
datac = zeros(L,zongshu);
dataM =zeros(L,5);


 symbol='^GSPC';
 path=['C:\Users\eddy\Documents\GitHub\Matlab\historical\' symbol '.csv'];
 [m,n] = size(csvread(path,1,1));
 l_mkt = min(L,m);
 dataM((end-l_mkt+1):end,:)=flipud(csvread(path,1,1,[1,1,l_mkt,5]));   
 
 dataM(:,1:4) = 0.0001*dataM(:,1:4);
 dataM(:,5) = 0.00000000001*dataM(:,5);
 
 
 %%%% make the samples from data
 l = 50;
 input = zeros(l_mkt-l,5*l);
 target = zeros(l_mkt-l,5);
 
 for i=1:l_mkt-l
     for j =1:l
         for k =1:4           
             input(i,(j-1)*5+k) = dataM(i+j-1,k)/dataM(i,4);             
         end
         input(i,(j-1)*5+5) = dataM(i+j-1,5)*dataM(i,4);
     end 
     target(i,1:4) = dataM(i+l,1:4)/dataM(i,4);
     target(i,5) = dataM(i+l,5)*dataM(i,4);
 end
 
 
%%%% train the model
x= input';
t = target';
 
net = feedforwardnet([5,5,5,5,5,5,5,5,5,5]); %%% deep neural network
net.divideFcn = 'divideblock';
net.divideParam.trainRatio = 90/100;
net.divideParam.valRatio = 5/100;
net.divideParam.testRatio = 5/100;
net = train(net,x,t);
%view(net)
y = net(x);
perf = perform(net,y((end-249):end),t((end-249):end));



%%%% compute the correlation of the return and predicted return
h = l_mkt*net.divideParam.testRatio;
 
r= y(4,(end-h+1):end)-t(4,(end-h+1):end);
s = mse(r);

r= y(4,(end-h+1):end)-t(4,(end-h):(end-1));
s1 = mse(r);

r=t(4,(end-h+1):end)-t(4,(end-h):(end-1));
s2 =mse(r);

rou = (s1+s2-s)/(2*sqrt(s1*s2));
display(['correlation of return and predicted return is ',num2str( rou)]);

