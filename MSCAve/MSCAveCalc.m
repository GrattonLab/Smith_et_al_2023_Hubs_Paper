%This Script Makes MSC -1 Ave Maps%

%This script is just like the script MSCAveCalc_NoSave.m but it saves the connectivity profile for the MSC-1 average as dconn.nii files and then stops

%First add path to cifti functions (provided in the General_Utilities folder)%
addpath(genpath('/!!Your Path Here!!/General_Utilities'));
%Add path with special functions used when making the sim maps
addpath('/!!Your Path Here!!/MSCAve/')
parpool('local', 1)     %% Name of cluster profile for batch job

clear all
CortexOnly = 1; %% Toggles whether to run correlations on cortex only
subs = {'MSC01','MSC02','MSC03','MSC04','MSC05','MSC06','MSC07','MSC09','MSC10'};

cd '/!!Your Path Here!!';   %% Change CD to root project directory

disp(sprintf('Job Submitted: %s', datestr(now)));



if CortexOnly == 1      %% Select correct number of voxels for template
    
    voxnum = 59412;
    
else
    
    voxnum = 65625;
    
end

catData = [];
for thesub=1:length(subs);
lesssubs = {'MSC01','MSC02','MSC03','MSC04','MSC05','MSC06','MSC07','MSC09','MSC10'};
lesssubs(thesub)=[]; %DMS: Remove the subject so it is not included in the average
sizelog=[];
for i=1:numel(lesssubs)

    % Load rest vcids
    restdir = dir(['/!!Your Path to MSC Resting State Data Here!!/' lesssubs{i} '/Functionals/FCPROCESS_SCRUBBED_UWRPMEAN/cifti_timeseries_normalwall_native_freesurf']);
    vcidlist = restdir(~cellfun(@isempty,strfind({restdir.name},'dtseries')));
    vcidlist = vcidlist(~cellfun(@isempty,strfind({vcidlist.name},'vc')));

    disp(sprintf('%i resting sessions found for subject %s: %s', size(vcidlist,1), lesssubs{i}, datestr(now)));

    % Load rest tmasks
    load(['/!!Your Path to MSC Resting State Data Here!!/' lesssubs{i} '/Functionals/FCPROCESS_SCRUBBED_UWRPMEAN/QC.mat'])
    
    % Load and concatentate data
    for k=1:length(vcidlist)
        
        vcid = vcidlist(k).name;
        
        disp(sprintf('Loading timeseries for session %s for subject %s rest: %s', vcid, lesssubs{i}, datestr(now)));
        
        

        data = ft_read_cifti_mod(['/!!Your Path to MSC Resting State Data Here!!/' lesssubs{i} '/Functionals/FCPROCESS_SCRUBBED_UWRPMEAN/cifti_timeseries_normalwall_native_freesurf/' vcid]);
        disp(sprintf('Loading data size %i by %i, %s', size(data.data,1), size(data.data,2), datestr(now)));
        data = data.data;
        

      	% Load rest tmasks
     	load(['/!!Your Path to MSC Resting State Data Here!!/' lesssubs{i} '/Functionals/FCPROCESS_SCRUBBED_UWRPMEAN/QC.mat']);
        
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
%Save Subject's Time Series%
sizelog(i,:)=size(catData);
S(i).f1 = catData;

    catData = []; %DMS added this and it is critical%
end
%Trim Number of time points to the number for the subject with the min number of time points   
MinDur=min(sizelog(:,2));
for trim=1:length(lesssubs);
    S(trim).f1=S(trim).f1(:,1:MinDur);
end
%Get the Average Time Series%
%Sum & Div for Ave
SumData=zeros(size(S(1).f1)); %Does not matter which index since they have all been trimmed to the same szie at this point
for gave=1:length(lesssubs);
   SumData=SumData+S(gave).f1;
   S(gave).f1=[];%Remove 
end
NewData=SumData/length(lesssubs);

clearvars S; %clear S for space
%Save the deconn%
templatedeconn = ft_read_cifti_mod(['/!!Your Path Here!!/Atlases/120_avg_corr_LR.dconn.nii']);
templatedeconn.data=paircorr_mod(NewData');
NewData = []; %This is critical%
ft_write_cifti_mod(['/!!Your Path Here!!/MSCAve/',char(subs(thesub)),'_Exc_MSCAveCorr.dconn.nii'],templatedeconn);
end
