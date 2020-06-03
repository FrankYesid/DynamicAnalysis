
function [D] = fncChannelEudist(X,Y)
D = nan(size(X,1),1);

for i = 1:size(X,1)
     D(i) = norm(X(i,:)-Y(i,:));% entre más grande más diferentes        
end
