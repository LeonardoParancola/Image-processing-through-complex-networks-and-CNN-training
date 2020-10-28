clear all;

% ID dataset.
datas=47;

% Loads dataset.
load(strcat('DatasColor_',int2str(datas)),'DATA');

DIV=DATA{3};        % Division between training and test set.
DIM1=DATA{4};       % Number of training patterns.
DIM2=DATA{5};       % Number of patterns.
yE=DATA{2};

% Extract the true labels of each fold.
yy = [];
for i = 1:5
    yy = [yy yE(DIV(i,DIM1+1:DIM2))];
end

fileNameScore0 = 'score/score_without_preprocessing';
fileNameScore1 = 'score/score_paper_radius_';
fileNameScore2 = 'score/score_modified_radius_';
fileNameScore3 = 'score/score_three_different_methods_radius_';

% sumEnsemble will contain the sum of the scores for each fold.
sumEnsemble = {};
for i = 1:5
    sumEnsemble{i} = zeros(224,8);
end

%------------------------------
% Load the score of the without preprocessing method
load(fileNameScore0);
for i = 1:5
    sumEnsemble{i} = sumEnsemble{i} + score{i};
end

%-----------------------------
% Choose, with the radius, what file to load.
for radius = 7:10
    load(strcat(fileNameScore1,int2str(radius)));
    for i = 1:5
        sumEnsemble{i} = sumEnsemble{i} + score{i};
    end
end

%-----------------------------
for radius = 7:10
    load(strcat(fileNameScore2,int2str(radius)));
    for i = 1:5
        sumEnsemble{i} = sumEnsemble{i} + score{i};
    end
end

%-----------------------------
for radius = 7:10
    load(strcat(fileNameScore3,int2str(radius)));
    for i = 1:5
        sumEnsemble{i} = sumEnsemble{i} + score{i};
    end
end

% b contains the predicted label.
b = [];
for i = 1:5
    [a,temp]=max(sumEnsemble{i}');
    b = [b temp];
end

% Ensemble's accuracy
accuracy = sum(b==yy)./length(yy);
disp("The ensemble's accuracy is ");
disp(accuracy);

for i = 1:5
    score{i} = sumEnsemble{i};
end

fileScore = input('Choose the file name (without extension): ', 's');
fileScore = strcat('score/score_ensemble', fileScore);

save(fileScore, 'score');
