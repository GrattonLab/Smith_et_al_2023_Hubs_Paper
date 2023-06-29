The scripts in this folder conduct the rotation of the hub sets.


These scripts are derived from code written by BAS at WashU and BTK at Northwestern. 

Rotate_Parcels_Hubs.m: This script randomly rotates a set of parcels. The rotations are conducted in a GIFTI (hemisphere) and the GIFTIs with the rotations are combined into a CIFTI file.     

generate_rotated_parcellation_Hubs.m: This script randomly rotates sets of hubs. The rotations are performed in each hemisphere. If any of the hubs/parcels intersect with the medial wall the rotation was recalculated until none of the members of the set intersected with the medial wall.It outputs gifti files with the rotations for each hemisphere.

Supporting Functions

attribute_gifti_data_to_cifti.m
cifti_write_wHDR.m
