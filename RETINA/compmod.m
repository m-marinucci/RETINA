function[cand_check0,dup_ind]=compmod(cum_candidate,candidate);
% This function establishes if two models are the same or not
% the cum_candidate  is a matrix where each column includes a model
% candidate is a vector which we want to test against cum_candidate
% If no duplicates  cand_check0  will be zero   

if ~isempty(cum_candidate);
    cand_check1=sum((repmat(candidate,1,size(cum_candidate,2)) == cum_candidate),1);
    cand_check0=(cand_check1 == length(candidate));
    dup_ind=find(cand_check0);
    cand_check0=sum(cand_check0,2);
else
    cand_check0=0;
    dup_ind=[];
end