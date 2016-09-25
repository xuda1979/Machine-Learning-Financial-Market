clc; 

 

A=csvread('C:\Company\historical\C.csv',1,1);
 

 [m,n]=size(A);
 N=180;
 count=0;
 s=0;
 
 for i=1:N
     a=abs(A(i,2)-A(i,1))/A(i,1);
     b=abs(A(i,3)-A(i,1))/A(i,1);
      s=s+max(a,b);
      if(b<0.01 && a<0.01)
          count=count+1;
      end
     
 end
 
s=s/N
r=count/N