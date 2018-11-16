%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    curve fitting of behavioral data 
%
%   This script takes parsed data from a GA behavioral assay, automatically
%   detects behavioral transitions (either low to high or high to low
%   arousal) and fits them to the 3 parameter logistic equation.
%
%   As input, this script requires the structure of parsed data generated
%   by GA_total_parser.m
%
%   The script calls the companion functions wake_times_function.m,
%   window_picker.m, and log_fit.m
%
%   This script produces an output structure that organizes the curve fits
%   by cage number, giving the following outputs:
%       all_data: the consolidated raw data
%   for each behavioral transition that was detected:
%       indx: the location of the behavioral transition in the raw data
%       raw_transition: the raw data of the transition that we used to
%       curve fitting
%       x: parameter x from the best logistic fit
%       k: parameter k from the best logistic fit
%       l: parameter l from the best logistic fit
%       rmse: the root mean squared error of the best logistic fit
%       normalized_transition: the normalized transition that was used in
%       the logistic curve fit (centered around 0, min/max set to 0)
%       curve_fit: the logistic curve that best fits the data
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% if fitting the low-to-high activity transition, set LD to 1, if fitting
% the high-to-low transition, set LD to 2
LD = 1;

% location of the input structure
fpath = '/users/abubnys/Desktop/ND_GA_assay/';
fnom = 'ND_round2_HACTV.mat';
load([fpath fnom]);

curve_fits = struct;
%%
for c = 1:size(mouse_activity,2)
    
    % consolidate all recorded activity for a given cage
    all_trc = [];
    for w = 1:size(mouse_activity(c).cage,2)
        for d = 1:size(mouse_activity(c).cage(w).week,2)
            all_trc = [all_trc mouse_activity(c).cage(w).week(:,d)'];
        end
    end
    all_trc(find(isnan(all_trc)))=[];
    
    % calculate all behavioral transitions
    [bout_indx,smoothed_trc] = wake_times_function(all_trc');
    
    x_fits = [];
    k_fits = [];
    l_fits = [];
    rmses = [];
    fit_curves = {};
    
    % for each detected behavioral transition, fit it to the logistic
    % equation
    for e = 1:size(bout_indx,LD)
        
        % determine the range over which the behavioral transition occurs
        trc_to_fit = window_picker(bout_indx(e,LD),smoothed_trc,LD);
        
        % fit the transition to the logistic function
        [best_x,best_k,best_l,rmse_min,y_norm,y_fit] = log_fit(trc_to_fit);
        close all
        
        % save the results
        curve_fits(c).cage(e).indx = bout_indx(e,LD);
        curve_fits(c).cage(e).raw_transition = trc_to_fit;
        curve_fits(c).cage(e).x = best_x;
        curve_fits(c).cage(e).k = best_k;
        curve_fits(c).cage(e).L = best_l;
        curve_fits(c).cage(e).rmse = rmse_min;
        curve_fits(c).cage(e).normalized_transition = y_norm;
        curve_fits(c).cage(e).curve_fit = y_fit;
        curve_fits(c).all_data = all_trc;
        
    end
    
end


