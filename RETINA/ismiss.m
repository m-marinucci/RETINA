function[ind_miss]=ismiss(X)
% function ismiss reproduces Aptech Gauss function ismiss
% If X is a matrix ismiss returns a logical value 0 if there are no missing
% values. It returns 1 if at least one element of X has a NaN value.

ind_miss=isnan(X);
ind_miss=sum(sum(ind_miss));
ind_miss=(ind_miss > 0);