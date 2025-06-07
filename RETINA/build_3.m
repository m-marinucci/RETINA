function[cum_tmp]=build_3(y,w,y2,w2,criteria)
% This proc gives back all the necessary stats including "on the fly stats
% of cross-validated measures"
% We can monitor the evolution of the stepwise procedure.
% Importantly this procedure gives back the collinearity index at
% which each predictor is added and the criterion for a new
% addition. If the parameter 'criteria' is set to 1 then it will
% be the correlation between the candidate set of remaining
% predictors to be included and the 'in-sample' error term.
% If the parameter 'criteria' is set to 2 then we consider the
% corrleatio betwee the cross-validated resudual and the
% predictors of the cross-validation set.
% NOTE: The dependent variable is always at the end.
list=1:1:cols(w);
rw=rows(w); % rows of the first subsample
nw=cols(w);
varcov= cov([w y]);
corryw_ = varcov ./ sqrt(diag(varcov)*diag(varcov)');
% We will perform computation using the correlation matrix, then we 
% transform coefficients back for cross-validation
corrw = corryw_(1:nw,1:nw);
% This is the correlation matrix among predictors
corryw= corryw_(1:nw,nw+1).^2;
% Compute the correlation of each predictor with the response

[trash,aug]= max(corryw);

% This finds the index for the most correlated pred with Y in terms of the 
% corrw matrix
starters=aug;
cum_aug=aug;
swe=corryw_;
check_=0;
disp('        aug    insr2      cv_r2       rsq    corryw   correrr   aic      bic');
%This loop adds in a stepwise fashion all candidates. We may monitor a
% at each step the main stats cincluding those related with the
% crossvalidation.
    u=0;
    while (~isempty(check_));
    u=u+1;
    if u==100;
        break
    end
    % First sweep the candidate predictor
    swe=sweep(aug,swe);
    % Compute the next predictor to be included
    [coeff,in_res,insSS,insr2,cv_res, cv_r2, coll_index,criterion,aic,bic]=...
        build3_stats(cum_aug,swe,aug,varcov,nw,rw,w,w2,y,y2,criteria)
        
    [starters,lambdaopt]=onestep(coll_index,criterion,aug);

    starters=setdiff(starters,cum_aug);
    if isempty(starters);
        break;
    end
    
    [trash, maxindc]=max(criterion(starters));
    aug=starters(maxindc); % this selects the predictor which has the 
    % best performance on the selected criterion 
    cum_aug=[cum_aug;aug];
   
    check_=setdiff(list,cum_aug); % check_ this the remaining pred to be processed
 disp([aug insr2 cv_r2 coll_index(cum_aug(rows(cum_aug))) corryw(aug) criterion(aug) aic bic])
end;



    
    % This block creates the candidate model matrix

cum_tmp=zeros(nw,rows(cum_aug));
for i=1:rows(cum_aug)
    cum_tmp(cum_aug(1:i),i)=ones(rows(cum_aug(1:i)),1);
end


