module ea.individual;

import ea.ea_config;
import tsp.tsp;
import std.algorithm;
import std.conv;
import std.random;
import std.string;
import std.stdio;
import pyd.pyd;

class Individual {

    // These are generic variables
    EaConfig config;
    TSP tsp;
    int genotypeLength;
    int[] genotype;
    int[] phenotype;
    float fitness;
    int distanceValue;
    int costValue;

    this(EaConfig config TSP tsp) {
        this.config = config;
        this.genotypeLength = config.getGenotypeLength; //genotypeLength;
        genotype = new int[](config.getGenotypeLength); //genotypeLength);
        phenotype = new int[](config.getGenotypeLength);
        fitness = 0.0f;
    }

    @property int[] getPhenotype() { return phenotype; }

    @property float getFitness() { return fitness; }

    @property void setFitness(float fitness) { this.fitness = fitness; }

    void calcValues() {
        distanceValue = tsp.getTravelValue(this.genotype, true);
        costValue = tsp.getTravelValue(this.genotype, false);
    }

    int[][] getValues() {
        return int[distanceValue][costValue];
    }

    void setGenotype(int[] genotype) {
        this.genotype = genotype;
    }

    void generateGenotype() {
        foreach(i; 0 .. genotypeLength) {
            genotype[i] = uniform(0, 2) == 0;
        }
    }

    void generatePhenotype() {
        phenotype = genotype.dup;
    }

    void evaluateFitness() {

    }
}
