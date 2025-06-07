function[bin_mod]=evamod(y2,y3,x2,x3,candidate,rho);
% This function performs StageII of the RETINA algorithm described at page
% 826 of PAGW. Candidate is the model considered so far.
% rho is the correlations vector with the response.
% 'bin_mod' delivers a logical vector corresponding to the model with the best
% performance measure. 


n2=length(y2);
n3=length(y3);
cum_aic=[];

       for c_stg3=1:size(candidate,1);       % iterate construction for each sub model
                b=[ones(n2,1) x2(:,rho(1:c_stg3))]\y2;
                r_stg3 = [ones(n3,1) x3(:,rho(1:c_stg3))]*b-y3;                 
                rss=r_stg3'*r_stg3;
                
                % Out of sample Aic in subsample 3
                [aic_stg3]=aicc(rss,n3,length(b));
                cum_aic =[cum_aic;aic_stg3];
        end;     
        % We choose the model with the lowest hold-out AIC 
        % in the third subsample
        
        [minaic wcum_aic]=min(cum_aic);
        model=rho(1:wcum_aic); 
        bin_mod=zeros(size(x2,2),1);
        bin_mod(model)=ones(size(model,1),1);

