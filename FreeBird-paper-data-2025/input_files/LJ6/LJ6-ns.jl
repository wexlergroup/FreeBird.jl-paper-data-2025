using FreeBird

configs = generate_initial_configs(120, 562.5, 6)
walkers = AtomWalker.(generate_initial_configs(120, 562.5, 6))

lj = LJParameters(epsilon=0.1, sigma=2.5, cutoff=4.0)
ls = LJAtomWalkers(walkers, lj)

ns_params = NestedSamplingParameters(mc_steps=200, step_size=0.1, random_seed=Int(round(time())))
mc = MCRandomWalkClone()
save = SaveEveryN(n_traj=10, n_snap=10_000, n_info=10)

energies, liveset, _ = nested_sampling(ls, ns_params, 30_000, mc, save)