package ai;

import java.util.ArrayList;

/**
 * Created by iver on 22/02/16.
 */
public interface Problem {

    char mutateGenomeComponent(char component);
    double fitness(String phenotype);
    ArrayList<Individual> createInitialPopulation(int size, int genotypeSize);
    String genotypeToPhenotype(String genotype);
    ArrayList<Individual> adultSelection(ArrayList<Individual> population);
    Individual parentSelection(ArrayList<Individual> population, double k , double epsilon, double... args);
    Individual crossover(Individual parent1, Individual parent2);
    ArrayList<Individual> mutate(ArrayList<Individual> population, double rate);

}
