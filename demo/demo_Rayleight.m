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
warning off
%% Load data of Rayleight
load Rel_based_J_1sec.mat % BCI_competition IV dataset 2a

%% parameters
% 
database = 2;
type = 4;
tex = 0;
load('electrodesBCICIV2a.mat') 
load('HeadModel.mat')          % model of the head.
t_e = 15;                      % size electrodes.
M1.xy = elec_pos;              % position of channels.
M1.lab = Channels;             % names of channels.
sel = 1:22;

%% Normalization
xd = cell2mat(pvt_sub);
mxd = max(xd(:));
mnxd = min(xd(:));
clear xd
%normlizado entre sujetos
X_tmp1 = cellfun(@(x) (x-mnxd)/(mxd-mnxd), pvt_sub, 'UniformOutput', 0 )';

Xtmp2 = cellfun(@(x) (x), X_tmp1, 'UniformOutput', 0 )';
xd = cell2mat(Xtmp2);
mxd = max(xd(:));
mnxd = min(xd(:));

X_tmp = cellfun(@(x) (x-mnxd)/(mxd-mnxd), Xtmp2, 'UniformOutput', 0 )';

for s = sS
    a = 1;
    for fr = [3,7,9,11]
        for v = [6 15 28 37 60] 
            figure;
            set(gcf,'position',[667   128   404   420])
            x1 = 0.02;     y1 = 0.06;     w = 0.95;      h = 0.92;
            subplot('position',[x1,y1,w,h]);
            fnc_MyTopo22(squeeze(X_tmp{s}(:,v,fr)),sel,M1.xy,M1.lab,[0,mmx(a)],1,t_e,database,HeadModel,type,tex,colormap('parula'));
            saveas(gca,['D:\toop\' ...
                'head_S' num2str(s) '_fr' num2str(fr)  '_v' num2str(v) ...
                '_w' num2str(2000) 'msec'],'epsc')
            saveas(gca,['D:\toop\' ...
                'head_S' num2str(s) '_fr' num2str(fr)  '_v' num2str(v) ...
                '_w' num2str(2000) 'msec'],'png')
            close
        end
        a = a+1;
    end
end
