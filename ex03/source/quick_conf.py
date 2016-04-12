class QuickConf:

    flatland = False

    if flatland:
        generations = 50
        population_size = 200
        number_of_children = 200
        genotype_length = 18 * 16
        adult_selection = "g"
        parent_selection = "t"
        tournament_epsilon = 0.9
        tournament_group_size = 20
        boltzmann_temperature = 1.0
        boltzmann_delta_t = 0.01
        crossover_rate = 0.1
        children_per_pair = 2
        mutation_type = "g"
        mutation_rate = 1.0
        food_bonus = 1.0
        poison_penalty = 2.0
        small_object_bonus = 1.0
        big_object_penalty = 2.0
        pull_mode = False
        no_wrap = False
        timesteps = 60

    else:
        generations = 50
        population_size = 200
        number_of_children = 200
        pull_mode = True
        no_wrap = False
        timesteps = 600
        genotype_length = 34 * 8 if not no_wrap else 38 * 8
        adult_selection = "g"
        parent_selection = "t"
        tournament_epsilon = 0.2
        tournament_group_size = 40
        boltzmann_temperature = 1.0
        boltzmann_delta_t = 0.01
        crossover_rate = 0.5
        children_per_pair = 2
        mutation_type = "g"
        mutation_rate = 1.0
        food_bonus = 1.0
        poison_penalty = 2.0
        small_object_bonus = 1.0
        big_object_penalty = 10.0
