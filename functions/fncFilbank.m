function Xa = fncFilbank(X2tr,filter_bank,seg_start,seg_end,fs)
Xa = cell(size(filter_bank,1),1);
for b = 1:size(filter_bank,1)%Precompute all filters and trim
    Xa{b} = fcnfiltband(X2tr, fs, filter_bank(b,:), 5);
    Xa{b} = cellfun(@(x) x(seg_start:seg_end,:),Xa{b},'UniformOutput',false);
end
end