function Stability( S )

Stability = S.Stability;

for evt = 1 : size(Stability.Data,1)
    
    % get Side
    side_num = Stability.Get('side',evt);
    switch side_num
        case -1
            side = 'Left';
        case +1
            side = 'Right';
    end
    
    % get timeseries
    vect            = S.SR.Get(side,Stability.Get('sample_start',evt):Stability.Get('sample_stop',evt));
    
    deviation       = vect - 1;
    n               = length(vect);
    score_accuracy  = mean(abs(deviation)); % lower is better
    overshoot       = deviation>0;
    undershoot      = deviation<0;
    n_overshoot     = sum(overshoot );
    n_undershoot    = sum(undershoot);
    ratio_over_under= (n_overshoot - n_undershoot) / n; % +++ => more overshoot, --- => more undershoot
    score_overshot  = mean(deviation(overshoot ));
    score_undershot = mean(deviation(undershoot));
    score_stability = mean(abs(diff(deviation)));
    
    Stability.Data(evt,Stability.Get('score_accuracy'  )) = score_accuracy;
    Stability.Data(evt,Stability.Get('ratio_over_under')) = ratio_over_under;
    Stability.Data(evt,Stability.Get('score_overshot'  )) = score_overshot;
    Stability.Data(evt,Stability.Get('score_undershot' )) = score_undershot;
    Stability.Data(evt,Stability.Get('score_stability' )) = score_stability;
    
end


end
