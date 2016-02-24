package ai;

import java.util.ArrayList;
import java.util.Collections;
import java.util.concurrent.ThreadLocalRandom;

/**
 * Created by iver on 23/02/16.
 */
public class OneMax extends AbstractProblem implements Problem {

    private int genotypeSize;
    private String ideal;

    public OneMax(int genotypeSize, boolean random) {
        this.genotypeSize = genotypeSize;
        this.ideal = "";
        for (int i = 0; i < genotypeSize; i ++) {
            if (random) ideal += Integer.toString(ThreadLocalRandom.current().nextInt(0, 2));
            else ideal += "1";
        }
    }

    @Override
    public char mutateGenomeComponent(char component) {
        return component == '1' ? '0' : '1';
    }

    @Override
    public double fitness(String phenotype) {
        //System.out.println("Checking fitness of " + phenotype);
        int error = 0;
        for (int i = 0 ; i < genotypeSize; i++) {
            if (phenotype.charAt(i) != this.ideal.charAt(i)) error += 1;
        }

        double fitness = 1 - ((double) error / (double) this.genotypeSize);
        //System.out.println("Fitness: " + fitness);

        return fitness;
    }

    @Override
    public ArrayList<Individual> adultSelection(ArrayList<Individual> population) {
        return fullReplacement(population);
    }

    @Override
    public Individual parentSelection(ArrayList<Individual> population, double k, double epsilon, double... args) {
        return tournamentSelection(population, k, epsilon);
    }

    @Override
    public Individual crossover(Individual parent1, Individual parent2) {
        return onePointCrossover(parent1, parent2);
    }

    @Override
    public ArrayList<Individual> mutate(ArrayList<Individual> population, double rate) {
        return mutatePerGenome(population, rate);
    }

}
