%Get the Post Low Signal Filtering Null Dist Mean and SD Variant Density for both HCP and MSC and both PC and CD

%Be sure to load the output of the scripts that make the collective and
%single rot plots (actual overlap and overlap for the rotations)

%First do it for the collective rot then the single (aka individual) rot
NullAveCD=zeros(1,2); %Rows are hubs cols are HCP and MSC
NullSDCD=zeros(1,2); 
NullAvePC=zeros(1,2); 
NullSDPC=zeros(1,2); 
for sample=1:2;
        if sample==1; %Determine if HCP or MSC and select the correct storage col HCP=1 MSC=2
            col=1;
            Thedataset='HCP';
        elseif sample==2;
            col=2;
            Thedataset='MSC';
        end
    for hubtype=1:2; %Determine hub type CD=1 and PC=2
        if hubtype==1;
           load(['/!!Your Path Here!!/CollectiveCD',char(Thedataset),'.mat']);
           NullAveCD(1,col)=nanmean(AveAllOverlap(1,:));
           NullSDCD(1,col)=nanstd(AveAllOverlap(1,:));
        elseif hubtype==2;
           load(['/!!Your Path Here!!/CollectivePC',char(Thedataset),'.mat']);
           NullAvePC(1,col)=nanmean(AveAllOverlap(1,:));
           NullSDPC(1,col)=nanstd(AveAllOverlap(1,:));
        end
        
    end
end
%Now do it for Single/Indiv Rots

%Get Null Mean and SD for single hubs (each hemi) for HCP dataset
PCIndivHCPAve=zeros(1,2); %Col 1 is left and col 2 is right
PCIndivHCPSD=zeros(1,2);
CDIndivHCPAve=zeros(1,2);
CDIndivHCPSD=zeros(1,2);
%Note that ydata is just AveValOverlap transposed and the two cols switched so that it goes left --> right
load('/!!Your Path Here!!/IndivCDHCP.mat'); %Load !!Note it does not matter if I open PC or CD since they use the same null dist for the single location rotation
        for thehems=1:2;
            CDIndivHCPAve(1,thehems)=nanmean(ydata(:,thehems));
            CDIndivHCPSD(1,thehems)=nanstd(ydata(:,thehems));
            PCIndivHCPAve(1,thehems)=nanmean(ydata(:,thehems));
            PCIndivHCPSD(1,thehems)=nanstd(ydata(:,thehems));
        end

           
   