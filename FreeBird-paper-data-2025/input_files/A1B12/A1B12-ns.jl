using FreeBird

lj11 = LJParameters(epsilon=0.1, sigma=2.5, cutoff=4.0)
lj22 = LJParameters(epsilon=0.05, sigma=2.5, cutoff=4.0)
lj12 = LJParameters(epsilon=sqrt(0.1*0.05), sigma=2.5, cutoff=4.0)

lj = CompositeLJParameters(2, [lj11, lj12, lj22])

at = [FreeBirdIO.generate_multi_type_random_starting_config(50.0,[13,20];particle_types=[:H,:He]) for _ in 1:120]
walkers = [AtomWalker(a) for a in at]

ls = LJAtomWalkers(walkers, lj)

ns_params = NestedSamplingParameters(200, 0.1, 0.01, 1e-5, 1.0, 0, 200, 1234)
mc = MCRandomWalkClone()
save = SaveEveryN(n_traj=100, n_snap=10_000)

energies, liveset, _ = nested_sampling_loop!(ls, ns_params, 100_000, mc, save)
