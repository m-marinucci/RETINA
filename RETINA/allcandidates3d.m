function[allcand]=allcandidates3d(cummod)
% Cummod must be a tridimensional array 
% (predictors x models x subsamples permutations)
% This function delivers the union matrix (predictors x models) 
% given a set of candidates obtained
% from each subset rotation

union_mod=(sum(cummod,3) > 0);   %This is a logical union matrix
allcand=cat(3,cummod, union_mod);
         