%Makes Orig and Adj hub figures in RedBlue ColorMap
subs={'01','02','03','04','05','06','07','09','10'};
subswashu={'01','02','03','04','05','06','07','09','10','WashU'};%use for fig name
for theset=1:2;
if theset==1;
    savedir='/!!Your Path Here!!/Spotlight/RedBlueFigs/OrigHubs';
    load('/!!Your Path Here!!/Spotlight/OrigHubsGroupNetworks/OrigHubsGroupNets.mat');
    hubtype='OrigHub';
    hubset=SubLevelReorderCorr;
else
    savedir='/!!Your Path Here!!/Spotlight/RedBlueFigs/AdjHubs';
    load('/!!Your Path Here!!/Spotlight/AdjHubsGroupNetworks/HubLoopTest.mat');
    hubtype='AdjHub';
    hubset=newhubmats;
end
%Make figures%
for thehubs=1:10;
    figure(1)
    imagesc([hubset{thehubs,1},WashUperHubNetCorrProfile(:,thehubs)]);
    xticklabels(subswashu);
    set(gca,'FontWeight','Bold')
    tstart = -1;
    tend = 1;
    caxis([tstart tend]);
    colorbar
    colormap(redblue)
    saveas(1,[savedir,'/RedBlue_',hubtype,'_',char(num2str(thehubs)),'_Network Corrs By Subject WashU.jpg']);
end
end