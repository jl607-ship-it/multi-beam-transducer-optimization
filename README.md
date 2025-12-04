# 2023 CUMCM Problem B Solution (Multi-beam Echo Sounding)

This repository contains the MATLAB source code for the 2023 China Undergraduate Mathematical Contest in Modeling (CUMCM), Problem B: "Design of Multi-beam Echo Sounding Survey Lines".

## Project Structure

- `problem1.m`: Solution for Question 1. Calculates the coverage width ($W$) and overlap rate ($\eta$) for a single survey line on a regular slope.
- `problem2.m`: Solution for Question 2. Determines the optimal line spacing ($d$) and direction ($\beta$) to ensure full coverage with minimum total length.
- `problem3.m`: Solution for Question 3. Design of survey lines for a realistic 3D seabed terrain (imported from Excel data).
- `Attachment.xlsx`: The raw bathymetric data provided by the competition.
- `间距为1.xlsx`: Processed grid data (if applicable).

## How to Run

1. Ensure you have MATLAB installed.
2. Clone or download this repository.
3. Open the `.m` files in MATLAB.
4. **Note**: Make sure the Excel files are in the same directory as the scripts, or add them to your MATLAB path.

## Methodology

- **Coordinate System**: Established with the southwest corner as the origin.
- **Algorithms**:
  - Geometric modeling of the sounding footprint.
  - Iterative search for optimal overlap rates ($\eta \in [10\%, 20\%]$).
  - Slope calculation using numerical differentiation of the grid data.

## Results

- **Problem 2**: Optimized spacing and angle found by traversing $\beta \in [0, \pi]$ and calculating total line lengths.
- **Problem 3**: Calculated the shortest survey length and the percentage of missed sea area for the given terrain.

## License

MIT License
