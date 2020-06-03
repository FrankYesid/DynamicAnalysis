
function Xdr = fncCutdata(Xd_,tini,tfin,fs) 

%% recortar 
ini = tini*fs;%0.1*fs;
fin = tfin*fs;
Xdr = cell(1,length(Xd_));
for i = 1:length(Xd_)
    Xf_ = Xd_{i};
    for k = 1:length(Xf_)
        [samples,~] = size(Xf_{k});
        lags = 1:samples;  
        pos = find(lags<fin+1 & lags>ini);
        Xdr{i}{k} = Xf_{k}(pos,:);  
    end
end