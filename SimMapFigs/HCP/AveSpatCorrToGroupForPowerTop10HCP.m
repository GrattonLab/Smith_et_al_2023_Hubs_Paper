%First add path to cifti functions (provided in the General_Utilities folder)%
addpath(genpath('/!!Your Path Here!!/General_Utilities'));
%load%
tarParcels=ft_read_cifti_mod('/!!Your Path Here!!/top10PC_5mm_ROIs.dtseries.nii'); %Path to Power Hubs
%Get HCP file names%
hcpdata=dir('/!!Your Path Here!!/HCP_spCorr/');
hcpvec=3:754; %hcpdata has two empty slots in name that we don't need%
%Get Average Corr for each parcel%
parnums=nonzeros(unique(tarParcels.data(:,1)));
base=zeros(59412,1);
%Set subjs%
subs=1:752;
AveCorrSave=zeros(10,752); %Power ROIs by subjects%
AvePCSave=zeros(10,752);
for p=1:length(parnums);
    for os=1:752;
        othercorr=ft_read_cifti_mod(['/!!Your Path Here!!/HCP_spCorr/',hcpdata(hcpvec(os)).name]); %Path to HCP subject-WashU-120 reference similarity maps
        otherparcorr=othercorr.data(tarParcels.data==parnums(p));
        AveCorrInPowerHub=mean(otherparcorr);
        %Store/Save%
        AveCorrSave(p,os)=AveCorrInPowerHub; 
    end
end

save('/!!Your Path Here!!/HCP_SpatCorr.mat','AveCorrSave');