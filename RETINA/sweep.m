function[g]=sweep(z,c);
% This function performs the sweeping operation of column c on the square
% matrix z
pv = 1/c(z,z);             % step 1 @
g = c - c(:,z)*c(z,:)*pv;   % step 2 @
g(z,:) = c(z,:).*pv;         % step 3 @
g(:,z) = -c(:,z).*pv;        % step 4 @
g(z,z) = pv;                % step 5 @
