% This is the main file of the program.
% Firstly, variables useful to change the program behavior are
% initialized. One important variable is 'method' that is used to choose
% one of the following methods:
%   0, is the method without image pre-processing;
%   1, is the method which considers the image pre-processing calculating
%       the 'outdegree', the 'outdegree' considering the sum of the weight of the out-edges
%       and the 'indegree' with the sum of the weight of the in-edges;
%   2, is the method which includes the calculation of the 'outdegree', like
%       the method above, the 'incloseness' and the 'outcloseness' for the
%       image pre-processing;
%   3, in this method, three different methods to pre-process the image are
%       used. These methods are: 'outdegree', 'outcloseness' and
%       'indegree' with the sum.
% 
% Then, after the value of the radius is decided, the image processing is
% done before starting the training of the network.
%
% After the training, the results are saved.

clear all
warning off

% ID dataset to load.
datas=47;

% Loads dataset.
load(strcat('DatasColor_',int2str(datas)),'DATA');

disp('***METHOD');

% Possible values:
% 0 -> without preprocessing;
% 1 -> paper;
% 2 -> modified;
% 3 -> three different methods.
method = 1;
disp(method);

% To try a specific radius, simply set minRadius equals maxRadius.
disp('***RADIUS');
disp('Minimum radius');
minRadius = 1;
disp(minRadius);

disp('Maximum radius');
maxRadius = 10;
disp(maxRadius);

disp('***FILES');
disp('Score and accuracy will be saved in the following files:');

switch(method)
    case 0
        fileNameScore = 'score/score_without_preprocessing';
        fileNameAcc = 'acc/acc_without_preprocessing';
    case 1
        fileNameScore = 'score/score_paper_radius_';
        fileNameAcc = 'acc/acc_paper_radius_';
    case 2
        fileNameScore = 'score/score_modified_radius_';
        fileNameAcc = 'acc/acc_modified_radius_';
    case 3
        fileNameScore = 'score/score_three_different_methods_radius_';
        fileNameAcc = 'acc/acc_three_different_methods_radius_';
end

disp(fileNameScore);
disp(fileNameAcc);

for radius = minRadius:maxRadius
    % The following value is used to construct the complex network.
    gpuDevice(1);       % Resets the GPU for 'GPU out of memory' error.
    NF=size(DATA{3},1); % Number of folds.
    DIV=DATA{3};        % Division between training and test set.
    DIM1=DATA{4};       % Number of training patterns.
    DIM2=DATA{5};       % Number of patterns.
    yE=DATA{2};         % Patterns' label.
    NX=DATA{1};         % Images.
    
    % Images pre-processing if method > 0.
    if method > 0
        parfor i = 1:DIM2
            disp(i);
            NX{i} = fromRGBToCustomFormat(NX{i}, radius, method);
        end
    end
    
    % Loads the pre-trained network.
    net = alexnet;  %Loads AlexNet.
    siz=[227 227];
    
    % Neural network parameters.
    miniBatchSize = 30;
    learningRate = 1e-4;
    metodoOptim='sgdm';
    options = trainingOptions(metodoOptim,...
        'MiniBatchSize',miniBatchSize,...
        'MaxEpochs',30,...
        'InitialLearnRate',learningRate,...
        'Verbose',false,...
        'Plots','training-progress');
    numIterationsPerEpoch = floor(DIM1/miniBatchSize);
    
    
    for fold=1:NF
        close all force
        
        disp(fold);
        
        trainPattern=(DIV(fold,1:DIM1));
        testPattern=(DIV(fold,DIM1+1:DIM2));
        y=yE(DIV(fold,1:DIM1));         % Training label.
        yy=yE(DIV(fold,DIM1+1:DIM2));   % Test label.
        numClasses = max(y);            % Number of classes.
        
        % Creates the training set.
        clear nome trainingImages
        for pattern=1:DIM1
            IM = NX{DIV(fold,pattern)}; % Image.
            
            IM=imresize(IM,siz); % Resize of the image to make it compatible with CNN.
            
            if size(IM,3)==1
                IM(:,:,2)=IM;
                IM(:,:,3)=IM(:,:,1);
            end
            
            trainingImages(:,:,:,pattern)=IM;
        end
        imageSize=[siz 3];
        
        % Creates additional patterns, data augmentation.
        imageAugmenter = imageDataAugmenter( ...
            'RandXReflection',true, ...
            'RandXScale',[1 2], ...
            'RandYReflection',true, ...
            'RandYScale',[1 2],...
            'RandRotation',[-10 10],...
            'RandXTranslation',[0 5],...
            'RandYTranslation', [0 5]);
        trainingImages = augmentedImageSource(imageSize,trainingImages,categorical(y'),'DataAugmentation',imageAugmenter);
        
        % Network tuning.
        % The last three layers of the pre-trained network net are configured for 1000 classes.
        % These three layers must be fine-tuned for the new classification problem.
        % Extract all layers, except the last three, from the pretrained network.
        layersTransfer = net.Layers(1:end-3);
        layers = [
            layersTransfer
            fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
            softmaxLayer
            classificationLayer];
        netTransfer = trainNetwork(trainingImages,layers,options);
        
        % Creates test set.
        clear nome test testImages
        
        for pattern=ceil(DIM1)+1:ceil(DIM2)
            IM = NX{DIV(fold,pattern)}; % Image.
            
            IM=imresize(IM,[siz(1) siz(2)]);
            if size(IM,3)==1
                IM(:,:,2)=IM;
                IM(:,:,3)=IM(:,:,1);
            end
            
            testImages(:,:,:,pattern-ceil(DIM1))=IM;
        end
        
        % Test patterns classification.
        [outclass, score{fold}] =  classify(netTransfer,testImages);
        
        % Accuracy.
        [a,b]=max(score{fold}');
        ACC(fold)=sum(b==yy)./length(yy);
        
    end
    
	% Saves the result.
    
    % Changes the string adding the radius if needed.
    if method > 0       
        fileScore = strcat(fileNameScore,int2str(radius));
        fileAcc = strcat(fileNameAcc,int2str(radius));
    end
    
    save(fileScore, 'score');
    save(fileAcc, 'ACC');
end