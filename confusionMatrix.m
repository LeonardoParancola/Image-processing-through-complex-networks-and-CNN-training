clear all;

% ID dataset.
datas=47;

% Loads dataset.
load(strcat('DatasColor_',int2str(datas)),'DATA');

% Useful variables.
fileNameScore0 = 'score/score_without_preprocessing';
fileNameScore1 = 'score/score_paper_radius_';
fileNameScore2 = 'score/score_modified_radius_';
fileNameScore3 = 'score/score_three_different_methods_radius_';
fileNameScore4 = 'score/score_ensemble';
fileNameScore5 = 'score/score_ensembleConsideringAllFiles'; 
fileNameScore6 = 'score/score_ensembleConsideringRadiusWithHigherAccuracy';

% Loads the score.
% Change the following value to modify the radius to consider.
r = 10;
fileNameScore1 = strcat(fileNameScore1,int2str(r));
fileNameScore2 = strcat(fileNameScore2,int2str(r));
fileNameScore3 = strcat(fileNameScore3,int2str(r));

% Change the following value (0, 1, 2, 3, 4) to choose which file load.
load(fileNameScore5);

DIV=DATA{3};        % Division between training and test set.
DIM1=DATA{4};       % Number of training patterns.
DIM2=DATA{5};       % Number of patterns.
yE=DATA{2};

% Extract the true labels of each fold.
yy = [];
for i = 1:5
    yy = [yy yE(DIV(i,DIM1+1:DIM2))];
end

% b contains the predicted label.
b = [];
for i = 1:5
    [a,temp]=max(score{i}');
    b = [b temp];
end

% Accuracy
accuracy = sum(b==yy)./length(yy);
disp("The accuracy is ");
disp(accuracy);

cm = confusionchart(yy, b);
cm.Title = 'Confusion Matrix: ensemble considering all the classifiers';
cm.RowSummary = 'row-normalized';
cm.ColumnSummary = 'column-normalized';

x = input('Choose the file name (without extension): ', 's');
saveas(gcf,strcat('img/confusionMatrix/confusionMatrix_',x, '.png'));