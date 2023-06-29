The scripts and functions in this folder make subject to group average connectivity profile similarity maps and determine similarity to network templates


MakeRestDeconnMSC_Sim.m: This script makes the similarity maps aka spatial correlation maps of the MSC individual level connectivity profile with the group average connectivity profile (WashU-120 reference set). This script basically gets data ready to be processed by createSptlcorr_MSCdconns.m

MakeRestDeconnMSC_NetworkTemps.m: This script produces similarity maps between subject level connectivity profiles and the canonical network templates

createSptlcorr_MSCdconns.m: This function actually makes the similarity map with input from MakeRestDeconnMSC_Sim.m (it is called in the script)

createSptlcorr_MSCdconns_NetCorr.m: This function actually makes the similarity map (between each of the 14 network templates and a given subject) with input from MakeRestDeconnMSC_NetworkTemps.m (it is called in the script)

The following two functions are used by the code above

paircorr_mod.m
FisherTransform.m