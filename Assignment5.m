input  = load("feature_array.mat");
data = input.feature_array;
data = normalize(data);
target  = load("class_name.mat");
label = target.class_name;
acc_mat_2 = zeros([1,475]);

for z = 1:475
    X = data(:, 1:z);
    Y = label;
    
    cv1 = cvpartition(Y, 'HoldOut', 0.3);
    XTrain = X(training(cv1), :);
    YTrain = Y(training(cv1), :);
    
    XRest = X(test(cv1), :);       % 30% remaining
    YRest = Y(test(cv1), :);
    
    % Step 2: Split remaining 30% into 15% Validation, 15% Test
    cv2 = cvpartition(YRest, 'HoldOut', 0.5);
    XVal = XRest(training(cv2), :);
    YVal = YRest(training(cv2), :);
    
    XTest = XRest(test(cv2), :);
    YTest = YRest(test(cv2), :);
    % Step 3: Train an SVM with Gaussian kernel
    % Tune parameters on validation set
    bestAccuracy = 0;
    bestModel = [];
    sigmaList = [0.1, 0.5, 1, 2];
    boxList = [0.1, 1, 10];
    
    for sigma = sigmaList
        for box = boxList
            model = fitcsvm(XTrain, YTrain, ...
                'KernelFunction', 'rbf', ...
                'KernelScale', sigma, ...
                'BoxConstraint', box, ...
                'Standardize', true);
    
            % Validate
            pred_val = predict(model, XVal);
            acc = mean(pred_val == YVal);
    
            if acc > bestAccuracy
                bestAccuracy = acc;
                bestModel = model;
            end
        end
    end
    
    % Step 4: Test best model
    pred_test = predict(bestModel, XTest);
    testAccuracy = mean(pred_test == YTest);
    acc_mat_2(z) = testAccuracy;
    % Step 5: Report
    fprintf('Best validation accuracy: %.2f%%\n', bestAccuracy * 100);
    fprintf('Test accuracy: %.2f%%\n', testAccuracy * 100);
end



%%

input  = load("feature_array.mat");
X = input.feature_array;
target  = load("class_name.mat");
label = target.class_name;
label_1 = label == 1;
Y = label .* label_1;
acc_mat_1 = zeros([1,475]);

cv1 = cvpartition(Y, 'HoldOut', 0.3);
XTrain = X(training(cv1), :);
YTrain = Y(training(cv1), :);

XRest = X(test(cv1), :);
YRest = Y(test(cv1), :);

% Step 2: Split remaining 30% into 15% Validation, 15% Test
cv2 = cvpartition(YRest, 'HoldOut', 0.5);
XVal = XRest(training(cv2), :);
YVal = YRest(training(cv2), :);

XTest = XRest(test(cv2), :);
YTest = YRest(test(cv2), :);

% Convert labels to categorical
YTrain = categorical(YTrain);
YVal = categorical(YVal);
YTest = categorical(YTest);

for z = 1:475
    xtrain = XTrain(:, 1:z);
    xval = XVal(:, 1:z);
    xtest = XTest(:,1:z);
    inputSize = size(xtrain, 2);
    numClasses = numel(categories(YTrain));
    
    layers = [
        featureInputLayer(inputSize)
        fullyConnectedLayer(10)
        reluLayer
        fullyConnectedLayer(numClasses)
        softmaxLayer
        classificationLayer];
    
    options = trainingOptions('adam', ...
        'MaxEpochs', 50, ...
        'ValidationData', {xval, YVal}, ...
        'ValidationFrequency', 10, ...
        'Verbose', true, ...
        'Plots', 'none');
    net = trainNetwork(xtrain, YTrain, layers, options);
    
    YPred = classify(net, xtest);
    accuracy = sum(YPred == YTest) / numel(YTest);
    acc_mat_1(z) = accuracy;
    disp(['Test Accuracy: ', num2str(accuracy*100), '%']);
end

%%

