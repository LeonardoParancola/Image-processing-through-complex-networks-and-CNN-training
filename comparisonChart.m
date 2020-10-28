clear all;

% ID dataset.
datas=47;

% Loads dataset.
load(strcat('DatasColor_',int2str(datas)),'DATA');

DIV=DATA{3};        % Division between training and test set.
DIM1=DATA{4};       % Number of training patterns.
DIM2=DATA{5};       % Number of patterns.
yE=DATA{2};         % True labels.

% Extract the true labels of each fold.
yy = [];
for i = 1:5
   yy = [yy yE(DIV(i,DIM1+1:DIM2))];
end

fileNameScore0 = 'score/score_without_preprocessing';
fileNameScore1 = 'score/score_paper_radius_';
fileNameScore2 = 'score/score_modified_radius_';
fileNameScore3 = 'score/score_three_different_methods_radius_';
fileNameScoreEnsemble1 = 'score/score_ensemble';
fileNameScoreEnsemble2 = 'score/score_ensembleConsideringAllFiles';
fileNameScoreEnsemble3 = 'score/score_ensembleConsideringRadiusWithHigherAccuracy';

% x: vector which contains the values regarding the radius.
x0 = [1 2 3 4 5 6 7 8 9 10];

% y: contains vectors which will contain the accuracies of the methods.
% It will contain 10 values. If there is a contant value, then it will
% contain 10 times the same value (without preprocessing and ensemble).
y = {};

% ----------------
% Loads the without preprocessing's score.
load(fileNameScore0);
temp = [];
for i = 1:5 % for each fold
    [a,b] = max(score{i}');
    temp = [temp b];
end

method = 1;
for r = 1:10
    y{method}(r) = sum(temp==yy).*100./length(yy);
end

% ----------------
method = 2;
for r = 1:10
    load(strcat(fileNameScore1,int2str(r)));
    temp = [];
    for i = 1:5 % for each fold
        [a,b] = max(score{i}');
        temp = [temp b];
    end
    y{method}(r) = sum(temp==yy).*100./length(yy);
end

% ----------------
method = 3;
for r = 1:10
    load(strcat(fileNameScore2,int2str(r)));
    temp = [];
    for i = 1:5 % for each fold
        [a,b] = max(score{i}');
        temp = [temp b];
    end
    y{method}(r) = sum(temp==yy).*100./length(yy);
end

% ----------------
method = 4;
for r = 1:10
    load(strcat(fileNameScore3,int2str(r)));
    temp = [];
    for i = 1:5 % for each fold
        [a,b] = max(score{i}');
        temp = [temp b];
    end
    y{method}(r) = sum(temp==yy).*100./length(yy);
end

% ----------------
% Loads the ensemble's score.
load(fileNameScoreEnsemble1);
temp = [];
for i = 1:5 % for each fold
    [a,b] = max(score{i}');
    temp = [temp b];
end

method = 5;
for r = 1:10
    y{method}(r) = sum(temp==yy).*100./length(yy);
end

% ----------------
% Plot.
p = plot(x0, y{1}, x0, y{2}, x0, y{3}, x0, y{4}, x0, y{5});

title('Accuracy comparison');
xlabel('Radius');
ylabel('Accuracy(%)');

legend({'Without preprocessing','First method', 'Second method', 'Third method', 'Ensemble'}, 'Location', 'southeast', 'NumColumns', 2);

p(1).LineWidth = 1.5; % without preprocessing
p(2).LineWidth = 1.5; % First
p(3).LineWidth = 1.5; % Second
p(4).LineWidth = 1.5; % Third
p(5).LineWidth = 1.5; % Ensemble
xlim([1 10]);
ylim([60 100]);

x = input('Choose the file name (without extension): ', 's');
saveas(gcf,strcat('img/comparisonChart/comparisonChart_',x, '.png'));