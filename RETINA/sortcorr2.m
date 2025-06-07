function[indpnt]=sortcorr2(y,x,tag);
%  ORDER WIJ,S BY ABSOLUTE VAL CORREL COEFF. WITH DEPENDENT VARIABLE 
nw=size(x,2);  

corryw = corrcoef([y x]);                 
abcorr = corryw(2:nw+1,1).^2; 
[indyx_1  index1] = sort(abcorr, 1, 'descend');      % This finds the ranking of the predictors
indpnt=tag(index1)';                                      % This finds the index for the most correlated pred with Y in terms of the corrw matrix
