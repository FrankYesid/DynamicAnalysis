%% Template for using the EEG analysis.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Experiment: Group .
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2019 Signal Processing and Recognition Group.
% Universidad Nacional de Colombia.
% L.F. Velasquez-Martinez
% F.Y. Zapata-Castaño.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = 'DI';     % DI = BCI2a, DII = Giga
method = 'ERD';
if strcmp(data,'DI')
    ch = [8,12]; % channels C3 an C4.
elseif strcmp(data,'DII')
    ch = [13,50];% channels C3 an C4.
end
load(['data' filesep data filesep 'results' filesep 'best_Resultados_Grupos'])
if strcmp(data,'BCI2a')
    [nfeat,nch,ngroup] = size(Xga_{1});
elseif strcmp(data,'Giga')
    [nfeat,nch,ngroup] = size(Xga_{1}(:,:,1:23));
end
ng = 2:ngroup; ng = flip(ng);
if strcmp(data,'BCI2a')
    load('means_std_2a_5.mat')
    sub = [8,3,1,9,7,5,4,6,2];
elseif strcmp(data,'Giga')
    load('Means_giga_mayo.mat')
    bs = S1(1:23); 
end
posf = 1;

for fr = [3,7,9,11]
    pos = 1;
    for i = ng
        group_features(pos,:) = Xga_{1}(fr,ch,i);
        pos = pos + 1;
    end    
    dist_group = abs(pdist2(group_features,group_features));
    dist_group = dist_group/max(dist_group(:))   figure
    set(gcf,'position',[267   228   404   420])
    
    subplot('position',[x1,y1,w,h]);
    fig = imagesc(1-dist_group); 
    if strcmp(data,'BCI2a')
        set(gca,'XTick',1:numel(ng),'XTickLabel',ng,'YTick',1:numel(ng),'YTickLabel',ng)
    elseif strcmp(data,'Giga')
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
    for i= 1:numel(tmp_)
        g_acc(i) = mean([acc(1:pos1(i)),acc(1:pos2(i))]);
    end
    %%
    figure
    set(gcf,'position',[267   528   404   420])
    
    subplot('position',[x1,y1,w,h]);
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
    saveas(gca,['D:\Dropbox\02 Dynamic Modeling\Correctedversion\figure\'...
        method '\Distances_group\' data '\scatter_group_' ...
        'fr' num2str(fr)],'epsc')
end