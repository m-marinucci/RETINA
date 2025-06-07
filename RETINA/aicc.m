function[aicc]=aicc(rss,n,lengthb);
% Computes the AIC statistic corrected for small samples
% K is the total number of parameters including the intercept and sigma
K=lengthb+1; 
aic =  n*log(rss/n) + 2*K;  
n_K_1=(n-K-1);
if n_K_1>0
    aicc = aic + 2*K*(K+1)/(n-K-1);
elseif n_K_1<1 
    %disp('Warning AICC could not be computed, using AIC instead')
    aicc=aic;
end
