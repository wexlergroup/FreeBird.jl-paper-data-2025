using FreeBird

lj11 = LJParameters(epsilon=0.1, sigma=2.5, cutoff=4.0)
lj22 = LJParameters(epsilon=0.05, sigma=2.5, cutoff=4.0)
lj12 = LJParameters(epsilon=sqrt(0.1*0.05), sigma=2.5, cutoff=4.0)

lj = CompositeLJParameters(2, [lj11, lj12, lj22])

at = [FreeBirdIO.generate_multi_type_random_starting_config(281.25,[1,12];particle_types=[:H,:He]) for _ in 1:1]
walkers = [AtomWalker(a) for a in at]

ls = LJAtomWalkers(walkers, lj)

at = deepcopy(ls.walkers[1])

temperatures = collect(400.0:-25:100)
num_equilibration_steps = 10_000_000
num_sampling_steps = 5_000_000
step_size = 1.0

mc_params = MetropolisMCParameters(
    temperatures,
    equilibrium_steps=num_equilibration_steps,
    sampling_steps=num_sampling_steps,
    step_size=step_size,
    step_size_up=0.5,
    accept_range=(0.5, 0.5),
    random_seed=random_seed=Int(round(time()))
)

mc_energies, mc_ls, mc_cvs, acceptance_rates = monte_carlo_sampling(at, lj, mc_params)

write_walkers("output_mc.tarj.extxyz", mc_ls.walkers)

using DataFrames

df = DataFrame()

kb = 8.617333262145e-5 # eV/K
dof = 13 * 3

df.Temp = temperatures
df.energy = mc_energies
df.Cv = mc_cvs .+ dof * kb / 2 # adding kinetic contribution

write_df("output_df_mc.csv", df)