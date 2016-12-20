clear;

path='C:\Users\eddy\Documents\GitHub\Matlab\russell_3000_2011-06-27.csv';
file=fopen(path);
symbols=textscan(file,'%s','delimiter', ',');
 
symbols=[symbols{:}]; 
fclose('all'); 

zongshu=2975;
L=5000;
datac = zeros(L,zongshu);
dataM =zeros(L,1);


 symbol='^GSPC';
 path=['C:\Users\eddy\Documents\GitHub\Matlab\historical\' symbol '.csv'];
 [m,n] = size(csvread(path,1,1));
 l_mkt = min(L,m);
 dataM((end-l_mkt+1):end)=flipud(csvread(path,1,4,[1,4,l_mkt,4]));   

for i=1:zongshu
    try  
    symbol=char(symbols(i));
     
    path=['C:\Users\eddy\Documents\GitHub\Matlab\historical\' symbol '.csv'];
    [m,n] = size(csvread(path,1,1));
    l = min(m,l_mkt);
    datac((end-l+1):end,i)=flipud(csvread(path,1,4,[1,4,l,4]));
     
    catch exception
    end
end



%%%% loading daily close data over

%%% length for training

len= 100;
profit = zeros(zongshu,1);
positions = zeros(zongshu,1);
tradePrices = zeros(zongshu,1);
 
tradingCost= 0.001;
 
H=[1,0;0,0];
C=[0,0]';
pl = zeros(L,1);
realizedPL = 0;
frequency = 10;
TV = zeros(L,1);

%for i=200:L
for i=(L-210):L
    pl(i) = realizedPL;
    if( rem(i,100) ==0)
    r_mkt = (dataM((i-len+1):i)-dataM((i-len-frequency+1):(i-frequency)))./dataM((i-len-frequency+1):(i-frequency));
    
    r_mkt(isnan(r_mkt))=0;
    
    keySet = 1;
    valueSet = 1;
 
    mapObjPositive = containers.Map(keySet,valueSet);
    mapObjNegative = containers.Map(keySet,valueSet);
    for j=1:zongshu
     
  
    
       r = (datac((i-len+1):i,j)-datac((i-len-frequency+1):(i-frequency),j))./datac((i-len-frequency+1):(i-frequency),j);
         r(isnan(r)) = 0;
         t = table(r_mkt,r,'VariableNames',{'Mkt','r'});
         lm= fitlm(t);
         TV(i)= predict(
         
       if(~isnan(lm.Coefficients.Estimate(1)))
       if(lm.Coefficients.Estimate(1) ~=0)
           if(lm.Coefficients.Estimate(1)>0)
                t = coefTest(lm,H,C);
                if(~isnan(t))
                     mapObjPositive(t)=j;
                end
           end
    
    
        if(lm.Coefficients.Estimate(1)<0)
            t = coefTest(lm,H,C);
            if(~isnan(t))
                mapObjNegative(t)=j;
            end
        end
       end
       end
    end
    
    newPositions=zeros(zongshu,1);
   
   % display 'mapObjPositive.Count is';
    s=mapObjPositive.Count;
    allkeys =keys(mapObjPositive);
    for k=1:min(s,100)
     %   display 'buy on stock';
     %  allkeys{k}
        newPositions(mapObjPositive(allkeys{k})) = 1/200;
    end

     display 'mapObjNegative.Count is';
     s=mapObjNegative.Count;
     allkeys =keys(mapObjNegative);
        for k=1:min(s,100)
      %      display 'sell on stock';
       %     allkeys{k}
            newPositions(mapObjNegative(allkeys{k})) = -1/200;
        end
        
        for k =1:zongshu
            if tradePrices(k) ~=0
                pl(i) =pl(i)+positions(k)*(datac(i,k)-tradePrices(k))/tradePrices(k); 
            end
            pl(i) = pl(i)-abs((newPositions(k)-positions(k))*tradingCost);
       
        end
        tradePrices = datac(:,j);
        positions = newPositions;
        realizedPL = pl(i);
 
    else
       for k =1:zongshu
           
               if tradePrices(k) ~=0
                   pl(i) =pl(i)+positions(k)*(datac(i,k)-tradePrices(k))/tradePrices(k);
               end
         
       
       end
    end 
    
end

plot(pl);


