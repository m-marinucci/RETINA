function[bic]=bic(rss,n,lengthb);
% Computes the BIC statistic here lengthb refers to the parameter vector including the constant 
bic =  n*log(rss/n) + log(n)*(lengthb+1);  
