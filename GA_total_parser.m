%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       parser for GA assay data
%
%   This script takes the behavioral data from an excel file
%   and extracts and organizes it into a structure that organizes the data
%   by cage, week, and day
%
%   A data point was collected once every minute over 24 hours for several
%   weeks per experiment. So a single day's worth of data consists of 1440
%   measurements for each animal
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
week_lst = 1:3; % weeks 1 to 6
cage_lst = 3:6; % cages 1 to 4
fnom = 'raw_data.xlsx';
fpath = '';

mouse_activity = struct;

for wk = 1:week_lst(end)
    counter = 1;
    for cg = cage_lst(1):cage_lst(end)
        mouse_activity(counter).cage(wk).week = GA_parser_by_day(cg,wk,fnom,fpath);
        counter = counter+1;
    end
    sprintf('currently loading week %0.0f',wk)
end