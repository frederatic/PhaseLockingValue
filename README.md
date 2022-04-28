# PhaseLockingValue
MATLAB function that calculates the Phase Locking Value for Hyperscanning studies

## Files

*clean_set*: cleans all raw EEG files (.set format) and prepares them for Independent Component Analysis (ICA)  
*run_ICA*: runs ICA on all cleaned EEG files to identify and remove noisy components  
*hyperPLV*: a generic function that calculations the Phase Locking Value (Lachaux et al., 1999) between all channels of 2 EEG sets.  

The PLV is a measure of brain synchrony, here adapted for hyperscanning studies where you calculate the brain synchrony between each channel of the brains of 2 different people.  

*Reference:*  
Lachaux, J. P., Rodriguez, E., Martinerie, J., & Varela, F. J. (1999). Measuring phase synchrony in brain signals. Human brain mapping, 8(4), 194-208. 
