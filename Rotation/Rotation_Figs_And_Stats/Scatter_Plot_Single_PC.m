%Gets null dist for the low signal filtered cd rots
load('/!!Your Path Here!!/Indiv.mat'); %Load the Indiv (aka single) hub rots (one ROI in each hemi marked with a different number)
clearvars -except zFiltRotCortex;
jitlevel=.2;
%Pick your dataset (the dataset the variant overlap map is based on)
dataset=['/!!Your Path Here!!/HCP752_overlap.dtseries.nii'];
VarDenMSC = ft_read_cifti_mod(dataset);
%Set Name%
if strcmp(dataset,'/!!Your Path Here!!/overlap_MSC9.dtseries.nii')==1;
    %For MSC 9 Subjects
    FileName='GoodFilt_MSC';
    SubNum=9;
elseif strcmp(dataset,'/!!Your Path Here!!/HCPallSplitHalfSubs_overlap.dtseries.nii')==1;
    %For HCP 384 Subjects
    FileName='GoodFilt_HCP';
    SubNum=384;
elseif strcmp(dataset,'/!!Your Path Here!!/HCP752_overlap.dtseries.nii')==1;
    %For HCP 752 Subjects
    FileName='GoodFilt_HCP';
    SubNum=752;
end
%
Rot=1;
if Rot==1;
Lval=5;
Rval=1;
elseif Rot==2;
Lval=6;
Rval=2;
end
MinHemi=min([Rval,Lval]);
RealHubs = ft_read_cifti_mod(['/!!Your Path Here!!/top10PC_5mm_ROIs.dtseries.nii']);
RealHubCortex=RealHubs.data(:,1); %(VarDenMSC.brainstructure>0,1); %The brainstrcuture is good in VarDenMSC%
%Set Underlay for Overlap%
Target=VarDenMSC.data; %Set to MSC or HCP%
%Convert VarDen Map to % %
Target=(Target/SubNum)*100;
OutputName='HCP752_PowerIndivOverlap'; %Set to MSC or HCP%
%Filter Out Subcortical stuff from Rot Maps%
RotCortex=zFiltRotCortex; %Get rid of extra stuff%

%Get Real Hub Overlap%
realHubidx=nonzeros(unique(RealHubs.data(:,1)));
realHubnum=length(realHubidx);
RealHubOverlapStore=cell(realHubnum,1);
RealHubAveValOverlap=zeros(realHubnum,1);
RealHubAllOverlap=[];

for r=1:realHubnum;
    overlap=Target(RealHubCortex==realHubidx(r));
    RealHubOverlapStore{r,1}=overlap;
    Ave=mean(overlap);
    RealHubAveValOverlap(r)=Ave;
    RealHubAllOverlap=[RealHubAllOverlap,transpose(overlap)];
end
RealHubAveAllOverlap=mean(RealHubAllOverlap);
%Split by hemi%
OrigRightHub=[1,2,3,4,7,10];
OrigLeftHub=[5,6,8,9];
RightHub=RealHubAveValOverlap([1,2,3,4,7,10]);
LeftHub=RealHubAveValOverlap([5,6,8,9]);
%Calc Rot Overlap%
RotCortexOnes=RotCortex(:,1)>0;
parcelidx=nonzeros(unique(RotCortex(:,2)));%Col does matter because you need to use a col that has both the right and left parcel out of the ls mask%
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
%CI for each hub%
IndivLB=[];
IndivUB=[];
for p=1:parcelnum;
    IndivLB=[IndivLB;prctile(AveValOverlap(p,:),2.5)];
    IndivUB=[IndivUB;prctile(AveValOverlap(p,:),97.5)];
end
IndivUWaveOverlap=mean(AveValOverlap); %Just Averaging across the average overlap for each hemi's parcel%
%CI for all%
OverallLB=prctile(AveAllOverlap,2.5);
OverallUB=prctile(AveAllOverlap,97.5);
UWaveLB=prctile(IndivUWaveOverlap,2.5);
UWaveUB=prctile(IndivUWaveOverlap,97.5);
figure(1)
ydata=transpose(AveValOverlap);
ydata=[ydata(:,2),ydata(:,1)];%Need to switch the first and second col to get the hemis into left then right order
[r, c] = size(ydata);
%New Stuff%
sz=2000;
if Lval<Rval;
Hems={'Left Hemi','Right Hemi'}
rightHubx=repmat(2,length(RightHub),1);
leftHubx=repmat(1,length(LeftHub),1);
else
Hems={'Left Hemi','Right Hemi'}
rightHubx=repmat(2,length(RightHub),1);
leftHubx=repmat(1,length(LeftHub),1);
end
for hemitarget=1:2; %Right is first then left%
    if hemitarget==1;
        hemihubs=RightHub;
        hubdixvals=OrigRightHub;
    elseif hemitarget==2;
        hemihubs=LeftHub;
        hubdixvals=OrigLeftHub;
    end
for hubcase=1:length(hemihubs);
figure(1)
xdata=repmat(0,r,1);
scatter(xdata(:), ydata(:,hemitarget),100,'k.','jitter','on', 'jitterAmount', jitlevel);
hold on;
scatter(jitlevel/2, hemihubs(hubcase), sz,'r.','d');
xlim([0,1]);
ylim([0 max(ydata(:)+1)]);
ylh = ylabel('(%)','fontweight','bold','FontSize',18);
ylh.Position(1) = ylh.Position(1) - 0.03;
set(gca,'linewidth',4);
set(gca,'XTick',1,'XTickLabel',' ','FontWeight','Bold');
set(gca,'YTick',[0,15,30],'FontWeight','Bold','FontSize',16);
HubName=hubdixvals(hubcase);

saveas(1,['/!!Your Path Here!!/',FileName,'_PC_Hub ',char(num2str(HubName)),'_IndivPar.jpg']);

close all
end
end
