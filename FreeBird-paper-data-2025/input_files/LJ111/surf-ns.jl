using FreeBird

np = 4

# First, we need to read the walkers from a file
ats = read_walkers("slab-04.extxyz",pbc="TTF")
ats = [AtomWalker{2}(at.configuration;list_num_par=[80,np],frozen=Bool[1,0]) for at in ats]
# Note that the periodic boundary conditions are set to True, True, False

lj = LJParameters(epsilon=0.1, sigma=2.5, cutoff=4.0, shift=true)

ls = LJAtomWalkers(ats, lj)

mc = MCRandomWalkClone()
ns_params = NestedSamplingParameters(step_size=0.1)
save = SaveEveryN(n_traj=100, n_snap=1_000, n_info=100)

energies, ls, _ = nested_sampling(ls, ns_params, 50_000, mc, save)