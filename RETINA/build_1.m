function[cum_candidate]=build_1(y,w,lamstep);
% This function is the original PAGW algorithm

nw=cols(w);
corryw = corrcoef([y w]);                 
abcorr = corryw(2:nw+1,1).^2; 
[indyx_1  indpnt] = sort(abcorr, 1, 'descend');      % This finds the ranking of the predictors
                                     % This finds the index for the most correlated pred with Y in terms of the corrw matrix


count=0;
cum_candidate=zeros(nw,1);
cum_candidate(indpnt(1))=1; %initialise with the most correlated var
cum_lambda=0;
check=0;
C=corrcoef(w);    

for lambda=lamstep:lamstep:1 % Here begins the Lambda grid serach loop

    candidate=zeros(nw,1); % this matrix saves the candidate for each lamstep 
    
    curry=indpnt(2);  % Index of Dependent variable label
    currw=indpnt(1);  % Initialise Index of Regressors best corr with dep
    currw_cum=currw;    % stores the candidate regressors after each iteration
        
    for i=2:nw % for each column of w, begin model construction controlling for collinearity
%curry
            % This controls for p>n.
            if (cols(w(:,currw)) >= rows(w)-1)
                 break;
            end
            [rsq]= rsq2(C,[curry;currw]);
        check=(rsq < lambda);
        if rsq < lambda;    % include the regressor only if it is not too collinear conditional on lambda for this step
                currw_cum=[currw;curry] ;
                currw=currw_cum;
        
                candidate(currw)=ones(rows(currw),1); % this matrix saves the candidate for each lamstep
                
                [cand_check1 tmp]=compmod(cum_candidate, candidate);
                if cand_check1 ==0
                    cum_candidate=[cum_candidate candidate];
                    cum_lambda=[cum_lambda lambda];
                end     
                
        end
        if i < nw;      % this is to avoid errors in the last iteration of the model building loop            
                curry=indpnt(i+1); % If rsq < lambda then we consider the next variable of the ordered W's as dependent
        elseif i==nw;
                curry=indpnt(i); % If rsq < lambda then we consider the next variable of the ordered W's as dependent
        end 
        %cum_candidate
count=count+1;
        end         % closes rsq < lambda search loop
end % closes lambda grid search loop
%"operations" count;

