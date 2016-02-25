package ai;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

/**
 * Created by iver on 22/02/16.
 */
public class LOLZ extends AbstractProblem implements Problem {

    private int z;
    private int genotypeSize;

    public LOLZ(int z, int genotypeSize) {
        this.z = z;
        this.genotypeSize = genotypeSize;
    }

    @Override
    public char mutateGenomeComponent(char component) {
        return mutateGenomeComponentSimple(component);
    }

    @Override
    public double fitness(String phenotype) {
        //System.out.println("Phenotype: " + phenotype);

        int counter = 0;
        char first = phenotype.charAt(0);

        for (int i = 0; i < phenotype.length(); i++) {
            if (phenotype.charAt(i) == first) counter++;
            else break;
        }
        if (first == 'A' && counter > this.z) counter = this.z;
        return (double) counter / (double) phenotype.length();


    }

    @Override
    public List<Individual> adultSelection(List<Individual> population) {
        return fullReplacement(population);
    }

    @Override
    public Individual parentSelection(List<Individual> population, double k, double epsilon, double... args) {
        //return tournamentSelection(population, k, epsilon);
        return fitnessProportionateSelection(population);
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
