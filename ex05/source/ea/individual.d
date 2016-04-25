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
    bool[] genotype;
    float[] phenotype;
    float fitness;

    this(EaConfig config) {
        this.config = config;
        this.genotypeLength = config.getGenotypeLength; //genotypeLength;
        genotype = new bool[](config.getGenotypeLength); //genotypeLength);
        phenotype = new float[](config.getGenotypeLength / 16L); //genotypeLength);
        fitness = 0.0f;
    }

    @property float[] getPhenotype() { return phenotype; }

    @property float getFitness() { return fitness; }

    void generateGenotype() {
        foreach(i; 0 .. genotypeLength) {
            genotype[i] = uniform(0, 2) == 0;
        }
    }

    void genToPhen(int position, float min, float max) {
        ubyte myInt = 0;
        int byteIndex = 0;
        foreach(i; position * config.bitsize .. position * config.bitsize + config.bitsize) {
            if (genotype[i]) myInt += cast(ubyte)(1 << byteIndex);
            byteIndex++;
        }
        float n = cast(float)myInt / cast(float)ubyte.max;
        float result = (((n - 0.0f) * (max - min)) / (1.0f - 0.0f)) + min;
        phenotype[position] = result;
    }

    void generatePhenotype() {
        for(int i = 0; i < config.getGenotypeLength; i++) {
            phenotype[i / config.bitsize] = genToPhen(i, 0f, 1f);
            i += config.bitsize;
        }
    }

    void evaluateFitness() {

    }
}