input  = load("feature_array.mat");
data = input.feature_array;
target  = load("class_name.mat");
label = target.class_name;
acc_mat_4 = zeros([1,51]);
[idx, scores] = fsrftest(data, label);
topK = 5;
X_selected = data(:, idx(1:topK));
for z = 1:51
    X = X_selected;
    Y = label;
    
    cv1 = cvpartition(Y, 'HoldOut', 0.3);
    XTrain = X(training(cv1), :);
    YTrain = Y(training(cv1), :);
    XTrain = XTrain(1:z, :);
    YTrain = YTrain(1:z, :);
    XRest = X(test(cv1), :);       % 30% remaining
    YRest = Y(test(cv1), :);
    
    % Step 2: Split remaining 30% into 15% Validation, 15% Test
    cv2 = cvpartition(YRest, 'HoldOut', 0.5);
    XVal = XRest(training(cv2), :);
    YVal = YRest(training(cv2), :);
    
    XTest = XRest(test(cv2), :);
    YTest = YRest(test(cv2), :);
    % Step 3: Train an SVM with Gaussian kernel
    % Tune parameters on validation set
    bestAccuracy = 0;
    bestModel = [];
    sigmaList = [0.1, 0.5, 1, 2];
    boxList = [0.1, 1, 10];
    if z == 1
        boxList = 1;
    end
    
    for sigma = sigmaList
        for box = boxList
            model = fitcsvm(XTrain, YTrain, ...
                'KernelFunction', 'rbf', ...
                'KernelScale', sigma, ...
                'BoxConstraint', box, ...
                'Standardize', true);
    
            % Validate
            pred_val = predict(model, XVal);
            acc = mean(pred_val == YVal);
    
            if acc > bestAccuracy
                bestAccuracy = acc;
                bestModel = model;
            end
        end
    end
    
    % Step 4: Test best model
    pred_test = predict(bestModel, XTest);
    testAccuracy = mean(pred_test == YTest);
    acc_mat_4(z) = testAccuracy;
    % Step 5: Report
    fprintf('Best validation accuracy: %.2f%%\n', bestAccuracy * 100);
    fprintf('Test accuracy: %.2f%%\n', testAccuracy * 100);
end

%%
input  = load("feature_array.mat");
X = input.feature_array;
target  = load("class_name.mat");
label = target.class_name;
[idx, scores] = fsrftest(data, label);
topK = 5;
X_selected = X(:, idx(1:topK));
label_1 = label == 1;
Y = label .* label_1;
acc_mat_3 = zeros([1,51]);

cv1 = cvpartition(Y, 'HoldOut', 0.3);
XTrain = X_selected(training(cv1), :);
YTrain = Y(training(cv1), :);

XRest = X_selected(test(cv1), :);
YRest = Y(test(cv1), :);

% Step 2: Split remaining 30% into 15% Validation, 15% Test
cv2 = cvpartition(YRest, 'HoldOut', 0.5);
XVal = XRest(training(cv2), :);
YVal = YRest(training(cv2), :);

XTest = XRest(test(cv2), :);
YTest = YRest(test(cv2), :);

% Convert labels to categorical
YTrain = categorical(YTrain);
YVal = categorical(YVal);
YTest = categorical(YTest);

for z = 1:51
    xtrain = XTrain(1:z, :);
    Ytrain = YTrain(1:z, :);
    xval = XVal;
    xtest = XTest;
    inputSize = size(xtrain, 2);
    numClasses = numel(categories(YTrain));
    
    layers = [
        featureInputLayer(inputSize)
        fullyConnectedLayer(10)
        reluLayer
        fullyConnectedLayer(numClasses)
        softmaxLayer
        classificationLayer];
    
    options = trainingOptions('adam', ...
        'MaxEpochs', 50, ...
        'ValidationData', {xval, YVal}, ...
        'ValidationFrequency', 10, ...
        'Verbose', true, ...
        'Plots', 'none');
    net = trainNetwork(xtrain, Ytrain, layers, options);
    
    YPred = classify(net, xtest);
    accuracy = sum(YPred == YTest) / numel(YTest);
    acc_mat_3(z) = accuracy;
    disp(['Test Accuracy: ', num2str(accuracy*100), '%']);
end
%%
%%
figure(1)
a = 1:475;
plot(a, acc_mat_1, a,acc_mat_2)
legend('ANN Model', 'SVM Model')
axis tight
ylabel('Model Accuracy');
xlabel('Number of Features Used')
title('Accuracy vs Features Used Plot')


%%
figure(2)
a = (1:51)/51*100 ;
plot(a, acc_mat_3, a,acc_mat_4)
legend('ANN Model', 'SVM Model')
axis tight
ylabel('Model Accuracy');
xlabel('Percent Training Data Used')
title('Accuracy vs Data Used Plot')

%%

