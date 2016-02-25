package ai;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

/**
 * Created by iver on 24/02/16.
 */
public class SurprisingSequence extends AbstractProblem implements Problem {

    int symbols;
    int genotypeSize;
    int numberOfAdults;
    String parentMethod;

    public SurprisingSequence(int symbols, int genotypeSize, int numberOfAdults) {
        this.symbols = symbols;
        this.genotypeSize = genotypeSize;
        this.numberOfAdults = numberOfAdults;
        this.parentMethod = "";
    }

    @Override
    public List<Individual> createInitialPopulation(int size, int genotypeSize) {
        List<Individual> individuals = new ArrayList<>();
        for (int i = 0; i < size; i++) {
            String genotype = "";
            for (int j = 0; j < genotypeSize; j++) {
                genotype += (char) ThreadLocalRandom.current().nextInt(65, symbols + 65);
            }
            //System.out.println(genotype);
            individuals.add(new Individual(genotype));
        }
        return individuals;
    }

    @Override
    public char mutateGenomeComponent(char component) {
        return (char) ThreadLocalRandom.current().nextInt(65, symbols + 65);
    }

    @Override
    public char mutateGenomeComponentSimple(char component) {
        return (char) ThreadLocalRandom.current().nextInt(65, symbols + 65);
    }

    @Override
    public double fitness(String phenotype) {
        ArrayList<String> stuff = new ArrayList<>();
        int error = 0;
        for (int i = 0; i < phenotype.length(); i++) {
            for (int j = i + 1; j < phenotype.length(); j++) {
                String sequence = phenotype.charAt(i) + "-" + phenotype.charAt(j) + ":" + Integer.toString(j - i);
                if (stuff.contains(sequence)) error++;
                else stuff.add(sequence);
            }
        }

        double maxError = (phenotype.length() * (phenotype.length() - 1)) / 2;
        double result = (maxError - error) / maxError;

        if (result == 1.0) {
            //System.out.println("FOUND IT! " + phenotype);
        }
        //System.out.println("Fitness of phenotype " + ": " + result);
        return result;
    }

    @Override
    public List<Individual> adultSelection(List<Individual> population) {
        return overProduction(population, numberOfAdults);
    }

    @Override
    public Individual parentSelection(List<Individual> population, double k, double epsilon, double... args) {
        switch (parentMethod) {
            case "TOURNAMENT_SELECTION":
                return tournamentSelection(population, k, epsilon, args);
            case "BOLTZMAN_SELECTION":
                return boltzmanSelection(population, 1);
            case "FITNESS_PROPORTIONATE_SELECTION":
                return fitnessProportionateSelection(population);
            default:
                return tournamentSelection(population, k, epsilon, args);
        }
    }

    @Override
    public Individual crossover(Individual parent1, Individual parent2) {
        return onePointCrossover(parent1, parent2);
    }

    @Override
    public List<Individual> mutate(List<Individual> population, double rate) {
        return mutatePerGenomeComponent(population, rate);
    }
}
