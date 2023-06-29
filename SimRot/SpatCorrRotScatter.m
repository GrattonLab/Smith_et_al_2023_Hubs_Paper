%This script determines where the similarity of hub locations to the group
%average connectivity profile stand in terms of a distribution of
%similarity based on random rotations for each MSC Subject

%First add path to cifti functions (provided in the General_Utilities folder)%
addpath(genpath('/!!Your Path Here!!/General_Utilities'));

%Load the mat file containing the Low Signal Mask filtered parcel/ROI/Node rotations (each rotation is a col in the matrix)%
load('/!!Your Path Here!!/RotSumPC.mat') %This is an output file from FiltCollective.m

figure(1)
jitlevel=.2; %Set jitter for the figure
%This script does the rotation analysis with spatial correlation (aka similarity) to the group instead of variant density overlap
CIsave=cell(9,1);
distsave=cell(9,1);
realsave=cell(9,1);
subs={'01','02','03','04','05','06','07','09','10'};

%Get the Power PC Hub locations
RealHubs = ft_read_cifti_mod(['/!!Your Path Here!!/top10PC_5mm_ROIs.dtseries.nii']);
RealHubCortex=RealHubs.data(:,1);

%Get the similarity for the hub locations for the MSC subjects
for mscsubs=1:9; %for each of the 9 MSC subjects
SubSpatCorr = ft_read_cifti_mod(['/!!Your Path Here!!/SimMaps/CorrMaps/MSC',char(subs(mscsubs)),'_REST_AllSessions_vs_120_allsubs_corr_cortex_corr.dtseries.nii']); %Insert your MSC subject similarity map to Group Ave Profile
%Set Underlay for Overlap%
Target=SubSpatCorr.data; 
%Filter Out Subcortical stuff from Rot Maps%
RotCortex=zFiltRotCortex; %Use Filtered Rotations%
%Calc Real Overlap%
realidx=nonzeros(unique(RealHubs.data(:,1)));%Col should have the unique values that mark each hub%
realnum=length(realidx);
RealOverlapStore=cell(realnum,1);
RealAveValOverlap=zeros(realnum,1);
RealAllOverlap=[];
for r=1:realnum;
    overlap=Target(RealHubCortex==realidx(r));
    RealOverlapStore{r,1}=overlap;
    Ave=mean(overlap);
    RealAveValOverlap(r)=Ave;
    RealAllOverlap=[RealAllOverlap,transpose(overlap)];
end
RealAveAllOverlap=mean(RealAllOverlap);
%Calc Rot Overlap%
parcelidx=nonzeros(unique(RotCortex(:,1)));%Col does not matter they all have same vals%
parcelnum=length(parcelidx);
OverlapStore=cell(parcelnum,1000);
AveValOverlap=zeros(parcelnum,1000);
AveAllOverlap=[];
for i=1:1000; %for each of the 1000 rotations
    AllOverlap=[];
    for ii=1:parcelnum;    %Col does not matter they all have same vals%
    overlap=Target(RotCortex(:,i)==parcelidx(ii));
    OverlapStore{ii,i}=overlap;
    Ave=mean(overlap);
    AveValOverlap(ii,i)=Ave;
    AllOverlap=[AllOverlap,transpose(overlap)];
    end 
    Allave=mean(AllOverlap);
    AveAllOverlap=[AveAllOverlap,Allave];
end

%Get CIs (Confidence Intervals)%
%CI for all%
OverallLB=prctile(AveAllOverlap,2.5); %Not corrected for mult tests here(be sure to do that at a later stage when analyzing output of this script)%
OverallUB=prctile(AveAllOverlap,97.5); %Not corrected for mult tests here(be sure to do that at a later stage when analyzing output of this script)%

%Make Plots%
subplot(3,3,mscsubs)
ydata=transpose(AveValOverlap);
ydata=AveAllOverlap;
[r, c] = size(ydata);
sz=500;
xdata=repmat(1,c,1);
scatter(xdata(:), ydata(:),'k.','jitter','on', 'jitterAmount', jitlevel);
hold on;

scatter(1, RealAveAllOverlap, sz,'r.','d');
ylim([0 1]);
set(gca,'XTick',1,'XTickLabel','','FontWeight','Bold');
ylabel('Similarity (r)','fontweight','bold');
title(['MSC',char(subs(mscsubs))]);
CIsave{mscsubs,1}=[OverallLB,OverallUB];
distsave{mscsubs,1}=AveAllOverlap;
realsave{mscsubs,1}=RealAveAllOverlap;
end

%Save the figure
saveas(1,['/!!Your Path Here!!/SimRot/SpatCorr Dist.jpg']);
save('/!!Your Path Here!!/SimRot/SpatCorrSubplotOutput.mat'); %Save workspace output

close all