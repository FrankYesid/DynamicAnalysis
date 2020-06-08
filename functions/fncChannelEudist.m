function [D] = fncChannelEudist(X,Y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2019 Signal Processing and Recognition Group.
% Universidad Nacional de Colombia.
% L.F. Velasquez-Martinez
% F.Y. Zapata-Casta�o.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

D = nan(size(X,1),1);

for i = 1:size(X,1)
     D(i) = norm(X(i,:)-Y(i,:));% entre m�s grande m�s diferentes        
end
