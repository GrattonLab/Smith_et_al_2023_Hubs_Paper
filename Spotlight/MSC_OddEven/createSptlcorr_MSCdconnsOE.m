function createSptlcorr_MSCdconnsOE(groupAvgLoc,groupAvgName,cortexOnly,outputdir,dconnData, outputname)
%DMS updated the template dirs%
 

if ~exist(outputdir , 'dir')
mkdir(outputdir)
end


   
    
    % Compute spatial correlations
    
            
            
            cifti_corrmap = dconnData;
            clear dconnData

            disp(['Cifti corrmap is ' num2str(size(cifti_corrmap,1)) ' by ' num2str(size(cifti_corrmap,2)) ': ' datestr(now)]);

            % Remove NaNs (produced if vertices have no data)
            cifti_corrmap(isnan(cifti_corrmap)) = 0;

            % Apply the Fisher tranformation
                        
            
            for dconnrow = 1:size(cifti_corrmap,1)
            
                cifti_corrmap(dconnrow,:) = single(FisherTransform(cifti_corrmap(dconnrow,:)));
                
            end
            
          

            disp(sprintf('Fisher Transform Finished: %s', datestr(now)));
            
            
disp(sprintf('Loading Template: %s', datestr(now)));

% Load group-average corrmat (assumes it's a dconn)
group = ft_read_cifti_mod([groupAvgLoc '/' groupAvgName '.dconn.nii']);
if cortexOnly==1
    group = group.data(1:59412,1:59412);
    sizedata = size(group,1);
    
    % Load template file
    template = ft_read_cifti_mod('/!!Your Path Here!!/template_files/MSC01_allses_mean_native_freesurf_vs_120sub_corr.dtseries.nii');
    template.data = [];
else
    group = group.data(1:65625,1:65625);
    sizedata = size(group,1);
    
    %%%%%%% NEED TO MAKE YOUR A TEMPLATE FILE SO DIMENSIONS MATCH %%%%%%%%
    template = ft_read_cifti_mod('/!!Your Path Here!!/!!Your Cortex Plus dtseries.nii File !!');
    template.data = [];
    template.hdr(6).dim = 1;
    
end

disp(['Cifti group data is ' num2str(size(group,1)) ' by ' num2str(size(group,2)) ': ' datestr(now)]);

disp(sprintf('Template Loaded: %s', datestr(now)));
            
            % Compare to group average
            for i=1:sizedata
                template.data(i,1) = paircorr_mod(group(:,i),cifti_corrmap(:,i));
            end
            clear cifti_corrmap
            
            disp(sprintf('Correlation Finished: %s', datestr(now)));

            % Write out the sim maps
            
            if cortexOnly == 1
            
                ft_write_cifti_mod([outputdir '/' outputname '_vs_' groupAvgName '_cortex_corr'],template);
                template.data = [];
            
            elseif cortexOnly == 0
                
                ft_write_cifti_mod([outputdir '/' outputname '_vs_' groupAvgName '_subcort_corr'],template);
                template.data = [];
                
            end
 

