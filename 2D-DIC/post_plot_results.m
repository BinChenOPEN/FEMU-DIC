clear, clc,
%% Specify the parameters in the following
Params_plot = 'exy'; % select between exx, eyy,exy, u, v
Params_file = '/Users/binchen/Downloads/FEMU-DIC-main-4/Demo/VirtualImage/Params.mat'; % parameter files
data_file = '/Users/binchen/Downloads/FEMU-DIC-main-4/Demo/VirtualImage/Img_Simu_0001.mat'; % data file for the figure
ImRef_file = '/Users/binchen/Downloads/FEMU-DIC-main-4/Demo/VirtualImage/Img_Simu_0000.bmp'; % Reference image
ImDef_file = '/Users/binchen/Downloads/FEMU-DIC-main-4/Demo/VirtualImage/Img_Simu_0001.bmp'; % Deformed image

%%
load(Params_file);
load(data_file);

ImRef = imread(ImRef_file); 
ImDef = imread(ImDef_file);

if size(ImRef,3)>1
    ImRef = rgb2gray(ImDef);
    ImDef = rgb2gray(ImDef);    
end
ImRef = repmat(uint8(ImRef),1,1,3);
subplot(1,2,1);
imagesc(ImRef);
axis tight,axis equal,axis off

plotOnImg(Params, ImDef,comptPoints, Disp,Strain, Params_plot); 