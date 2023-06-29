%Get the average similarity to the group across the vertices for each Power PC hub for each of the 8 MSC subjects

%First add path to cifti functions (provided in the General_Utilities folder)%
addpath(genpath('/!!Your Path Here!!/General_Utilities'));

%Open dtseries.nii file with the vertices of the top 10 Power PC hubs marked by unique numbers for each hub%
tarParcels=ft_read_cifti_mod('/!!Your Path Here!!/top10PC_5mm_ROIs.dtseries.nii');

%Get Average Corr for each parcel%
parnums=nonzeros(unique(tarParcels.data(:,1)));
base=zeros(59412,1);
%Set subjs%
subs={'01','02','03','04','05','06','07','09','10'};
AveCorrSave=zeros(10,9); %Power ROIs by MSC subjects%
for p=1:length(parnums);
    for os=1:9;
        %Below load similarity map for the given MSC subject (these are dtseries.nii files) to learn more look at SimMaps folder
        othercorr=ft_read_cifti_mod(['/!!Your Path Here!!/MSC',char(subs(os)),'_REST_AllSessions_vs_120_allsubs_corr_cortex_corr.dtseries.nii']);
        otherparcorr=othercorr.data(tarParcels.data==parnums(p));
        AveCorrInPowerHub=mean(otherparcorr);
        %Store/Save%
        AveCorrSave(p,os)=AveCorrInPowerHub; 
    end
end
save('SpatCorrMSC.mat','AveCorrSave');