%% Template for using the EEG analysis.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Experiment: Estimation Rayleight (J).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2019 Signal Processing and Recognition Group.
% Universidad Nacional de Colombia.
% L.F. Velasquez-Martinez
% F.Y. Zapata-Castaño.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('data\DI\cvNEW.mat') % Train
SUBJECTS_DIR = 'data\DI\';
addpath(genpath('functions'))

%% DataBase
COHORT   = 'BCICIV_2a_';
SUBJECTS = dir([SUBJECTS_DIR filesep '*' COHORT '*']);
SUBJECTS = struct2cell(SUBJECTS);
SUBJECTS = SUBJECTS(1,:)';

%% Paramaters definition
% Lasso parameters
param = linspace(0,0.9,100);
experiment_name = mfilename;

%% Filter bank
f_low  = 4; f_high = 40;
Window = 4; Ovrlap = 2;
filter_bank = [f_low:Ovrlap:f_high-Window;f_low+Window:Ovrlap:f_high]';
orden_filter = 5;
labels = [1 2];
% definitions
SS    = 8;
nfold = 5;
Xa    = cell(size(filter_bank,1),1);
Wfolds= cell(1, nfold);
j     = cell(1,9);
poverlapp = 0.9;
tfin  = 7;
w     = [2,1.5,1,0.5]; % size of windows in Rayleight.

%% Rayleight.
for w_tao = w
    for s = SS
        load([SUBJECTS_DIR filesep SUBJECTS{s} filesep 'eeg' filesep 'raw.mat'])
        y = y(:);
        ind = ismember(y,labels);
        y = y(ind); X = X(ind);
        X = cellfun(@(x) double(x),X,'UniformOutput',false);
        tic
        twin = w_tao*fs; %------------ time segment
        ovlpt = round(poverlapp*twin);
        tseg = 1:twin-ovlpt:(tfin*fs)-twin; 
        jfold = zeros(17,numel(tseg),nfold);
        facc = zeros(numel(tseg),numel(param),nfold); 
        fks = zeros(numel(tseg),numel(param),nfold); 
        u_fold = cell(1,nfold);        
        for fold = 1:nfold
            tr_ind   = c{s,fold}.training; tr_ind = tr_ind(ind);
            ts_ind   = c{s,fold}.test; ts_ind = ts_ind(ind);
            [F,T] = ndgrid(filter_bank(:,1),tseg);
            jtmp = zeros(size(F));
            u_v = cell(1,numel(tseg));
            acc = nan(numel(tseg),numel(param));
            ks = nan(numel(tseg),numel(param));
            Wall = cell(size(F));
            %% Rayleight computation
            y_ = y(tr_ind);
            F_ = numel(F);
            parfor ii = 1 :numel(F)
                Xa = fncFilbank(X,[F(ii),F(ii)+4],T(ii),T(ii)+twin-1,fs);
                fprintf(['Rayleight. Sub:' num2str(s) ' - w: ' num2str(ii) ' of ' num2str(F_) '\n ']) 
                C = cell2mat(reshape(cellfun(@(x)(cov(x)/...
                    trace(cov(x))),Xa{1},'UniformOutput',false),[1 1 numel(Xa{1})]));
                W = csp_feats(C(:,:,tr_ind),y_,'train','Q',11);
                Wall{ii} = W; W = W(1:6,:);
                ind1 = y==1; ind1 = ind1 & tr_ind;
                ind2 = y==2; ind2 = ind2 & tr_ind;
                C1 = mean(C(:,:,ind1),3);
                C2 = mean(C(:,:,ind2),3);
                %--- Rayleight quotient
                nc = (diag(W*C1*W')/trace(W*C1*W'));
                dc = (diag(W*(C1+C2)*W')/trace(W*(C1+C2)*W'));                
                jtmp(ii) = (mean(nc(1:3)))/(mean(dc(1:3)));
            end
            jfold(:,:,fold) = jtmp;
            fprintf(['Fold ' num2str(fold) '... Sub:' num2str(s)  '\n '])
            clear jtmp C            
            %% Accuracy by window
            t_seg = numel(tseg);
            parfor v = 1 :numel(tseg)
                %% FilterBank
                C = cell(1,size(filter_bank,1));
                for b = 1:size(filter_bank,1)
                    temp = fcnfiltband(X, fs, filter_bank(b,:), 5);
                    temp = cellfun(@(x) cov(x(tseg(v):tseg(v)+twin-1,:)),temp,'UniformOutput',false);
                    temp = cellfun(@(x)(x/trace(x)),temp,'UniformOutput',false);
                    C{b} = cell2mat(reshape(temp,[1 1 numel(temp)]));
                end
                %% CSP - LASSO
                Xc = cell(1,size(filter_bank,1));
                for b=1:size(filter_bank,1)
                    W = csp_feats(C{b}(:,:,tr_ind),y_,'train','Q',3);
                    Xc{b} = csp_feats(C{b},W,'test');
                end
                Xf = cell2mat(Xc);
                [acc(v,:),ks(v,:),u_v{v}] = fncLassoTunning(Xf,y,tr_ind,ts_ind,param);          
                fprintf(['Acc window ' num2str(v) '... of ' num2str(t_seg)  '\n '])                
            end % window
            facc(:,:,fold) = acc;
            fks(:,:,fold) = ks;
            u_fold{fold} = u_v;
            Wfolds{fold} = Wall;
            fprintf(['Fold ' num2str(fold) '... of ' num2str(nfold)   '\n '])
        end % end fold
        toc
        fprintf(['Fold ' num2str(fold) '... Done \n '])
        macc = squeeze(mean(facc,3));    % mean acc
        mstd = squeeze(std(facc,[],3));  % std acc
        mmacc = zeros(2,numel(tseg));    % acc by each window
        indAcc = zeros(1,numel(tseg));
        for v = 1:numel(tseg)
            [mmacc(1,v),indAcc(v)] = max(macc(v,:));
            mmacc(2,v) = mstd(v,indAcc(v));
        end        
        mks = squeeze(mean(fks,3));      % mean acc
        mksstd = squeeze(std(fks,[],3)); % std acc
        mmks = zeros(2,numel(tseg));     % acc by each window
        indKs = zeros(1,numel(tseg));
        for v = 1:numel(tseg)
            [mmks(1,v),indKs(v)] = max(mks(v,:));
            mmks(2,v) = mksstd(v,indKs(v));
        end
        
        %% J computation
        j{s} = jfold; 
        %Normalization
        jmean = mean(jfold,3); 
        m = 1/(max(max(jmean))-min(min(jmean)));
        tmp = jmean.*m;
        j_mean = tmp+(1-(1/(max(max(jmean))-min(min(jmean))))*(max(max(jmean))));    
          
        %% Saving results
        save([SUBJECTS_DIR filesep SUBJECTS{s} filesep 'results' filesep ...
            filesep experiment_name '_w' num2str((twin/fs)*1000) 'msec'],...
            'jfold','j_mean','mmacc','mmks','u_fold','Wfolds');
    end
end

