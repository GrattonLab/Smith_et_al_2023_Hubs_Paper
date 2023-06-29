function createSptlcorr_MSCdconns_NetCorr(target,TarName,cortexOnly,outputdir,dconnData, outputname)


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

% Get the target ready

if cortexOnly==1
    target = target(1:59412,1); %The target is now a 1D vector
    sizedata = size(target,1);
    
    % Load template file
    template = ft_read_cifti_mod('/!!Your Path Here!!/template_files/MSC01_allses_mean_native_freesurf_vs_120sub_corr.dtseries.nii');
    template.data = [];
 %%%%%%%Do what we did to the current subject to the target subject Z Trans etc...%
          tar_corrmap = target;
          clear target

            disp(['Tar corrmap is ' num2str(size(tar_corrmap,1)) ' by ' num2str(size(tar_corrmap,2)) ': ' datestr(now)]);

            % Remove NaNs (produced if vertices have no data)
            tar_corrmap(isnan(tar_corrmap)) = 0;

            % Apply the Fisher tranformation
                        
            
            for tarrow = 1:size(tar_corrmap,1)
            
                tar_corrmap(tarrow,:) = single(FisherTransform(tar_corrmap(tarrow,:)));
                
            end   
    
else
    target = target(1:65625,1);
    sizedata = size(target,1);
  %%%%%%%Do what we did to the current subject to the target subject Z Trans etc...%
          tar_corrmap = target;
          clear target

            disp(['Tar corrmap is ' num2str(size(tar_corrmap,1)) ' by ' num2str(size(tar_corrmap,2)) ': ' datestr(now)]);

            % Remove NaNs (produced if vertices have no data)
            tar_corrmap(isnan(tar_corrmap)) = 0;

            % Apply the Fisher tranformation
            
            %cifti_corrmap = single(FisherTransform(cifti_corrmap));    %%Changed to row-wise transformation for memory allocation
            
            
            for tarrow = 1:size(tar_corrmap,1)
            
                tar_corrmap(tarrow,:) = single(FisherTransform(tar_corrmap(tarrow,:)));
                
            end
    %%%%%%% NEED TO MAKE YOUR A TEMPLATE FILE SO DIMENSIONS MATCH %%%%%%%%
    template = ft_read_cifti_mod('/!!Your Path Here!!/!!Your Cortex Plus dtseries.nii File !!');
    template.data = [];
    template.hdr(6).dim = 1;
    
end

disp(['Cifti target data is ' num2str(size(cifti_corrmap,1)) ' by ' num2str(size(cifti_corrmap,2)) ': ' datestr(now)]);

disp(sprintf('Template Loaded: %s', datestr(now)));
            
            % Compare to target subject
            for i=1:sizedata
                template.data(i,1) = paircorr_mod(tar_corrmap(:,1),cifti_corrmap(:,i)); %Target always the same vector%
            end
            clear cifti_corrmap
            
            disp(sprintf('Correlation Finished: %s', datestr(now)));

            % Write out the maps
            
            if cortexOnly == 1
            
                ft_write_cifti_mod([outputdir '/' outputname '_vs_' TarName '_cortex_corr'],template);
                template.data = [];
            
            elseif cortexOnly == 0
                
                ft_write_cifti_mod([outputdir '/' outputname '_vs_' TarName '_subcort_corr'],template);
                template.data = [];
                
            end
 

