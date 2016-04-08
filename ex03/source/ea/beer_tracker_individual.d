module ea.beertrackerindividual;

import ea.ea_config;
import std.algorithm;
import std.conv;
import std.random;
import std.string;
import std.stdio;
import pyd.pyd;

class BeerTrackerIndividual {

    // These are generic variables
    EaConfig config;
    int genotypeLength;
    bool[] genotype;
    float[] phenotype;
    float fitness;
    float[] fitnessRange;

    int capturedBigObjects;
    int capturedSmallObjects;
    int avoidedObjects;


    this(EaConfig config) {
        this.config = config;
        this.genotypeLength = config.getGenotypeLength; //genotypeLength;
        genotype = new bool[](config.getGenotypeLength); //genotypeLength);
        phenotype = new float[](config.getGenotypeLength / 8L); //genotypeLength);
        fitness = 0.0f;
        fitnessRange = [0.0f, 1.0f];
    }

    @property float[] getPhenotype() { return phenotype; }

    @property float getFitness() { return fitness; }

    @property void setFitnessRange(float[] fitnessRange){
        this.fitnessRange = fitnessRange;
    }

    @property float[] getFitnessRange(){ return fitnessRange; }

    @property int getCapturedBigObjects() { return this.capturedBigObjects; }
    void setCapturedBigObjects(int o) { this.capturedBigObjects = o; }
    @property int getCapturedSmallObjects() { return this.capturedSmallObjects; }
    void setCapturedSmallObjects(int o) { this.capturedSmallObjects = o; }

    void generateGenotype() {
        foreach(i; 0 .. genotypeLength) {
            genotype[i] = uniform(0, 2) == 0;
        }
    }

    float genToPhen(bool[] phen, float min, float max) {
        ushort myInt = 0;
        foreach(i; 0 .. 8L) {
            if (phen[i]) myInt += cast(ushort)(1<<i);
        }
        float n = cast(float)myInt / cast(float)ushort.max;
        return (((n - 0.0f) * (max - min)) / (1.0f - 0.0f)) + min
    }

    void generatePhenotype() {
        // BIAS of layer0
        phenotype[0] = genToPhen(genotype[0 .. 8], -10, 0);
        // remaining weights of layer0
        foreach(i; 1 .. 1 + 7) {
            phenotype[i] = genToPhen(genotype[i * 8 .. i * 8 + 8], -5, 5);
        }
        // BIAS of layer1
        phenotype[8] = genToPhen(genotype[8 * 8 .. 8 * 8 + 8], -10, 0);
        // remaining weights of layer1
        foreach(i; 9 .. 13) {
            phenotype[i] = genToPhen(genotype[i * 8 .. i * 8 + 8], -5, 5);
        }
    }

    void evaluateFitness() {
        fitness = capturedSmallObjects * config.smallObjectBonus
            - capturedBigObjects * config.bigObjectPenalty;

    }
}
