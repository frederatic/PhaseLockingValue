% This code preprocesses the SET files in preparation for ICA:
% 1. Add channel locations
% 2. High pass filter 1 Hz
% 3. Low pass filter 45 Hz
% 4. ClearRaw and ASR
% 5. Interpolate channels
% 6. Re-reference to Average
%
% Replace FILE_PATH with your own file paths.

SavePath = 'FILE_PATH';
removedChans = {'file' 0}

% Find all EEGLAB files in current directory or add own path
files = dir('*.set');

% Loop over each file
for file = files'    
    % Load data
    EEG = pop_loadset(file.name);
    EEG = eeg_checkset( EEG );

    % Load Channel Info
    EEG = pop_chanedit(EEG, 'load',{'FILE_PATH','filetype','autodetect'},'delete',1,'delete',1,'delete',1,'setref',{'1:65','Cz'});
    EEG = eeg_checkset( EEG );

    % 1Hz Highpass filter 
    EEG = pop_eegfiltnew(EEG, 'locutoff',1,'plotfreqz',0);
    EEG.comments = pop_comments(EEG.comments,'','High-pass filter the data at 1-Hz.', 1);

    % 45Hz Lowpass Filter
    EEG = pop_eegfiltnew(EEG, 'hicutoff',45,'plotfreqz',0);
    EEG.comments = pop_comments(EEG.comments,'','45Hz Lowpass filter.', 1);
    EEG = eeg_checkset( EEG );
    
    % Apply clean_rawdata() to remove bad channels and correct continuous data using Artifact Subspace Reconstruction (ASR). 
    backup_locs = EEG.chanlocs;
    EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion','off','ChannelCriterion',0.7,'LineNoiseCriterion',4,'Highpass','off','BurstCriterion',20,'WindowCriterion','off','BurstRejection','off','Distance','Euclidian');
    EEG = eeg_checkset( EEG );
    
    % Save number of removed channels
    %if isfield(EEG.chaninfo, 'removedchans')
    %    removedChan = {filename size(EEG.chaninfo.removedchans,2)}
    %    removedChans = [removedChans;removedChan]
    %end
    
    % Interpolate all the removed channels
    EEG = pop_interp(EEG, backup_locs,'spherical');
 
    % Re-reference the data to average
    EEG = pop_reref( EEG, []);

    % Save
    EEG = pop_saveset( EEG, 'filename', file.name, 'filepath', SavePath);
    
end

% If you want to save the number of removed channels per file
% writecell(removedChans, 'removedChans_child.csv')