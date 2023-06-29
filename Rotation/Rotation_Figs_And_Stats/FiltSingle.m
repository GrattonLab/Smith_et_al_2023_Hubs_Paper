%Filters out Low Signal Regions for Indiv Hub Rotations%
%The same rotations were used for both CD and PC hubs. 
%The targets of the rotations are two ROIs (one in each hemisphere) with their vertices marked by different numbers
%The ROIs used in the rotation should be the same size as the hubs of
%interest (e.g., diameter 10mm).

%First add path to cifti functions (provided in the General_Utilities folder)%
addpath(genpath('/!!Your Path Here!!/General_Utilities'));
 
        Rotations = ft_read_cifti_mod(['/!!Your Path Here!!/Rotate_Overlap_MSC/MSC_GIFTI_Geo_Files/GIFTI_Rotation_Maps/MSC_Overlap_CIFTI_rest_map_Indiv1.dtseries.nii']);
        RotCortex=Rotations.data(1:59412,:); %Get rid of extra stuff (non-cortex points)%
        savename='Indiv';
    LowSigMask=ft_read_cifti_mod(['/!!Your Path Here!!/bottomBrainMask.dtseries.nii']);
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

    save('Indiv.mat','FiltRotCortex','zFiltRotCortex','RotCortex'); %Save rotations