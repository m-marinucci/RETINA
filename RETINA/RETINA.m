function[b,model]=RETINA(pvec,y,w,dataflag,procflag,criteria)
% Max Marinucci (C) 2007 Universidad Complutense Madrid, 28223 Somosaguas.
% RETINA model building and selection algorithm Usage: - pvec is a (2x1)
% vector which contains the proportions to be used for
%   splitting the sample in three subsamples. The condition
%   pvec(1)+pvec(2)<1 is required.   
% - y is the (nx1) response vector - w is the (nxp) predictors matrix -
% 'dataflag' is a scalar. If 0 then data is scrambled randomly. If 1 then
%   the natural ordering is considered. The former case is adequate for
%   cross-section. The latter is adequate for stationary time series data.
% - 'procflag' is a scalar. If 1 then the original PAGW algorithm is
%   adopted. If 2 a minor modification is introduced by speeding up 
%   computations via sweeping and  computing the union
%   model at the end of the subsets cycling loop. If 3 the new version with
%   adaptive lambda grid search is adopted. The main difference between the
%   two procedures resides in the fact that the PAGW algorithm uses the
%   correlations with the dependent variable as a static criteria in order
%   to decide the inclusion of a new variable. On the other side the new
%   algorithm includes in a more adaptive way a new variable depending not
%   on its correlation with the response but with the residual of the
%   regression of the previously included predictors. There is also the
%   possibility to use as a criterion the correlation with the residuals
%   obtained by cross-validation setting the 'criteria' parameter
%   adequetly.
% - 'criteria' is active only when procflag is set to 3. It is a
%   scalar and can assume either 1 or 2. When it is 1 the model is
%   constructed using the in-sample error of the regression with the 
%   previously included predictors to decide the inclusion of a new
%   predictor. When it is 2 the model is built using the
%   crossvalidated-sample error of the regression with the previously
%   included predictors. 
%
%     b is the estimated OLS vector
%
%     References: Perez-Amaral T. Gallo G. and White H., "A Flexible Tool
%     for Model Building: the Relevant Transformation of the Inputs Network
%     Approach (RETINA)", Oxford Bulletin of Economics and Statistics,
%     821-838, (65), 2003.

    [rw,nw]=size(w);
    cnst=ones(rw,1);
    tagg=1:nw;

    % Compute once for all the subsets to be used further
    [rndidx] = datasubsets(pvec,rw,dataflag);
    
    % All possible sequences of subsets
    if dataflag==0;
    perm= [1 2 3;
           1 3 2;
           2 1 3;
           2 3 1;
           3 1 2;
           3 2 1]; 
    end
    % When Stationary time-series data is used then only the sequence 1-2-3
    % is valid
 
    if dataflag ==1;
        perm= [1 2 3];
    end
    
     % Initializes the logical (yes/no) model matrix where rows are predictors.
     % and columns are models
    cummod=[];

    %----------------------------------------------------------------------
    % This is the original PAGW RETINA algorithm
    %---------------------------------------------------------------------- 
    if procflag ==1;
        lambda_step=.1;
        for i=1:rows(perm)    
            idx1=find(rndidx==perm(i,1));        
            idx2=find(rndidx==perm(i,2));        
            idx3=find(rndidx==perm(i,3));        

            y1=y(idx1); w1=w(idx1,:);
            y2=y(idx2); w2=w(idx2,:);
            y3=y(idx3); w3=w(idx3,:);

            [fmodels]=build_1(y1,w1,lambda_step);   
            
            [fmodel]=crossub_1_2_2(y1,y2,w1,w2,fmodels);        % This returns the candidate model a
            [ind_ycandt]=...
                sortcorr([y1;y2],[w1(:,fmodel);w2(:,fmodel)],tagg(fmodel));
            [bin_mod]=evamod([y1;y2],y3,[w1;w2],w3,fmodel,ind_ycandt);
            
            % Here we compare the candidate model with those previously
            % computed and add them to the list only if its specification
            % is differente from the previous ones
            [cand_check0,dup_ind]=compmod(cummod,bin_mod);
            if cand_check0==0;
                cummod=[cummod bin_mod];
            end
            % This establishes the best model in terms of AIC over the
            % whole sample
            [b,model]=evafinal(y,w, cummod);
        end   
    end

    %----------------------------------------------------------------------
    % This is RETINA algorithm adding the union model feature
    %---------------------------------------------------------------------- 
   
    if procflag==2;
            for i=1:rows(perm)    
                idx1=find(rndidx==perm(i,1));        
                idx2=find(rndidx==perm(i,2));        
                idx3=find(rndidx==perm(i,3));        

                y1=y(idx1); w1=w(idx1,:);
                y2=y(idx2); w2=w(idx2,:);
                y3=y(idx3); w3=w(idx3,:);

                [fmodels]=build_2(y1,w1);                    
                [fmodel]=crossub_1_2_2(y1,y2,w1,w2,fmodels);        % This returns the candidate model a
                [ind_ycandt]=sortcorr([y1;y2],[w1(:,fmodel);w2(:,fmodel)],tagg(fmodel));
                [bin_mod]=evamod([y1;y2],y3,[w1;w2],w3,fmodel,ind_ycandt);

                % Here we compare the candidate model with those previously
                % computed and add them to the list only if its specification
                % is differente from the previous ones
                [cand_check0,dup_ind]=compmod(cummod,bin_mod);
                if cand_check0==0;
                    cummod=[cummod bin_mod];
                end
            end   
            % This generates the union model
            [cummod]=allcandidates(cummod);
            % This establishes the best model in terms of AIC over the
            % whole sample
            [b,model]=evafinal(y,w, cummod);
    end
 
    
    %----------------------------------------------------------------------
    % This is the second type of RETINA algorithm
    %----------------------------------------------------------------------
    rperm= rows(perm);
    
    if procflag==3;
    cube_models=zeros(nw,nw,rperm);                                         
    cube_test_SS=zeros(rperm,nw); 
        for i=1:rperm          
            idx1=find(rndidx==perm(i,1));        
            idx2=find(rndidx==perm(i,2));        
            idx3=find(rndidx==perm(i,3));        

            y1=y(idx1); w1=w(idx1,:);
            y2=y(idx2); w2=w(idx2,:);
            y3=y(idx3); w3=w(idx3,:);
        
            [fmodels]=build_3(y1,w1,y2,w2,criteria);
            rnw=nw-cols(fmodels);
            fmodels=[fmodels zeros(nw,rnw)];
            % This returns the candidate models
            % This matrix has p models in columns
            cube_models(:,:,i)=fmodels;                     
            % This is a tridimensional array where the third dimension is
            % relative  to the subset rotations                                                
        end

        % Now we must collect in a bi-dimensional array all non-redundant
        % models
        % Since the first column contain one predictor, the second, two, the
        % third three and so on, the redundancy check must operate along
        % the third dimension. 
        cummod=[];

        for j=1:nw % select one parameterization class (first col, one pred, second col two preds...)
            for k=1:rperm   % cicle within the class through all subsample permutations
             [cand_check0,duplicate]=compmod(cummod,cube_models(:,j,k)); % check whether there are redundancies
                 if cand_check0==0;
                     cummod=[cummod cube_models(:,j,k)]; % If no redundancies cumulate otherwise discard
                 end
            end
        end
        
        %Here we consider the union 
        cube_models=allcandidates3d(cube_models);
        %This extracts the union model
        union_models=cube_models(:,:,rperm+1);         
        cumtmp=[];
        % Now check for redundancies the union matrix
            for j=1:nw 
                % check wether there are redundancies
                [cand_check0,trash]=compmod(cumtmp,union_models(:,j)); 
                if cand_check0==0;
                    % This is the union matrix  without redundancies
                  cumtmp=[cumtmp  union_models(:,j)];
                end
            end
          
         % Now check for each of parameterizations of the union matrix the
         % redundancy with the cummod matrix and obtain the definitive
         % matrix of candidates cummod.
         %
            for j=1:cols(cumtmp) % check wether there are redundancies
                [cand_check0,trash]=compmod(cummod,cumtmp(:,j)); 
                if cand_check0==0;
                    % This is the union matrix  without redundancies
                  cummod=[cummod cumtmp(:,j)]; 
                end
            end
  
            test=sum(cummod,1);
            test=find(test==0);
            cummod(:,test)=[];
            
            % Here we evaluate the last step considering the stabilization
            % by implementing ridge estimation for each model in cummod
            cum_aic=[];
            for i=1:cols(cummod)
                indexes=find(cummod(:,i));
                [beta_r,df]=ridge_reg(y,w(:,indexes));
                beta_ridge(:,i)=zeros(nw+1,1);
                indexes=[indexes;(nw+1)];
                beta_ridge(indexes,i)=beta_r;
                in_res=y-[w cnst]*beta_ridge(:,i);
                ins_aic=log(in_res'*in_res)+2*(df+1)/(rw-df-2);  %regularized AICC              
                cum_aic=[cum_aic ins_aic];
            end
            [AIC min_AIC]=min(cum_aic);
            model=find(cummod(:,min_AIC));
            b=beta_ridge(:,min_AIC);
    end
    % closes prcflag