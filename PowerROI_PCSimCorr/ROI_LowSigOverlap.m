%This script Marks each node with its proportion overlap with the low signal mask% 

%First add path to cifti functions (provided in the General_Utilities folder)%
addpath(genpath('/!!Your Path Here!!/General_Utilities'));
%Below load .dtseries.nii with the cortical locations (vertices) overlaping with the nodes marked by a unique node ID number (we input power nodes that were not cerebellum/subcortical)%
RealHubs=ft_read_cifti_mod('/!!Your Path Here!!/NoCerSubcUncer59412_5mm_ROIs.dtseries.nii');
%Below load the low signal mask%
LSM=ft_read_cifti_mod(['/!!Your Path Here!!/bottomBrainMask.dtseries.nii']);

parnums=unique(RealHubs.data); %Get list of unique values
parnums=parnums(parnums~=0); %Remove 0 since it is for non-node vertices%
ProOverlap=[];
%Below calc the proportion LSM overlap for each node%
for par=1:length(parnums);
    thepar=RealHubs.data==parnums(par);
    parverts=sum(thepar);
    intersection=LSM.data(thepar);
    Overlap=sum(intersection);
    ProOverlap=[ProOverlap,(Overlap/parverts)];
end
ProOverlap=transpose(ProOverlap);
%Below load the output of the TopPC_SimCalc.m script (note make sure PCvec varialbe from this script is in the same order as the nodes/parcels in this script)%
load('/!!Your Path Here!!/ROISim.mat');
TopPCLowSig=[PCvec,ProOverlap]; %Get ready to sort by PC
Sorted=sortrows(TopPCLowSig,1); %Sort
save('ProOverlap_ROI_LowSigOverlap.mat','ProOverlap');