function zhengliData2(filename,afilename)
 
fclose('all');
file=fopen(filename);
afile=fopen(afilename);
numC=7;

x=textscan(file, '%s', 'delimiter',',', 'bufsize', 20000000);
x=[x{:}];
[m,n]=size(x);
ax=textscan(afile, '%s', 'delimiter',',', 'bufsize', 20000000);
ax=[ax{:}];
x=[x;ax((numC+1):end)];
finished=0;

j=0;
 
  
[row,column]=size(x);

s=0;
t=0;
q=0;
for i=(m/numC):floor(row/numC)-1
    for k=i+1:floor(row/numC)
        if( strcmp(x(numC*i-numC+1),x(numC*k-numC+1))==1 && strcmp(x(numC*i-numC+2),x(numC*k-numC+2))==1 )==1 
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
    
 
         y=x;
           
         y=[y(1:numC*s);y(numC*t+1:end)];
           
         x=y;
             
    
end

 
 
[row,column]=size(x);
output=cell(floor(row/numC),numC);

for i=1:floor(row/numC)
    for j=1:numC
    output{i,j}=x(numC*i-numC+j);
    end
end
cell2csv(filename,output);


           
     