input  = load("feature_array.mat");
X = input.feature_array;
target  = load("class_name.mat");
label = target.class_name;
[idx, scores] = fsrftest(data, label);
topK = 5;
X_selected = X(:, idx(1:topK));
label_1 = label == 1;
Y = label .* label_1;
acc_mat_3 = zeros([1,51]);

cv1 = cvpartition(Y, 'HoldOut', 0.3);
XTrain = X_selected(training(cv1), :);
YTrain = Y(training(cv1), :);

XRest = X_selected(test(cv1), :);
YRest = Y(test(cv1), :);

% Step 2: Split remaining 30% into 15% Validation, 15% Test
cv2 = cvpartition(YRest, 'HoldOut', 0.5);
XVal = XRest(training(cv2), :);
YVal = YRest(training(cv2), :);

XTest = XRest(test(cv2), :);
YTest = YRest(test(cv2), :);

% Convert labels to categorical
YTrain = categorical(YTrain);
YVal = categorical(YVal);
YTest = categorical(YTest);

xtrain = XTrain(:, :);
Ytrain = YTrain(:, :);
xval = XVal;
xtest = XTest;
inputSize = size(xtrain, 2);
numClasses = numel(categories(YTrain));

layers = [
    featureInputLayer(inputSize)
    fullyConnectedLayer(10)
    reluLayer
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

options = trainingOptions('adam', ...
    'MaxEpochs', 50, ...
    'ValidationData', {xval, YVal}, ...
    'ValidationFrequency', 10, ...
    'Verbose', true, ...
    'Plots', 'training-progress');
net = trainNetwork(xtrain, Ytrain, layers, options);

YPred = classify(net, xtest);
accuracy = sum(YPred == YTest) / numel(YTest);
acc_mat_3(z) = accuracy;
disp(['Test Accuracy: ', num2str(accuracy*100), '%']);

%%

input  = load("feature_array.mat");
data = input.feature_array;
target  = load("class_name.mat");
label = target.class_name;
acc_mat_4 = zeros([1,51]);
[idx, scores] = fsrftest(data, label);
topK = 5;
X_selected = data(:, idx(1:topK));
    X = X_selected;
    Y = label;
    
    cv1 = cvpartition(Y, 'HoldOut', 0.3);
    XTrain = X(training(cv1), :);
    YTrain = Y(training(cv1), :);
    XTrain = XTrain(:, :);
    YTrain = YTrain(:, :);
    XRest = X(test(cv1), :);       % 30% remaining
    YRest = Y(test(cv1), :);
    
    % Step 2: Split remaining 30% into 15% Validation, 15% Test
    cv2 = cvpartition(YRest, 'HoldOut', 0.5);
    XVal = XRest(training(cv2), :);
    YVal = YRest(training(cv2), :);
    
    XTest = XRest(test(cv2), :);
    YTest = YRest(test(cv2), :);
    % Step 3: Train an SVM with Gaussian kernel
    % Tune parameters on validation set
    bestAccuracy = 0;
    bestModel = [];
    sigmaList = [0.1, 0.5, 1, 2];
    boxList = [0.1, 1, 10];
    
    for sigma = sigmaList
        for box = boxList
            model = fitcsvm(XTrain, YTrain, ...
                'KernelFunction', 'rbf', ...
                'KernelScale', sigma, ...
                'BoxConstraint', box, ...
                'Standardize', true);
    
            % Validate
            pred_val = predict(model, XVal);
            acc = mean(pred_val == YVal);
    
            if acc > bestAccuracy
                bestAccuracy = acc;
                bestModel = model;
            end
        end
    end
    
    % Step 4: Test best model
    pred_test = predict(bestModel, XTest);
    testAccuracy = mean(pred_test == YTest);
    acc_mat_4(z) = testAccuracy;
    % Step 5: Report
    fprintf('Best validation accuracy: %.2f%%\n', bestAccuracy * 100);
    fprintf('Test accuracy: %.2f%%\n', testAccuracy * 100);
%%
figure (1)
YPred = predict(bestModel, XTest);
plotconfusion(YTest', YPred')

%%
figure (2)
YPred = predict(bestModel, XVal);
plotconfusion(YVal', YPred')
%%
figure (3)
YPred = predict(bestModel, XTrain);
plotconfusion(YTrain', YPred')
    %%
figure (1)
YPred = classify(net, xval);
plotconfusion(YVal', YPred')
%%
figure (2)
YPred = classify(net, xtrain);
plotconfusion(Ytrain, YPred)

figure (3)
YPred = classify(net, xtest);
plotconfusion(YTest, YPred)