 
% Include Neural Network Toolbox dependencies.
% web([docroot '/toolbox/compiler/function.html'])
%#function network

while(1)
  a=clock;
  if(a(4)==20 && a(5)==5)
clear;
DownloadData;
 
GSPC;

shangzheng;
HSI;
NK;
FTSE;
DAX;
CAC;
  end
end
