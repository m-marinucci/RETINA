function[cum_mod]=build_2(y,w)

nw=size(w,2);  
corryw_ = corrcoef([y w]);
corrw = corryw_(2:(nw+1),2:(nw+1));                 % This is the correlation matrix among predictors 
corryw=corryw_(2:(nw+1),1).^2;                  % This is the sqaured correlation among predictors
[trash  index1] = sort(corryw, 1, 'descend');      % This finds the ranking of the predictors
aug=index1(1);                                       % This finds the index for the most correlated pred with Y in terms of the corrw matrix

[indyx_2  index2] = sort((corrw(:,index1(1)).^2), 1);      % This computes the lowest correlation index between the first candidate
                                                   % and the second
laminit=indyx_2(index2(1));
lamstep=(1-laminit)/9;                           % This initializes lamstep
index1=index1(2:length(index1));                    % Just consider the remaining variables to be added ordered by their correlation with the dependent var
list=laminit:lamstep:1;

incl_rsq=[]; % this keeps track of the collinearity indexes in each already included model
cum_rsq_tested=[];
cum_indyx_1=[];
cum_candidate=[];
sto_indyx_1=index1;
%currw=aug;
cum_mod=[]; 

for lam=1:length(list)
%Initialize for each lambda
    indyx_1=sto_indyx_1;
    currw=aug; % For each round search start with the predictor most correlated with the response
    count=1;

      lambda=list(lam);
      while ~isempty(indyx_1);
                          % here switch cols
                    curry=indyx_1(count);  % Index of Dependent variable label of the reduced candidates sets since the first and the second var are always in.
                    vx=[currw;curry];% Initialise Index of predictor on which we test the inclusion of the reduced candidate set                
                    candidate=zeros(nw,1);
                    candidate(vx)=ones(length(vx),1);
                   
                    [cand_check0 dup_ind]=compmod(cum_candidate,[candidate;curry]);   % This gives back 0 if no duplicates >0 otherwise.
                    [cand_check2,tmp]=compmod(cum_indyx_1,candidate);   % This gives back 0 if no duplicates >0 otherwise.
                        if ~cand_check2
                            cum_indyx_1=[cum_indyx_1 candidate];
                        end

                    % If the collinearity check has not been already been performed with the current dep var, 
                    % compute it using fast sweeping tecniques
                    % otherwise take the info from the stored base.
                        if ~cand_check0;
                            rsq=rsq2(corrw,vx);   
                            cum_rsq_tested=[cum_rsq_tested;rsq];
                            cum_candidate=[cum_candidate [candidate;curry]];
                        else % Here we have to find where the duplicate is and retrieve the r2 without any additional computation
                             rsq=cum_rsq_tested(dup_ind);
                        end;
                     % Now perform comparison with established lambda threshold   
                      if  rsq <= lambda;
                            currw_cum=[currw;curry]; %Update the specification
                            ee=(indyx_1 == curry);
                            indyx_1(ee>0)=[];  % now indyx_1 includes the ordered indexes of the w's to be added.
                            count=0;
                            mod=zeros(nw,1);
                            mod(currw_cum)=ones(size(currw_cum,1),1);
                            [cand_check1 tmp]=compmod(cum_mod,mod); 
                            % If the model passes the test then add it to the potential 
                            % candidates otherwise go ahead
                            % This stores not only the terminal models for each lambda 
                            % but also each intermediate candidate
                                if ~cand_check1;     
                                    cum_mod=[cum_mod mod]; % store the intermediate candidate and its Collinearity Index (CI)
                                    incl_rsq=[incl_rsq;rsq];
                                end;
                            currw=currw_cum;
                            end;

                    if count < size(indyx_1,1);
                     count=count+1;
                    else
                      break;
                    end;
        end; %closes the candidate loop

       if isempty(indyx_1);
        break; 
       end;
    end;  

    
    % Here we add the null, the first two models, plus the full model if necessary

mod=zeros(nw,1);
mod(aug(1))=1;
tmp=mod;
cum_mod=[tmp cum_mod];
incl_rsq=[laminit;incl_rsq];
cum_rsq_tested=[incl_rsq;  cum_rsq_tested];