%Clean Version by DMS 2023
%First add path to cifti functions (provided in the General_Utilities folder)%
addpath(genpath('/!!Your Path Here!!/General_Utilities'));
workbenchdir = '/!!Your Path Here!!'; %dir where workbench is stored 
seeddir='/!!Your Path Here!!/seeds'; %
mapdir='/!!Your Path Here!!/maps'; %
Hubdir='/!!Your Path Here!!/top10PC_5mm_ROIs.dtseries.nii'; %Dir where you store the hubs
hubs=ft_read_cifti_mod(Hubdir); %load hubs
hubnums=nonzeros(unique(hubs.data(:,1))); %Get the unique non-zero numbers marking the hubs
BigZoneHubsdir='/!!Your Path Here!!/top10PC_10mm_ROIs.dtseries.nii'; %dir where you store hubs with radius of 10mm that will be used for the search zone
BigZoneHubs=ft_read_cifti_mod(BigZoneHubsdir);
Pointlog=[];
for i=1:length(hubnums); %For each hub get locations for the hub%
    hubpoints=BigZoneHubs.data(:,1)==hubnums(i);
    hubpoints=double(hubpoints); %convert to number%
    base=zeros(59412,1);
    locations=find(hubpoints==1);
    Pointlog=[Pointlog;[i,sum(hubpoints)]];
    for ii=1:sum(hubpoints); %Make cifti for each hub point%
        vec=base;
        vec(locations(ii),1)=1; %put 1 in given location%
        temp=hubs;
        temp.data=vec;
        ft_write_cifti_mod([seeddir,'Hub',char(num2str(i)),'Point',char(num2str(ii)),'.dtseries.nii'],temp) %Save the seed point
    end
end
for iii=1:10;
points=Pointlog(iii,2);   
for iiii=1:points;
%Dilate for each nonoverlap point%
system([workbenchdir,'wb_command -cifti-dilate  /seeddir/Hub',char(num2str(iii)),'Point',char(num2str(iiii)),'.dtseries.nii COLUMN 5 0 ',mapdir,'Hub',char(num2str(iii)),'Point',char(num2str(iiii)),'_5mm.dtseries.nii -left-surface /!!Your Path Here!!/Atlases/32k_ConteAtlas_v2_distribute/Conte69.L.midthickness.32k_fs_LR.surf.gii -right-surface /!!Your Path Here!!/Atlases/32k_ConteAtlas_v2_distribute/Conte69.R.midthickness.32k_fs_LR.surf.gii -nearest']); %Note actually write out seeddir when used here
%Above: These potential adjusted hubs are stored in your mapdir and are based on the seed points in your seedir 

end
end
save('/!!Your Path Here!!/Spotlight/Pointlog.mat','Pointlog'); %Save for the Point log in your spotlight analysis folder for later use by other scripts