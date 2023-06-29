%This script makes adjusted hub density maps%

%First add path to cifti functions (provided in the General_Utilities folder)%
addpath(genpath('/!!Your Path Here!!/General_Utilities'));
%Make Adj Hub Den Map for Each Power Hub for the Mode Network Method for the Hubs That Need New Ref Subj%
hubnum=10;
tarhubs=[1,2,3,4,5,6,7,8,9,10];
subnum=9;
template=ft_read_cifti_mod(['!!Your Path Here!!/top10PC_5mm_ROIs.dtseries.nii']);%Use as a template%
subs={'01','02','03','04','05','06','07','09','10'};
for i=1:hubnum;
    newtemp=zeros(size(template.data,1),1);
    for ii=1:subnum;
      adjmap=ft_read_cifti_mod(['!!Your Path Here!!/Spotlight/AdjHubsGroupNetworks/Hub',char(num2str(tarhubs(i))),'MSC',char(subs(ii)),'_trim.dtseries.nii']); 
      refvec=adjmap.data~=0;
      newtemp=newtemp+refvec; %Add this subject's adj hub%
    end
    %put in prt terms%
    denvec=(newtemp./subnum)*100;
    template.data=denvec;
    ft_write_cifti_mod(['!!Your Path Here!!/Spotlight/AdjHubDen/WashUGroupAdjustedHub',char(num2str(tarhubs(i))),'Den.dtseries.nii'],template);
end