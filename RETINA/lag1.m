function[lagged1x]=lag1(x)
% This function reproduces the lag1 function of Aptech's Gauss
% x is an input vector, but may also be a matrix where each column
% represents a time series
% The first value of the lagged series will be a NaN
lagged1x=circshift(x,[1 0]);
lagged1x(1)=NaN;

