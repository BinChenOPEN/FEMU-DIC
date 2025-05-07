function Params = readSpeckleImageFiles()
% first select the refenrence image, and deformed image. The file names are
% selected in Params

% [refFile, imgPath]   = uigetfile({'*.bmp;*.tiff;*.tif'},'Select reference image');
% Params.fileDef_All{1}   = refFile;
% [dataFileAllTemp, imgPath] = uigetfile({'*.bmp;*.tiff;*.tif'},'MultiSelect','on',...
%     'Select deformed images');
% if ~iscell(dataFileAllTemp)
%     Params.fileDef_All{2} = dataFileAllTemp;
% else
%     for i = 1:length(dataFileAllTemp)
%         Params.fileDef_All{i+1} =  dataFileAllTemp{i};
%     end
% end
% Params.Folder        = imgPath;


[dataFileAllTemp, imgPath] = uigetfile({'*.bmp;*.tiff;*.tif;*.png;*.jpg;*.jpeg'},'MultiSelect','on',...
    'Select deformed images');

for i = 1:length(dataFileAllTemp)
    Params.fileDef_All{i} =  dataFileAllTemp{i};
    if i == 1
        img = imread(fullfile(imgPath,Params.fileDef_All{i}));
        is_uint8 = isa(img, 'uint8');
        is_uint16 = isa(img, 'uint16');
        is_uint24 = isa(img, 'uint24');
        is_uint32 = isa(img, 'uint32');
        if is_uint8
            Params.Bit_Depth = 8;
        end
        if is_uint16
            Params.Bit_Depth = 16;
        end
        if is_uint24
            Params.Bit_Depth = 24;
        end

        if is_uint32
            Params.Bit_Depth = 32;
        end
    end
end

Params.Folder        = imgPath;

