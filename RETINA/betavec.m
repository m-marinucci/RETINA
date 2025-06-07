function[b]=betavec(y,w,model)
% This function delivers the betas ordered by their original position with
% respect to their associated predictors. The constant is placed at the
% end. As an example consider we have 10 predictors and the candidate model
% is given by predictors 3 and 7. Then betavec will be a vector 11x1 with
% all zeros except on indexes 3 and 7 where the OLS coefficient show up.
% Position 11 will include the value of the estimated constant

tagg =1:cols(w);
rw=rows(w);
nw=cols(w);
cnst=ones(rw,1);
exclude=setdiff(tagg,model);
b=[w(:,model) cnst]\y;
blist=[[b [model;nw+1]];[zeros(length(exclude),1) exclude']];
b=sortrows(blist,2);
b=b(:,1);