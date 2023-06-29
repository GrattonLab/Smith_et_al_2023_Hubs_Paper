% Makes a figure of the similarity of the MSC Subjects (output of AveSpatCorrToGroupForPowerTop10MSC.m) Power PC hub locations to the Group Ave Profile

%load the output of AveSpatCorrToGroupForPowerTop10MSC.m 
load('/!!Your Path Here!!/SpatCorrMSC.mat')
subs={'01','02','03','04','05','06','07','09','10'};
figure(1)
imagesc(AveCorrSave)
set(gca,'XTick',1:9,'XTickLabel',subs)
set(gca,'fontsize',18,'fontweight','bold');
colorbar
colormap hot
caxis([0 1])