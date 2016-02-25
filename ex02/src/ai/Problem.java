package ai;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by iver on 22/02/16.
 */
public interface Problem {

    char mutateGenomeComponent(char component);
    double fitness(String phenotype);
    List<Individual> createInitialPopulation(int size, int genotypeSize);
    String genotypeToPhenotype(String genotype);
    List<Individual> adultSelection(List<Individual> population);
    Individual parentSelection(List<Individual> population, double k , double epsilon, double... args);
    Individual crossover(Individual parent1, Individual parent2);
    List<Individual> mutate(List<Individual> population, double rate);
    void setAdultMechanism(String mechanism);
    void setParentMechanism(String mechanism);
    String getAdultMechanism();
    String getParentMechanism();

}
