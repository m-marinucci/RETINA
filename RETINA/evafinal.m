function[b,model]=evafinal(y,w, cummod)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here we evaluate the performance over the whole sample and consider a
% winner model, we need to compute a winner
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rw=rows(w);
cnst=ones(rw,1);
cum_aic=[];
for i=1:cols(cummod)
    indexes=find(cummod(:,i));
    b=[w(:,indexes) cnst]\y;
    in_res=y-[w(:,indexes) cnst]*b;
    insSS=in_res'*in_res;
    [aic]=aicc(insSS,rw,length(b));
    cum_aic=[cum_aic aic];
end

[aic minaic]=min(cum_aic);
model=find(cummod(:,minaic));
b=betavec(y,w,model);