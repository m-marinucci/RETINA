# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

RETINA (Relevant Transformation of the Inputs Network Approach) is a MATLAB-based statistical model selection algorithm that automatically identifies relevant predictors while controlling for multicollinearity.

## Key Commands

### Running RETINA
```matlab
% Basic usage
clear all; close all; clc;
pvec=[.33;.33];  % Subsample proportions (training, validation, test)
[y,w,dataflag]=test1;  % Load test data (or your own data)
[c_retina1,subset_retina1]=RETINA(pvec,y,w,dataflag,procflag,verbose);
```

### Parameters
- `pvec`: Vector of subsample proportions (must sum to less than 1)
- `y`: Response variable (column vector)
- `w`: Predictor matrix
- `dataflag`: Data type (1=actual data, 0=simulated)
- `procflag`: Algorithm variant (1=original PAGW, 2=PAGW with union, 3=adaptive)
- `verbose`: Display output (0=silent, 1=verbose)

## Architecture

### Core Algorithm Flow
1. **Data Splitting** (`datasubsets.m`): Divides data into 3 subsamples
2. **Model Building** (`build_1/2/3.m`): Constructs candidate models on first subsample
3. **Cross-Validation** (`crossub_1_2_2.m`): Evaluates models on second subsample
4. **Final Selection** (`evamod.m`, `evafinal.m`): Tests best models on third subsample

### Key Components
- **Model Building**: Stepwise addition of predictors with multicollinearity control via lambda threshold
- **Model Evaluation**: Uses AIC, AICC, or BIC for model selection
- **Efficient Computation**: Uses sweep operations (`sweep.m`) for matrix calculations
- **Duplicate Detection**: `compmod.m` prevents redundant model evaluation

### Algorithm Variants
- **Procedure 1**: Original PAGW - fixed lambda grid search
- **Procedure 2**: PAGW with union model - includes all-predictor model
- **Procedure 3**: Adaptive lambda - adjusts grid based on data characteristics