
function [D] = fncChannelEudist(X,Y)
D = nan(size(X,1),1);

for i = 1:size(X,1)
     D(i) = norm(X(i,:)-Y(i,:));% entre m�s grande m�s diferentes        
end
