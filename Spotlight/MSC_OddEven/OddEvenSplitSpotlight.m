%The script uses Group Level Networks and conducts spotlight analysis on data broken up by odd and evan sessions%
NetNames={'Default','Visual','Fronto-Parietal','Dorsal Attention','Unknown System','Ventral Attention','Salience','Cingulo-Opercular','Somatomotor Dorsal','Somatomotor Lateral','Auditory','Temporal Pole','Medial Temporal','Parietal Memory','Parietal-Occipital'};%Group network names and they are in the same order as their numbers in NetNums%
TrimNetNames=NetNames;
TrimNetNames(5)=[];
%Above it should be noted that the reorder variable is set up to reorder the TrimNetNames
%This script finds new hub locations for each of the 10 Power Hubs.  It
%uses the WashU 120 template connectivity profile as a reference
%Then it finds the adj locations based on the location in the spotlight with the at least have 70% of their verts overlaping
%with the mode network and compares trimmed hubs with
%the WashU ref and the trimmed hub with the min distance from the WashU
%ref is chosen as the adjusted hub
overlapthres=70;
%First add path to cifti functions (provided in the General_Utilities folder)%
addpath(genpath('/!!Your Path Here!!/General_Utilities'));
addpath(genpath('/!!Your Path Here!!/Spotlight/MSC_OddEven'));
subs={'01','02','03','04','05','06','07','09','10'};
subidx=[1,2,3,4,5,6,7,8,9]; %Index values in badhubs corresponding to subs%
allsubs={'01','02','03','04','05','06','07','09','10','WashU'}; %Use this for the figure
%Load the orig Power hubs 5mm%
tarParcels=ft_read_cifti_mod('!!Your Path Here!!/top10PC_5mm_ROIs.dtseries.nii');
tarhubs=[1,2,3,4,5,6,7,8,9,10]; %Set the hubs you are interested in
workbenchdir = '/!!Your Path Here!!/';
seeddir='/!!Your Path Here!!/seeds/';
mapdir='/!!Your Path Here!!/maps';
Hubdir='/!!Your Path Here!!/top10PC_5mm_ROIs.dtseries.nii';
hubs=ft_read_cifti_mod(Hubdir);
hubnums=nonzeros(unique(hubs.data(:,1)));
hubvec=hubs.data(:,1);
BigZoneHubsdir='!!Your Path Here!!/top10PC_10mm_ROIs.dtseries.nii';
BigZoneHubs=ft_read_cifti_mod(BigZoneHubsdir);
%Need to get the Pointlog%
load('!!Your Path Here!!/Spotlight/Pointlog.mat');
%Loop through the target hubs%
newhubmats=cell(length(tarhubs),1);
winnerrefsubjnetcorrlog=[];
WashUperHubNetCorrProfile=[];
%Log of Random Selection of adj hub locations for null dist%
DistanceSaveOdd=cell(length(tarhubs),length(subs));
DistanceSaveEven=cell(length(tarhubs),length(subs));
%Store Orig locations for odd and even
OrigDistOdd=zeros(length(subs),length(tarhubs));
OrigDistEven=zeros(length(subs),length(tarhubs));
OrigNetCorrOdd=cell(length(subs),length(tarhubs));
OrigNetCorrEven=cell(length(subs),length(tarhubs));
for thehub=1:length(tarhubs);
%Calc the WashU Network Corr Profile%
    corrsave=zeros(1,14);
    for networks=1:14;
        tarcorr=ft_read_cifti_mod(['/!!Your Path Here!!/Spotlight/WashUNetCorr/WashU120__vs_Template120_Net',char(num2str(networks)),'_NetworkCorrMap_cortex_corr.dtseries.nii']); %Correlation of WashU cortical locations with WashU based template network maps%
        tarparcorr=tarcorr.data(hubvec==hubnums(tarhubs(thehub))); 
        AveParCorr=mean(tarparcorr); %Get average correlation across the verts
        corrsave(1,networks)=AveParCorr; %Correlations are not reordered%
    end
    reorder=[8,9,10,2,4,7,6,3,5,1,12,13,14,11];%The order of the networks%
    reordercorrsave=corrsave(reorder); %reorder the correlations (need to do this since we remade the net correlations%
    WashUperHubNetCorrProfile=[WashUperHubNetCorrProfile,transpose(reordercorrsave)]; %Add the group profile for this hub to the log
    winner=reordercorrsave; %Going to match to this
  winnerrefsubjnetcorrlog=[winnerrefsubjnetcorrlog,winner]; %WashU reference for each log%
  winneridxlog=zeros(2,length(subs)); %Log the map that is the closest to the ref (for each subject) with the thres condition%
  WinnerDistCell=cell(length(subs),2);
  winnerActidxlog=zeros(length(subs),2);
%Now loop through all the subjects (yeah we don't really need to do it for the reference)%
for thesubs=1:length(subs);
%Do it for odd and even sessions%
for OE=1:2;
if OE==1;
    Split='Odd';
elseif OE==2;
    Split='Even';
end
reorder=[8,9,10,2,4,7,6,3,5,1,12,13,14,11];%The order of the networks%

MapMat=zeros(14,Pointlog(tarhubs(thehub),2)); %Going to store info on the potential replacement locations in here%
AdjHubMaps=zeros(59412,Pointlog(tarhubs(thehub),2)); %Will store the vert maps for the adj hubs post non-mode network trim in here cols below the 70% threshold will stay all zeros
badpointtrack=ones(1,Pointlog(tarhubs(thehub),2));
basemapvec=1:Pointlog(tarhubs(thehub),2);
for map=1:Pointlog(tarhubs(thehub),2);  %for each map for the hub%
      tarParcel=ft_read_cifti_mod([mapdir,'Hub',char(num2str(tarhubs(thehub))),'Point',char(num2str(map)),'_5mm.dtseries.nii']); %Open adj location map
      corrsave=zeros(1,14);
    %Trim off non-mode network verts%
    netmap=ft_read_cifti_mod(['/!!Your Path Here!!/Spotlight/GroupLevelNetowrks/120_colorassn_minsize400_manualconsensus.dtseries.nii']); %Get group level networks
    netmapcortex=netmap.data(1:59412,1); %Trim off non-cortex locations
    HubVertCount=sum(tarParcel.data~=0);
    HubNetOverlap=netmapcortex(tarParcel.data~=0,1);
    NumNets=length(unique(HubNetOverlap));
    ModeNet=mode(HubNetOverlap);
    ModeCount=length(HubNetOverlap(HubNetOverlap==ModeNet,1));
    tarhubmodenetverts=and(tarParcel.data~=0,netmapcortex==ModeNet); %Gives me a vector marking the hub locations in the mode network
    PrtMode=(ModeCount/HubVertCount)*100; 
    OverlapThresTest=PrtMode>=overlapthres;
if OverlapThresTest==1; %if the 70% or more of verts on mode network
      AdjHubMaps(:,map)=tarhubmodenetverts; %save trimmed potential adj hub location
%Use the Group level Networks for matching    
for thenet=1:14;
            tarcorr=ft_read_cifti_mod(['/!!Your Path Here!!/Spotlight/MSC_OddEven/OddEven_NetCorMapts/MSC',char(subs(thesubs)),'_REST_',char(Split),'Sessions_vs_Template120_Net',char(num2str(thenet)),'_NetworkCorrMap_cortex_corr.dtseries.nii']);
            tarparcorr=tarcorr.data(AdjHubMaps(:,map)==1); %It is already set to the target up (look at the line were we read the cifti) so it can look for 1%
            AveParCorr=mean(tarparcorr);
            corrsave(1,thenet)=AveParCorr; %Correlations are not reordered%
end
reorderedcorr=corrsave(reorder); %Reorder%
MapMat(:,map)=transpose(reorderedcorr);%Save%
else
  badpointtrack(1,map)=0;  
end

end
%Now do it for the orig hub locations
    for thenetagain=1:14;
        Origtarcorr=ft_read_cifti_mod(['/!!Your Path Here!!/Spotlight/MSC_OddEven/OddEven_NetCorMapts/MSC',char(subs(thesubs)),'_REST_',char(Split),'Sessions_vs_Template120_Net',char(num2str(thenetagain)),'_NetworkCorrMap_cortex_corr.dtseries.nii']);
            Origtarparcorr=Origtarcorr.data(tarParcels.data(:,1)==thehub); %for each orig hub%
            OrigAveParCorr=mean(Origtarparcorr);
            Origcorrsave(1,thenetagain)=OrigAveParCorr; %Correlations are not reordered%
    end
    Origreorderedcorr=Origcorrsave(reorder);

            %odd and even
            if OE==1;
               OrigNetCorrOdd{thesubs,thehub}=Origreorderedcorr;
            elseif OE==2;
              OrigNetCorrEven{thesubs,thehub}=Origreorderedcorr;
            end
%
%Filter out less than 70% overlap cases
origindx=basemapvec(badpointtrack~=0);
FiltMapMat=MapMat(:,badpointtrack~=0);
%Get the difference
  Dist=zeros(1,size(FiltMapMat,2));
  for m=1:size(FiltMapMat,2);
      Dist(1,m)=pdist(transpose([FiltMapMat(:,m),transpose(winner)]));
  end
  %Get the winner location for each subject for this hub%
  [mind,Idxd]=min(Dist); %Find the closest to the ref (will not be the zero cases)%
  actidx=origindx(Idxd);
  MinDistIndex=Idxd;

newhubmats{thehub,1}(:,subidx(thesubs))=[FiltMapMat(:,MinDistIndex)];%Stick New hub col for given subject in spot
winneridxlog(OE,thesubs)=MinDistIndex; %log the min index%
%WinnerDistCell{thesubs,OE}=MinDistIndex;
WinnerDistCell{thesubs,OE}=mind; %store min dist
winnerActidxlog(thesubs,OE)=actidx; %store orig index (pre trim) of the min adj hub location
%Save Distances for Odd and Even
if OE==1;
DistanceSaveOdd{thehub,thesubs}=Dist;
OrigDistOdd(thesubs,thehub)=pdist([OrigNetCorrOdd{thesubs,thehub};winner]);
elseif OE==2;
DistanceSaveEven{thehub,thesubs}=Dist;
OrigDistEven(thesubs,thehub)=pdist([OrigNetCorrEven{thesubs,thehub};winner]);
end

end
save(['/!!Your Path Here!!/Spotlight/MSC_OddEven/OddEvenHub',char(num2str(tarhubs(thehub))),'_',char(Split),'_Minlog.mat'],'winneridxlog','MinDistIndex','WinnerDistCell','winnerActidxlog','OrigNetCorrOdd','OrigNetCorrEven','winnerrefsubjnetcorrlog','DistanceSaveOdd','DistanceSaveEven','OrigDistOdd','OrigDistEven');
end

end
save(['/!!Your Path Here!!/Spotlight/MSC_OddEven/OddEven_HubLoopTest.mat'],'newhubmats','MinDistIndex','MapMat','FiltMapMat','badpointtrack','winneridxlog','winnerActidxlog','WashUperHubNetCorrProfile','DistanceSaveOdd','DistanceSaveEven','winnerrefsubjnetcorrlog','OrigDistOdd','OrigDistEven','OrigNetCorrOdd','OrigNetCorrEven');