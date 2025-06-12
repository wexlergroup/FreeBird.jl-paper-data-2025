using FreeBird

adsorption_energy = -0.04
nn_energy = -0.01
nnn_energy = -0.0025

initial_lattice = SLattice{SquareLattice}(components=[[1,2,3,4]])

h = GenericLatticeHamiltonian(adsorption_energy, [nn_energy, nnn_energy], u"eV")

# Wang-Landau
energy_min = 20.5 * nn_energy + nn_energy / 8
energy_max = 16 * nn_energy - nn_energy / 8
num_energy_bins = 100

wl_params = WangLandauParameters(
    energy_min=energy_min, 
    energy_max=energy_max,
    random_seed=Int(round(time() * 1000)),)

energies_wl, configs, wl_params, S, H = wang_landau(initial_lattice, h, wl_params)