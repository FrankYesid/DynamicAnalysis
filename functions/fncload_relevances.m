function [pvt_sub,sel,M1,t_e,database,type,tex,flag,cur,ticks,GS] = ...
    fncload_relevances(data,method)
% load compouted relevances 
% L.F. Velasque-Martinez
cur = [];
ticks =[];
GS = [];
if strcmp(data,'BCI2a')
    %% Load relevances
    if strcmp(method,'J')
        load('J\Rel_based_J_Mayo.mat','pvt_sub'); %ventanas 1 s Rel_based_J_Mayo%Rel_based_J_1sec
    elseif strcmp(method,'ERD')
        load('ERD\X_erds_class.mat') % 
        pvt_sub   = {X1 X2};
    elseif strcmp(method,'Cx')
        %% Load data
        for i = 1:9
            %H:\Dropbox\ERD\results_ERDfc_subjects\pruebas_Frontiers\
            load(['Cx\Cx_1_sub' num2str(i) '.mat']) % BCI dataset2a ERD-based relevances
            for c =1:2
                tmp = Cx_1{1}{c};
                for ch = 1:size(tmp,2); pvt_sub{c}{i}(:,ch,:) = tmp{ch}; end
            end
        end
    end
    
    %% Parameters for topography 
    load('electrodesBCICIV2a.mat')            % Electrode positions

    database = 2;
    type = 4; tex = 0;
    t_e = 10;                                           % Electrodes size
    M1.xy = elec_pos(:,1:2);                            % posicion de los canales.
    M1.lab = Channels;  %1:9,11:22                      % nombre de los canales.
    sel = 1:22;
    flag = 1;
    
elseif strcmp(data,'Giga')
    %pvt_sub = cell(1,52);
    %% Load relevances
    name_dir = 'E:\Luisa\RESULTADOS PaperFrontiers\Results\';
    %% Load relevances
    if strcmp(method,'J')
        addpath(genpath([name_dir method '\Relevances_Giga']));
        listing = dir([name_dir method '\Relevances_Giga']);
        for i = 3:length(listing)
            subj = str2double(listing(i).name(12:13));
            load([listing(i).name],'Jfilt_'); 
            for ch = 1:size(Jfilt_{1}{1},2)
                tmp(ch,:,:) = Jfilt_{1}{1}{ch}';
            end
            pvt_sub{subj} = tmp;
        end
    elseif strcmp(method,'ERD')
        %% GIGA ERD-based relevances
        dir1 = 'E:\Luisa\RESULTADOS PaperFrontiers\Results\ERD\';
        load([dir1 'X_erds_class_giga_b.mat'])
        pvt_sub = {X1 X2}; clear X1 X2 
        
        load([dir1 '\X_erds_class_giga_m1.mat'])
        for sub = 1:52
            if isempty(X1{sub}); else pvt_sub{1}{sub} = X1{sub}; end 
            if isempty(X2{sub}); else pvt_sub{2}{sub} = X2{sub}; end
            if isempty(X1{sub}) && isempty(X2{sub})
            end
        end
        clear X1 X2 
        
        load([dir1 'X_erds_class_giga_m2.mat'])
        for sub = 1:length(X1)
            if isempty(X1{sub}); else pvt_sub{1}{sub} = X1{sub}; end 
            if isempty(X2{sub}); else pvt_sub{2}{sub} = X2{sub}; end
            if isempty(X1{sub}) && isempty(X2{sub})
            end
        end
    elseif strcmp(method,'Cx')
        name_dir = 'Relevancias_Giga_2020\';
        addpath(genpath([name_dir method]));
        listing = 1:52; listing(29) = 0; listing(34) = 0;
        for i = 1:numel(listing)
            subj = listing(i);
            if subj ~=0
                load(['Cx_1_sub' num2str(subj)]); 
                tmp1 = Cx_1{1}{1}; tmp2 = Cx_1{1}{2};
                for ch = 1:numel(tmp1)
                    pvt_sub{1}{subj}(:,ch,:) = tmp1{ch};
                    pvt_sub{2}{subj}(:,ch,:) = tmp2{ch};
                end
            end
        end
    end
    
    %% Parameters for topography 64 channels
    load('pos_struct_giga.mat');
    database = [];
    sel    = 1:64;
    t_e    = 20;
    cur    = 0;
    ticks  = 0;
    GS    = 500;
    type   = 0;
    tex = [];
    flag = [];
    
end


