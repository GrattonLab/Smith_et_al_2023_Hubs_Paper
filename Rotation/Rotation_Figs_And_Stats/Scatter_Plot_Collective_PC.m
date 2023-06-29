%Gets null dist for the low signal filtered cd rots
load('/!!Your Path Here!!/GoodSumPC.mat');
clearvars -except zFiltRotCortex;
jitlevel=.2;
%Pick your dataset (the dataset the variant overlap map is based on)
dataset=['/!!Your Path Here!!/overlap_MSC9.dtseries.nii'];
VarDenMSC = ft_read_cifti_mod(dataset);
%Set Name%
if strcmp(dataset,'/!!Your Path Here!!/overlap_MSC9.dtseries.nii')==1;
    %For MSC 9 Subjects
    FileName='GoodFilt_MSC';
    SubNum=9;
elseif strcmp(dataset,'/!!Your Path Here!!/HCPallSplitHalfSubs_overlap.dtseries.nii')==1;
    %For 384 HCP Subjects
    FileName='GoodFilt_HCP';
    SubNum=384;
elseif strcmp(dataset,'/!!Your Path Here!!/HCP752_overlap.dtseries.nii')==1;
    %For 752 HCP
    FileName='GoodFilt_HCP';
    SubNum=752;
end
RealHubs = ft_read_cifti_mod(['/!!Your Path Here!!/top10PC_5mm_ROIs.dtseries.nii']);
RealHubCortex=RealHubs.data(:,1); %(VarDenMSC.brainstructure>0,1); %The brainstrcuture is good in VarDenMSC%
%Set Underlay for Overlap%
Target=VarDenMSC.data; %Set to MSC or HCP%
%Convert VarDen Map to % %
Target=(Target/SubNum)*100;
%Filter Out Subcortical stuff from Rot Maps%
RotCortex=zFiltRotCortex;
%Calc Real Overlap%
realidx=nonzeros(unique(RealHubs.data(:,1)));%Col should have the unique values%
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
for i=1:1000;
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
%Make CIs%

%CI for all%
OverallLB=prctile(AveAllOverlap,2.5);
OverallUB=prctile(AveAllOverlap,97.5);
%Make Histos%
ydata=AveAllOverlap;
[r, c] = size(ydata);
sz=1500;
figure(1)
xdata=repmat(0,c,1);
scatter(xdata(:), ydata(:),100,'k.','jitter','on', 'jitterAmount', jitlevel);
hold on;
scatter(jitlevel/2, RealAveAllOverlap, sz,'r.','d');
xlim([0,1]);
ylim([0,15]);
ylh = ylabel('Frequency of Variants (%)','fontweight','bold','FontSize',18);
ylh.Position(1) = ylh.Position(1) - 0.03;
set(gca,'linewidth',4);
set(gca,'XTick',1,'XTickLabel',' ','FontWeight','Bold');
set(gca,'YTick',[0,5,10,15],'FontWeight','Bold','FontSize',16);

saveas(1,['/!!Your Path Here!!/',FileName,'_July_Hub_PC.jpg']);

close all