# OF2i Simulation Code

This repository contains the source code for performing simulations related to the Optofluidic Force Induction (OF2i) technique as described in the associated bachelor thesis. The code simulates the behavior of spheroidal particles in optical fields, focusing on their alignment and dynamics under optical forces and torques.

## Features

- Simulation of particle dynamics in Laguerre-Gaussian beams.
- Investigation of lateral drift and alignment behavior of spheroidal particles.
- Supports various particle shapes and optical field configurations.
- Output data for further analysis and visualization.


## Documentation

The full bachelor thesis can be seen in `docs/thesis.pdf`

## Repository Structure

- **`src/`**: Contains the main simulation scripts and helper functions.
- **`data/`**: Folder for storing simulation data.
- **`docs/`**: Documentation for the methods and algorithms implemented.

## Requirements

- MATLAB (version R2020b or later recommended)
- [NanoBEM Toolbox](https://www.sciencedirect.com/science/article/pii/S0010465522000558?via%3Dihub) for nanoparticle boundary element simulations
- Statistics and Machine Learning Toolbox
- Optimization Toolbox, Parallel Computing Toolbox (optional for faster simulations)

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/chchurcher/bac-of2i_momentum.git
   ```
2. Navigate to the repository directory in MATLAB or your file explorer.

## Usage

1. Open MATLAB and add the `src/` directory to your MATLAB path:
   ```matlab
   addpath('src');
   ```
2. Modify parameters in the scripts in **`src/scripts/`** to customize the simulations.

3. Run the simulation scripts

### Example

Run the optical trapping simulation for default parameters:
```matlab
halfAxes = [100, 100, 200]
opticalTrapping
```

Load already run simulations:
```matlab
load('.\results\opticalTrapping\256be11n0muX20muX100a100b300c.mat')
```

## Contributions

Contributions to improve the code or add features are welcome. Please submit a pull request or create an issue for any bugs or suggestions.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

## Contact

For questions or further information, please contact the author via the email provided or open an issue in the repository.
christoph.kircher.56@gmail.com
