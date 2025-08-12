using FreeBird

lj11 = LJParameters(epsilon=0.1, sigma=2.5, cutoff=4.0)
lj22 = LJParameters(epsilon=0.05, sigma=2.5, cutoff=4.0)
lj12 = LJParameters(epsilon=sqrt(0.1*0.05), sigma=2.5, cutoff=4.0)

lj = CompositeLJParameters(2, [lj11, lj12, lj22])

walkers =AtomWalker.(generate_initial_configs(960, 281.25, [1,12]; particle_types=[:H,:He]))

ls = LJAtomWalkers(walkers, lj)

ns_params = NestedSamplingParameters(mc_steps=400, step_size=0.1, random_seed=Int(round(time())))
mc = MCRandomWalkClone()
save = SaveEveryN(n_traj=100, n_snap=10_000, n_info=10)

energies, liveset, _ = nested_sampling(ls, ns_params, 500_000, mc, save)
