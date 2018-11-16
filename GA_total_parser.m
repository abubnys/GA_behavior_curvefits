%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       parser for GA assay data
%
% this script takes the data from Nadera's new template scripts (circa
% 8/23/17) and extracts and organizes it into a structure
%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
week_lst = 1:8; % weeks 1 to 6
cage_lst = 3:10; % cages 1 to 8
fnom = 'ND_round2_HACTV.xlsx';
fpath = '/Users/abubnys/Desktop/ND_GA_assay/';

mouse_activity = struct;

for wk = 1:8
    counter = 1;
    for cg = 3:10
        mouse_activity(counter).cage(wk).week = GA_parser_by_day(cg,wk,fnom,fpath);
        counter = counter+1;
        %sprintf('cage %0.0f',cg)
    end
    sprintf('week %0.0f',wk)
end