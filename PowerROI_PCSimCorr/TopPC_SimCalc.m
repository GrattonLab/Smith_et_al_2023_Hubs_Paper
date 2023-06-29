%Get top 25% of nodes in terms of PC and calc their similarity to Group Ave Profile (Note be sure to run the output of this script through ROI_LowSigOverlap.m to check for ROIs that overlap with low signal regions)%

%First add path to cifti functions (provided in the General_Utilities folder)%
addpath(genpath('/!!Your Path Here!!/General_Utilities'));

%Below load .dtseries.nii with the cortical locations (vertices) overlaping with the nodes marked by a unique node ID number (we input power nodes that were not cerebellum/subcortical or that were not asigned a network)%
tarParcels=ft_read_cifti_mod('/!!Your Path Here!!/NoCerSubcUncer59412_5mm_ROIs.dtseries.nii');

%Get Average Corr across vertices for each parcel%
parnums=nonzeros(unique(tarParcels.data(:,1)));
%Set subjs%
subs={'01','02','03','04','05','06','07','09','10'};
AveCorrSave=zeros(length(parnums),9); %Power ROIs by the 9 MSC subjects%
for p=1:length(parnums);
    for os=1:9;
        %Below load similarity map for the given MSC subject (these are dtseries.nii files) to learn more look at SimMaps folder
        othercorr=ft_read_cifti_mod(['/!!Your Path Here!!/MSC',char(subs(os)),'_REST_AllSessions_vs_120_allsubs_corr_cortex_corr.dtseries.nii']);
        otherparcorr=othercorr.data(tarParcels.data==parnums(p));
        AveCorrInPowerROIs=mean(otherparcorr);
        %Store/Save%
        AveCorrSave(p,os)=AveCorrInPowerROIs; 
    end
end
%Fisher Z Transform%
zAveCorr=FisherTransform(AveCorrSave);
%Make PC Vector (do this by reading in text files with unique id numbers and PCs for the Power nodes that are not cerebellum/subcortical)%
ROIList=dlmread('/!!Your Path Here!!/NoCerSubcUncer_ROI.txt');
PCList=dlmread('/!!Your Path Here!!/NoCerSubcUncer_PC.txt');
combo=[ROIList,PCList];
PCvec=zeros(length(parnums),1);
for i=1:length(parnums);
    idx=find(combo(:,1)==parnums(i));
    PCvec(i,1)=combo(idx,2);
end
%
Prt75sim=prctile(PCvec,75);
highPCnodes=PCvec>=Prt75sim;
HighPCROINums=ROIList(highPCnodes,:);
HighPCNodeSim=AveCorrSave(highPCnodes,:);
%Save
save('ROISim.mat');