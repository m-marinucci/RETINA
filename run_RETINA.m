clear all; close all; clc;

pvec=[.33;.33];  % this establishes the weights of the first and second subsamples

[y,w,dataflag]=test1;


% PAGW RETINA
tic; [c_retina1,subset_retina1]=RETINA(pvec,y,w,dataflag,1,0); times(1)=toc;