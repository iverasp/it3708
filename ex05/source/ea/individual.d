module ea.individual;

import ea.ea_config;
import std.algorithm;
import std.conv;
import std.random;
import std.string;
import std.stdio;
import pyd.pyd;

class Individual {

    // These are generic variables
    EaConfig config;
    int genotypeLength;
    int[] genotype;
    int[] phenotype;
    float fitness;

    this(EaConfig config) {
        this.config = config;
        this.genotypeLength = config.getGenotypeLength; //genotypeLength;
        genotype = new int[](config.getGenotypeLength); //genotypeLength);
        phenotype = new int[](config.getGenotypeLength);
        fitness = 0.0f;
    }

    @property int[] getPhenotype() { return phenotype; }

    @property float getFitness() { return fitness; }

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
