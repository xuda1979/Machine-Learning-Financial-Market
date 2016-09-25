function zhengliData(filename)
 
fclose('all');
file=fopen(filename);
numC=9;

x=textscan(file, '%s', 'delimiter',',', 'bufsize', 10000000);
x=[x{:}];

finished=0;


while(finished==0)
[row,column]=size(x);

s=0;
t=0;
q=0;
for i=1:floor(row/numC)-1
    for k=i+1:floor(row/numC)
        if  strcmp(x(numC*i-numC+1),x(numC*k-numC+1))==1 || strcmp(x(numC*i-numC+2),'-1')==1 
            s=i;
            t=k;
            
        end
        if s~=0
            break;
        end
    end
    
    if s~=0
        break;
    end
end


if (s~=0)
    
    for p=0:(t-s)
        try
         if strcmp(x(numC*(s+p)-numC+1),x(numC*(t+p)-numC+1))==1  
             
          q=p;
         else
             break;
         end
        catch exception
            break;
        end
        
    end
         y=x';
           if(s>1)
           y=[y(1:numC*s-numC),y(numC*(s+q)+1:end)];
           else
             y=y(2*numC-numC+1:end);   
           end
           x=y';
             
    
end

if(s==0)
    finished=1;
end

end
 
[row,column]=size(x);
output=cell(floor(row/numC),numC);

for i=1:floor(row/numC)
    for j=1:numC
    output{i,j}=x(numC*i-numC+j);
    end
end
cell2csv(filename,output);


           
     