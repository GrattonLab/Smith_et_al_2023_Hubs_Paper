%Makes scatter plot with best fit line and Power PC Top 10 Hubs marked in a different color from non-hubs

%First add path to cifti functions (provided in the General_Utilities folder)%
addpath(genpath('/!!Your Path Here!!/General_Utilities'));

%Below load .dtseries.nii with the cortical locations (vertices) overlaping with the nodes marked by a unique node ID number (we input power nodes that were not cerebellum/subcortical)%
tarParcels=ft_read_cifti_mod('/!!Your Path Here!!/NoCerSubcUncer59412_5mm_ROIs.dtseries.nii');

%Get Average Corr for each parcel%
parnums=nonzeros(unique(tarParcels.data(:,1)));
%Set subjs%
subs={'01','02','03','04','05','06','07','09','10'};
AveCorrSave=zeros(length(parnums),9); %Power ROIs by subjects%
for p=1:length(parnums);
    for os=1:9;
        othercorr=ft_read_cifti_mod(['/projects/b1081/member_directories/dmsmith/HubPaperFigs/Revision_Stuff/Revision_Round_Two/Redo/SimMaps/Good_CG_CorrMaps/MSC',char(subs(os)),'_REST_AllSessions_vs_120_allsubs_corr_cortex_corr.dtseries.nii']);
        otherparcorr=othercorr.data(tarParcels.data==parnums(p));
        AveCorrInPowerROIs=mean(otherparcorr);
        %Store/Save%
        AveCorrSave(p,os)=AveCorrInPowerROIs; 
    end
end
%Fisher Z Transform%
zAveCorr=FisherTransform(AveCorrSave);
%Make PC Vector (do this by reading in text files with unique id numbers and PCs for the Power nodes that are not cerebellum/subcortical)%
ROIList=dlmread('/!!Your Path Here!!/Good_Files/NoCerSubcUncer_ROI.txt');
PCList=dlmread('/!!Your Path Here!!/NoCerSubcUncer_PC.txt');
combo=[ROIList,PCList];
PCvec=zeros(length(parnums),1);
%This script does not need the loop below anymore since PCvec should be the same as PCList%
for i=1:length(parnums);
    idx=find(combo(:,1)==parnums(i));
    PCvec(i,1)=combo(idx,2);
end
%Get Correlation for each MSC subject
SubCorrLog=[];
load('/projects/b1081/member_directories/dmsmith/HubPaperFigs/Revision_Stuff/PowerROI_PC_SpatCor_Cor/Good_Files/ProOverlap_ROI_LowSigOverlap.mat'); %Load map with your ROIs marked by their proportion of overlap with the low signal mask (Col vector) with ROI locations matching PCvec
PCfilt=PCvec(ProOverlap<.30);
[B,I]=maxk(PCfilt,10);
figure(1)
for ii=1:9; %for each MSC subject
    zcors=zAveCorr(:,ii);
    zcorsfilt=zcors(ProOverlap<.30);
    rval=corrcoef(zcorsfilt,PCfilt);
    SubCorrLog=[SubCorrLog,rval(2,1)];
    %Scatter Plots
    subplot(3,3,ii);
    ax=scatter(PCfilt,zcorsfilt);
    c = ax.CData;
npts = length(zcorsfilt);
% c is now a 1x3, meaning a RGB color that's used for all of the points
c = repmat(c,[npts 1]);
% c is now a matrix with the original RGB
for h=1:10;
c(I(h),:) = [1 0 0];
end
% c now contains red for the hubs
ax.CData = c;
% Now the scatter object is using those colors
    h1=lsline
    h1.Color='r';
    ylim([0,1.5]);
    xlim([0,6]);
    ylabel('Similarity (Fisher Z)');
    xlabel('Sum PC');
    title(['MSC',subs(ii)]);
end
%Average Correlation Across Subjects 
 AveSimPCCorr=mean(SubCorrLog);
 SDSimPCCorr=std(SubCorrLog);
 %Save Corr Stats
 save('SimPC_Corr_TopPC_Filt_Output.mat','SubCorrLog','AveSimPCCorr','SDSimPCCorr');