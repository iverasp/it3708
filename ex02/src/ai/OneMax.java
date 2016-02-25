package ai;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

/**
 * Created by iver on 23/02/16.
 */
public class OneMax extends AbstractProblem implements Problem {

    private int genotypeSize;
    private String ideal;
    private int numberOfAdults;

    public OneMax(int genotypeSize, boolean random, int numberOfAdults) {
        this.genotypeSize = genotypeSize;
        this.numberOfAdults = numberOfAdults;
        this.ideal = "";
        for (int i = 0; i < genotypeSize; i ++) {
            if (random) ideal += (char) ThreadLocalRandom.current().nextInt(65, 67);
            else ideal += "B";
        }
    }

    @Override
    public char mutateGenomeComponent(char component) {
        return component == 'B' ? 'A' : 'B';
    }

    @Override
    public double fitness(String phenotype) {
        //System.out.println("Checking fitness of " + phenotype);
        int error = 0;
        for (int i = 0 ; i < genotypeSize; i++) {
            if (phenotype.charAt(i) != this.ideal.charAt(i)) error += 1;
        }

        double fitness = 1 - ((double) error / (double) this.genotypeSize);
        //System.out.println("Fitness: " + fitness + " - " + phenotype);
        if (fitness == 1.0) {
            //System.out.println("break here");
        }

        return fitness;
    }

    @Override
    public Individual crossover(Individual parent1, Individual parent2) {
        return onePointCrossover(parent1, parent2);
    }

    @Override
    public List<Individual> mutate(List<Individual> population, double rate) {
        return mutatePerGenome(population, rate);
    }

}
