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
name = 'BCICIV_2a';
% Path database 
path_name = 'K:\Database\BCI Competition\BCICIV_2a\Training\A0';
% format of data.
data = '.gdf'; % download in BCI competition IV.
%% Parameters
Nfolds = 1;    % Numer of folds

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
ref    = [0.5,1.5];% reference of estimation ERDs.
cue    = 2;        % cue of dataset.
%%  BCI Competition IV dataset 2a.
SS     = 1:9; % Numer of Subjects in
Class_ = 1:2; % Select classes of database. (1- hand left), (2- hand right). 
%%
for ss = SS
    erd_sin = cell(1,numel(Class_));
    erd_con =cell(1,numel(Class_));
    indx = [];
    for clas = Class_
        tic
        classes = [1 2 3 4];    % [] ... All classes - Clases para los indices.
        method = 'bp';          % 'bp' or 'fft'.
        refmethod = 'classic';  % 'classic' or 'trial'.
        % Load data.
        channel = 0;            % 0 ... All channels
        [S, h] = sload([path_name num2str(ss) 'T' data], channel, 'OVERFLOWDETECTION:OFF');
        S(isnan(S)) = 0;        % is NAN in zeros.
        % Montage of channels.
        montage = '22ch';       % channels distribution standar.
        channels = 1:22;        % numer of channels.
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
        indd = h.ArtifactSelection==0 & ismember(h.Classlabel, classes);
        h.Classlabel = h.Classlabel(indd);
        h.TRIG = h.TRIG(indd);
        fs = h.SampleRate;
        indx = ismember(h.Classlabel,[1 2]) & ismember(ve_run(indd),r);
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
    %%
    fprintf(['Quantification Event-related Desynchronization Subject: ',num2str(ss),'Type: ',name1,' in ',name,'\n'])
    ERDs_con = cell (1,Nfolds);
    ERDs_sin = cell (1,Nfolds);
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
    save(['Result\ERD_sub' num2str(ss) nam 'class.mat'],'ERDs_con','ERDs_sin')
    clear erd_sin erd_con indd
end
