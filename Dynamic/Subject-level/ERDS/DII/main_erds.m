%% Template for using the EEG analysis.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Experiment: Estimation ERDs.
% ERD: evente-related desynchronization/synchronization.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2019 Signal Processing and Recognition Group.
% Universidad Nacional de Colombia.
% L.F. Velasquez-Martinez
% F.Y. Zapata-Castaño.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note: run BIOSIG for functions of load dataset.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc %
warning off
%% Load data
% name of database
name = 'GigaScience';
% Path database
path_name = 'data\';
% format of data.
data = '.mat'; % download in Gigascience.
%% Parameters
%% ------------- Filter bank -------------
f_low  = 4;    % frecuency minimal.
f_high = 40;   % frecuency maxim.
f_bandwidths = 4;    % bandwith.
Ovrlap = 2;    % overlape.
filter_bank = [f_low:Ovrlap:f_high-f_bandwidths;...
    f_low+f_bandwidths:Ovrlap:f_high]';

%% ------------- ERDs -----------------
lambda = 0;
alpha  = 0.01;     % alpha of significance in ERDs.
t      = [0, 0, 7];% Start point, time resolution and end point within a trial (in s)
% <1x3>. If the second value is 0, the time resolution corresponds to 1/fs.
ref    = [1.5,2];% reference of estimation ERDs.
cue    = 2;        % cue of dataset.
%%  Database - Gigascience.
SS     = [1:28,30:33,35:52]; % Numer of Subjects in
Class_ = 1:2; % Select classes of database. (1- hand left), (2- hand right).
%%
fprintf(['Quantification ERD/ERS','\n'])
for ss = SS
    erd_sin = cell(1,numel(Class_));
    erd_con =cell(1,numel(Class_));
    indx = [];
    if ss < 10
        load([path_name filesep 's0' num2str(ss),data])
    else
        load([path_name filesep 's' num2str(ss),data])
    end
    for clas = Class_
        tic
        classes = [1 2 3 4];    % [] ... All classes - Clases para los indices.
        method = 'bp';          % 'bp' or 'fft'.
        refmethod = 'classic';  % 'classic' or 'trial'.
        % Load data.
        if clas == 1
            S = double(eeg.imagery_left');  % Class hand left.
        elseif clas == 2
            S = double(eeg.imagery_right'); % Class hand right.
        end
        S(isnan(S)) = 0;    % is NAN in zeros.
        % Montage of channels.
        montage = '64ch';   % channels distribution standar.
        channels = 1:64;    % numer of channels.
        % Output parameters:
        %   lap        ... Laplacian filter matrix.
        %   plot_index ... Indices for plotting the montage.
        %   n_rows     ... Number of rows of the montage.
        %   n_cols     ... Number of columns of the montage.
        [lap, plot_index, n_rows, n_cols] = getMontage(montage);
        mont = plot_index;  
        % Laplacian Filter.
        s = S(:,channels)*lap;
        % Trials - Artifacts.
        bad_trails   = eeg.bad_trial_indices.bad_trial_idx_mi{clas};
        h.Classlabel = ones(numel(find(eeg.imagery_event==1)),1)*clas;
        h.TRIG       = find(eeg.imagery_event==1)';
        indd            = h.Classlabel; indd(bad_trails) = 0;
        indx_          = zeros(numel(find(eeg.imagery_event==1)),1);
        indx = indd & indx_;
        fs = eeg.srate;
        for r = runs
            indx = ismember(h.Classlabel,[1 2]) & ismember(ve_run(indd),r);
            indx_{s,clas} = sum(indx);
            %% Quantification ERD/ERS.
            erd_sin{clas}{r} = calcErdsMap(indx,s, h, t, [filter_bank(1,1)+2, filter_bank(end,1)+2],...
                'method', method, 'class', clas, 'ref', ref,'f_bandwidths', f_bandwidths, ...
                'f_steps', Ovrlap, 'sig', 'boxcox', 'lambda', lambda,'alpha', alpha, 'heading', name,...
                'montage', mont, 'cue', cue,'refmethod', refmethod, 'submean', true);
            erd_sin{clas}.heading = ['Subject: ' num2str(ss)];
            %% Quantification ERD/ERS with significance.
            erd_con{clas}{r} = plotErdsMap2(erd_sin{clas}{r},ss,clas,channels);
            fprintf('Subject ')
        end
    end
    %%
    fprintf(['Quantification Event-related Desynchronization Subject: ',num2str(ss),'Type: ',name1,' in ',name,'\n'])
    ERDs_con = cell (1,numel(Class_));
    ERDs_sin = cell (1,numel(Class_));
    for cl = Class_
        for ch = channels
            ERDs_con{cl}{ch} = erd_con{fold}{cl}.ERDS{ch}.erds;
        end
    end
    for cl = Class_
        for ch = channels
            ERDs_sin{cl}{ch} = erd_sin{fold}{cl}.ERDS{ch}.erds;
        end
    end
    save(['ERD_sub' num2str(ss) nam 'class.mat'],'ERDs_con','ERDs_sin')
    clear erd_sin erd_con indd
end
