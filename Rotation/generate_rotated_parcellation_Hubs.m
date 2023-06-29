function verts=generate_rotated_parcellation_Hubs(watershedname,iterations,rotations,iscifti,hem,outfileprefix,analysistarget)

%% Setup
% Set paths and constants

bufsize=16384;
caretdir = '/!!Your Path Here!!/Rotation';
% Read in node neighbor file generated from caret -surface-topology-neighbors
[neighbors(:,1) neighbors(:,2) neighbors(:,3) neighbors(:,4)...
    neighbors(:,5) neighbors(:,6) neighbors(:,7)] = ...
    textread([caretdir '/node_neighbors.txt'],'%u %u %u %u %u %u %u',...
    'delimiter',' ','bufsize',bufsize,'emptyvalue',NaN);
neighbors = neighbors+1;
nonanneighbors = neighbors; nonanneighbors(isnan(neighbors)) = 380;
% Normal wall mask
maskname = ['/!!Your Path Here!!/Atlases/32k_ConteAtlas_v2/medial_wall.' hem '.32k_fs_LR.func.gii'];
mask = gifti(maskname);
mask = mask.cdata;
% Eroded normal wall mask
erodedmask = gifti(['/!!Your Path Here!!/Atlases/32k_ConteAtlas_v2/' hem '.atlasroi_erode3.32k_fs_LR.shape.gii']); erodedmask = erodedmask.cdata;

