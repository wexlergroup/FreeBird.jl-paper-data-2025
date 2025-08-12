using FreeBird

np = 4

# First, we need to read the walkers from a file
ats = read_walkers("slab-04.extxyz",pbc="TTF")
ats = [AtomWalker{2}(at.configuration;list_num_par=[80,np],frozen=Bool[1,0]) for at in ats]
# Note that the periodic boundary conditions are set to True, True, False

lj = LJParameters(epsilon=0.1, sigma=2.5, cutoff=4.0, shift=true)

ls = LJAtomWalkers(ats, lj)

# grab a random walker from the list as the initial configuration
at = deepcopy(rand(ls.walkers)) 

temperatures = collect(2000.0:-100:100.0)
num_equilibration_steps = 5_000_000
num_sampling_steps = 5_000_000
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

write_walkers("output_mc.tarj.extxyz", mc_ls.walkers)

using DataFrames

df = DataFrame()

kb = 8.617333262145e-5 # eV/K
dof = np * 3

df.Temp = temperatures
df.energy = mc_energies
df.Cv = mc_cvs .+ dof * kb / 2 # adding kinetic contribution

write_df("output_df_mc.csv", df)