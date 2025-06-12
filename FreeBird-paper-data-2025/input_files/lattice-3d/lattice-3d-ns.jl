using FreeBird

adsorption_energy = -0.04
nn_energy = -0.01
nnn_energy = -0.0025

initial_lattice = SLattice{SquareLattice}(components=[[1,2,3,4]], 
                        supercell_dimensions=(4,4,3), 
                        adsorptions=collect(1:16))

h = GenericLatticeHamiltonian(adsorption_energy, [nn_energy, nnn_energy], u"eV")

using Distributions

walkers = [deepcopy(initial_lattice) for i in 1:2000]

for walker in walkers
    walker.components[1] = [false for i in 1:length(walker.components[1])]
    for i in sample(1:length(walker.components[1]), 4, replace=false)
        walker.components[1][i] = true
    end
end

walkers = [LatticeWalker(walker) for walker in walkers]

ls = LatticeGasWalkers(walkers, h)

mc = MCRejectionSampling()
ns_params = LatticeNestedSamplingParameters(mc_steps=100,allowed_fail_count=1_000_000,random_seed=1234*Int(round(time() * 1000)))
save = SaveEveryN(n_traj=1000, n_snap=10000, df_filename="output_df_3d_ns.csv")

ns_energies, ls, _ = nested_sampling(ls, ns_params, 30_000, mc, save)