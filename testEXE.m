function testEXE
clear;
N=15; %the smallest number of rows in all the historical data
load GSPCnet net;
VIX=csvread('C:\\Company\\historical data\\^VIX.csv',1,1,[1,1,5001,4]);
 