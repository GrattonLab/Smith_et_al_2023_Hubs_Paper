%Filters out Low Signal Regions from the Collective Rotations%

%First add path to cifti functions (provided in the General_Utilities folder)%
addpath(genpath('/!!Your Path Here!!/General_Utilities'));

for i=1:2;
    if i==1; %Save Sum PC Hubs
        Rotations = ft_read_cifti_mod(['/!!Your Path Here!!/Rotate_Overlap_MSC/MSC_GIFTI_Geo_Files/GIFTI_Rotation_Maps/MSC_Overlap_CIFTI_rest_1KSepWay_Power_map.dtseries.nii']);
        RotCortex=Rotations.data(1:59412,:); %Get rid of extra stuff%
        savename='SumPC';
    elseif i==2; %Save ComDen Hubs
        Rotations = ft_read_cifti_mod(['/!!Your Path Here!!/Rotate_Overlap_MSC/MSC_GIFTI_Geo_Files/GIFTI_Rotation_Maps/MSC_Overlap_CIFTI_rest_ComDen5mm_map.dtseries.nii']);
        RotCortex=Rotations.data(1:59412,:); %Get rid of extra stuff%
        savename='ComDen';
    end
    LowSigMask=ft_read_cifti_mod(['/!!Your Path Here!!/bottomBrainMask.dtseries.nii']); %load low signal mask
    FiltRotCortex=RotCortex;
    zvec=zeros(1,1000);
    nanvec=NaN(1,1000);
    zFiltRotCortex=FiltRotCortex;
    for ii=1:59412;
    if LowSigMask.data(ii,1)==1;
    FiltRotCortex(ii,:)=nanvec;
    zFiltRotCortex(ii,:)=zvec;
    end
    end
    template=LowSigMask;
    ft_write_cifti_mod(['/!!Your Path Here!!/Rotation/Rotation_Figs_And_Stats/',savename,'_bottomBrainMask.dtseries.nii'],template);
    if i==1;
        save('RotSumPC.mat','FiltRotCortex','zFiltRotCortex','RotCortex'); %Save PC Rotations
    elseif i==2;
        save('RotComDen.mat','FiltRotCortex','zFiltRotCortex','RotCortex'); %Save CD Rotations
    end
    clearvars -except i
end