cross_datatype_indices = [[1:32492]' zeros(32492,2)];
for i=1:size(cross_datatype_indices,1)
    if ~mask(i)
        cross_datatype_indices(i,2) = max(cross_datatype_indices(:,2))+1;
    end
    if erodedmask(i)
        cross_datatype_indices(i,3) = max(cross_datatype_indices(:,3))+1;
    end
end

 realwatershed = watershedname;

parcelIDs = unique(realwatershed); parcelIDs(parcelIDs==0) = [];
numparcels = nnz(unique(realwatershed));
rotstore=cell(numparcels,iterations);
realstore=cell(numparcels,iterations);
surfdir = '/!!Your Path Here!!/Atlases/32k_ConteAtlas_v2_distribute';
sphere = gifti([surfdir '/Conte69.' hem '.sphere.32k_fs_LR.surf.gii']);
spherecoords = sphere.vertices;

disp(['Running ' num2str(iterations) ' random rotations of ' num2str(numparcels) ' parcels'])
rotmap = zeros(32492,iterations);
test = zeros(32492,3);


for iternum = 1:iterations       
    xrot = rotations.rotations.xrot(iternum);
    yrot = rotations.rotations.yrot(iternum);
    zrot = rotations.rotations.zrot(iternum);
    
    rotmat_x = [1 0 0;0 cos(xrot) -sin(xrot); 0 sin(xrot) cos(xrot)];
    rotmat_y = [cos(yrot) 0 sin(yrot); 0 1 0; -sin(yrot) 0 cos(yrot)];
    rotmat_z = [cos(zrot) -sin(zrot) 0; sin(zrot) cos(zrot) 0; 0 0 1];
    
    parcelinds = [];
    
while true      %% Loop to randomly rotate parcels until they end up not on the medial wall and not overlapping
    allrotidx=[];
    for parcelnum = 1:numparcels

        parcelID = parcelIDs(parcelnum);

        realparcelindices = find(realwatershed==parcelID);

        %find parcel center
        meanX = mean(spherecoords(realparcelindices,1));
        meanY = mean(spherecoords(realparcelindices,2));
        meanZ = mean(spherecoords(realparcelindices,3));
        coord = [meanX meanY meanZ];
        sphere_coords = [spherecoords(realparcelindices,1) spherecoords(realparcelindices,2) spherecoords(realparcelindices,3)];
        rep_coord = repmat(coord, [size(sphere_coords,1) 1]);
        dist_coord = sum((sphere_coords-rep_coord).^2,2).^(1/2);
        [y indval] = min(dist_coord);
        centerind = realparcelindices(indval);


        string{parcelnum} = ['Rotation ' num2str(iternum) ': parcel ' num2str(parcelnum)];
        if parcelnum==1; fprintf('%s',string{parcelnum}); else fprintf([repmat('\b',1,length(string{parcelnum-1})) '%s'],string{parcelnum}); end
        
        


            indexcoords = spherecoords(realparcelindices,:)';
                xrotcoords = rotmat_x * indexcoords;
                xyrotcoords = rotmat_y * xrotcoords;
                xyzrotcoords = rotmat_z * xyrotcoords;

            clear rotparcelindices
            for n = 1:length(realparcelindices)

                
                test(:,1) = xyzrotcoords(1,n); test(:,2) = xyzrotcoords(2,n); test(:,3) = xyzrotcoords(3,n);
                diff_test = sum(abs(spherecoords - test),2);
                [val rotparcelindices(n)] = min(diff_test);
                if n==indval
                    rotcenterind = rotparcelindices(n);
                end
            end
            
            %Store indices%
            rotstore{parcelnum,iternum}=rotparcelindices;
            realstore{parcelnum,iternum}=realparcelindices;
            allrotidx=[allrotidx,rotparcelindices];
         end
            % Stop loop if parcel is not on medial wall and does not
            % overlap with existing parcels, else generate random numbers
            % and re-rotate parcel
            
            
            if (numel(intersect(allrotidx,find(mask == 1))) == 0) && (isempty(parcelinds) || (numel(intersect(allrotidx,parcelinds)) == 0))
                
                
                parcelinds = [parcelinds allrotidx];
                
                break
                
            else
                
                xrot = min(rotations.rotations.xrot) + (max(rotations.rotations.xrot)-min(rotations.rotations.xrot))*rand(1,1);
                yrot = min(rotations.rotations.yrot) + (max(rotations.rotations.yrot)-min(rotations.rotations.yrot))*rand(1,1);
                zrot = min(rotations.rotations.zrot) + (max(rotations.rotations.zrot)-min(rotations.rotations.zrot))*rand(1,1);
                
                rotmat_x = [1 0 0;0 cos(xrot) -sin(xrot); 0 sin(xrot) cos(xrot)];
                rotmat_y = [cos(yrot) 0 sin(yrot); 0 1 0; -sin(yrot) 0 cos(yrot)];
                rotmat_z = [cos(zrot) -sin(zrot) 0; sin(zrot) cos(zrot) 0; 0 0 1];
            end


     end    
          
 %Restart the parcel by parcel stuff here%       
        
 for curparcel=1:numparcels;
 parcelID = parcelIDs(curparcel);
 rotparcelindices=rotstore{curparcel,iternum};       
 realparcelindices=realstore{curparcel,iternum};       
            doneadding = 0;
            while doneadding ==0
                rotatedparcel = zeros(size(mask));
                rotatedparcel(rotparcelindices) = 1;
                rotneighvals = rotatedparcel(neighbors(13:end,2:7));
                rotneighvals_top = rotatedparcel(neighbors(1:12,2:6));
                rotverts_toadd = [((sum(rotneighvals_top,2) > 3) .* (rotatedparcel(1:12)==0)) ; ((sum(rotneighvals,2) > 4) .* (rotatedparcel(13:end)==0))];
                if nnz(rotverts_toadd) == 0
                    doneadding = 1;
                else
                    rotatedparcel = rotatedparcel + rotverts_toadd;
                    rotparcelindices = find(rotatedparcel);
                end
            end

                samesize = 0;
                while samesize==0

                    deltaverts = length(rotparcelindices) - length(realparcelindices);
                    rotatedparcel = zeros(size(rotatedparcel)); rotatedparcel(rotparcelindices) = 1; rotatedparcel(logical(mask)) = 2;
                    if sign(deltaverts) == 1

                        borderverts = find((rotatedparcel==1) .* any(rotatedparcel(nonanneighbors(:,2:end))==0,2));

                        if length(borderverts) >= deltaverts
                            rotparcelindices = setdiff(rotparcelindices,borderverts(1:deltaverts));
                            samesize = 1;
                        else
                            rotparcelindices = setdiff(rotparcelindices,borderverts);
                        end
                    elseif sign(deltaverts) == -1

                        borderverts = find((rotatedparcel==0) .* any(rotatedparcel(nonanneighbors(:,2:end))==1,2));

                        if length(borderverts) >= abs(deltaverts)
                            rotparcelindices = union(rotparcelindices,borderverts(1:abs(deltaverts)));
                            samesize = 1;
                        else
                            rotparcelindices = union(rotparcelindices,borderverts);
                        end
                    else
                        samesize = 1;
                    end
                end

 

                    rotmap(rotparcelindices,iternum) = parcelID;
                    


    end
    fprintf(repmat('\b',1,length(string{parcelnum})))

end
    
disp(' ')




watersheds = unique(realwatershed);
watersheds(watersheds==0) = [];
templabel = zeros(size(realwatershed));
for watershednum = 1:length(watersheds)
    watershed = watersheds(watershednum);
    templabel(realwatershed==watershed) = watershednum;
    realsizes(watershednum) = nnz(realwatershed==watershed);
    
end


save(gifti(single(rotmap)),[outfileprefix '_rotatedmaps_YourHubs.func.gii'])

verts = rotmap;         %% Output 
save(['Rot Hubs 1K',hem],'verts','rotmap','rotstore','realstore','realwatershed','realparcelindices')


