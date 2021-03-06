function [ fea1,fea2,labels ] = fea2bag( fea, bbs,gtBB )
%FEA2LABEL �˴���ʾ�йش˺����ժҪ
%   �˴���ʾ��ϸ˵��
    dim = size( fea,1 );
    num = size(fea,2 );
    neg_idx = [];
    pos_idx = [];
    fea1 = [];
    labels = [];
    count = 0;
    for ii = 1 : num 
        corr = false;
        cnt = 0;
        for jj = 1 : size( gtBB,1 )
            %rectangle('position',[gtBB(jj,1) gtBB(jj,2) gtBB(jj,3)- gtBB(jj,1) gtBB(jj,4) - gtBB(jj,2)] , 'LineWidth',2,'LineStyle','--', 'EdgeColor','c');
            bb = bbs( ii, :);
            [ ov1 ] = BBOverlap( bb ,[ gtBB( jj,1 ) gtBB( jj,2 ) ( gtBB( jj,3 ) -gtBB(jj,1) ) ( gtBB( jj,4 ) -gtBB(jj,2) ) ] );
            %[ov2,~ ] = BBOverlap( [ gtBB(1 ) gtBB( 3 ); gtBB( 2 ) gtBB(4 ) ] , [ bb( 1 ) bb(1) + bb(3) ; bb(2 ) bb( 2 ) + bb( 4 ) ]);
            if ov1 > 0.6 
                
                fea1 = [ fea1 fea(:,ii) ] ;
             
                pos_idx = [ pos_idx ii ];
                break;
            elseif ov1 < 0.3 
                cnt = cnt + 1 ;
            end
        end
        if cnt == size( gtBB,1 )
            neg_idx = [ neg_idx ii ];
        end
    end 
    pos_num = size( fea1, 2 );
    labels = [ labels 1  ] ;  
    if  0 
        for ii = 1 : pos_num 
            idx = pos_idx( ii );
            rectangle( 'position', bbs( idx ,1 : 4 ) , 'LineWidth',2,'LineStyle','--', 'EdgeColor','y');
        end
    end
    
    neg_num = min( pos_num * 5 , size( neg_idx ,2  ) );
    N = zeros(size( neg_idx ) );
    n = randperm( size(neg_idx, 2 ),neg_num);
    fea2 = [];
    for ii = 1 : neg_num 
        idx = n(ii);
        fea2 = [ fea2 fea(:, neg_idx ( idx ) ) ];        
    end 
    labels = [ labels -1 ];
end

