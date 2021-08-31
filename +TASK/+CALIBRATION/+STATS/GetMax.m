function GetMax( S )

f = figure('Name',S.DataFileName,'NumberTitle','off');
a = axes(f);

time       = S.SR.Get('time' ,[]);
vect_Left  = S.SR.Get('Left' ,[]);
vect_Right = S.SR.Get('Right',[]);

hold(a,'on')
plot(a,time,vect_Left ,'b')
plot(a,time,vect_Right,'r')
legend('Left','Right')

[Y_Left ,I_Left ] = max(vect_Left );
[Y_Right,I_Right] = max(vect_Right);

plot(time(I_Left), Y_Left  , 'sb', 'LineWidth', 5, 'MarkerSize',5)
plot(time(I_Right), Y_Right, 'sr', 'LineWidth', 5, 'MarkerSize',5)

fprintf('max Left : %0.3f - max Right : %0.3f \n', Y_Left, Y_Right)


end % function
