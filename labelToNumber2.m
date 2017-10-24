function y = labelToNumber2(val)
    if (~isempty(strfind(val, 'dvp_back_')))
        y = 1;
    elseif (~isempty(strfind(val, 'dvp_flat_')))
        y = 2;
    elseif (~isempty(strfind(val, 'fabric_')))
        y = 3;
    elseif (~isempty(strfind(val, 'oboi_')))
        y = 4;
    elseif (~isempty(strfind(val, 'still_')))
        y = 5;
    elseif (~isempty(strfind(val, 'tkan_')))
        y = 6;
    end;
end
        
