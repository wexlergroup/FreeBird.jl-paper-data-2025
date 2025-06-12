using FreeBird

for N in 1:3

    np = 4

    # First, we need to read the walkers from a file
    ats = read_walkers("slab-04-$N.extxyz",pbc="TTF")
    ats = [AtomWalker{2}(at.configuration;list_num_par=[80,np],frozen=Bool[1,0]) for at in ats]
    # Note that the periodic boundary conditions are set to True, True, False

    # Then, we need to create a potential object
    lj = LJParameters(epsilon=0.1, sigma=2.5, cutoff=4.0, shift=true)

    # Now, we can create the liveset by combining the walkers and the potential
    ls = LJAtomWalkers(ats, lj)
    # The last argument is the number of frozen particles

    # We can now create a Monte Carlo object
    mc = MCRandomWalkClone()
    ns_params = NestedSamplingParameters(step_size=0.1)
    # We can also create a save object
    save = SaveEveryN(n_traj=100, n_snap=1_000, df_filename="output_df_ns$N.csv", traj_filename="output_traj_ns$N.tarj", n_info=100)

    # And finally, we can run the simulation
    energies, ls, _ = nested_sampling(ls, ns_params, 50_000, mc, save)

end