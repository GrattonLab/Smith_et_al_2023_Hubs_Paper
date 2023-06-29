%Opens output of AveSpatCorrToGroupForPowerTop10MSC and gets basic stats

%load AveSpatCorrToGroupForPowerTop10MSCFinal.m output file
load('/!!Your Path Here!!/SpatCorrMSC.mat');
SimAveVec=zeros(10,1);
for i=1:10; %Average across subjects for each hub
    SimAveVec(i)=mean(AveCorrSave(i,:));
end
GrandAve=mean(SimAveVec);
GrandSD=std(SimAveVec);