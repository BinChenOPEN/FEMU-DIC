function [Disp,strain,ZNCC,iterNum,Params] = DIC_local(imgPath,defFile,ImRef,Params)
% Most of the DIC operation are called in this function, including the
% B-spline filter of the images, the initial guess of the seed point and
% most importantly, the matching of the two images.
% Author: Bin Chen;
% E-mail: binchen@kth.se
% Update: 2021-06-04

subplot(1,2,2);
title(defFile,'Interpreter','none');
ImDef                = double(imread(fullfile(imgPath,defFile)))/(2^Params.Bit_Depth-1);
if length(size(ImDef)) == 3
    ImDef              = double(rgb2gray(ImDef));
end
h                    = fspecial('gaussian',5,1);
ImDef                = imfilter(ImDef,h);
ImDef                = BsplineFilter(ImDef);

imshow(repmat(ImDef,1,1,3));

% Initialize the displacement for the seed point
if Params.fixed_seedPts
    InitMatP         = Params.InitP(1:2,1);
else
    ImRef_TEMP       = double(imread(fullfile(Params.Folder,Params.defFile0)))/(2^Params.Bit_Depth-1);
    if length(size(ImRef_TEMP)) == 3
        ImRef_TEMP              = double(rgb2gray(ImRef_TEMP));
    end

    h                = fspecial('gaussian',5,1);
    ImRef_TEMP       = imfilter(ImRef_TEMP,h);
    ImRef_TEMP       = BsplineFilter(ImRef_TEMP);
    InitMatP         = findInitP(ImRef_TEMP,ImDef,Params,Params.InitP(:,1),Params.InitP(:,1));
end

pCoord               = Params.InitP; % the coordinate of a seed point
% the initial guess of the displacement at seed point
Params.InitMatP      = InitMatP;
Params.InitDispP     = InitMatP-pCoord(1:2,1);

% Registration method
switch Params.IterMethod    
    case {'IC-GN-RG','IC-LM-RG'}
        outP                 = zeros(Params.NumCalPt,6);
        
        p                    = [Params.InitDispP(1),0,0,Params.InitDispP(2),0,0]';
        [Disp,strain,ZNCC,iterNum] = DICmatch_RG(ImRef,ImDef,pCoord,p,Params,outP);
    
end



