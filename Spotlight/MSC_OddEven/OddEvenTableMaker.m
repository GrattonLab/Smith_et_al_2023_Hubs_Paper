%Gather Data for Odd Even Analysis
load('/!!Your Path Here!!/Spotlight/MSC_OddEven/OddEven_HubLoopTest.mat'); %load data
MinO=zeros(9,10);
MinE=zeros(9,10);
DO=zeros(9,10);
DE=zeros(9,10);
TestO=zeros(9,10);
TestE=zeros(9,10);
TestDO=zeros(9,10);
TestDE=zeros(9,10);
for i=1:10; %for each hub
    for ii=1:9; %for each subject
        [Omind,Ominidx]=min(DistanceSaveOdd{i,ii});
        [Emind,Eminidx]=min(DistanceSaveEven{i,ii});
        TestO(ii,i)=DistanceSaveOdd{i,ii}(Eminidx);
        TestE(ii,i)=DistanceSaveEven{i,ii}(Ominidx);
        DO(ii,i)=OrigDistOdd(ii,i)-Omind;
        DE(ii,i)=OrigDistEven(ii,i)-Emind;
        TestDO(ii,i)=OrigDistOdd(ii,i)-TestO(ii,i);
        TestDE(ii,i)=OrigDistEven(ii,i)-TestE(ii,i);
        MinO(ii,i)=Omind;
        MinE(ii,i)=Emind;
    end
end
%A is for the mean and B is for the SD%
MeanOrigO=transpose(mean(OrigDistOdd));
SDOrigO=transpose(std(OrigDistOdd));
MeanOrigE=transpose(mean(OrigDistEven));
SDOrigE=transpose(std(OrigDistEven));
MeanMinO=transpose(mean(MinO));
SDMinO=transpose(std(MinO));
MeanMinE=transpose(mean(MinE));
SDMinE=transpose(std(MinE));
MeanTestO=transpose(mean(TestO));
SDTestO=transpose(std(TestO));
MeanTestE=transpose(mean(TestE));
SDTestE=transpose(std(TestE));
MeanDO=transpose(mean(DO));
SDDO=transpose(std(DO));
MeanDE=transpose(mean(DE));
SDDE=transpose(std(DE));
MeanTestDO=transpose(mean(TestDO));
SDTestDO=transpose(std(TestDO));
MeanTestDE=transpose(mean(TestDE));
SDTestDE=transpose(std(TestDE));
%Save Data (averaged across subjects) as a table 
Names={'Original_Dist_Odd','Original_Dist_Even','Min_Dist_Odd','Min_Dist_Even','Delta_Dist_Odd','Delta_Dist_Even','Test_Dist_Odd','Test_Dist_Even','Test_Delta_Dist_Odd','Test_Delta_Dist_Even'};
A=[MeanOrigO,MeanOrigE,MeanMinO,MeanMinE,MeanDO,MeanDE,MeanTestO,MeanTestE,MeanTestDO,MeanTestDE];
B=[SDOrigO,SDOrigE,SDMinO,SDMinE,SDDO,SDDE,SDTestO,SDTestE,SDTestDO,SDTestDE];
mytableMean=array2table(A,'VariableNames',Names);
mytableSD=array2table(B,'VariableNames',Names);
writetable(mytableMean,'OddEvenMean.csv');
writetable(mytableSD,'OddEvenSD.csv');