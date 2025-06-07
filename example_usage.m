%% RETINA Example Usage
% This script demonstrates how to use the RETINA algorithm for automatic
% variable selection with multicollinearity control.

clear all; close all; clc;

%% Generate Example Data
% You can replace this with your own data loading
fprintf('Generating example data...\n');
[y, w, dataflag] = test1;  % Built-in test data generator

% Display data dimensions
[n, p] = size(w);
fprintf('Data dimensions: %d observations, %d predictors\n', n, p);

%% Set RETINA Parameters
% Subsample proportions for 3-way split (must sum to less than 1)
pvec = [0.33; 0.33];  % 33% training, 33% validation, 34% test

% Algorithm settings
procflag = 1;   % Algorithm variant (1, 2, or 3)
verbose = 1;    % Display detailed output

%% Run RETINA Algorithm
fprintf('\nRunning RETINA algorithm...\n');
fprintf('Algorithm variant: %d\n', procflag);
fprintf('Subsample proportions: %.2f%% training, %.2f%% validation, %.2f%% test\n', ...
    pvec(1)*100, pvec(2)*100, (1-sum(pvec))*100);

% Run the algorithm
[c_retina, subset_retina] = RETINA(pvec, y, w, dataflag, procflag, verbose);

%% Display Results
fprintf('\n========== RETINA RESULTS ==========\n');

% Selected variables
selected_vars = find(c_retina(:,1) ~= 0);
selected_vars = selected_vars(selected_vars > 1) - 1;  % Adjust for intercept
fprintf('\nSelected variables: ');
fprintf('%d ', selected_vars);
fprintf('\n');

% Model statistics
fprintf('\nModel performance:\n');
fprintf('R-squared: %.4f\n', c_retina(1,2));
fprintf('Number of selected predictors: %d out of %d\n', ...
    length(selected_vars), p);

%% Try Different Algorithm Variants
fprintf('\n\nComparing different algorithm variants:\n');
fprintf('----------------------------------------\n');

for proc = 1:3
    fprintf('\nProcedure %d: ', proc);
    switch proc
        case 1
            fprintf('Original PAGW algorithm\n');
        case 2
            fprintf('PAGW with union model\n');
        case 3
            fprintf('Adaptive lambda approach\n');
    end
    
    % Run quietly
    [c_temp, ~] = RETINA(pvec, y, w, dataflag, proc, 0);
    
    % Display results
    selected = find(c_temp(:,1) ~= 0);
    selected = selected(selected > 1) - 1;
    fprintf('  Selected %d predictors: ', length(selected));
    fprintf('%d ', selected);
    fprintf('\n  R-squared: %.4f\n', c_temp(1,2));
end

%% Working with Your Own Data
fprintf('\n\n========== USING YOUR OWN DATA ==========\n');
fprintf('To use RETINA with your own data:\n\n');
fprintf('1. Load your response variable (y) as a column vector\n');
fprintf('2. Load your predictor matrix (w) with predictors in columns\n');
fprintf('3. Set dataflag = 1 for real data\n');
fprintf('4. Choose subsample proportions (pvec)\n');
fprintf('5. Select algorithm variant (procflag = 1, 2, or 3)\n\n');
fprintf('Example:\n');
fprintf('   y = load(''response.mat'');\n');
fprintf('   w = load(''predictors.mat'');\n');
fprintf('   [model, info] = RETINA([0.4; 0.3], y, w, 1, 2, 1);\n');

fprintf('\n========== END OF EXAMPLE ==========\n');