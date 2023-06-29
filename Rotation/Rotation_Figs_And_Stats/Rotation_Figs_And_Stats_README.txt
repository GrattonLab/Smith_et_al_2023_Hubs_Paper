These scripts filter out low signal regions from the rotations 
and they make plots of the actual overlap and the overlap for the 
rotations. The two sets of scatter plot scripts could be condensed
into a single script (e.g., combine the ComDen and PC Collective scripts).


OrigHubLSOverlapCalc.m: Determines the degree to which hubs overlap with a low signal mask

FiltCollective.m: This script filters out low signal regions from the collective hub rotations.

FiltSingle.m: This script filters out low signal regions from the single hub rotations.

Scatter_Plot_Collective_ComDen.m: This script makes scatter plots of the ComDen collective rotation distribution and calculates confidence intervals.

Scatter_Plot_Collective_PC.m: This script makes scatter plots of the PC collective rotation distribution and calculates confidence intervals.

Scatter_Plot_Single_ComDen.m: This script makes scatter plots of the ComDen single hub (1 per hemi) rotation distribution and calculates confidence intervals.

Scatter_Plot_Single_PC.m: This script makes scatter plots of the PC single hub (1 per hemi) rotation distribution and calculates confidence intervals.

NullDistStatCalc.m: This script gets basic summary stats for the rotation distributions.