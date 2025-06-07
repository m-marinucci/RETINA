function[y,w,dataflag]=test1
% This is the example with independent regressors
w=[1 0; 0 1; 0 0];
w=repmat(w,100,1);
y=[1 1 0]';
y=repmat(y,100,1);
b=[w ones(rows(y),1)]\y;
dataflag=0;