function svm_classify_loo(fea_dir, c_svm, class ,knn)

clname = {'Applelogos', 'Bottles', 'Giraffes', 'Mugs', 'Swans'};
class_name = clname{ class };
load('data/partion.mat');

trn_ixs = Partion( class ).trn_ixs ;
tst_pos = Partion( class ).tst_pos ;
tst_neg = Partion( class ).tst_neg ;
tst_ixs = [ tst_pos ; tst_neg ];
tst_num = length( tst_ixs );
fdatabase = retr_database_dir(fea_dir, '*_code.mat');

train_model( fdatabase,class_name,trn_ixs );
model = loadmodel( ['result/' lower( class_name ) '/' lower( class_name ) '.model'] ,knn * 21 );
%[w,b] = train_rmisvm( fdatabase, class_name, trn_ixs );
ap = zeros(8,1);

ids = [];
BB = [];
gt1 = cell( length( tst_num ) , 1 );
det = cell( length( tst_num ) , 1 );

npos = 0;
for test_img_idx = tst_pos'
  
    fpath = fdatabase.path{test_img_idx  };
    t_base = fpath(1 : length(fpath) - 8 - 7 );
    idd = strfind( t_base,'/');
    name = t_base( idd(end) + 1 : end);

    load( fpath , 'feas','bbs');
    feas = feas';
    label2 = zeros( size( feas,1), 1 );
    [ label2 , ~ , prob_estimates ] = svmpredict( label2,feas,model,'-b 1' );
    %label2 = rmipredict(feas,label2,w,b );

    idx = find( label2 == 1 );
    bbs(:,5 ) = prob_estimates( :,1);
    bbs = bbs( idx,:);
    [~,iddd ] = sort( bbs(:,5), 'descend');
    bbs = bbs( iddd ,:);
   
        pick = nms( bbs, 5 * 0.1 ) ;
        bbs = bbs(pick,:);
        nbbs = size(bbs,1);   
        ids = [ ids ;ones( nbbs , 1 ) * test_img_idx ];

        gt_fname = [t_base '_' lower( class_name ) '.groundtruth'];
        gt_found = exist(gt_fname, 'file');
        if gt_found == 2 
            fprintf('process postive test image: %d of %d\n', test_img_idx, tst_num );
            gtBB = load(  gt_fname ) ;
            npos = npos + size(gtBB,1);
            gt1{ test_img_idx } = gtBB;
            det{ test_img_idx } = zeros( size(gtBB,1),1);
            bbs(:,6 ) = 1;
            BB = [ BB ; bbs ];
        else
            fprintf('process negtive test image: %d of %d\n', test_img_idx, tst_num );
            bbs(:,6 ) = -1;
            BB = [ BB ; bbs ];
        end   
    %save(['result/' lower( class_name ) '/' name '.mat'],'bbs','-v7.3');
    if 0           
        for ii = 1 : size(bbs,1)
           I = imread( [ t_base '.jpg'] );figure(1);imshow(I); hold on;
           rectangle('position',bbs(ii,1:4), 'LineWidth',2,'LineStyle','--', 'EdgeColor','c');
           saveas(gcf,['result/' lower( class_name ) '/' name '_' num2str(ii) '.jpg' ]);
           close all;
        end
    end
end
temp.gt = gt1;
temp.det = det;
save(['result/' lower( class_name ) '/evaluation.mat'],'temp','ids','BB','npos','tst_num','-v7.3');




