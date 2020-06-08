%% Template for using the EEG analysis.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Experiment: Group - Connectivity (wPLI).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020 Signal Processing and Recognition Group.
% Universidad Nacional de Colombia.
% L.F. Velasquez-Martinez
% F.Y. Zapata-Castaño.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data   = 'DI';      % DI = BCI2a, DII = Giga
method = 'Connectivity'; % Connectivity wPLI
if strcmp(data,'DI')
    ch = [8,12];    % channels C3 an C4.
elseif strcmp(data,'DII')
    ch = [13,50];   % channels C3 an C4.
end
freqs = [3,7,9,11]; % frecuencias 
% load results group
load(['data' filesep data filesep 'results' filesep 'best_Resultados_Grupos'])
[nfeat,nch,ngroup] = size(Xga_);
ng = 2:ngroup; ng = flip(ng);
if strcmp(data,'BCI2a')
    load('means_std_2a_5.mat')
    sub = [8,3,1,9,7,5,4,6,2];
elseif strcmp(data,'Giga')
    load('Means_giga_mayo.mat')
    bs = S1(1:23);
end
posf = 1;
group_features = zeros(numel(freqs),size(ng));

%% estimation groups
for fr = freqs
    pos = 1;
    for i = ng
        group_features(pos,:) = Xga_(fr,ch,i);
        pos = pos + 1;
    end
    
    dist_group = abs(pdist2(group_features,group_features));
    dist_group = dist_group/max(dist_group(:));
    figure
    fig = imagesc(1-dist_group);
    if strcmp(data,'DI')
        set(gca,'XTick',1:numel(ng),'XTickLabel',ng,'YTick',1:numel(ng),'YTickLabel',ng)
    elseif strcmp(data,'DII')
        set(gca,'XTick',1:4:22,'XTickLabel',ng(1:4:22)-1,'YTick',1:4:22,'YTickLabel',ng(1:4:22)-1)
    end
    if fr == 3
        xticks([])
        fig.Parent.TickLabelInterpreter = 'latex';
        fig.Parent.FontSize = 40;
    else;  xticks([]); yticks([]);
    end
    posf = posf + 1;
    clear group_features
    
    %% scatter
    acc = means(1:ngroup,3)';    
    pos =1;
    tmp = (1-dist_group);    
    tmp_= zeros(numel(ng)-1+numel(ng),1);
    for f =1:numel(ng)-1
        for ff= 2+f-1:numel(ng)
            tmp_(pos) = tmp(f,ff);
            pos =pos +1;
        end
    end
    
    %% scatter clusterings
    pos1 = []; pos2 = [];
    pos=numel(ng)-1;
    for i = 1:pos
        pos1 = [pos1, ng(i)*ones(1,pos)];
        pos = pos-1;
        pos2 = [pos2, flip(ng(end):ng(i)-1)];
    end
    g_acc = zeros(numel(tmp_),1);    
    for i= 1:numel(tmp_)
        g_acc(i) = mean([acc(1:pos1(i)),acc(1:pos2(i))]);
    end
    figure
    fig = plot(tmp_,g_acc,'b.','MarkerSize',20);
    ylim([92.5,100])
    xlim([0,1])
    if fr == 3
        fig.Parent.TickLabelInterpreter = 'latex';
        fig.Parent.FontSize = 35;
    else; yticks([])
        fig.Parent.TickLabelInterpreter = 'latex';
        fig.Parent.FontSize = 35;
    end
end