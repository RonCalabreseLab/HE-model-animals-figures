# Leech heartbeat motor neuron (HE) model compared to animals figures

Matlab code for generating figures of the paper ["Synaptic Strengths Dominate Phasing of Motor Circuit: Intrinsic Conductances of Neuron Types Need Not Vary across Animals"](https://doi.org/10.1523/ENEURO.0417-18.2019).

## Requirements

- [Common scripts for the HE model](https://github.com/RonCalabreseLab/HE-model-analysis-matlab)
- [Spike-triggered averaging Matlab toolbox](https://github.com/RonCalabreseLab/HN-HE-synapses-STA)
- [Leech heart motor neuron animal-to-animal variability paper figures simulation data](https://doi.org/10.6084/m9.figshare.7963748.v3)
- [Pandora Matlab Toolbox v1.4](https://github.com/cengique/pandora-matlab)

## How to generate figures

- Download the common scripts and add to your Matlab path
- Install the Pandora Toolbox in Matlab 
- Extract the data into a folder `data/` outside of this folder (or
  adjust paths according to where you place them).
- Open *.m files in Matlab and run the top region to load prereqs and
  one of the bottom regions for the intended figure or panel. Some
  other regions may also need to be executed to generate intermediate
  variables.

## Troubleshooting

Create a [Github Issue](https://github.com/RonCalabreseLab/HE-model-analysis-matlab/issues) for problems.

