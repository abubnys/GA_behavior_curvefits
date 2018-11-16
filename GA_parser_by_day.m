%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   GA assay parser separate by day
%
% a function that runs as part of NR_parser and extracts data for one cage
% for a given week
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function activity_by_day = GA_parser_by_day(cage,week,fnom,fpath)

data = xlsread([fpath fnom],week);

% sort out dates and times
ll = length(data(:,1));
for e = 1:length(data(:,1))
    if isnan(data(e,1))==1
        ll = e;
        break
    end
end

if data(1,1) < 1
    m_time = data(1:ll,1);
    cage = cage-1;
else 
    m_time = data(1:ll,2);
end

ftime = cell(length(m_time),1);
for e = 1:length(m_time)
    if isnan(m_time(e)) == 1
        break
    end
    ftime{e} = datestr(m_time(e),'HH:MM');
end

ftime = ftime(~cellfun('isempty',ftime));
m1_utime = unique(ftime);

%%
% each day starts at 00:00 and ends at 23:59
% sort movement data by the day that it happened
d = 0;
m = 0;
activity_by_day = zeros(length(m1_utime),7);
for e = 1:length(ftime)
    if strcmp(ftime{e},'00:00') == 1
        d = d+1;
        m = 1;
    end
    if d > 0
        activity_by_day(m,d) = data(e,cage);
        m = m+1;
    end
end

end