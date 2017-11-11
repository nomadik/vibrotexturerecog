len = numel(mydata);
maindir = 'data_by_trials';
classdir = './data_by_trials/%s/';
speeddir = './data_by_trials/%s/%d/';
template = './data_by_trials/%s/%d/%s';
dirtemplate = './data_by_trials/%s/%d/*.mat';
mkdir(maindir);
for i=1:len
    str = mydata{i}.filename;
    str = strrep(str, '_again', '');
    str = strrep(str, '.csv', '');
    str = regexprep(str, '_vel\d*', '');
    
    classname = str;
    speed = abs(mydata{i}.velocity); 
    
    mkdir(sprintf(classdir, classname));
    mkdir(sprintf(speeddir, classname, speed));
    numbers = numel(dir(sprintf(dirtemplate, classname, speed))) + 1;
    trialname = sprintf('trial%d.mat', numbers);
    tosave = mydata{i};
    save(sprintf(template, classname, speed, trialname), 'tosave');
end;