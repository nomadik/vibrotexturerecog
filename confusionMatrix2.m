function y = confusionMatrix2(pred, data)
    y = zeros(6);
    disp(sprintf('data size %d', numel(data)));
    for i=1:numel(data)
        y(data(i), pred(i)) = y(data(i), pred(i)) + 1;
    end
    printmat(y, 'Confusion Matrix', ...
        '1 2 3 4 5 6',...
        '1 2 3 4 5 6'); 
end
        
