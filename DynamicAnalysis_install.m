%% Dynamic Analysis... runs on Matlab. 
% This is a script installing all components in an automatically.
%  
% 1) extract the files and
% 2) save the Dynamic Analysis... files in <your_directory>
% 3) start matlab
%    cd <your_directory> 
%    Dynamic Analysis_installer 
% 4) For a permanent installation, save the default path with 
%     PATHTOOL and click on the "SAVE" button. 
% 5) For removing 
%    remove the path to 
%       HOME/
%       HOME/DynamicAnalysis/ and all its subdirectories
% 
%  NOTE: For more information see README. 
% 
%% local path
Name_HOME = pwd;	%<your_directory>

if exist('functions','dir')
     fprintf(2,'\n');
else
     fprintf(2,'Error: subdirectories functions not found\n');
        return;
end    

path(Name_HOME,path);			        % 
path([Name_HOME,'/demo'],path);		% demos
path([Name_HOME,'/data'],path);		% Documents. 
path([Name_HOME,'/functions'],path);  % functions of signal processing and feature extraction.
path([Name_HOME,'/Subject-level'],path);	% display and presentation
path([Name_HOME,'/Group-level'],path);	% display and presentation
path([Name_HOME,'/graphics'],path);		    % visualization of analysis

if exist([Name_HOME,'/Subject-level'],'dir')
    Dyn_DIR_sub = [Name_HOME,'/Subject-level'];
elseif exist([Name_HOME,'/Group-level'],'dir')
    Dyn_DIR_Gr = [Name_HOME,'/Group-level'];
else 
	fprintf(2,'Error: subdirectories Subject and Group-level not found\n');
    return;
end

path([Dyn_DIR_sub,'/Rayleight'],path);	% display and presentation
path([Dyn_DIR_sub,'/Connectivity'],path);	% display and presentation
path([Dyn_DIR_sub,'/ERD'],path);	% display and presentation
path([Dyn_DIR_Gr,'/Rayleight'],path);	% display and presentation
path([Dyn_DIR_Gr,'/Connectivity'],path);	% display and presentation
path([Dyn_DIR_Gr,'/ERD'],path);	% display and presentation


disp('  --------------------- Dynamic Analysis... activated --------------------------- ');
disp('	If you want DynamicAnalysis... permanently installed, use the command SAVEPATH. ')
