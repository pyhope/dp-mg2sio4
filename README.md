# Train an MLP for Mg<sub>2</sub>SiO<sub>4</sub> using DeePMD-kit

## General procedure
### Step 1: prepare the initial training set
1. **Solid:** Run NPT simulations using VASP under targe P/T conditions (500, 900, and 1300 GPa; 4000, 5000, 6000, and 7000 K). I choose a simulation time of 5000 fs for each ordered/disordered structure. Calculate the average volumes for each trajectory.
2. **Liquid:** Select some solids with different volumes from above simulations. Melt them under NVT ensemble, i.e., liquids have the same volumes as those solids. Run long NVT simulations (I choose 10 ps) for each liquid using VASP at a high temperature.
* **Note**: Including the liquid in the training set is not intended for the MLP to simulate the liquid phase, but rather to sample more local environments to improve the MLP's performance in simulating disordered solids. Thus, we keep the volumes of liquids the same as the solids. Additionally, at the recalculation step, the temperatures for liquids are set to 4000-7000 K.

### Step 2: Convergence test
1. Convergence test for PCA analysis:
   1. Try different numbers of frames (e.g., 50, 100, 200, etc) to do PCA analyses for some trajectories in Step 1. 
   2. Train preliminary models using different numbers of PCA frames (without recalculation at this stage). 
   3. Run several short AIMD simulations with different initial velocities (by changing the random seed) to generate a test set. 
   4. Plot the test error as a function of the number of PCA frames, and determine how many frames are needed to achieve the desired test error.
2. Convergence test for KPOINTS and ENCUT:
   1. Plot TOTEN as a function of the KPOINTS and ENCUT to determine the appropriate setup for high-accuracy recalculations.
   
### Step 3: Recalculation
1. Do PCA analyses for all trajectories in Step 1. Construct a training set using these frames. Random select some frames that are not selected by PCA to construct a test set.
2. Do high-accuracy DFT recalculations for both training and test sets.
3. Use the recalculated training set (set.000) and test set (set.001) to train a preliminary MLP.

### Step 4: Iterative training
1. Run NPT simulations for various disordered structures that are not included in Step 1 using LAMMPS and the preliminary MLP.
2. Do PCA analyses and high-accuracy DFT recalculation.
3. Calculate the test error (energy, force, and stress RMSE) for each structure. For a structure with high RMSEs, add all recalculated frames of it into the training set. For a structure with acceptable RMSEs, add all recalculated frames of it into the test set.
4. Train an updated MLP with the new training and test sets and repeat Step 4.
* **Note**: In LAMMPS NPT simulations, we can set the beginning and ending pressures to be different to explore various intermediate pressures between 500 and 1300 GPa.
