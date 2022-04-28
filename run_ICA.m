% This code runs ICA on the cleaned files
% Uses ICLabel to reject Muscle and Eye Noise of >90%

SavePath = 'FILE_PATH';

% Find all EEGLAB files in current directory or add own path
files = dir('*.set');

% Loop over each file
for file = files'    
    % Load data
    EEG = pop_loadset(file.name);
    EEG = eeg_checkset( EEG );
    
    % ICA
    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on');
    EEG = eeg_checkset( EEG );
    
    % Use ICLabel to automatically reject noisy components
    EEG = pop_iclabel(EEG, 'default');
    EEG = eeg_checkset( EEG );
    EEG = pop_icflag(EEG, [NaN NaN;0.9 1;0.9 1;NaN NaN;NaN NaN;NaN NaN;NaN NaN]);
    EEG = eeg_checkset( EEG );
    EEG = pop_subcomp( EEG, [], 0);

    % Save
    EEG = pop_saveset( EEG, 'filename', file.name, 'filepath', SavePath);
end