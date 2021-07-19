function Plot( self )

f  = figure('Name',self.fpath,'NumberTitle','off');
ax = axes(f);
imagesc(ax, self.X)
set    (ax, 'XAxisLocation', 'top')
axis   (ax, 'equal')

end % function
