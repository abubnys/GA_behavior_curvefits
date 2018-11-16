%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   automated window picker
%   
%   this script takes the waking bout start/end times calculated in wake_times,
%   along with the associated trace (smoothed GA assay data) and calculates
%   the appropriate window for curve fitting of behavioral transitions
%   
%   the criteria for window picking:
%   if LD = 1
%   - begin at last local minimum before wake bout
%   - end at first local maximum after wake bout
%   if LD = 2
%   -being at last local maximum before sleep bout
%   -end at first local minimum after sleep bout
%
%   this produces an output trace that can then be provided to log_fit for
%   fitting to the logarithmic function
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function trc_to_fit = window_picker(bout_start,trc,LD)
% bout_start = time_indices(1);
% trc = smoothed_trc;
% LD = 2;

inv_window = trc.*-1;

% first criterion: start curve at last local minimum before indx
[l_min, min_indx] = findpeaks(inv_window);
[l_max, max_indx] = findpeaks(trc);

if LD == 1 % sleep-wake transition, local min before transition to local max after transition
    
    min_dist_from_st = min_indx-bout_start;
    st_window = 1;
    for e = 1:length(min_dist_from_st)-1
        if min_dist_from_st(e) < 0 && min_dist_from_st(e+1) >= 0
            st_window = min_indx(e);
        end
    end
    
    max_dist_from_st = max_indx-bout_start;
    fn_window = length(trc);
    for e = 2:length(max_dist_from_st)
        if max_dist_from_st(e-1) < 0 && max_dist_from_st(e) >= 0
            fn_window = max_indx(e);
        end
    end
    
elseif LD == 2 % wake-sleep transition, local max before transition to local min after transition
    
    max_dist_from_st = max_indx-bout_start;
    st_window = 1;
    for e = 1:length(max_dist_from_st)-1
        if max_dist_from_st(e) < 0 && max_dist_from_st(e+1) >= 0
            st_window = max_indx(e);
        end
    end
    
    min_dist_from_st = min_indx-bout_start;
    fn_window = length(trc);
    for e = 2:length(min_dist_from_st)
        if min_dist_from_st(e-1) < 0 && min_dist_from_st(e) >= 0
            fn_window = min_indx(e);
        end
    end
    
end

% figure
% hold on
% plot([st_window-100:fn_window+100],trc(st_window-100:fn_window+100))
% plot(trc)
% plot(st_window, trc(st_window),'g*')
% plot(fn_window, trc(fn_window),'r*')
% plot(bout_start, trc(bout_start),'c*')

trc_to_fit = trc(st_window:fn_window);
end