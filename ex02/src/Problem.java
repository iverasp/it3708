import java.util.ArrayList;

/**
 * Created by iver on 22/02/16.
 */
public interface Problem {

    int mutateGenomeComponent(int component);
    double fitness(String phenotype);
    ArrayList<Individual> createInitialPopulation(int size);
    String genotypeToPhenotype(String genotype);
    ArrayList<Individual> adultSelection(ArrayList<Individual> population);
    Individual parentSelection(ArrayList<Individual> population, int k , double epsilon, double... args);
    Individual crossover(Individual parent1, Individual parent2);
    ArrayList<Individual> mutate(ArrayList<Individual> population, double rate);

}
