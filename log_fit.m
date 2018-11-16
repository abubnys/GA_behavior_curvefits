%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            logarithmic fit
%
%   this function takes as input the fitting window output of window_picker
%   and fits that curve to a logarithmic function, providing as output the
%   parameters and rmse of the fit
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [best_x,best_k,best_l,rmse_min,y_norm,y_fit] = log_fit(t)

% trim the trace to make it an even length
if rem(length(t),2) == 1
    t = t(1:end-1);
end

ts = 1:length(t);

% for the logistic fit, center it around 0
ts_norm = -1*floor(length(ts)/2):floor(length(ts)/2)-1;

% make data sigmoid start at 0
y_norm = t - mean(t(1:10));

%% logistic fit

logistic = @(x,x0,k,L) L./(1+exp(k*(x-x0)));

% find values for x,k,and L that minimize rmse
xtot = 50;
xlst = linspace(-10,40,xtot);
ktot = 20;
klst = linspace(0,0.5,ktot);
ltot = 100;
llst = linspace(max(y_norm)-50,max(y_norm)+10,ltot);
rmse_lst = zeros(xtot,ktot,ltot); % x,k,l dimensions

for xx = 1:length(xlst)
    for kk = 1:length(klst)
        for ll = 1:length(llst)
            f = logistic(xlst(xx),ts_norm,klst(kk),llst(ll));
            if size(f,1) == size(y_norm,1)
                rmse = sqrt(mean((y_norm - f).^2));
            else
                rmse = sqrt(mean((y_norm - f').^2));
            end
            rmse_lst(xx,kk,ll) = rmse;
        end
    end
end

% find optimal values from rmse list

[rmse_min,rmse_i] = min(rmse_lst(:));
[xindx,kindx,lindx] = ind2sub(size(rmse_lst),rmse_i);
best_x = xlst(xindx);
best_k = klst(kindx);
best_l = llst(lindx);

% round 2: redo fitting around the optimal values from round 1
xtot = 20;
xlst = linspace(best_x-1,best_x+1,xtot);
ktot = 20;
klst = linspace(best_k-0.05,best_k+0.05,ktot);
ltot = 50;
llst = linspace(best_l-5,best_l+5,ltot);
rmse_lst = zeros(xtot,ktot,ltot); % x,k,l dimensions

for xx = 1:length(xlst)
    for kk = 1:length(klst)
        for ll = 1:length(llst)
            f = logistic(xlst(xx),ts_norm,klst(kk),llst(ll));
            if size(f,1) == size(y_norm,1)
                rmse = sqrt(mean((y_norm - f).^2));
            else
                rmse = sqrt(mean((y_norm - f').^2));
            end
            rmse_lst(xx,kk,ll) = rmse;
        end
    end
end

[rmse_min,rmse_i] = min(rmse_lst(:));
[xindx,kindx,lindx] = ind2sub(size(rmse_lst),rmse_i);
best_x = xlst(xindx);
best_k = klst(kindx);
best_l = llst(lindx);
y_fit = logistic(best_x,ts_norm,best_k,best_l);

%% plot the resulting fit

figure
hold on
plot(ts,y_norm,'bs')
plot(ts,y_fit,'r-','LineWidth',2)
title(sprintf('x: %2.3f, k: %2.3f, L: %2.3f, rmse: %2.3f',[best_x,best_k,best_l,rmse_min]))

sprintf('x: %2.3f, k: %2.3f, L: %2.3f, rmse: %2.3f',[best_x,best_k,best_l,rmse_min])

end

