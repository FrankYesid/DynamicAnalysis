%% Template for using the EEG analysis.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Experiment: Visualization - topotplots ERDs.
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
warning off




























%% Load data of Rayleight
load Rel_based_J_1sec.mat % BCI_competition IV dataset 2a

%% parameters toppoplot
database = 2;
type = 4;
tex = 0;
load('electrodesBCICIV2a.mat') 
load('HeadModel.mat')          % model of the head.
t_e = 15;                      % size electrodes.
M1.xy = elec_pos;              % position of channels.
M1.lab = Channels;             % names of channels.
sel = 1:22;

%% Normalization of data
mxd = max(cell2mat(cellfun(@(x) max(x),pvt_sub,'UniformOutput',false)));
mnxd= min(cell2mat(cellfun(@(x) min(x),pvt_sub,'UniformOutput',false)));
% normlizado entre sujetos
X_tmp = cellfun(@(x) (x-mnxd)/(mxd-mnxd), pvt_sub, 'UniformOutput', 0 )';
%% Visualization}
SS = 8; % subject.
freq  = [3,7,9,11];
window= [6 15 28 37 60];
mmx = [0.6 0.33 0.33 0.5]; % threshold.
for s = SS
    a = 1;
    for fr = freq
        for v = window
            figure;
            fnc_MyTopo22(squeeze(X_tmp{s}(:,v,fr)),sel,M1.xy,M1.lab,[0,mmx(a)],1,t_e,database,HeadModel,type,tex,colormap('parula'));
        end
        a = a+1;
    end
end
