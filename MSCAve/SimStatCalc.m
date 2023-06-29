%This script gets the correlation between the MSC-1 similarity maps and the corresponding similarity map to the WashU 120. 
%It opens the similarity maps, applies the Fisher Z transformation, calculates the correlation, and once it does this for each subject it gets the average correlation across subjects plus the standard deviation

%First add path to cifti functions (provided in the General_Utilities folder)%
addpath(genpath('/!!Your Path Here!!/General_Utilities'));
addpath('/!!Your Path Here!!/MSCAve/')

subs = {'MSC01','MSC02','MSC03','MSC04','MSC05','MSC06','MSC07','MSC09','MSC10'};
%Get Correlation between sim maps for each subject and store in a vector then get average and SD for the vector%
CorrVec=[];
PVec=[];
for thesub=1:length(subs)
%Load Data
MSCAveSim=ft_read_cifti_mod(['/!!Your Path Here!!/MSCAve/',char(subs(thesub)),'_SimMap_MSCAveCorr.dtseries.nii']);
WashUSim=ft_read_cifti_mod(['/!!Your Path Here!!/SimMaps/',char(subs(thesub)),'_REST_AllSessions_vs_120_allsubs_corr_cortex_corr.dtseries.nii']);
%Fisher Z Transform
ZMSCAveSim=FisherTransform(MSCAveSim.data);
ZWashUSim=FisherTransform(WashUSim.data);
%Correlate
[r,p]=corrcoef(ZMSCAveSim,ZWashUSim);
%Save
CorrVec=[CorrVec,r(2,1)];
PVec=[PVec,p(2,1)];
end
%Get Stats
CorrAve=mean(CorrVec);
CorrSD=std(CorrVec);
