# RETINA - Relevant Transformation of the Inputs Network Approach

A MATLAB implementation of the RETINA algorithm for automatic variable selection in statistical modeling with multicollinearity control.

## Overview

RETINA is a model selection algorithm designed to automatically identify relevant predictors from a set of candidate variables while controlling for multicollinearity. It uses a stepwise approach with cross-validation to build parsimonious models that generalize well to new data.

## Features

- **Automatic variable selection** with multicollinearity control
- **Three algorithm variants**:
  - Original PAGW (Perez-Amaral, Gallo, White) algorithm
  - PAGW with union model feature
  - Adaptive lambda grid search
- **Cross-validation** using three-way data splitting
- **Multiple model selection criteria**: AIC, AICC, BIC
- **Efficient computation** using sweep operations

## Installation

Clone this repository:
```bash
git clone https://github.com/m-marinucci/RETINA.git
cd RETINA
```

## Requirements

- MATLAB (tested on R2020a and later)
- Statistics and Machine Learning Toolbox (optional, for extended functionality)

## Quick Start

```matlab
% Clear workspace and initialize
clear all; close all; clc;

% Add RETINA to your MATLAB path
addpath('path/to/RETINA');

% Load your data or use the test example
[y, w, dataflag] = test1;  % Example data

% Set subsample proportions (must sum to less than 1)
pvec = [0.33; 0.33];  % 33% training, 33% validation, 34% test

% Run RETINA
[selected_model, subset_info] = RETINA(pvec, y, w, dataflag, 1, 1);

% selected_model contains the final selected variables
% subset_info contains detailed information about the selection process
```

## Usage

### Basic Usage

```matlab
[c_retina, subset_retina] = RETINA(pvec, y, w, dataflag, procflag, verbose)
```

### Parameters

- `pvec`: Vector of subsample proportions (must sum to less than 1, e.g., `[0.33; 0.33]` for equal splits)
- `y`: Response variable (n×1 column vector)
- `w`: Predictor matrix (n×p matrix)
- `dataflag`: Data type indicator (1 = actual data, 0 = simulated data)
- `procflag`: Algorithm variant:
  - 1: Original PAGW algorithm (fixed lambda grid search)
  - 2: PAGW with union model (includes all-predictor model)
  - 3: Adaptive lambda approach (adjusts grid based on data characteristics)
- `verbose`: Output verbosity (0 = silent, 1 = verbose)

### Output

- `c_retina`: Selected model coefficients and statistics
- `subset_retina`: Detailed information about the model selection process

## Algorithm Details

RETINA works in several stages with sophisticated model selection mechanisms:

### Core Algorithm Flow

1. **Data Splitting** (`datasubsets.m`): Divides data into three subsamples for training, validation, and testing
2. **Model Building** (`build_1.m`, `build_2.m`, `build_3.m`): Constructs candidate models on the first subsample using stepwise addition of predictors with multicollinearity control via lambda threshold
3. **Cross-Validation** (`crossub_1_2_2.m`): Evaluates candidate models on the second subsample
4. **Final Selection** (`evamod.m`, `evafinal.m`): Tests the best models on the third subsample and selects the final model using information criteria (AIC, AICC, or BIC)

### Key Components

- **Model Building**: Stepwise addition of predictors with multicollinearity control via lambda threshold
- **Model Evaluation**: Uses AIC, AICC, or BIC for model selection
- **Efficient Computation**: Uses sweep operations (`sweep.m`) for matrix calculations
- **Duplicate Detection**: `compmod.m` prevents redundant model evaluation

### Algorithm Variants

The three `procflag` options provide different approaches:

- **Procedure 1** (Original PAGW): Fixed lambda grid search with systematic exploration of predictor combinations
- **Procedure 2** (PAGW with union model): Includes all-predictor model in addition to stepwise selection
- **Procedure 3** (Adaptive lambda): Adjusts lambda grid based on data characteristics for more flexible multicollinearity control

## Example

See `example_usage.m` for a complete working example with synthetic data.

## File Structure

```
RETINA/
├── RETINA.m              # Main algorithm function
├── build_1.m             # Original PAGW algorithm
├── build_2.m             # PAGW with union model
├── build_3.m             # Adaptive lambda version
├── datasubsets.m         # Data splitting function
├── crossub_1_2_2.m       # Cross-validation function
├── evamod.m              # Model evaluation function
├── evafinal.m            # Final model selection
├── sweep.m               # Efficient matrix operations
├── test1.m               # Example data generator
└── run_RETINA.m          # Example runner script
```

## Citation

If you use RETINA in your research, please cite:

```bibtex
@phdthesis{marinucci2008automatic,
  title={Automatic Prediction and Model Selection},
  author={Marinucci, Massimiliano},
  year={2008},
  school={Universidad Complutense Madrid},
  type={{PhD} dissertation}
}
```

Or in text format:
```
Marinucci, M. (2008). Automatic Prediction and Model Selection. 
PhD dissertation, Universidad Complutense Madrid.
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Authors

- Massimiliano Marinucci

## References

### Core RETINA Publications

- Pérez-Amaral, T., Gallo, G. M., & White, H. (2003). A flexible tool for model building: the relevant transformation of the inputs network approach (RETINA). *Oxford Bulletin of Economics and Statistics*, 65(s1), 821-838.

- Pérez-Amaral, T., Gallo, G. M., & White, H. (2005). A comparison of complementary automatic modeling methods: RETINA and PcGets. *Econometric Theory*, 21(1), 262-277.

- Marinucci, M. (2010). *Automatic Prediction and Model Selection*. LAP Lambert Academic Publishing. ISBN: 978-3-8383-2689-4.

### Related Automatic Model Selection Methods

- Hendry, D. F., & Krolzig, H. M. (1999). Improving on 'Data mining reconsidered' by K.D. Hoover and S.J. Perez. *Econometrics Journal*, 2(2), 202-219.

- Hoover, K. D., & Perez, S. J. (1999). Data mining reconsidered: encompassing and the general-to-specific approach to specification search. *Econometrics Journal*, 2(2), 167-191.

- Hendry, D. F., & Krolzig, H. M. (2001). *Automatic Econometric Model Selection Using PcGets*. London: Timberlake Consultants.

- Castle, J. L., Doornik, J. A., & Hendry, D. F. (2012). Model selection when there are multiple breaks. *Journal of Econometrics*, 169(2), 239-246.

### Multicollinearity and Variable Selection

- Tibshirani, R. (1996). Regression shrinkage and selection via the lasso. *Journal of the Royal Statistical Society: Series B*, 58(1), 267-288.

- Zou, H., & Hastie, T. (2005). Regularization and variable selection via the elastic net. *Journal of the Royal Statistical Society: Series B*, 67(2), 301-320.

## Acknowledgments

- Based on the PAGW algorithm by Perez-Amaral, Gallo, and White
- Developed as part of PhD research on automatic model selection methods