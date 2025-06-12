using FreeBird

kb = 8.617333262e-5

initial_config = FreeBirdIO.generate_random_starting_config(562.5, 6)
at_init = AtomWalker(initial_config)
ats = [at_init]

lj = LJParameters(epsilon=0.1, sigma=2.5, cutoff=4.0, shift=true)
ls = LJAtomWalkers(ats, lj)


# Wang-Landau

initial_walker = deepcopy(ats[1])

step_size = 1.0 

energy_min = -1.26
energy_max = 0.0
num_energy_bins = 1000

wl_params = WangLandauParameters(num_steps=10_000,
                            energy_min=energy_min,  
                            energy_max=energy_max, 
                            num_energy_bins=num_energy_bins, 
                            step_size=step_size,
                            max_iter=10000,
                            f_min=1.00001)

energies_wl, configs, wl_params, S, H = wang_landau(initial_walker, lj, wl_params)