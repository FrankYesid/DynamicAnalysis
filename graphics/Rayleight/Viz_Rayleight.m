%% Visualization: the accuracy evolution over the interval of neural activation
% Rayleight
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2019 Signal Processing and Recognition Group.
% Universidad Nacional de Colombia.
% L.F. Velasquez-Martinez
% F.Y. Zapata-Castaño.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc; close all
%% Path
SUBJECTS_DIR = 'data\DI';
COHORT = 'BCICIV_2a_'; 
SUBJECTS = dir([SUBJECTS_DIR filesep '*' COHORT '*']);
SUBJECTS = struct2cell(SUBJECTS);
SUBJECTS = SUBJECTS(1,:)';

%% Subjects
SS = 8;

%% Paramaters definition
% Lasso parameters
param = linspace(0,0.9,100);
%% Filter bank
f_low  = 4; f_high = 40;
Window = 4; Ovrlap = 2;
filter_bank = [f_low:Ovrlap:f_high-Window;f_low+Window:Ovrlap:f_high]';
orden_filter = 5;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pruebas de J %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% definitions
labels = [1 2];
fs = 250;
nfold = 5;
experiment_name_5  = 'Main_Rayleight2_2';
load('Max_min_bci_2a.mat','max_','min_')
Xa = cell(size(filter_bank,1),1);
Wfolds = cell(1, nfold);
j = cell(1,9);
poverlapp = 0.9;
tfin = 7;

for w_tao = [2,1.5,1,0.5]
    twin = w_tao*fs; %------------ time segment
    ovlpt = round(poverlapp*twin);
    tseg = 1:twin-ovlpt:(tfin*fs)-twin;
    jfold = zeros(17,numel(tseg),nfold);
    facc = zeros(numel(tseg),numel(param),nfold);
    fks = zeros(numel(tseg),numel(param),nfold);
    u_fold = cell(1,nfold);
    pos_s = 1;
    for s = SS
        %% BCI 2a  con 5 folds
        load([SUBJECTS_DIR filesep SUBJECTS{s} filesep ...
            experiment_name_5 '_w' num2str((twin/fs)*1000) 'msec_2'])
        ast =  (tseg(2)-tseg(1))/fs;
        %% Gráfica de acierto y relevancia de frecuencia
        set(gcf,'position',[467   528   704   400])
        x = 0.06;     y1 = 0.25;     w = 0.93;      h = 0.73; % w = 0.77;
        fig1=subplot('position',[x,y1,w,h]);
        jmean = mean(jfold,3);
        max_j = max(jmean(:));
        min_j = min(jmean(:));
        imagesc((tseg./fs),1:17,jmean,[1.0211,1.1262]); axis xy;
        xticks([])
        set(gca,'TickLabelInterpreter','latex')
        fig = gca; fig.FontSize = 20;
        if w_tao == 2
            yticks(1:2:size(filter_bank,1));
            yticklabels({num2str(filter_bank(1:2:17,2)-2)})
        else
            yticks([])
        end
        set(gca,'TickLabelInterpreter','latex')
        % marginal en el eje y
        x_m2 = x+w+0.003+0.01; y_3 = y1;
        w_m2 = 0.08; h_m2 = h;
        % plot acc y kappa
        subplot('position',[x,y1-0.24,w,0.2]);
        plot([2.5, 2.5], [0, 100])
        indMI = tseg/fs>2.5;
        [Accm,Im] = max(mmacc(1,indMI));
        stdm = mmacc(2,indMI);
        if isnan(stdm(Im))
            stdm(Im) = 0;
        end
        hold on
        inBetween = [[40.5, 100], [100, 40.5]];
        fill([[-0.1, -0.1],[2.5, 2.5]], inBetween, [244/255,244/255,244/255]);
        left_color = [006/255,057/255,113/255]; right_color = [034/255,113/255,179/255];
        errorbar((tseg./fs),mmacc(1,:).*100,mmacc(2,:).*100,'color',...
            [006/255,057/255,113/255],'LineWidth',1.2)
        ax = gca;
        ax.YColor = left_color;
        xlim([-0.1,tseg(end)/fs+ast/2])
        set(gca,'TickLabelInterpreter','latex')
        errorbar((tseg./fs),mmks(1,:),mmks(2,:),'color',...
            [034/255,113/255,179/255],'LineWidth',1.2); ylim([0,1]);
        ax.YColor = right_color;
        t_t = tseg(indMI);
        ylim([40,100,])
        xticks([])
        if w_tao ~= 2
            yticks([])
        end        
        pos_s = pos_s+1;
    end
end