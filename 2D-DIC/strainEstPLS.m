function strain = strainEstPLS(Disp,Params)
% Calculate the strain fields based on the displacement based on pointwise
% least-squares.

% Ref: B. Pan, Full-field strain measurement using a two-dimensional
% Savitzky-Golay digital differentiator in digital image correlation,
% Opt. Eng. 46 (2007) 033601.

% Author: Bin Chen;
% E-mail: binchen@kth.se
% Update: 2021-06-04

order         = 1;
strainWinSize = Params.strainWin;
X             = Params.comptPoints;

ROIsize       = [Params.Lx,Params.Ly];
switch order
    case 1
        A             = NaN(prod(ROIsize),3);
    case 2
        A             = NaN(prod(ROIsize),6);
end

B             = A;
halfWsize     = floor(strainWinSize/2);

x = reshape(X(:,1),ROIsize);    y = reshape(X(:,2),ROIsize);
u = reshape(Disp(:,1),ROIsize); v = reshape(Disp(:,2),ROIsize);

GS_filter_x = 3/((strainWinSize(1))^2*(halfWsize(1)+1)*halfWsize(1)*Params.Step).*...
    repmat([-halfWsize(1):halfWsize(1)]',1,strainWinSize(1));

GS_filter_y = GS_filter_x';

ux = imfilter(u,GS_filter_x);
uy = imfilter(u,GS_filter_y);
vx = imfilter(v,GS_filter_x);
vy = imfilter(v,GS_filter_y);
A(:,2) = ux(:);
A(:,3) = uy(:);
B(:,2) = vx(:);
B(:,3) = vy(:);

for i = 1 : ROIsize(1)
    for j = 1 : ROIsize(2)
        if ~isnan(u(i,j))

            %             wWin            = w(xVec,yVec);

            % indNoNan        = find(~isnan(uWin(:)));
            if ~isnan(ux(i,j))
                % if isempty(indNan) && (length(uWin(:)) == prod(strainWinSize))
                % A((j-1)*ROIsize(1)+i,2) = sum(sum(GS_filter_x.*uWin));
                % A((j-1)*ROIsize(1)+i,3) = sum(sum(GS_filter_y.*uWin));
                % B((j-1)*ROIsize(1)+i,2) = sum(sum(GS_filter_x.*vWin));
                % B((j-1)*ROIsize(1)+i,3) = sum(sum(GS_filter_y.*vWin));

            else
                xVec            = max(1,i-halfWsize) : min(ROIsize(1),i+halfWsize);
                yVec            = max(1,j-halfWsize) : min(ROIsize(2),j+halfWsize);

                if length(xVec)<=2 || length(yVec)<=2
                    continue;
                end
                uWin            = u(xVec,yVec);
                vWin            = v(xVec,yVec);
                indNan          = find(isnan(uWin(:)));

                xCen            = x(i,j);
                yCen            = y(i,j);

                xWin            = x(xVec,yVec);
                yWin            = y(xVec,yVec);
                deltax          = xWin(:)-xCen;
                deltay          = yWin(:)-yCen;

                uWin(indNan)    = [];
                vWin(indNan)    = [];
                deltax(indNan)  = [];
                deltay(indNan)  = [];

                coeff           = [ones(numel(deltax),1),deltax,deltay]';
                coeffMat        = (coeff*coeff')\coeff;
                A((j-1)*ROIsize(1)+i,:) = coeffMat*uWin';
                B((j-1)*ROIsize(1)+i,:) = coeffMat*vWin';

            end
        end
    end
end


% output the strain
exx      = A(:,2);
eyy      = B(:,3);
exy      = (A(:,3)+B(:,2))/2;
strain   = [exx,eyy,exy];
% surf(reshape(exx(:,1),ROIsize)),shading interp,axis tight, axis equal, view([0,90]);
% std(exx)
% std(eyy)
