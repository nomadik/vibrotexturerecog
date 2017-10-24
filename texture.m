close all; clear all; clc;
path = '.\texture_rec_csv\';
filetempl = '.\\texture_rec_csv\\%s';           
files = dir([path '\*.csv']);
 
doplot = false;
mydata = {};
maincounter = 1; 
%outputFID = fopen('result.txt','w');
%
for fileind = 1:numel(files)
    fname = files(fileind).name; 
    label = fname(1:3);
    fid = fopen(sprintf(filetempl, fname),'rt');
    tline = fgetl(fid);
    counter = 0;
    data = [];
    while ischar(tline)
        counter = counter + 1;
        splitted = strsplit(tline, ',');
        tline = fgetl(fid);
        if (counter == 1)
            continue;
        end;

        data = vertcat(data, splitted(5:end));
    end

    fclose(fid);
    colIndxs = [5,6,7,8,14,18,21,22,23,24] - 4;
    dataextracted = cellfun(@str2double,data);
    dataextracted = dataextracted(:,colIndxs);
    
    % show 
    if (doplot)
        close all;
        hold on;
        plot(dataextracted(:,1), 'b');
        plot(dataextracted(:,3), 'g');
        plot(dataextracted(:,4), 'y');
        plot(medfilt1(dataextracted(:,4), 11), 'r');
        hold off;
    end;
    % extract data segments
    locations = find(diff(dataextracted(:,1)));
    for i=1:numel(locations) - 1
        loc = locations(i) + 1;
        if (i == numel(locations))
            endloc = numel(dataextracted(:,1));
        else
            endloc = locations(i + 1) - 1;
        end;
        state = 0;
        eps = 0.05;
        startind = loc;
        endind = 0;
        sngn = dataextracted(loc+1,1);
        if (sngn > 0) 
            [~, maxloc] = max(dataextracted(loc:endloc, 4));
        else
            [~, maxloc] = min(dataextracted(loc:endloc, 4));
            continue;
        end;
        flag = 0;
        loc = maxloc + loc;
        while (1 == 1)
            if ((dataextracted(loc,4) >= 0 && dataextracted(loc, 1) < 0)...
                    ||(dataextracted(loc,4) <= 0 && dataextracted(loc, 1) > 0))
                endind = loc;
                break;
            else
                loc = loc + 1;
            end;
        end;
        
        n1 = startind;
        n2 = endind;
        veloc = mean(dataextracted(n1:n2,2)); 
        
        singledata = struct('set_point_4', dataextracted(n1:n2,1), ...
            'pos_gain4', dataextracted(n1:n2,2), ...
            'proc_val4', dataextracted(n1:n2,3), ...
            'proc_val_dot4', dataextracted(n1:n2,4), ...
            'ffj4', dataextracted(n1:n2,5), ...
            'ffj4_dot', dataextracted(n1:n2,6), ...
            'ffj3_tao', dataextracted(n1:n2,7), ...
            'ffj4_tao', dataextracted(n1:n2,8), ...
            'pac0', dataextracted(n1:n2,9), ...
            'pac1', dataextracted(n1:n2,10), ...
            'label', label, ...
            'velocity', veloc, ...
            'filename', fname);
        mydata{maincounter} = singledata;
        maincounter = maincounter + 1;
    end;
    disp(sprintf('iteration ok %d', fileind)); 
end;
%%
disp('data extracted');
hold on;
plot(dataextracted(:,1), 'b');
plot(dataextracted(:,4), 'g');
plot(medfilt1(dataextracted(:,4), 11), 'r');
hold off;
%%
kokoko = 0;
loc = 0;
mymax = 0;
sizechecks = [];
datachekcs = {};
if (kokoko == 1)
    for i=1:size(mydata, 2)
        disp(mydata{i}.filename);
        disp(mydata{i}.velocity);
        close all;
        hold on;
        plot(mydata{i}.set_point_4, 'g');
        plot(mydata{i}.proc_val_dot4, 'b');
        %plot(mydata{i}.pac0, 'r');
        %plot(mydata{i}.pac1, 'y');
        hold off;
        drawnow();
        pause();
    end;

    %%
    maxsize = 0;
    minsize = 0;
    for i=1:size(mydata, 2)
        if (maxsize < numel(mydata{i}.set_point_4))
            maxsize = numel(mydata{i}.set_point_4);
        end;
        if (minsize > numel(mydata{i}.set_point_4) || i == 1)
            minsize = numel(mydata{i}.set_point_4);
        end;
    end;
end;

%% generate stupid features
fftsize = 300;
features1 = [];
features2 = [];
features12 = [];
close all;
dohighpass = false;
%hd = design(fdesign.highpass('Fst,Fp,Ast,Ap', FREQ_ESTIMATE - 0.05, FREQ_ESTIMATE + 0.05,60,1));
for i=1:size(mydata, 2)
    if (dohighpass)         
        %pac0Filt = filter(hd, mydata{i}.pac0); 
        %pac1Filt = filter(hd, mydata{i}.pac1); 
    else
        pac0Filt = mydata{i}.pac0;
        pac1Filt = mydata{i}.pac1;
    end;
    %close all;
    %hold on;
    %plot(mydata{i}.angles, 'b');
    %plot(filter(hd, mydata{i}.angles), 'r');
    %hold off;
    %drawnow();
    %pause();
    Pxx0 = fft(pac0Filt-mean(pac0Filt), fftsize);
    Pxx1 = fft(pac1Filt-mean(pac1Filt), fftsize);
    
    data0 = Pxx0;
    data1 = Pxx1;
    mydata{i}.label = labelToNumber2(mydata{i}.filename);
    label = mydata{i}.label;
    velocity = mydata{i}.velocity;
    datapiece12 = horzcat(data0', data1');
    datapiece12 = horzcat(datapiece12, label);
    datapiece12 = horzcat(datapiece12, velocity);
    features12 = vertcat(features12, datapiece12);
    
    datapiece1 = data0';
    datapiece1 = horzcat(datapiece1, label);
    datapiece1 = horzcat(datapiece1, velocity);
    features1 = vertcat(features1, datapiece1);
    
    datapiece2 = data1';
    datapiece2 = horzcat(datapiece2, label);
    datapiece2 = horzcat(datapiece2, velocity);
    features2 = vertcat(features2, datapiece2);
    
