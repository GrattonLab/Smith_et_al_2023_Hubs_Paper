%Calc Ave SpatCorr to Group Level Network Templates For Group Hub Locations in Indiv Subjects (Non-Adjusted Hubs)%
%First add path to cifti functions (provided in the General_Utilities folder)%
addpath(genpath('/!!Your Path Here!!/General_Utilities'));
addpath(genpath('/!!Your Path Here!!/Spotlight'));
%Set subjs%
subs={'01','02','03','04','05','06','07','09','10'};
subswashu={'01','02','03','04','05','06','07','09','10','WashU'};%use for fig name
network_names = {'DMN','Vis','FP','DAN','VAN','Sal','CO','SMd','SMl','Aud','Tpole','MTL','PMN','PON','SpatCorr'};
%Might Want to Reorder to This%
%CatNames={'SMd','SMl','Aud','Vis','DAN','CO','Sal','FP','VAN','DMN','MTL','PMN','PON','Tpole','SpatCorr'};
%CatNamesShort={'SMd','SMl','Aud','Vis','DAN','CO','Sal','FP','VAN','DMN','MTL','PMN','PON','Tpole'};
CatNames={'SMd','SMl','Aud','Vis','DAN','CO','Sal','FP','Lang','DMN','MTL','PMN','PON','Tpole','SpatCorr'};
CatNamesShort={'SMd','SMl','Aud','Vis','DAN','CO','Sal','FP','Lang','DMN','MTL','PMN','PON','Tpole'};
Cats=categorical(CatNames);
ReOrderCatNames=reordercats(Cats,CatNames);
reorder=[8,9,10,2,4,7,6,3,5,1,12,13,14,11];
SubLevelReorderCorr=cell(10,1); %Will contain network by subject corrs%
SpatCorrVecs=zeros(10,9); %Hub by Subj% 
SubLevelReorderMax=cell(10,1);
MaxMats=cell(10,1);
%
AveCorrSave=cell(9,1);
AveCorrAcrossSubs=zeros(9,14);
SEMCorrAcrossSubs=zeros(9,14);
%Load Power Top 10 Parcels Here%
tarParcels=ft_read_cifti_mod(['!!Your Path Here!!/top10PC_5mm_ROIs.dtseries.nii']);
pars=nonzeros(unique(tarParcels.data(:,1)));
hubvec=tarParcels.data(:,1);
for tars=1:9; %for each MSC subject
    othersubs=subs;
    othersubs(tars)=[];
    corrsave=zeros(length(pars),14);%parcels and 14 is the number of networks%
    reorder=[8,9,10,2,4,7,6,3,5,1,12,13,14,11];
    for thenet=1:14;
        tarcorr=ft_read_cifti_mod(['!!Your Path Here!!/SimMaps/NetworkCorrMaps/MSC',char(subs(tars)),'_REST_AllSessions_vs_Template120_Net',char(num2str(thenet)),'_NetworkCorrMap_cortex_corr.dtseries.nii']);
        for p=1:length(pars);
            tarparcorr=tarcorr.data(tarParcels.data==pars(p));
            AveParCorr=mean(tarparcorr);
            corrsave(p,thenet)=AveParCorr; %Correlations are not reordered%
            
        end
    end
    for pagain=1:length(pars);
    ReOrderCorr=corrsave(pagain,reorder);
    SubLevelReorderCorr{pagain,1}=[SubLevelReorderCorr{pagain,1},transpose(ReOrderCorr)];
    end
end
%Get WashU 120%
WashUperHubNetCorrProfile=[];
for thehub=1:10;
%Calc the WashU Network Corr Profile%
    corrsave=zeros(1,14);
    for networks=1:14;
        tarcorr=ft_read_cifti_mod(['!!Your Path Here!!/Spotlight/WashUNetCorr/WashU120__vs_Template120_Net',char(num2str(networks)),'_NetworkCorrMap_cortex_corr.dtseries.nii']); %Correlation of WashU cortical locations with WashU based template network maps%
        tarparcorr=tarcorr.data(hubvec==pars(thehub)); 
        AveParCorr=mean(tarparcorr); %Get average correlation across the verts
        corrsave(1,networks)=AveParCorr; %Correlations are not reordered%
    end
    reorder=[8,9,10,2,4,7,6,3,5,1,12,13,14,11];%The order of the networks%
    reordercorrsave=corrsave(reorder); %reorder the correlations (need to do this since we remade the net correlations%
    WashUperHubNetCorrProfile=[WashUperHubNetCorrProfile,transpose(reordercorrsave)]; %Add the group profile for this hub to the log
end
    %Make figures%
for thehubs=1:10;
    figure(1)
    imagesc([SubLevelReorderCorr{thehubs,1},WashUperHubNetCorrProfile(:,thehubs)]);
    title(['Hub ',char(num2str(thehubs)),' Network Corrs By Subject']);
    xlabel('MSC Subject'); 
    ylabel('Network Corr');
    xticklabels(subswashu);
    set(gca,'YTick',1:14,'YTickLabel',CatNames);
    tstart = -1;
    tend = 1;
    caxis([tstart tend]);
    colorbar
    colormap jet
    saveas(1,['!!Your Path Here!!/Spotlight/OrigHubsGroupNetworks/OrigHub ',char(num2str(thehubs)),'_Network Corrs By Subject WashU.jpg'])
    SubLevelReorderMax{thehubs,1}=max(SubLevelReorderCorr{thehubs,1});
end
save('!!Your Path Here!!/Spotlight/OrigHubsGroupNetworks/OrigHubsGroupNets.mat','CatNames','SubLevelReorderCorr','subswashu','WashUperHubNetCorrProfile');