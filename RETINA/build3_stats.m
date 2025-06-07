function[coeff,in_res,insSS,insr2,cv_SS, cv_r2,collinearity,corr,aic,bbic]=...
    build3_stats(cum_aug,swe,aug,varcov,nw,rw,w,w2,y,y2,criteria)

% This proc gives back all the necessary stats including "on the fly stats 
% of cross-validated measures"
% We can monitor the evolution of the stepwise procedure whenever it is
% computed by using a sweeping technique
% Importantly this procedure gives back the collinearity index at
% which each predictor is added and the criterion for a new
% addition. If the parameter 'criteria' is set to 1 then it will
% be the correlation between the candidate set of remaining
% predictors to be included and the 'in-sample' error term.
% If the parameter 'criteria' is set to 2 then we consider the
% corrleatio betwee the cross-validated resudual and the
% predictors of the cross-validation set.
% Observe that the coefficients include the constant in the last position
% In sample r2 with respect all the other variable involved

collinearity=1-diag(swe);
%This converts from standardized to unstandardized coefficients and adds
%the constant. Recall the constant is in the last position
coeff=swe(cum_aug,(nw+1)).*diag(sqrt(varcov((nw+1),(nw+1))./...
    sqrt(varcov(aug,aug))));
coeff=[coeff; (mean(y)-mean(w(:,cum_aug),1)*coeff)];

% In-sample residuals (first subsample)
in_res=y-[w(:,cum_aug) ones(rows(w),1)]*coeff;
insSS=in_res'*in_res;
insr2=collinearity(nw+1);

% Cross validated residuals and R2
cv_res=y2-[w2(:,cum_aug) ones(rows(w2),1)]*coeff;
cv_SS=cv_res'*cv_res;       %"outofsampleSS"
cv_r2=1-cv_SS./(y2' * y2);

% This is using the correlation between predictors and actual
% response y (first sample)
if criteria==1
    corr=corrcoef([w y in_res]).^2;
end

% This is using the cv correlation between cv predictions and actual
% response y2
if criteria==2
    corr=corrcoef([w2 y2 cv_res]).^2;
end

corr=corr(1:nw,nw+2);
lengthb=length(coeff);
% This measures are referred to the first subsample only
[aic]=aicc(insSS,rw,lengthb); 
[bbic]=bic(insSS,rw,lengthb);  %
