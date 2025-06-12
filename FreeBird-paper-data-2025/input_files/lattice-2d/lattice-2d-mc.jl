using FreeBird

adsorption_energy = -0.04
nn_energy = -0.01
nnn_energy = -0.0025

initial_lattice = SLattice{SquareLattice}(components=[[1,2,3,4]])

h = GenericLatticeHamiltonian(adsorption_energy, [nn_energy, nnn_energy], u"eV")

# Metropolis Monte Carlo
mc_lattice = deepcopy(initial_lattice)

temperatures = collect(200.0:-10:10)
num_equilibration_steps = 25_000
num_sampling_steps = 25_000

mc_params = MetropolisMCParameters(
    temperatures,
    equilibrium_steps=num_equilibration_steps,
    sampling_steps=num_sampling_steps,
    random_seed=Int(round(time()))
)


mc_energies, mc_configs, mc_cvs, acceptance_rates = monte_carlo_sampling(mc_lattice, h, mc_params)