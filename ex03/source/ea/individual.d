module ea.individual;

import ea.config;
import std.algorithm;
import std.conv;
import std.random;
import std.string;
import std.stdio;
import pyd.pyd;

class Individual {

    // These are generic variables
    Config config;
    int genotypeLength;
    float[] genotype;
    float[] phenotype;
    double fitness;
    double fitnessRange;

    // These are problem specific variables
    int devouredFood;
    int devouredPoison;

    this(Config config) {
        genotypeLength = config.getGenotypeLength;
        genotype = new float[](config.getGenotypeLength);
        phenotype = new float[](config.getGenotypeLength);
        fitness = 0.;
        fitnessRange = 0.;
    }
    
    @property float[] getPhenotype(){ return phenotype; }

    @property float getFitness(){ return fitness; }

    void generateGenotype() {
        for (int i = 0; i < genotypeLength; i++) {
            genotype[i] = uniform01();
        }
    }

    void generatePhenotype() {
        phenotype = genotype.dup;
    }

    void evaluateFitness() {
        // This calculates onemax fitness:
        // fitness = to!double(genotype.sum) / to!double(genotype.length);

        fitness = devouredFood + (-devouredPoison * 2);
    }
}
