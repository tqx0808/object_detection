function encoding = fisherEncoding( code_sc, bbs , xy, sz,dict )
%FISHERENCODING Summary of this function goes here
%   Detailed explanation goes here
    pyramid = [1,2,4];
    kmeans = size( dict.mean,2);
    dim = size(code_sc,1 ) *  sum(pyramid.^2) * 2 * kmeans;
    num = size(bbs,1 );
    encoding = zeros( dim , num );
    for ii = 1 : num
        region = bbs(ii , : );
        fea = zeros( size(code_sc,1 ) * 2 * kmeans , sum(pyramid.^2) );
        hgt = region(4);wid = region(3);counter = 0;
        for p = 1:length(pyramid) 
            for i = 1:pyramid(p)
                for j = 1:pyramid(p)
                    yrang = region(2) + hgt*[i-1,i]/pyramid(p);
                    xrang = region(1) + wid*[j-1,j]/pyramid(p);
        
        %plot( xy(:,1), xy(:,2),'*' );
                    idxx = find( ( xrang(1) < xy( : ,1 ) ) .* ( xy(:,1 )< ( xrang( 2 ) ) ) ) ;
                    idxy = find( ( yrang(1) < xy( :, 2 ) ) .* ( xy(:,2) < ( yrang( 2 ) ) ) );
                    idx = intersect( idxx, idxy );
        %plot( xy(idx,1), xy( idx,2), 'r*');
                    if 0
                         rectangle('position',[xrang(1) yrang(1) xrang(2) - xrang(1) yrang(2) - yrang(1) ], 'LineWidth',2,'LineStyle','--', 'EdgeColor','c');
                        for jj = 1 : length(idx)
                            plot( xy( idx(jj),1) , xy( idx(jj), 2), 'c+');
                            plot( pnts{ idx(jj) }(:,1), pnts{ idx(jj) }(:,2),'r' );
                        end
                    end
                    temp = code_sc(:,idx);
                    counter = counter + 1;
                    if isempty( temp )
                        fea(:,counter) = zeros( size(code_sc,1 ) * 2 * kmeans ,1);
                    else
                        maxPool = vl_fisher( single( temp ), dict.mean, dict.cov, dict.pri);
                        %maxPool = max( temp,[],2);
                        %maxPool = sum( temp,2);
                        fea(:, counter ) = maxPool;
                    end
                end
            end
        end
        temp = fea(:);
        if ~ any( temp) 
            feas = zeros( dim,1);
        else 
            feas = temp / sqrt( sum ( temp.^2) );
        end
        encoding(:,ii) = feas;
    end

end



