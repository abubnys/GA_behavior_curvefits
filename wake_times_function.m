%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          wake times
%
%   This code takes GA assay data as raw input (can be any length) and
%   calculated "wake" period onset from the 1D filter smoothed data.
%   Output is the indices for wake periods (bout_indx) and the smoothed 
%   trace used to calculate them.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [bout_indx,trc] = wake_times_function(raw)

% smooth raw data
weighted_avg = ones(60,1)./60;
%trc = filfilt(weighted_avg, 1, raw);
spl_trc = fit([1:length(raw)]',raw,'smoothingspline','SmoothingParam',0.0001);
trc = spl_trc(1:length(raw));

% activity threshold: stdev of 600 min bins of data
b_length = 600;
binned_thresh = [];
for e = 1:length(trc)-b_length
    bin = trc(e:e+b_length);
    binned_thresh = [binned_thresh std(bin)];
end
binned_thresh = [binned_thresh ones(1,b_length).*std(bin)]; 

% find the mean of smoothed data separated into bins
% if the bin mean > threshold, consider this a bout of activity
w_size = 30;
bout = zeros(1,length(trc)-w_size);
binned_means = [];
for e = 1:length(trc)-w_size
    bin = trc(e:e+w_size);
    binned_means = [binned_means mean(bin)];
    %if mean(bin) > std(trc)
    if mean(bin) > binned_thresh(e)
        bout(e) = 1;
    end
end
    

% fill in small gaps of low activity within a larger activity bout

nap_max_length = 150;
c = 0;
c_start = 0;
bout_filled = bout;
c_filled = [];

for e = 2:length(bout)
    if c_start == 1
        c = c+1;
    end
    if bout(e) == 0 && bout(e-1) == 1 % start of quiet period
        c_start = 1;
        i_start = e;
    end
    if c_start == 1 && bout(e) == 1 && bout(e-1) == 0 % end of quiet period
        c_start = 0;
        i_end = e;
        if c < nap_max_length   % if quiet period is short, fill it in
            bout_filled(i_start:i_end) = 1;
            c_filled = [c_filled; i_start i_end];
        end
        c = 0;
    end
    if e == length(bout) && c_start == 1
        i_end = e;
        if c < nap_max_length   % if quiet period is short, fill it in
            bout_filled(i_start:i_end) = 1;
        end
        c = 0;
    end
end

% identify long periods of activity as "active periods"

active_period_min_length = 300;
bout_indx = [];
c = 0;
c_start = 0;
for e = 2:length(bout_filled)
    if e == 2 && bout_filled(e) == 1
        c_start = 1;
        st_indx = e;
    end
    if c_start == 1
        c = c+1;
    end
    if bout_filled(e-1) == 0 && bout_filled(e) == 1
        c_start = 1;
        st_indx = e;
    end
    if bout_filled(e-1) == 1 && bout_filled(e) == 0
        c_start = 0;
        fn_indx = e;
        if c > active_period_min_length
            bout_indx = [bout_indx; st_indx fn_indx];
        end
        c = 0;
    end
    if e == length(bout_filled) && c_start == 1
        fn_indx = e;
        if c > active_period_min_length
            bout_indx = [bout_indx; st_indx fn_indx];
        end
        c = 0;
    end
end

%% section 3: plots of the output

figure
hold on
plot(raw,'y')
plot(trc,'k')
for e = 1:length(bout_indx)
    line([bout_indx(e,1) bout_indx(e,1)],[0 max(trc)],'Color','g','LineWidth',2)
    line([bout_indx(e,2) bout_indx(e,2)],[0 max(trc)],'Color','r','LineWidth',2)
end
title('mouse sleep/wake bouts')
legend('raw','smoothed','wake bout start','wake bout end')
ylim([0 max(trc)])
end