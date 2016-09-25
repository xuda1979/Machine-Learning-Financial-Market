clear;
path='C:\Company\sp100.csv';
file=fopen(path);
 symbols=textscan(file,'%s %s','delimiter', ',');
 symbols=[symbols{:}];
%  for t=1:NN
%  q=textscan(char(xiaoFX(t+2001-NN)),'%s', 'delimiter', ',');
%  q=[q{:}];
%  p=textscan(char(q(2)),'%d', 'delimiter', ':');
%  p=[p{:}]; 
%   hourFX(t)=p(1);
%   minuteFX(t)=p(2);

 fclose('all');
 
 
 
 
  d=day(date);
yue=month(date);
yue=yue-1;
nian=year(date);
 for i=1:100
     

symbol=char(symbols(i,1));
URL=['http://ichart.finance.yahoo.com/table.csv?s=' symbol '&a=00&b=3&c=1977&d=0' int2str(yue) '&e=' int2str(d) '&f=' nian '&g=d&ignore=.csv'];
path=['C:\Company\historical\' symbol '.csv'];
urlwrite(URL, path); 
     
 end
 
 
 L=500;
 data=zeros(L,100);
 
 for i=1:100
     symbol=char(symbols(i,1));
 
     path=['C:\Company\historical\' symbol '.csv'];
     data(:,i)=flipud(csvread(path,1,4,[1,4,L,4]));
     
 end
 
 
 
%  correlation= corrcoef(data);
%  standard_deviation=std(data);
 
 Information=[];
 Technology=[];
 Financials=[];
 CS=[];
 CD=[];
 H=[];
 E=[];
 M=[];
 U=[];
 I=[];
 T=[];
 sectors={'Information Technology', 'Financials', 'Consumer Staples', 'Consumer Discretionary', 'Energy', 'Health Care', 'Materials','Utilities', 'Industrials','Telecommunication Services'};
 
 
 
 
 
 for i=1:100
     
     
     
     
    switch char(symbols(i,2))
    case 'Information Technology'
          Technology=[Technology,data(:,i)];
  
    case 'Financials'
          Financials=[Financials,data(:,i)];  
    case 'Consumer Staples'
          CS=[CS,data(:,i)];
 
    case 'Consumer Discretionary'
          CD=[CD,data(:,i)];
    case 'Health Care'
          H=[H,data(:,i)];
    case 'Energy'
          E=[E,data(:,i)];
    case 'Materials'
          M=[M,data(:,i)]; 
    case 'Utilities'
          U=[U,data(:,i)];         
    case 'Industrials'
          I=[I,data(:,i)];   
    case 'Telecommunication Services'
          T=[T,data(:,i)];      
          
    
    end
     
     
 end
 
    bianliang={'Technology','Financials','CS','CD','H','E','M','U','I','T'};
 
   dataCell=cell(1,10);
   pDataCell=cell(1,10);
   cDataCell=cell(1,10);
   positionDataCell=cell(1,10);
   portfolioPrices=zeros(500,10);
   
   for j=1:10
       
     eval(['dataCell{' int2str(j) '}=' char(bianliang(j)) ';']);  
     
     [m,n]=size(dataCell{j});
     
     pDataCell{j}=zeros(499,n);
     
     for r=0:498
     
     pDataCell{j}(499-r,:)=dataCell{j}(500-r,:)./dataCell{j}(499-r,:)-1;
     
     
     end
      
      cDataCell{j}=zeros(n,n);
 for s=1:n
     for t=1:n
%   cDataCell{j}(s,t)=pDataCell{j}(:,s)'*pDataCell{j}(:,t)/(norm(pDataCell{j}(:,s)*norm(pDataCell{j}(:,t))));
      cDataCell{j}=corrcoef(pDataCell{j});
     end
 end
 
 tezhengzhis=eig(cDataCell{j});
 tezhengzhi=min(tezhengzhis);
 [V,D]=eig(cDataCell{j});
 
 for i=1:n
     if(D(i,i)==tezhengzhi)
         
        tezhengxiangliang=V(:,i); 
     end
     
 end
 positionDataCell{j}=zeros(n,1);
 for i=1:n
 positionDataCell{j}(i)=tezhengxiangliang(i)/norm(pDataCell{j}(:,i));
 
 end
 portfolioPrices(:,j)=dataCell{j}*positionDataCell{j};
     
   end
   
   
   %%%%optimize the sector portfolios
   
   pPortfolioPrices=zeros(499,10);
   for r=0:498
     
     pPortfolioPrices(499-r,:)=portfolioPrices(500-r,:)./portfolioPrices(499-r,:)-1;
     
     
   end
   cPortfolio=zeros(10,10);
   
   for s=1:10
       for t=1:10
       cPortfolio(s,t)=pPortfolioPrices(:,s)'*pPortfolioPrices(:,t)/(norm(pPortfolioPrices(:,s)*norm(pPortfolioPrices(:,t))));   
       end
   end
   
   tezhengzhis=eig(cPortfolio);
 tezhengzhi=min(tezhengzhis);
 [V,D]=eig(cPortfolio);
 
 for i=1:10
     if(D(i,i)==tezhengzhi)
         
        tezhengxiangliang=V(:,i); 
     end
     
 end
 positionPortfolio=zeros(10,1);
 for i=1:10
 positionPortfolio(i)=tezhengxiangliang(i)/norm(cPortfolio(:,i));
 
 end
 finalPortfolioPrice=portfolioPrices*positionPortfolio;
 
 totalPrice=0;
 
 for j=1:10
     s=0;
     [m,n]=size(dataCell{j});
     
     for k=1:n
      
         s=s+abs(dataCell{j}(500,:))*abs(positionDataCell{j});
         
     end
     
     
     totalPrice=totalPrice+s*abs(positionPortfolio(j));
 end
    finalPercentage=100*finalPortfolioPrice/totalPrice;
   a=mean(finalPercentage);
   std(finalPercentage)
 x=1:1:500;

 plot(x,finalPercentage,x,a);
  xlabel('Trading days')
ylabel('Price of optimized portfolio change in percentage')
title('Optimized portfolio price in the past 500 trading days among SP100')
 
 
 
 
%  t=0;
%  
%  for i=1:10
%      
%     [m,n]=size(dataCell{i});
%     t=t+n;
%      
%  end
 