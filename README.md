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

| Requirement | Version |
|-------------|--------|
| Matlab | ≥ 3 |
| SCons | Latest |
| g++ | ≥ 5 |
| OpenMP | Supported |
| C++ standard | C++11 |

---

## Compilation

Compile the code using **SCons**: 

scons (bash)

## Input Files

Before running the program, the following input files must be prepared:

| File | Description |
|-------------|--------|
| Par_file | Parameter file controlling the calculation |
| velocity3d | 3-D velocity model |
| attenuation3d | 3-D attenuation model (Qp) |
| sources | Source location file |
| receivers | Receiver location file |

## Source Code Structure

The main source files are located in the folder `Src_Read`.

- **vel_model_load.cpp**  
  Loads the 3-D velocity model.

- **att_model_load.cpp**  
  Loads the 3-D attenuation model (quality factor Q).

- **source_load.cpp**  
  Reads source information such as earthquake locations.

- **receiver_load.cpp**  
  Reads receiver information such as station locations.

- **raytracing.cpp**  
  Performs ray tracing along the negative gradient of the traveltime field.

- **read_parafile.cpp**  
  Reads parameters required for the calculation.

- **eikonal.cpp**  
  Implements the fast marching algorithm and computes the traveltime t and attenuation operator t*.

- **main.cpp**  
  Main driver program combining all modules.

## Important Parameters

When using this package, several parameters in main.cpp may need to be modified depending on your application.

- **usesecond = false**  
  Determines whether second-order derivatives are used in the fast marching update. Possible values: true or false.

- **usecross = false**  
  Determines whether cross derivatives are used. It is recommended to keep this parameter set to false.

- **output_ts = true**  
  Determines whether the traveltime field and the attenuation operator t* field are written to output files.
