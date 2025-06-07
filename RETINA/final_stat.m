function[RSS,R2,rmse,mae,mre,res,S,pvalue]=final_stat(y,x,b)
% This function delivers the final statistics given the betas.
% recall coeffs has the constant in the last column
n=rows(y);
rb=cols(b);

x= [x ones(n,1)];

for i=1:rb
    yhat(:,i)=x*b(:,i);
    res(:,i)=y-yhat(:,i);
    RSS(i)=res(:,i)'*res(:,i);
    R2(i)=1-RSS(i)/(cov(y)*n);
    rmse(i)=sqrt(RSS(i)/n);
    mae(i)=mean(abs(res(:,i)));
    mre(i)=mean(res(:,i)./y);
end



% Here build the test statistic for Harvey, Leybourne and Newbold (1997).

for i=1:rb
    for j=1:i
        u_1= res(:,i)-res(:,j);
        u_2= res(:,i)+res(:,j);
        bhat=u_1\u_2;
        ehat=u_2-u_1*bhat;
        num=sum(u_1.^2 .* ehat.^2);
        den=sum(u_1.^2)^2;
        S(i,j)=bhat * sqrt(den ./ num);
        if isnan(S(i,j))
            S(i,j)=0;
        end
        pvalue(i,j)=(1-tcdf(abs(S(i,j)),n-1))*2;
    end
end



