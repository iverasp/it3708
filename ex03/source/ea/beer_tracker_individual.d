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
        phenotype = new float[](config.getGenotypeLength / 16L); //genotypeLength);
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

    void generatePhenotype() {
        int phenotypeIndex = 0;
        for (int i = 0; i < config.getGenotypeLength; i++) {
            ushort myInt = 0;
            ushort index = 0;
            foreach(j; i .. i + 16L) {
                if (genotype[j]) myInt += cast(ushort)(1 << index);
                index++;
            }
            phenotype[phenotypeIndex] = cast(float)myInt / cast(float)ushort.max;
            phenotypeIndex++;
            i += 16L - 1L;
        }
    }

    void evaluateFitness() {
        fitness = capturedSmallObjects * config.smallObjectBonus
            - capturedBigObjects * config.bigObjectPenalty;

    }
}
