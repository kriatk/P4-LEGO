data = importdata('feature_space_fullset_faceup.mat');

%these 2 belov takes... like.. A WHILE and will make you cpu on fire
mdl = fitcecoc(data,'Label'); 
CVMdl = crossval(mdl);

oosLoss = kfoldLoss(CVMdl);

