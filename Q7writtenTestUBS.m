E=zeros(1,10);

E(1)=72;

for i=2:10
   E(i)=50*i+0.5*(max(44*i,E(i-1))) 
    
end