%Makes violin plots of the similarity of the Power PC hub locations to the
%group average connectivity profile for the HCP subjects (752). 
%It uses the output of AveSpatCorrToGroupForPowerTop10HCP.m
figure(1)
load('/!!Your Path Here!!/HCP_SpatCorr.mat');
[h,L,MX,MED]=violinMod(transpose(AveCorrSave));
set(gca,'fontsize',18,'fontweight','bold');
title('Similarity to the Group');
ylabel('Similarity (r)');
xlh=xlabel('Participation Coefficient Hub');
legend('Location','southeast')
xticks([1,2,3,4,5,6,7,8,9,10]);
xticklabels({'1','2','3','4','5','6','7','8','9','10'});
 