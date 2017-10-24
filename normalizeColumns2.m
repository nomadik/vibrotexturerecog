function [C, maxs, mins] = normalizeColumns2(data)
    maxs = max(data(:, 1:end-2));
    mins = min(data(:, 1:end-2));

    for ind=1:size(maxs,2)
        if maxs(ind) == mins(ind)
            mins(ind) = maxs(ind) - 1;
        end;
    end;
    C = data;
    for ind = 1:size(data, 1) 
        C(ind, :) = [(data(ind, 1:end-2) - mins) ./ (maxs - mins), data(ind, end - 1), data(ind, end)];
    end
end
