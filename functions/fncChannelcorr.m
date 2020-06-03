
function [RP] = fncChannelcorr(X,Y)
R = nan(size(X,1),1);
P = nan(size(X,1),1);
for i = 1:size(X,1)
     [tmpR,tmpP] = corrcoef(X(i,:),Y(i,:));
     R(i) = tmpR(1,2);
     P(i) = tmpP(1,2);    %entre más pequeño más diferentes
end
RP{1} = R;
RP{2} = P;