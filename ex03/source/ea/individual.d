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

    this(int genotypeLength) {
        this.genotypeLength = genotypeLength;
        genotype = new float[](genotypeLength);
        phenotype = new float[](genotypeLength);
        fitness = 0.0f;
        fitnessRange = 0.0f;
    }
    
    @property float[] getPhenotype(){ return phenotype; }

    @property float getFitness(){ return fitness; }

    void generateGenotype() {
        for (int i = 0; i < genotypeLength; i++) {
            genotype[i] = uniform(0.0f, 1.0f);
        }
    }

    void generatePhenotype() {
        phenotype = genotype.dup;
    }

    void evaluateFitness() {
        // This calculates onemax fitness:
        fitness = to!double(genotype.sum) / to!double(genotype.length);

        //fitness = devouredFood + (-devouredPoison * 2);
    }
}
