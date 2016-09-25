

T=100; %the length of the time
monicishu=100000;
positions=zeros(T,1);

for c=1:monicishu
    s=0;
    high=0;
    weizhi=1;
for i=1:T
    
 a=randn(1);
 s=s+a;
 if(s>high)
 high=s;     
 weizhi=i;    
 end
 
    
    
end

positions(weizhi)=positions(weizhi)+1;

end

x=1:1:T;
plot(x,positions);