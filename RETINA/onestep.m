 function[cum_tmp,rsqq]=onestep(coll_index,criterion,tmp)
% this function gives back starters and implicit lambda levels of
% collinearity.
% Lambda thresholds are equal to the collinearity index vector in order to
% give each variable the opportunity to act
% as a starter for the next iteration. We do not need to check for any
% redundancy in the generated candidate model.
% What we are interested in is in the starter variables.  The fact that a
% variable may be a starter depend on
% two crucial things: the collinearity index from low to high and second by
% the order of the correlation with the
% dependent variable.
% Since we know correlations a priori we can exploit this info to adjust
% the grid search in order to find starters for
% the next iteration. Notice this loop avoids to check for duplicate
% models selected!!!
% this search stategy involves p-1 predictors;
% remark this may be costly having too many predictors (especially using l1
% trnsf) it is for this reason that we may need to set the interval to
% fixed lentgh of 10.

nw=rows(criterion);

cum_mm=[];
cum_tmp=[];
%tmp=find(coll_index <= 2.23e-16);
coll_index(tmp)=NaN;      
% this sets the already included predictor to 
% missing since its correlation is null given that it is ortogonal with the error term
laminit=sortrows(coll_index(1:nw));
laminit(find(isnan(laminit)))=[];  % this resets the indexes of the remaining candidates

minlam=min(laminit);
maxlam=max(laminit);
interval=rows(laminit);
% interval=10; -- this may be important given that when there are a lot
% of predictors the step size is small and the comptutational burden
% increases
tmp=(maxlam-minlam)/interval;
laminit=seqa(minlam,tmp,interval+1);

tmp=repmat(laminit',nw,1);

mm= (tmp >= repmat(coll_index(1:nw),1,cols(tmp))); % This is the check matrix
tmp = mm.*repmat(criterion,1,cols(mm));              % This reflects the correlation with the resids

[trash cum_tmp]=max(tmp); % This selects the best predictor 

% Removes duplicates but preserves the order
tmp= find(cum_tmp' == lag1(cum_tmp'));
cum_tmp(tmp)=[]
rsqq=coll_index(cum_tmp); % This is the lambda theshold passed

%disp('It may occur that no var passes the test') 
%cum_tmp
