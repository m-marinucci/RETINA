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

- `pvec`: Vector of subsample proportions (e.g., `[0.33; 0.33]` for equal splits)
- `y`: Response variable (n×1 column vector)
- `w`: Predictor matrix (n×p matrix)
- `dataflag`: Data type indicator (1 = actual data, 0 = simulated data)
- `procflag`: Algorithm variant:
  - 1: Original PAGW algorithm
  - 2: PAGW with union model
  - 3: Adaptive lambda approach
- `verbose`: Output verbosity (0 = silent, 1 = verbose)

### Output

- `c_retina`: Selected model coefficients and statistics
- `subset_retina`: Detailed information about the model selection process

## Algorithm Details

RETINA works in several stages:

1. **Data Splitting**: Divides data into training, validation, and test sets
2. **Model Building**: Constructs candidate models on the training set using stepwise selection with multicollinearity control
3. **Cross-Validation**: Evaluates candidate models on the validation set
4. **Final Selection**: Tests the best models on the test set and selects the final model using information criteria

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

## Acknowledgments

- Based on the PAGW algorithm by Perez-Amaral, Gallo, and White
- Developed as part of PhD research on automatic model selection methods