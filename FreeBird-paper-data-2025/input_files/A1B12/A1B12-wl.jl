using FreeBird

lj11 = LJParameters(epsilon=0.1, sigma=2.5, cutoff=4.0)
lj22 = LJParameters(epsilon=0.05, sigma=2.5, cutoff=4.0)
lj12 = LJParameters(epsilon=sqrt(0.1*0.05), sigma=2.5, cutoff=4.0)

lj = CompositeLJParameters(2, [lj11, lj12, lj22])

at = [FreeBirdIO.generate_multi_type_random_starting_config(281.25,[1,12];particle_types=[:H,:He]) for _ in 1:1]
walkers = [AtomWalker(a) for a in at]

ls = LJAtomWalkers(walkers, lj)

# Wang-Landau

initial_walker = deepcopy(walkers[1])

step_size = 1.0

energy_min = -2.45
energy_max = 0.0
num_energy_bins = 1000

wl_params = WangLandauParameters(num_steps=100_000,
                            energy_min=energy_min,  
                            energy_max=energy_max, 
                            num_energy_bins=num_energy_bins, 
                            step_size=step_size,
                            max_iter=100000,
                            f_min=1.00001)

energies_wl, configs, wl_params, S, H = wang_landau(initial_walker, lj, wl_params)