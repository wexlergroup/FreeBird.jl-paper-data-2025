using FreeBird

np = 4

# First, we need to read the walkers from a file
ats = read_walkers("slab-04.extxyz",pbc="TTF")
ats = [AtomWalker{2}(at.configuration;list_num_par=[80,np],frozen=Bool[1,0]) for at in ats]
# Note that the periodic boundary conditions are set to True, True, False

lj = LJParameters(epsilon=0.1, sigma=2.5, cutoff=4.0, shift=true)

ls = LJAtomWalkers(ats, lj)

# Wang-Landau

initial_walker = deepcopy(ats[2])

energy_min = -57.06 # Groud-state energy -57.07029072166561 eV
energy_max = -50.0
num_energy_bins = 1000
step_size = 1.0

wl_params = WangLandauParameters(num_steps=10_000,
                            energy_min=energy_min,
                            energy_max=energy_max,
                            num_energy_bins=num_energy_bins,
                            step_size=step_size,
                            max_iter=10000,
                            f_min=1.00001,
                            random_seed=Int(round(time())))

energies_wl, configs, wl_params, S, H = wang_landau(initial_walker, lj, wl_params)

using DataFrames

df_entropy = DataFrame(energy=wl_params.energy_bins, entropy=S)

write_df("output_df_wl_entropy.csv", df_entropy)