using FreeBird

np = 4

# First, we need to read the walkers from a file
ats = read_walkers("slab-04-1.extxyz",pbc="TTF")
ats = [AtomWalker{2}(at.configuration;list_num_par=[80,np],frozen=Bool[1,0]) for at in ats]
# Note that the periodic boundary conditions are set to True, True, False

lj = LJParameters(epsilon=0.1, sigma=2.5, cutoff=4.0, shift=true)

ls = LJAtomWalkers(ats, lj)


# Wang-Landau

initial_walker = deepcopy(ats[2])

energy_min = -57.06 # -57.0703 GE
energy_max = -50.5
num_energy_bins = 1000

step_size = 0.5

wl_params = WangLandauParameters(num_steps=10_000,
                            energy_min=energy_min,  
                            energy_max=energy_max, 
                            num_energy_bins=num_energy_bins, 
                            step_size=step_size,
                            max_iter=10000,
                            f_min=1.001)

energies_wl, configs, wl_params, S, H = wang_landau(initial_walker, lj, wl_params)