using FreeBird

initial_config = FreeBirdIO.generate_random_starting_config(562.5, 6)
at_init = AtomWalker(initial_config)

lj = LJParameters(epsilon=0.1, sigma=2.5, cutoff=4.0)

# Metropolis Monte Carlo
ats = LJAtomWalkers([at_init], lj)
at = deepcopy(ats.walkers[1])

temperatures = collect(1000.0:-50:0)
num_equilibration_steps = 100_000
num_sampling_steps = 100_000
step_size = 1.0 

mc_params = MetropolisMCParameters(
    temperatures,
    equilibrium_steps=num_equilibration_steps,
    sampling_steps=num_sampling_steps,
    step_size=step_size,
    step_size_up=1.0,
    accept_range=(0.5,0.5),
    random_seed=Int(round(time()))
)

mc_energies, mc_ls, mc_cvs, acceptance_rates = monte_carlo_sampling(at, lj, mc_params)

# Save the equilibrated configurations
write_walkers("output_mc.tarj.extxyz", mc_ls.walkers)

# Save the energies and specific heats
using DataFrames

df = DataFrame()

kb = 8.617333262145e-5 # eV/K
dof = 6 * 3

df.Temp = temperatures
df.energy = mc_energies
df.Cv = mc_cvs .+ dof * kb / 2 # adding kinetic contribution

write_df("output_df_mc.csv", df)