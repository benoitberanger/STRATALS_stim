function LoadImg( self, autocrop, invert )

if nargin < 2
    autocrop = 0;
end
if nargin < 3
    invert = 0;
end


%% Load image in MATLAB

[X, ~, alpha] = imread(self.fpath);


%% Auto crop

if autocrop
    
    mask = alpha>0;
    
    % horizontal crop limit
    vsum = sum(mask,1);
    lr_limits = find(diff(vsum>0));
    left_lim  = lr_limits(1);
    right_lim = lr_limits(2) +1 ;
    
    % horizontal crop limit
    hsum = sum(mask,2);
    ud_limits = find(diff(hsum>0));
    up_lim  = ud_limits(1);
    down_lim = ud_limits(2) +1 ;
    
    % do the crop
    X = X(up_lim:down_lim,left_lim:right_lim,:);
    alpha = alpha(up_lim:down_lim,left_lim:right_lim);
    
end

%% Invert

if invert
    X = 255 - X;
end


%% Generate rect

self.rect_Base = [0 0 size(X,2) size(X,1)];


%% Save

self.X     = X;
self.alpha = alpha;


end % function
