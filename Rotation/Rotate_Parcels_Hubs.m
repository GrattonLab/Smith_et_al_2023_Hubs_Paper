%This Script is based on code by BAS and BTK it randomly rotates parcel/node sets
clear all
%First add path to cifti functions (provided in the General_Utilities folder)%
addpath(genpath('/!!Your Path Here!!/General_Utilities'));

iterations = 1000; 
rotations = load('/!!Your Path Here!!/Rotation/rotations1000.mat');
%Stuff for making new rots each time%
 generaterotations=1 
    if generaterotations == 1
        
        rotationsxrot = [];
        rotationsyrot = [];
        rotationszrot = [];
        
        for rots = 1:iterations
            
            rng('shuffle')
            
            rotationsxrot = [rotationsxrot min(rotations.rotations.xrot)+(max(rotations.rotations.xrot)-min(rotations.rotations.xrot))*rand(1,1)];
            rotationsyrot = [rotationsyrot min(rotations.rotations.yrot)+(max(rotations.rotations.yrot)-min(rotations.rotations.yrot))*rand(1,1)];
            rotationszrot = [rotationszrot min(rotations.rotations.zrot)+(max(rotations.rotations.zrot)-min(rotations.rotations.zrot))*rand(1,1)];
            
        end
        
        rotations.rotations.xrot = rotationsxrot;
        rotations.rotations.yrot = rotationsyrot;
        rotations.rotations.zrot = rotationszrot;
        
        
    end




cifti_All_rest = ft_read_cifti_mod(['/!!Your Path Here!!/YourHubs_5mm_ROIs.dtseries.nii']); %Get My Hub Labels%

x=1 %Did this since there is one overlap map%  
analysistarget = 'Overlap'
    
    disp(['Performing parcel rotation for ' analysistarget])
    
    cifti_rest = cifti_All_rest; %Get ready to take out cols that are not needed%
    cifti_rest.data = cifti_All_rest.data(:,x); % Remove cols not needed%

    
    % Save files as GIFTIs
    
    template = ft_read_cifti_mod('/!!Your Path Here!!/YourHubs_5mm_ROIs.dtseries.nii');
  	template.data = [];
    
    template.data = cifti_rest.data;
    
    ft_write_cifti_mod(['/!!Your Path Here!!/Rotation/CIFTI_Geo_File/MSC_Overlap_Rest_Map_YourHubs'],template)
 	clear template
    

    system(['/!!Your Workbench Path Here!!/wb_command -cifti-separate /!!Your Path Here!!/Rotation/CIFTI_Geo_File/MSC_Overlap_Rest_Map_YourHubs.dtseries.nii COLUMN -metric CORTEX_LEFT /!!Your Path Here!!/Rotation/Rotate_Overlap_MSC/MSC_GIFTI_Geo_Files/MSC_Overlap_Rest_YourHubs_LH.func.gii']);
    
    system(['/!!Your Workbench Path Here!!/wb_command -cifti-separate /!!Your Path Here!!/Rotation/CIFTI_Geo_File/MSC_Overlap_Rest_Map_YourHubs.dtseries.nii COLUMN -metric CORTEX_RIGHT /!!Your Path Here!!/Rotation/Rotate_Overlap_MSC/MSC_GIFTI_Geo_Files/MSC_Overlap_Rest_YourHubs_RH.func.gii']);
    
    
    % Run rotation script with files
    
    gifti_restLH = gifti(['/!!Your Path Here!!/Rotation/Rotate_Overlap_MSC/MSC_GIFTI_Geo_Files/MSC_Overlap_Rest_YourHubs_LH.func.gii']);
    
    vertsLHrest = generate_rotated_parcellation_Hubs(gifti_restLH.cdata,iterations,rotations,0,'L',['/!!Your Path Here!!/Rotation/Rotate_Overlap_MSC/MSC_GIFTI_Geo_Files/GIFTI_Rotation_Maps/MSC_Overlap_gifti_rest_YourHubs_LH'],analysistarget);
    
    clear gifti_restLH
    
    gifti_restRH = gifti(['/!!Your Path Here!!/Rotation/Rotate_Overlap_MSC/MSC_GIFTI_Geo_Files/MSC_Overlap_Rest_YourHubs_RH.func.gii']);
    
    vertsRHrest = generate_rotated_parcellation_Hubs(gifti_restRH.cdata,iterations,rotations,0,'R',['/!!Your Path Here!!/Rotation/Rotate_Overlap_MSC/MSC_GIFTI_Geo_Files/GIFTI_Rotation_Maps/MSC_Overlap_gifti_rest_YourHubs_RH'],analysistarget);
    
    clear gifti_restRH
    
    
%     Convert output GIFTIs into CIFTIs
    
    LHemiFile = ['/!!Your Path Here!!/Rotation/Rotate_Overlap_MSC/MSC_GIFTI_Geo_Files/GIFTI_Rotation_Maps/MSC_Overlap_gifti_rest_CoefDiv_LH_rotatedmaps_YourHubs.func.gii'];
    RHemiFile = ['/!!Your Path Here!!/Rotation/Rotate_Overlap_MSC/MSC_GIFTI_Geo_Files/GIFTI_Rotation_Maps/MSC_Overlap_gifti_rest_CoefDiv_RH_rotatedmaps_YourHubs.func.gii'];
    outputfilerest = ['/!!Your Path Here!!/Rotation/Rotate_Overlap_MSC/MSC_GIFTI_Geo_Files/GIFTI_Rotation_Maps/MSC_Overlap_CIFTI_rest_YourHubs_map'];
    
    attribute_gifti_data_to_cifti(LHemiFile, RHemiFile, outputfilerest);
       