end;

% make real valued features
absfeat12 = abs(features12);
absfeat1 = abs(features1);
absfeat2 = abs(features2);

 
%% normalize
absfeat1 = absfeat1(absfeat1(:,end) == 3000, :);
absfeat2 = absfeat2(absfeat2(:,end) == 3000, :);
absfeat12 = absfeat12(absfeat12(:,end) == 3000, :);
[absfeat12k, maxs12, mins12] = normalizeColumns2(absfeat12);
[absfeat1k, maxs1, mins1] = normalizeColumns2(absfeat1);
[absfeat2k, maxs2, mins2] = normalizeColumns2(absfeat2);

% shuffle
rand_ind = randperm(size(absfeat12k, 1));
absfeat12k = absfeat12k(rand_ind, :);

rand_ind = randperm(size(absfeat1k, 1));
absfeat1k = absfeat1k(rand_ind, :);

rand_ind = randperm(size(absfeat2k, 1));
absfeat2k = absfeat2k(rand_ind, :);

%% train / test separation
absfeat1kp3000 = absfeat1k(absfeat1k(:, end) == 3000, :);
absfeat2kp3000 = absfeat2k(absfeat2k(:, end) == 3000, :);
absfeat12kp3000 = absfeat12k(absfeat12k(:, end) == 3000, :);
absfeat1kp3000(:,end) = [];
absfeat2kp3000(:,end) = [];
absfeat12kp3000(:,end) = [];

thresh1 = round(size(absfeat1kp3000, 1) * 0.8);
train_absfeat1 = absfeat1kp3000(1:thresh1, :);
test_absfeat1 = absfeat1kp3000(thresh1 + 1:end, :);

thresh2 = round(size(absfeat2kp3000, 1) * 0.8);
train_absfeat2 = absfeat2kp3000(1:thresh2, :);
test_absfeat2 = absfeat2kp3000(thresh2 + 1:end, :);
 
thresh3 = round(size(absfeat12kp3000, 1) * 0.8);
train_absfeat12 = absfeat12kp3000(1:thresh3, :);
test_absfeat12 = absfeat12kp3000(thresh3 + 1:end, :);

%% global test
absfeat1kpno3000 = absfeat1(absfeat1(:, end) ~= 3000, :);
absfeat2kpno3000 = absfeat2(absfeat2(:, end) ~= 3000, :);
absfeat12kpno3000 = absfeat12(absfeat12(:, end) ~= 3000, :);
absfeat1kpno3000(:,end) = [];
absfeat2kpno3000(:,end) = [];
absfeat12kpno3000(:,end) = [];

%%
flag1 = 0;
flag2 = 0;
hey1 = 0;
hey2 = 0;
tr1 = 0;
tr2 = 0;
for i=1:size(mydata,2)
    if (flag1 == 0 && mydata{i}.velocity == -500) 
        if (labelToNumber2(mydata{i}.filename) == 6)
            tr1 = tr1 + 1;
            if (tr1 == 2)
                hey1 = mydata{i};
                flag1 = 1;
            end;
        end;
    end;
    if (flag2 == 0 && mydata{i}.velocity == -500) 
        if (labelToNumber2(mydata{i}.filename) == 3)
            tr2 = tr2 + 1;
            if (tr2 == 2)
                hey2 = mydata{i};
                flag2 = 1;
            end;
        end;
    end;
    if (flag1 == flag2 && flag2 == 1)
        break;
    end;
end;
%%
close all;

hold on;
plot(hey1.ffj4_dot, 'r')
plot(hey2.ffj4_dot, 'b')
hold off;

%%  
close all;
 hold on;
 fftsize = 300;
 %axis([0 50 0 50]);
 plot(abs(fft(hey1.pac0 - mean(hey1.pac0), fftsize)), 'r');
 plot(abs(fft(hey2.pac0 - mean(hey2.pac0), fftsize)), 'b');
 hold off;
%%
close all;
hold on;
plot(hey1.pac0, 'r');
plot(hey1.pac1, 'b');
hold off;
%%
figure(2);
Pxx2 = fft(shit-mean(shit));
plot(abs(Pxx2));

%%
figure(3);
Pxx2 = fft(shit2-mean(shit2));
plot(abs(Pxx2));
%% test
yfit = svm12.predictFcn(absfeat1kpno3000(:,1:end-1));
sum(yfit == absfeat1kpno3000(:,end))/numel(absfeat1kpno3000(:,end))

y = confusionMatrix2(yfit, absfeat1kpno3000(:,end)); 