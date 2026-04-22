# FDFE_elastic_iso

## Introduction

**FDFE_elastic_iso** is a software package for computing the propagation of elastic wave in isotropic media using a **frequency domain finite-element method (FDFE) based on variational principles**.

Traditional finite-element approaches for simulating elastic wave propagation require a weak formulation of the governing equations. In contrast, **FDFE_elastic_iso** models wave propagation in isotropic media within a variational-principles framework. By constructing an appropriate functional, solving the governing equations becomes equivalent to finding its stationary value under given boundary conditions. This approach proposes an alternative finite-element framework for simulating seismic wave propagation and may serve as a new tool for wave modeling and full-waveform inversion.

This software is designed for studies of **seismic wave simulation and propagation in heterogeneous isotropic media**.

---

## Citation

If you use this software in your research, please cite:

Dongdong Wang and Haopeng Chen. *A variational finite-element method for frequency-domain simulation of seismic wave propagation in 2D elastic media.*  Computers & Geosciences.

---

## Requirements

| Requirement                | Version |
|---------------------------|---------|
| MATLAB                    | R2018a or later |
| Parallel Computing Toolbox | Required |

---

## Compilation

No need to compile.

## Input Files

Before running the program, the following parameters within 'sub_00_model_***' need be adjusted:

| Parameters | Description |
|-------------|--------|
| Model.Nx | The total number of grid in x direction |
| Model.Nz | The total number of grid in z direction |
| Model.Npx | The total number of PML in x direction |
| Model.Npz | The total number of PML in x direction |
| Model.source_ii | Source location in x direction |
| Model.source_jj | Source location in y direction |
| Model.source_type | Source Type |

## Source Code Structure

The main file is `**Main_finite_element_PSVTM.m**`.

- **Main_finite_element_PSVTM.m**  
  This is the main code.

- **sub_0_finite_element_construct_global_matrix_method.m**  
  Assemble and solve the linear system of equations.

- **get_3_frequency_dependence_input_parameter.m**  
  Calculation of the elastic parameters according to the velocity and density.

- **sub_3_2_fullspace_matrix_PSV.m**  
  Considering a fullspace model, and construct the cooeficent matrix in this model.

- **sub_3_2_freesurface_matrix_PSV.m**  
  Considering a half-space model, and construct the cooeficent matrix in this model.

