The scripts in this folder conduct the spotlight analysis


SpotlightLoop.m: The script is the first step in the spotlight analysis. It produces a set of potential hubs by dilating each vertex in a search zone. The script yields potential adjusted hubs (stored in a file folder), which are made by dilatation (5mm) around every vertex in zone aka the spotlight made by dilating 10mm around the center point of the original(the zone file is given as an input). The aforementioned files and a Pointlog.mat file are used to conduct the spotlight analysis.  

SpotlightGroupNetworksWashU.m: This script finds new hub locations for each of the 10 Power Hubs.  It uses the WashU-120 group average connectivity profile as a reference. It finds the adjusted hub locations based on locations in the spotlight with at least 70% of their vertices overlaping with the mode network and compares the network profile of the trimmed hubs (locations that meet the threshold are trimmed down so that all post-trim vertices are in the mode network) with the WashU ref and the trimmed hub with the min euclidean distance from the WashU ref is chosen as the adjusted hub location.

OrigHubsGroupNetworks.m: This script makes firgures for the original non-adjusted hub locations depicting their netowrk profiles

RedBlueColorMapMaker.m: Makes figures for original and adjusted hubs in the red-blue colormap. It uses the output from OrigHubsGroupNetworks.m and SpotlightGroupNetworksWashU.m



Supporting Functions

redblue.m: Red-Blue colormap 