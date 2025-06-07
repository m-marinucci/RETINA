function[allcand]=allcandidates(cummod)
% This function delivers the union model given a set of candidates obtained
% from each subset rotation. It adds the union model to the candidate model
% set only if it is not already containes in cummod.
% The argument is a logical matrix where each column is a model. Each
% element in each row correspond to the presence/absence of a particular
% regressor
         union_mod=(sum(cummod,2) > 0);
         [cand_check0,dup_ind]=compmod(cummod,union_mod);
         if cand_check0==0;
                allcand=[cummod union_mod];
         else
             allcand=cummod;
         end
