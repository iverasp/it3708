package ai;

import java.util.ArrayList;
import java.util.concurrent.ThreadLocalRandom;

/**
 * Created by iver on 24/02/16.
 */
public class SurprisingSequence extends AbstractProblem implements Problem {

    int symbols;
    int genotypeSize;

    public SurprisingSequence(int symbols, int genotypeSize) {
        this.symbols = symbols;
        this.genotypeSize = genotypeSize;
    }

    @Override
    public ArrayList<Individual> createInitialPopulation(int size, int genotypeSize) {
        ArrayList<Individual> individuals = new ArrayList<>();
        for (int i = 0; i < size; i++) {
            String genotype = "";
            for (int j = 0; j < genotypeSize; j++) {
                genotype += Integer.toString(ThreadLocalRandom.current().nextInt(0, symbols));
            }
            //System.out.println(genotype);
            individuals.add(new Individual(genotype));
        }
        return individuals;
    }

    @Override
    public char mutateGenomeComponent(char component) {
        return Integer.toString(ThreadLocalRandom.current().nextInt(0, symbols)).charAt(0);
    }

    @Override
    public double fitness(String phenotype) {
        ArrayList<String> stuff = new ArrayList<>();
        int error = 0;
        for (int i = 0; i < phenotype.length(); i++) {
            for (int j = 0; j < phenotype.length(); j++) {
                String sequence = phenotype.charAt(i) + phenotype.charAt(j) + ":" + Integer.toString(j - i);
                if (stuff.contains(sequence)) error++;
                else stuff.add(sequence);
            }
        }

        return 1.0 / (1.0 + error );
    }

    @Override
    public ArrayList<Individual> adultSelection(ArrayList<Individual> population) {
        return null;
    }

    @Override
    public Individual parentSelection(ArrayList<Individual> population, double k, double epsilon, double... args) {
        return tournamentSelection(population, k, epsilon, args);
    }

    @Override
    public Individual crossover(Individual parent1, Individual parent2) {
        return onePointCrossover(parent1, parent2);
    }

    @Override
    public ArrayList<Individual> mutate(ArrayList<Individual> population, double rate) {
        return null;
    }
}
