using FreeBird

adsorption_energy = -0.04
nn_energy = -0.01
nnn_energy = -0.0025

initial_lattice = SLattice{SquareLattice}(components=[[1,2,3,4]], 
                        supercell_dimensions=(4,4,3), 
                        adsorptions=collect(1:16))

h = GenericLatticeHamiltonian(adsorption_energy, [nn_energy, nnn_energy], u"eV")

# Metropolis Monte Carlo
mc_lattice = deepcopy(initial_lattice)

temperatures = collect(500:-10:10)
num_equilibration_steps = 100_000
num_sampling_steps = 100_000

mc_params = MetropolisMCParameters(
    temperatures,
    equilibrium_steps=num_equilibration_steps,
    sampling_steps=num_sampling_steps,
    random_seed=1234*Int(round(time() * 1000)),
)


mc_energies, mc_ls, mc_cvs, acceptance_rates = monte_carlo_sampling(mc_lattice, h, mc_params)