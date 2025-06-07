function[rndidx] = datasubsets(pvec,N,flagg)
% This function defines the indexes of three disjoint subsamples selected
% uniformly from N according to a two dimensional weight vector pvec where
% the elements are the weights of the first and the secon subsamples
% respectively
% if flag = 1 then selection is scrambled if flag = 0 then selection is
% sequential (adequate for time series)

    if flagg == 0;
        idx1 = randsample(N,round(pvec(1)*N));
        idxr = setdiff((1:N)',idx1);
        idx2=randsample(idxr,floor((pvec(2)*N)/(N-round(pvec(1)*N))*...
            size(idxr,1)));
        idx3=setdiff((1:N)',[idx1;idx2]);
    else   
        idx1 = (1:N-round(sum(pvec)*N))';
        idx2 = (max(idx1)+1:N-round(pvec(2)*N))';
        idx3 = (max(idx2)+1:N)';
    end;


    rndidx= [[idx1 ones(rows(idx1),1)];...
        [idx2 ones(rows(idx2),1).*2];...
        [idx3 ones(rows(idx3),1).*3]];
    rndidx=sortrows(rndidx,1);
    rndidx=rndidx(:,2);
