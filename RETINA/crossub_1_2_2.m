function[ccandidate]=crossub_1_2_2(y_es,y_cr,w_es,w_cr,ccandidate)
rw=size(w_es,1);
nw=size(w_es,2);
varcov= cov([w_es y_es]);
%   We will perform computation using the correlation matrix, then we
%   transform coefficients back for cross-validation
corryw_ = varcov ./ sqrt(diag(varcov)*diag(varcov)');   
%This is the correlation matrix among predictors
corrw = corryw_(1:nw,1:nw);
% Compute the correlation of each predictor with the response
corryw=corryw_(1:nw,nw+1).^2;
% This finds the index for the most correlated pred with Y in terms of the
% corrw matrix
[tmp aug]= max(corryw);   
cum_aug=[];
swe=corryw_;
cum_tmp=[];
% This can be done in the same build 2 step no necessity for this proc 
% since we recompute from scratch the correlation matrixes (NOT EFFICIENT)
% This is the sweeping matrix sequence
tmp=[ccandidate(:,1) abs(circshift(ccandidate,[0 -1])-ccandidate)]; 

% this scans and performs all the necessary sweeps
for k=1:size(ccandidate,2);
    aug=find(tmp(:,k));
    cum_aug=find(ccandidate(:,k));
    % this sweeps how many iterations are necessary given aug
    for i=1:size(aug,1);       
        swe=sweep(aug(i),swe);           % sweep the candidate -
        [coeff,in_res,insSS,insr2,cv_res, cv_r2,rsq,h0correrr,aic,bic]=...
       build3_stats(cum_aug,swe,aug(i),varcov,nw,rw,w_es,w_cr,y_es,y_cr,1);
    end;
    cum_tmp=[cum_tmp;cv_r2];
end;

[mmaaxx maxindc]=max(cum_tmp);

ccandidate=ccandidate(:,maxindc);
ccandidate=find(ccandidate);