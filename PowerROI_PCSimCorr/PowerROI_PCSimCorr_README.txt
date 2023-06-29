The scripts contained in this folder evaluate the relationship between the participation coefficient values of the regions of interest reported in Power et al., (2013) and the similarity to the group average connectivity profile for these locations in the MSC subjects. 

You should input a .dtseries.nii with the cortical locations (vertices) overlaping with the nodes marked by a unique node ID number (we used Power's nodes that were not cerebellum/subcortical and that were assigned to a network)
Also, you need text files with Power's ROI numbers and PC values arranged (filtered as described above) in a column. You will need a low signal mask (.dtseries.nii file) as well. 


ROI_SimPC_Corr_Filt.m: This script makes a scatter plot with the best fit line and Power PC Top 10 Hubs marked in a different color from non-hubs for each of the 9 MSC subjects 

PowerTop10Stats.m: This script obtains the average similarity to the group across the Power Top 10 PC Nodes **It needs the output of TopPC_SimCalc.m**

ROI_LowSigOverlap.m: This script marks each Power node with its proportion overlap with the low signal mask

TopPC_SimCalc.m: This script finds the top 25% of nodes in terms of PC and calculates their similarity to the group average connectivity profile. If you want to filter out ROIs that overlap a lot with low signal regions put the output of this script into ROI_LowSigOverlap.m