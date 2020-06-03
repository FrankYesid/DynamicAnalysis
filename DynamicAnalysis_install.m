%% Dynamic... runs on Matlab. 
% This is a script installing all components in an automatically.
%  
% 1) extract the files and
% 2) save the Dynamic... files in <your_directory>
% 3) start matlab
%    cd <your_directory> 
%    Name_installer 
% 4) For a permanent installation, save the default path with 
%     PATHTOOL and click on the "SAVE" button. 
% 5) For removing 
%    remove the path to 
%       HOME/
%       HOME/Dynamic/ and all its subdirectories
% 
%  NOTE: For more information see README. 
% 
%% local path
Name_HOME = pwd;	%<your_directory>

if exist('Dynamic','dir')
     fprintf(2,'\n');
else
     fprintf(2,'Error: subdirectories not found\n');
        return;
end    

if exist([Name_HOME,'/Dynamic'],'dir')
    Dyn_DIR = [Name_HOME,'/Dynamic'];
elseif exist([Name_HOME,'/Dynamic'],'dir')
    Dyn_DIR = [Name_HOME,'/Dynamic'];
else 
end

path(Dyn_DIR,path);			        % 
path([Dyn_DIR,'/demo'],path);		% demos
path([Dyn_DIR,'/data'],path);		% Documents. 
path([Dyn_DIR,'/functions'],path);  % functions of signal processing and feature extraction.
path([Dyn_DIR,'/Subject-level'],path);	% display and presentation
path([Dyn_DIR,'/Group-level'],path);	% display and presentation
path([Dyn_DIR,'/graphics'],path);		    % visualization of analysis

disp('Name... activated');
disp('	If you want Dynamic... permanently installed, use the command SAVEPATH.')
