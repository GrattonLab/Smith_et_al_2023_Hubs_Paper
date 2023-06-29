%Get the Average Similarity for the Power Top 10 PC Nodes
load('/!!Your Path Here!!/ROISim.mat');%Open Data (Output of TopPC_SimCalc.m)
[B,I]=sort(PCvec);%Sort by PC
SortedSim=AveCorrSave(I,:);%Sort similarity by PC
Top10Sim=SortedSim(1:10,:);%Get the top 10
%Average across hubs and then get the grand average (across subjects)
GrandAveAcrossHubs=mean(Top10Sim);
GrandAveAcrossSubs=mean(GrandAveAcrossHubs);
Top10simCorrSD=std(Top10Sim);
Top10SimCorrRange=[min(Top10Sim),max(Top10Sim)];
%Now do it for the Fisher Z Transformed values
SortedZ=zAveCorr(I,:);%Sort similarity by PC
Top10Z=SortedZ(1:10,:);%Get the top 10
%Average across hubs and then get the grand average (across subjects)
ZGrandAveAcrossHubs=mean(Top10Z);
ZTop10simCorrSD=std(Top10Z);
ZTop10SimCorrRange=[min(Top10Z),max(Top10Z)];