%% This strategy is to  
clear;
%path='C:\Company\sp1500.csv';
path='C:\Company\tradedSymbols.csv';
%path='C:\Company\Russell2000_Membership_List.csv';
file=fopen(path);
    %  symbols=textscan(file,'%s %s','delimiter', ',');
  symbols=textscan(file,'%s','delimiter', ',');

 symbols=[symbols{:}]; 
 fclose('all');
 
 
 zongshu=1500;
  toTrade=zeros(zongshu,1);
  
  
  d=day(date);
yue=month(date);
yue=yue-1;
nian=year(date);

 for i=1:zongshu    
 try
symbol=char(symbols(i,1));
URL=['http://ichart.finance.yahoo.com/table.csv?s=' symbol '&a=00&b=3&c=1977&d=0' int2str(yue) '&e=' int2str(d) '&f=' nian '&g=d&ignore=.csv'];
path=['C:\Company\historical\' symbol '.csv'];
urlwrite(URL, path); 

 catch exception
 end
     
 end
 
 zongshu=41;
 L=1000;
 
 datac=zeros(L,zongshu);
 datao=zeros(L,zongshu);
 datah=zeros(L,zongshu);
 datal=zeros(L,zongshu);
 datav=zeros(L,zongshu);
 xuangu=[];
 
 j=1;
 
 
tradedSymbols=cell(1,41);
 for i=1:zongshu
          
     try
     symbol=char(symbols(i,1));
 
     path=['C:\Company\historical\' symbol '.csv'];
     datac(:,j)=flipud(csvread(path,1,4,[1,4,L,4]));
     datah(:,j)=flipud(csvread(path,1,2,[1,2,L,2]));
     datal(:,j)=flipud(csvread(path,1,3,[1,3,L,3]));
     datao(:,j)=flipud(csvread(path,1,1,[1,1,L,1]));
     datav(:,j)=flipud(csvread(path,1,5,[1,5,L,5]));
%      if(datao(end,j)*datav(end,j)>50000000 && datao(end,j)>100)
%          tradedSymbols{j}=symbols(i,1);
%  
%         datao(end,j)*datav(end,j)
           j=j+1;
%          toTrade(i)=1;
%      
%      end
    catch exception
    end
  end
 
%  cell2csv('C:\Company\tradedSymbols1.csv', tradedSymbols,',');
 zongshu=j-1;
 
 
  l=1;
 teshu=0;
 duishu=6;
 commission=0.00025;
 positions=zeros(zongshu,1);
 newPositions=zeros(zongshu,1);
 chengjiaoPrices=zeros(zongshu,1);
 PL=zeros(L-l+1,1);
 
 pcData=zeros(L-l,zongshu);
 pchlData=zeros(L-l,zongshu);
  pchData=zeros(L-l,zongshu);
   pclData=zeros(L-l,zongshu);
 poData=zeros(L-l,zongshu);
 pohlData=zeros(L-l,zongshu);
  pohData=zeros(L-l,zongshu);
   polData=zeros(L-l,zongshu);
  
 for j=1:zongshu
     
  chengjiaoPrices(j)=datac(1,j);    
 end
 
 
 for j=1:zongshu
     
 for i=1:(L-l)
     
    pcData(L-l+1-i,j)=datac(L-i+1,j)/datac(L-i-l+1,j)-1; 
    pchData(L-l+1-i,j)=datac(L-i+1,j)/datah(L-i+1,j)-1; 
    pclData(L-l+1-i,j)=datac(L-i+1,j)/datal(L-i+1,j)-1; 
    
    if((datah(L-i+1,j)-datal(L-i+1,j)) ~=0)
    pchlData(L-l+1-i,j)=(datac(L-i+1,j)-datal(L-i+1,j))/(datah(L-i+1,j)-datal(L-i+1,j)); 
    else
     pchlData(L-l+1-i,j)=0.5;   
    end
    poData(L-l+1-i,j)=datao(L-i+1,j)/datao(L-i-l+1,j)-1; 
    
    if((datah(L-i-l+1,j)-datal(L-i-l+1,j))~=0)
    pohlData(L-l+1-i,j)=(datao(L-i+1,j)-datal(L-i-l+1,j))/(datah(L-i-l+1,j)-datal(L-i-l+1,j)); 
    else
    pohlData(L-l+1-i,j)=0;    
    end
    pohData(L-l+1-i,j)=datao(L-i+1,j)/datah(L-i-l+1,j)-1; 
    polData(L-l+1-i,j)=datao(L-i+1,j)/datal(L-i-l+1,j)-1; 
    
 end
 end
 
 
 for i=1:(L-l)
     
 
        
 
     PL(i+1)=PL(i);
    newPositions=zeros(zongshu,1);
       
 
 ohl=sort(pohlData(i,:));
 chl=sort(pchlData(i,:));
  oh=sort(pohData(i,:));
 ch=sort(pchData(i,:));
  ol=sort(polData(i,:));
 cl=sort(pclData(i,:));
 oo=sort(poData(i,:));
 cc=sort(pcData(i,:));
  
 
%     a=rand(1);
 
 for j=1:zongshu
  
%       if(a>0.5)
 for k=(1+teshu):(duishu+teshu)
    if(polData(i,j)==ol(k))
     newPositions(j)=1;   
 
    end
 end
 
%        else
 for k=(zongshu-duishu+1-teshu):(zongshu-teshu)
    if(pohData(i,j)==oh(k))
     newPositions(j)=-1;   
 
    end
 end
%        end
    

   if(newPositions(j) ~=positions(j))
%  if((positions(j)==0 && newPositions(j) ~=0 )|| (abs(newPositions(j)-positions(j))==2))
    PL(i+1)=PL(i+1)+ positions(j)*(datao(i+l,j)-chengjiaoPrices(j))/chengjiaoPrices(j)-commission*abs(positions(j));
    chengjiaoPrices(j)=datao(i+l,j)+commission*(newPositions(j))*datac(i+1,j); 
    
    positions(j)=newPositions(j);
    
    
    
   end
 
 
 end 
 
   newPositions=zeros(zongshu,1);
   
 
 
%     a=rand(1);
 
 for j=1:zongshu
%      if(a>0.5)
 for k=(zongshu-duishu+1-teshu):(zongshu-teshu)
    if(pchData(i,j)==ch(k) )
     newPositions(j)=-1; 
 
    end
 end
  
%      else
 for k=(1+teshu):(duishu-teshu)
    if(pclData(i,j)==cl(k)  && sum(newPositions)<=0)
     newPositions(j)=1;   
    end
 end
   
%       end
 
 
   if(newPositions(j) ~=positions(j))
%     if((positions(j)==0 && newPositions(j) ~=0 )|| (abs(newPositions(j)-positions(j))==2))
    PL(i+1)=PL(i+1)+ positions(j)*(datac(i+l,j)-chengjiaoPrices(j))/chengjiaoPrices(j)-commission*abs(positions(j));
    chengjiaoPrices(j)=datac(i+l,j)+commission*(newPositions(j))*datac(i+1,j); 
    
    positions(j)=newPositions(j);
    
    
    
   end
 
 
 end
 
 
 end
 
 
 
 x=1:1:(L-l+1);
 plot(x,PL);
 
 meiriPL=PL(2:(L-l+1))-PL(1:(L-l));
 
 a=mean(meiriPL(1:250));
 b=std(meiriPL(1:250));
 Sharpe=15.8*a/b
 
 
 a=mean(meiriPL((end-250):end));
 b=std(meiriPL((end-250):end));
 Sharpe=15.8*a/b
%  
   PL(end)-PL(end-250)
 
  daily_profit=(PL(end)-PL(end-250))/(250*12)
  