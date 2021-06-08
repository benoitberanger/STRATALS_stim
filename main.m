function main()

clc

project_dir = fileparts(mfilename('fullpath')); % "fileparts" first output is the dir of the input
cd(project_dir); % just to make sure we are in the right dir

fprintf('Project name : %s \n', project_name);
fprintf('Project path : %s \n', project_dir);

fprintf('Starting GUI... \n');
GUI.OpenGUI(); % the GUI is the only interface the user will interact with

end % function
