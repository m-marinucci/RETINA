function[rsq]=rsq2(corrw,vx);
% This function computes the r2 function by sweeping

    c=corrw(vx,vx);
    rowsc=rows(c);
    list=1:rowsc;
for i=1:(rowsc-1);
    c=sweep(list(i),c);
end
    rsq=1-c(rowsc,rowsc);

