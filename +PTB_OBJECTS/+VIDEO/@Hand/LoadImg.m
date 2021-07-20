function LoadImg( self, autocrop, invert, smoothing_kernel )

if nargin < 2
    autocrop = 0;
end
if nargin < 3
    invert = 0;
end


%% Load image in MATLAB

[X, ~, alpha] = imread(self.fpath);


%% Invert

if invert
    X = 255 - X;
end


%% Smoothing

if smoothing_kernel
    
    grid_size       = round(smoothing_kernel*2.0);                           % the size of the grid must be big enough to sample a gaussian curve
    [grid_x,grid_y] = meshgrid(-grid_size:grid_size, -grid_size:grid_size);  % create the 2D kernel matrix
    sigma           = smoothing_kernel / (2 * sqrt(2*log(2)));               % conversion from FWHM to Sigma
    envelope        = 255 * exp( -(grid_x.^2 + grid_y.^2) / (2 * sigma^2) ); % and here is the gaussian kernel
    
    X = double(X); % convert to double, or else i have mismatched between uint8 inputs and conv2 double outputs
    for i = 1 : 3 % for each channel (RGB)
        X(:,:,i) = conv2( X(:,:,i), envelope, 'same' );
        X(:,:,i) = 255 * X(:,:,i)/max(reshape(X(:,:,i),[1 numel(X(:,:,i))])); % normalize to [0 255]
    end
    
    alpha = double(alpha);
    alpha = conv2( alpha, envelope, 'same' );
    alpha = 255 * alpha/max(alpha(:));
    
end


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


%% Generate rect

self.rect_Base = [0 0 size(X,2) size(X,1)];


%% Save

self.X     = X;
self.alpha = alpha;


end % function
