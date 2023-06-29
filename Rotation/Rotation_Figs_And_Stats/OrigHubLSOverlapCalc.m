%The user picks a hub set to use and the script will determine the proportion of overlap each hub has with the low signal mask
%This script could be made into a function

%First add path to cifti functions (provided in the General_Utilities folder)%
addpath(genpath('/!!Your Path Here!!/General_Utilities'));

%Insert ROI Set you want to screen (ComDen Hubs, PC Hubs, Cortical Power ROIs etc...)
RealHubs=ft_read_cifti_mod('/!!Your Path Here!!/YourHubs_5mm_ROIs.dtseries.nii');
LSM=ft_read_cifti_mod(['/!!Your Path Here!!/Rotation/Rotation_Figs_And_Stats/bottomBrainMask.dtseries.nii']);
HubLocs=RealHubs.data(:,1)>0;
Overlap=LSM.data+HubLocs;
HubLocCount=sum(RealHubs.data(:,1)>0);
proporoverlap=sum(Overlap>1)/HubLocCount;