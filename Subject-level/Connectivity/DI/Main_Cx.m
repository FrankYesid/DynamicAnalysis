%% Template for using the EEG analysis.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Experiment: Estimation wPLI.
% wPLI:  weighted Phase Lag Index.
% Based on vink 2011 - fieldtrip toolbox.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2019 Signal Processing and Recognition Group.
% Universidad Nacional de Colombia.
% L.F. Velasquez-Martinez.
% F.Y. Zapata-Castaño.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note: run BIOSIG for functions of load dataset and fieldtrip for
% Connectivity.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc;
warning off
%% Path database
dir = 'K:\Database\BCI Competition\BCICIV_2a\Training\';
%% Path informaction: Position Electrodes.
dir_electrodes = 'info.mat';
%% Initial
SS         = 1:9;            % Subjects.
%% parameters
t          = [0,7];          % time interval for analysis.
classes    = [1 2 3 4];      % Dataset classes.
load(dir_electrodes,'channels','fs'); % loading labels of channels.
Mode_analysis = 'no-all';    % 'all' in all time, 'not-all' in windows.
tstar      = 0.5;            % time initial.
tend       = 7;              % time end.
twin       = 0.1;            % step of window. 0.04;
fmin       = 4;              % Minimal Frequency of analysis.
fsetp      = 2;              % Step of Frequency.
fmax       = 40;             % Maximal Frequency of analysis.
Ncycles    = 5;              % Cycles for Morlet-wavelet.
%% Connectivity WPLI.
for s = SS                   % By subject.
    wpli  = cell(1,2);
    for clas  = 1:2          % By class.
        fprintf(['Loading subject...  ' num2str(s) '... of ' num2str(size(SS,2))  '\n '])
        [data_,h] = sload([dir 'A0',num2str(s),'T.gdf'],'OVERFLOWDETECTION:OFF');
        data_(isnan(data_)) = 0;
        % para aplicar filtro laplaciano a los datos sin cambio de referencia.
        % Referenciation.
        montage   = '22ch';  % montaje de los canales que se van a utilizar.
        [lap, ~, ~, ~] = getMontage(montage);
        data_     =  data_(:,1:22)*lap;
        indd      = h.ArtifactSelection==0 & ismember(h.Classlabel, classes);
        indx      = ones(1,numel(h.TRIG(indd)))';
        h.Classlabel = h.Classlabel(indd);
        h.TRIG    = h.TRIG(indd);
        indx      = indx.*ismember(h.Classlabel,clas);        
        fs        = h.SampleRate;
        triallen  = round((t(2) - t(1)) * fs) + 1;  % Trial length (in samples)
        tmp       = trigg(data_, h.TRIG(ismember(h.Classlabel, classes) & indx), round(t(1)*fs), round(t(2)*fs));
        tmp1      = reshape(tmp, size(tmp,1),triallen, length(tmp)/triallen);  %
        data_trial= cell(1,size(tmp1,3));
        for trial = 1:size(tmp1,3)
            data_trial{1,trial} = tmp1(:,1:round(t(2)*fs) - round(t(1)*fs),trial);
        end
        %% data struct for fieldtrip
        % Load EEG
        data      = [];
        data.trial= data_trial;
        time      = t(1):1/fs:t(2)-(1/fs);      % Vector of the time.
        data.time = cellfun(@(X) time,data.trial,'UniformOutput',false);
        data.fsample    = fs;                   % Frecuency sample.
        data.label      = channels;             % canales seleccionados.
        data.trialinfo  = ones(size(data_trial,2),1)*clas; % class trial definition
        data.sampleinfo = [h.TRIG(logical(indx)),h.TRIG(logical(indx))+round(t(2)*fs) - round(t(1)*fs)-1];
        data.hdr.Fs     = fs;                   % Frecuency of sample.
        data.hdr.nChans = 22;                   % Numel channel.
        data.hdr.Samples     = round(t(2)*fs) - round(t(1)*fs);
        data.hdr.nSamplesPre = 0;
        data.hdr.nTrials     = size(tmp1,3);
        data.hdr.label       = channels;
        %% Time-freq descomposition
        fprintf(['Time-frequency subject...  ' num2str(s) '... of ' num2str(size(SS,2))  '\n '])
        cfg        = [];
        cfg.method = 'wavelet';   % options: 'mtmfft'    'wavelet' 'mtmconvol'
        cfg.output = 'powandcsd'; % options: 'powandcsd' 'fourier' 'pow'
        cfg.channel= 'all';
        cfg.keeptrials  = 'yes';
        cfg.width  = Ncycles;
        cfg.foi    = fmin:fsetp:fmax; % analysis f_min to f_max Hz in steps of 2 Hz.
        if strcmp(Mode_analysis,'all')
            cfg.toi= 'all';
        else
            cfg.toi= tstar:twin:tend; % para% el tiempo
        end
        cfg.pad    = 'nextpow2';
        tmp_freq   = ft_freqanalysis(cfg, data);
        %% Connectivity estimation
        fprintf(['Wpli Connectivity subject...  ' num2str(s) '... of ' num2str(size(SS,2))  '\n '])
        cfg        = [];
        cfg.method = 'wpli';
        wpli{cl}   = ft_connectivityanalysis(cfg, tmp_freq);    
    end
    Cx_all = cell(1,2);
    for cl = 1:2
        for fr = 1:numel(wpli{s}{cl}.freq)
            for v = 1:numel(wpli{s}{cl}.time)
                Cx_all{cl}(:,fr,v)  = wpli{cl}.wplispctrm(:,fr,v);
            end
        end
    end
    data      = [];
    data.labelcmb = wpli{1}.labelcmb;
    data.time = wpli{1}.time;
    data.freq = wpli{1}.freq;
    save(['result\Cx_wpli_giga_all_time_',num2str(tstar),'_',num2str(tend),'_sub',num2str(s),'.mat'],'Cx','data')
    clc
end
