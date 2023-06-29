%Produces similarity maps between subject level connectivity profiles and the network templates

%First add path to cifti functions (provided in the General_Utilities folder)%
addpath(genpath('/!!Your Path Here!!/General_Utilities'));
%Add path with special functions used when making the sim maps
addpath('/!!Your Path Here!!/SimMaps/')
parpool('local', 1)     %% Name of cluster profile for batch job

clear all

CortexOnly = 1; %% Toggles whether to run correlations on cortex only
nets=14;
subs = {'MSC01','MSC02','MSC03','MSC04','MSC05','MSC06','MSC07','MSC09','MSC10'};

outdir = '/!!Your Path Here!!/SimMaps/NetworkCorrMaps';


cd '/!!Your Path Here!!';   %% Change CD to root project directory

disp(sprintf('Job Submitted: %s', datestr(now)));

if CortexOnly == 1      %% Select correct number of voxels for template
    
    voxnum = 59412;
    
else
    
    voxnum = 65625;
    
end


catData = [];
%Load the templates here%
NetTemplates=ft_read_cifti_mod('/!!Your Network Template Dir Here!!/120_templates.dtseries.nii') %Templates for the 14 networks (WashU-120)
for thetar=1:nets;

    target = NetTemplates.data(:,thetar);
    %Prevents crazy growth of cdata%
    catData = [];
    
for i=1:numel(subs)
    

    % Load rest vcids
    restdir = dir(['/!!Your Path to MSC Resting State Data Here!!/' subs{i} '/Functionals/FCPROCESS_SCRUBBED_UWRPMEAN/cifti_timeseries_normalwall_native_freesurf']);
    vcidlist = restdir(~cellfun(@isempty,strfind({restdir.name},'dtseries')));
    vcidlist = vcidlist(~cellfun(@isempty,strfind({vcidlist.name},'vc')));

    disp(sprintf('%i resting sessions found for subject %s: %s', size(vcidlist,1), subs{i}, datestr(now)));

    % Load rest tmasks
    load(['/!!Your Path to MSC Resting State Data Here!!/' subs{i} '/Functionals/FCPROCESS_SCRUBBED_UWRPMEAN/QC.mat'])
    
    % Load and concatentate data
    for k=1:length(vcidlist)
        
        vcid = vcidlist(k).name;
        
        disp(sprintf('Loading timeseries for session %s for subject %s rest: %s', vcid, subs{i}, datestr(now)));
        

        data = ft_read_cifti_mod(['/!!Your Path to MSC Resting State Data Here!!/' subs{i} '/Functionals/FCPROCESS_SCRUBBED_UWRPMEAN/cifti_timeseries_normalwall_native_freesurf/' vcid]);
        disp(sprintf('Loading data size %i by %i, %s', size(data.data,1), size(data.data,2), datestr(now)));
        data = data.data;
        

      	% Load rest tmasks
     	load(['/!!Your Path to MSC Resting State Data Here!!/' subs{i} '/Functionals/FCPROCESS_SCRUBBED_UWRPMEAN/QC.mat']);
        
         %Use filtermask for MSC03 and MSC10
         if strcmp(subs{i}, 'MSC03') || strcmp(subs{i}, 'MSC10')
                    resttmask = QC(k).filtertmask;
                else
                    resttmask = QC(k).tmask;
         end
        
        
        disp(sprintf('tmask for rest file has %i good sample points, %s', sum(resttmask), datestr(now)));
        
        data = data(1:voxnum,logical(resttmask));
        
        catData = [catData data];
        
    end

    % Make and save rmat
    
    if CortexOnly == 1
        
        disp('Loading template: MSC01_allses_mean_native_freesurf_vs_120sub_corr.dtseries.nii');
        template = ft_read_cifti_mod('/!!Your Path Here!!/template_files/MSC01_allses_mean_native_freesurf_vs_120sub_corr.dtseries.nii');
        
    else
        
        disp(sprintf('Reading %s: %s', '!!Your Path Here!!/!!Your Cortex Plus dtseries.nii File !!', datestr(now)));
        template = ft_read_cifti_mod('/!!Your Path Here!!/!!Your Cortex Plus dtseries.nii File !!');
        
    end
    
    
    template.data = [];
    template.dimord = 'pos_pos';
    template.hdr.dim(7) = voxnum;
    template.hdr.dim(6) = template.hdr.dim(7);
    template.hdr.intent_code = 3001;
    template.hdr.intent_name = 'ConnDense';
    
    % Make and write dconn

 	disp(sprintf('Running Correlations: on data size %i by %i, %s', size(catData,1), size(catData,2), datestr(now)));
 	template.data = paircorr_mod(catData');
    
    % Make and write variant map
    
    outputfile = [subs{i} '_REST_AllSessions'];
    TarName=['Template120_Net',num2str(thetar),'_NetworkCorrMap'];
    createSptlcorr_MSCdconns_NetCorr(target,TarName,1,'/!!Your Output dir!!',template.data, outputfile);
    catData = []; %This can be critical for space%
end
end 
    

