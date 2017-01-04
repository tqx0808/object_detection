
% a improved edgelink version by Xg Wang (mailto: wxghust@gmail.com)

function [list2] = imlink(bw, radius, mincurv)

	if nargin == 1
		radius = 5;
		mincurv = 0.6;
	end
	
	elist = edgelink(bw);
	
	recorder = [];
	curv_map = zeros(size(bw) );
	
	for n = 1:length(elist)
		pnts = elist{n};
		recorder = [recorder; [n, 1] ];
		
        c = 0;
		for k = radius+1 : size(pnts, 1)-radius
            c = c + 1;
			pnt = pnts(k, :);
			curv = curvature(pnts, k, radius);
			curv_map(pnt(1), pnt(2)) = curv;
			if abs(curv) > mincurv && c > 2*radius
				recorder = [recorder; [n, k] ];
                c = 0;
			end
		end
	end
	
	list2 = cell(1, size(recorder, 1) );
	
	for n = 1:size(recorder, 1)
		if n == size(recorder, 1)
			list2{n} = elist{recorder(n, 1)}(recorder(n, 2): end, :);
        elseif recorder(n, 1) ~= recorder(n+1, 1)
			list2{n} = elist{recorder(n, 1)}(recorder(n, 2): end, :);
        elseif recorder(n, 1) == recorder(n+1, 1)
			list2{n} = elist{recorder(n, 1)}(recorder(n, 2): recorder(n+1, 2), : );
		end
    end
	
    if 0
    figure, imshow(bw); hold on
    for n = 1:length(list2)
        clr = rand(1,3);
        plot(list2{n}(:,2), list2{n}(:,1), 'Color', clr );
        text( round(mean(list2{n}(:,2))), round(mean(list2{n}(:,1))), int2str(n), 'Color', clr );
    end
    end
        
	
	
	
	
	
	
	
	
	
	
	
	