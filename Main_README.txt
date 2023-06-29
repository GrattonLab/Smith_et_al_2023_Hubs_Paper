The included functions and scripts were used in Smith et al., (2023). This code can be used to conduct the primary analyses employed in the aforementioned article. Each analysis folder contains its own README document describing the scripts and functions stored in the folder.  In addition, to an analysis folder’s main scripts supporting scripts and functions specific to the given analysis folder (e.g., calculating Fisher-Z transforming correlation coefficients) are included. General utilities like scripts and functions for reading and writing CIFTI and GIFTI files (https://github.com/fieldtrip/fieldtrip/) that were widely used across analyses (some of these scripts were modified) can be found at https://github.com/GrattonLab/Kraus_2021_TaskRestVariants/tree/main/dependencies. The presence of addpath(genpath('/!!Your Path Here!!/General_Utilities')) in a script indicates that these utilities are needed. 

It should be noted that Connectome Workbench (https://www.humanconnectome.org/software/get-connectome-workbench) is necessary for running a significant portion of the code contained in these folders. 

Descriptions of Analysis Folders

MSCAve: The scripts in this folder make leave one out (MSC-1) group average connectivity profiles based on the MSC dataset and produce similarity maps for the MSC subject connectivity profiles and the leave one out group average connectivity profiles. 

PowerROI_PCSimCorr: The scripts contained in this folder evaluate the relationship between the participation coefficient values of the regions of interest reported in Power et al., (2013) and the similarity to the group average connectivity profile for these locations in the MSC subjects. 

Rotation: Contains scripts and functions used to rotate hub regions. The resulting rotations can be used as null distributions for metrics of interest like the variant density of the locations overlapping with hubs. 

SimMapFigs: Contains scripts used to make figures depicting the similarity of the hub regions to the group average connectivity profile for the MSC and HCP datasets. 

SimMaps: The scripts and functions in this folder generate similarity maps between the MSC subject connectivity profiles and the group average (WashU-120) connectivity profile. Scripts for producing similarity maps between MSC subject connectivity profiles and network templates are included in this folder as well. 

SimRot: Contains a script for analyzing and producing figures comparing the similarity to the group average connectivity of the actual hub locations with the similarity to the group average connectivity profile of randomly rotated hub locations (a null distribution). 

Spotlight: Contains scripts which conduct the various spotlight analyses described in the manuscript. 
