clear;clc;
addpath('include/llc/');
addpath('include');
addpath('include/edge_linking');
addpath(genpath( 'include/edge_re_linking' ));
addpath('include/idsc_distribute/common_innerdist/');
addpath('include/vlfeat-0.9.20/toolbox');
addpath('EdgeBoxes/')
addpath(genpath( 'toolbox-master') ) ;
addpath('include/libsvm-master/matlab/')
vl_setup;

img_dir = 'data/ETHZ';
fea_dir = 'data/ethz_feas';
codebook_path = 'data/ethz_codebook.mat';
fmt = '*.jpg';


para.n_shapesamp = 2000;
para.n_contsamp = 50;
para.max_curvature = 0.5;
para.n_pntsamp = 100;
para.k_sc = 1000;
para.knn = 5;
clname = {'Applelogos', 'Bottles', 'Giraffes', 'Mugs', 'Swans'};

model=load('models/forest/modelBsds'); model=model.model;
model.opts.multiscale = 2; model.opts.sharpen=2; model.opts.nThreads=4;

%% set up opts for edgeBoxes (see edgeBoxes.m)
opts = edgeBoxes;
opts.alpha = .85;     % step size of sliding window search
opts.beta  = .55;     % nms threshold for object proposals
opts.minScore = .05;  % min score of boxes to detect
opts.maxBoxes = 1e4;  % max number of boxes to detect

C = 3;
tr_num = 10;                % number of training images
nRounds = 10;
pyramid = [1, 2, 4];          %[1,2,3,4];

%normalize_shape(img_dir, '*.tif');
%extr_cf(img_dir, '*.bmp', para);
%learn_codebook(img_dir, codebook_path, para);
%encode_cf(img_dir, codebook_path, para, model, opts);
%pyramid_mmpooling(img_dir, model,codebook_path,opts);
for class = 1 : 10
    svm_classify_loo( img_dir, C, 2 ,para.k_sc);
    [recall, prec, ap ] = evaldet( 2 ,1);
end