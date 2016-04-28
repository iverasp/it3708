class QuickConf:

    generations = 1000
    population_size = 1500
    number_of_children = 1500
    genotype_length = 48
    adult_selection = "g"
    parent_selection = "t"
    tournament_epsilon = 0.9
    tournament_group_size = 50
    boltzmann_temperature = 1.0
    boltzmann_delta_t = 0.01
    crossover_rate = 0.1
    children_per_pair = 2
    mutation_type = "g"
    mutation_rate = 1.0
    food_bonus = 1.0
    poison_penalty = 2.0
    big_object_bonus = 2.0
    big_object_penalty = 2.0
    small_object_bonus = 1.0
    small_object_penalty = 1.0
    pull_mode = False
    no_wrap = False
    timesteps = 60
