function PLV = hyperPLV(EEG, EEG2, direction, toMean)
% Computes the Phase Locking Value (PLV) between each channel of 2 EEG data sets (usually from 2 different subjects in hyperscanning studies).
%
% Input parameters:
%   EEG and EEG2: EEGLAB constructs containing EEG.data, a 3D matrix of shape numChannels x numTimePoints x
%   numEpochs. Both EEG files need to be bandpass-filtered in the frequency 
%   range of interest and epoched.
%
%   direction (string): specify the direction of PLV calculation
%       'time' to calculate the PLV over all time points of a trial, resulting in 1 PLV per trial
%       'trials' to calculate the PLV over all trials at each time point, resulting in 1 PLV per time point
%   
%   toMean (boolean): if true, averages the PLV values over all time points or trials, resulting in 1 mean PLV representing the epoch of interest
%
% Output parameters:
%   PLV is a 2D matrix of channels x PLV. If toMean is set to true, it will
%   be channels x 1. Otherwise, it will be channels x numTimePoints /
%   numEpochs (depending on the direction chosen).
%
% Example: test = hyperPLV(EEG_of_Subject1, EEG_of_Subject2, 'time', true);


% Phase angles of set 1
EEGsignal = EEG.data;
numChannels = size(EEGsignal, 1);
% Calculate angles: must be in loop because Hilbert input needs to have
% timepoints as 1st dimension!
for channelCount = 1:numChannels
    EEGsignal(channelCount, :, :) = angle(hilbert(squeeze(EEGsignal(channelCount, :, :))));
end

% Phase angles of set 2
EEGsignal2 = EEG2.data;
for channelCount2 = 1:numChannels
    EEGsignal2(channelCount2, :, :) = angle(hilbert(squeeze(EEGsignal2(channelCount2, :, :))));
end

% PLV calculations
if strcmp(direction,'time')    % results in 1 PLV per trial
    % Create empty matrix to hold the PLVs
    PLV = [];
    % Loop over channels
    for chanX = 1:numChannels
        % Calculate the phase differences between the same channel of the
        % two EEG signals
        phase_angles = zeros(2,EEG.pnts,EEG.trials);
        phase_angles(1,:,:) = EEGsignal(chanX,:,:);
        phase_angles(2,:,:) = EEGsignal2(chanX,:,:);
        % PLV formula
        plv_time = squeeze(abs(mean(exp(1i*diff(phase_angles,[],1)),2)));
        % Add the PLVs to the matrix
        PLV = [PLV,plv_time];
    end
    % Transpose the matrix so that rows = channels to be consistent with
    % the original signal
    PLV = PLV';
elseif strcmp(direction,'trials')    % results in 1 PLV per time point
    PLV = [];
    for chanX = 1:numChannels
        phase_angles = zeros(2,EEG.pnts,EEG.trials);
        phase_angles(1,:,:) = EEGsignal(chanX,:,:);
        phase_angles(2,:,:) = EEGsignal2(chanX,:,:);
        plv_trials = abs(mean(exp(1i*diff(phase_angles,[],1)),3));
        PLV = [PLV;plv_trials];
    end
else
    disp('Error: No direction specified as third argument.');
end

% Average per channel
if toMean
    PLV = mean(PLV,2);
end    

disp('PLV calculated!');

return;