


N=30;
a=rand(N,10);
 

t = table(a(:,1),a(:,2),a(:,3),a(:,4),a(:,5),a(:,6),a(:,7),a(:,8),a(:,9),a(:,10),'VariableNames',{'x','y','z','v4','v5','v6','v7','v8','v9','v10'});
%t = table(a(:,1),a(:,2),'VariableNames',{'x','y'});
 
fitlm(t)

scatter(a(:,1),a(:,2));