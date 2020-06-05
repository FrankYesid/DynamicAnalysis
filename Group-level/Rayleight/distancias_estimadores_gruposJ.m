clear all
close all

%set(0,'DefaultFigureWindowStyle','normal')

%%
data = 'Giga'; % BCI2a Giga
method = 'J';
ch = [8,12]; 
%%
load(['Results\' data '\' method '\best_Resultados_Grupos'])
[nfeat,nch,ngroup] = size(Xga_{1});
ng = 2:ngroup; ng = flip(ng);
if strcmp(data,'BCI2a')
    load('means_std_2a_5.mat')
    sub = [8,3,1,9,7,5,4,6,2];
    %
elseif strcmp(data,'Giga')
    load('Means_giga_mayo.mat')
    bs = S1(1:23);
end
posf = 1;
x1 = 0.2;     y1 = 0.2;     w = 0.78;      h = 0.75;

for fr = 3%[3,7,9,11]
    pos = 1;
    for i = ng
        group_features(pos,:) = Xga_{1}(fr,ch,i);
        pos = pos + 1;
    end
    
    dist_group = abs(pdist2(group_features,group_features));
    dist_group = dist_group/max(dist_group(:));
    %subplot(1,5,posf)
    figure
    set(gcf,'position',[267   228   404   420])
    
    subplot('position',[x1,y1,w,h]);
    fig = imagesc(1-dist_group); %clorbar();
    if strcmp(data,'BCI2a')
        set(gca,'XTick',1:numel(ng),'XTickLabel',ng,'YTick',1:numel(ng),'YTickLabel',ng)
    elseif strcmp(data,'Giga')
        set(gca,'XTick',1:4:22,'XTickLabel',ng(1:4:22)-1,'YTick',1:4:22,'YTickLabel',ng(1:4:22)-1)
    end
    if fr == 3 
        %set(gca,'XTick',1:numel(bs),'XTickLabel',bs,'YTick',1:numel(bs),'YTickLabel',bs)
        xticks([])
        %title(['freq' num2str(fr)])
        fig.Parent.TickLabelInterpreter = 'latex';
        fig.Parent.FontSize = 40;
    else;  xticks([]); yticks([]);
    end
    %title(['freq ' num2str(fr)]);
    posf = posf + 1;
    clear group_features
    saveas(gca,['D:\Dropbox\02 Dynamic Modeling\Correctedversion\figure\'...
        method '\Distances_group\' data '\Dist_group_' ...
        'fr' num2str(fr)],'epsc')
    
    %% scatter
    acc = means(1:ngroup,3)';
%     mean_acc = zeros(1,numel(ng));
%     for i=ng
%         mean_acc(i) = mean(acc(1:i));
%     end
%     mean_acc = flip(mean_acc);
    
    %%
    
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
%     for i = 1:10
%         label = ['G' num2str(pos1(i)) '-' num2str(pos2(i))];
%         text(tmp_(i),g_acc(i)+0.2,label,'FontSize',16,'HorizontalAlignment','left' ,'Interpreter', 'latex')
%     end
    ylim([92.5,100])
    xlim([0,1])
    %title(['freq ' num2str(fr)]);
    if fr == 3
        fig.Parent.TickLabelInterpreter = 'latex';
        fig.Parent.FontSize = 35;
    else; yticks([])
        fig.Parent.TickLabelInterpreter = 'latex';
        fig.Parent.FontSize = 35;
    end
    saveas(gca,['E:\Dropbox\02 Dynamic Modeling\Correctedversion\figure\'...
        method '\Distances_group\' data '\scatter_group_' ...
        'fr' num2str(fr)],'epsc')
end

close all
%% concatenada
fr = [7,9,11];
pos = 1;
for i = ng
    tmp = Xga_{1}(fr,ch,i);
    group_features(pos,:) = tmp(:);
    pos = pos + 1;
end

dist_group = abs(pdist2(group_features,group_features));
dist_group = dist_group/max(dist_group(:));
figure
set(gcf,'position',[267   528   404   420])

subplot('position',[x1,y1,w,h]);
fig = imagesc(1-dist_group); %clorbar();

set(gca,'XTick',1:numel(ng),'XTickLabel',ng,'YTick',1:numel(ng),'YTickLabel',ng)
%title(['freq ' num2str(fr)]);
% fig.Parent.TickLabelInterpreter = 'latex';
% fig.Parent.FontSize = 35;
xticks([]);yticks([])
saveas(gca,['E:\Dropbox\02 Dynamic Modeling\Correctedversion\figure\'...
    method '\Distances_group\' data '\Dist_group_' ...
    'concfr'],'epsc')

%% scatter clusterings
 pos =1;
    tmp = (1-dist_group);
    for f =1:numel(ng)-1
        for ff= 2+f-1:numel(ng)
            tmp_(pos) = tmp(f,ff);
            pos =pos +1;
        end
    end

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

figure
set(gcf,'position',[267   528   404   420])

subplot('position',[x1,y1,w,h]);
fig = plot(tmp_,g_acc,'b.','MarkerSize',20);
%     for i = 1:10
%         label = ['G' num2str(pos1(i)) '-' num2str(pos2(i))];
%         text(tmp_(i),g_acc(i)+0.2,label,'FontSize',16,'HorizontalAlignment','left' ,'Interpreter', 'latex')
%     end
ylim([92.5,100])
xlim([0,1])
%title(['freq ' num2str(fr)]);
yticks([])
fig.Parent.TickLabelInterpreter = 'latex';
fig.Parent.FontSize = 35;

saveas(gca,['E:\Dropbox\02 Dynamic Modeling\Correctedversion\figure\'...
    method '\Distances_group\' data '\scatter_group_' ...
    'concfr'],'epsc')

close  all

