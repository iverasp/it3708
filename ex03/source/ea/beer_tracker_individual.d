module ea.beertrackerindividual;

import ea.ea_config;
import std.algorithm;
import std.conv;
import std.random;
import std.string;
import std.stdio;
import std.typecons;
import std.math;
import pyd.pyd;

class BeerTrackerIndividual {

    // These are generic variables
    EaConfig config;
    int genotypeLength;
    bool[] genotype;
    float[] phenotype;
    float fitness;
    float[] fitnessRange;

    int avoidedBigObjects;
    int avoidedSmallObjects;
    int capturedBigObjects;
    int capturedSmallObjects;

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

    // Deprecated (belonging to sigma and boltzmann)
    @property void setFitnessRange(float[] fitnessRange){
        this.fitnessRange = fitnessRange;
    }
    @property float[] getFitnessRange(){ return fitnessRange; }

    @property void setAvoidedBigObjects(int o) { this.avoidedBigObjects = o; }
    @property int getAvoidedBigObjects() { return this.avoidedBigObjects; }
    @property void setAvoidedSmallObjects(int o) { this.avoidedSmallObjects = o; }
    @property int getAvoidedSmallObjects() { return this.avoidedSmallObjects; }
    @property void setCapturedBigObjects(int o) { this.capturedBigObjects = o; }
    @property int getCapturedBigObjects() { return this.capturedBigObjects; }
    @property void setCapturedSmallObjects(int o) { this.capturedSmallObjects = o; }
    @property int getCapturedSmallObjects() { return this.capturedSmallObjects; }

    void generateGenotype() {
        foreach(i; 0 .. genotypeLength) {
            genotype[i] = uniform(0, 2) == 0;
        }
    }

    void genToPhen(int position, float min, float max) {
        int bitsize = 8;
        ubyte myInt = 0;
        int byteIndex = 0;
        foreach(i; position * bitsize .. position * bitsize + bitsize) {
            if (genotype[i]) myInt += cast(ubyte)(1 << byteIndex);
            byteIndex++;
        }
        float n = cast(float)myInt / cast(float)ubyte.max;
        float result = (((n - 0.0f) * (max - min)) / (1.0f - 0.0f)) + min;
        phenotype[position] = result;
    }

    void generatePhenotype() {
        int start = 2;
        int end = 16;
        // BIAS of layer0
        genToPhen(0, -10, 0);
        genToPhen(1, -10 ,0);
        // weights of layer0
        foreach(i; start .. end) {
            genToPhen(i, -5, 5);
        }
        start = 16;
        end += 2;
        if (config.noWrap) {
            end += 2;
            foreach(i; start .. end) {
                genToPhen(i, 1, 10);
            }
            start += 4;
            end += 2;
        }
        // time constants of layer0
        foreach(i; start .. end) {
            genToPhen(i, 1, 2);
        }
        start += 2;
        end += 2;
        // gains of layer0
        foreach(i; start .. end) {
            genToPhen(i, 1, 5);
        }
        start += 2;
        end += 2;
        // BIAS of layer1
        foreach(i; start .. end) {
            genToPhen(i, -10, 0);
        }
        start += 2;
        end += 8;
        // weights of layer1
        foreach(i; start .. end) {
            genToPhen(i, -5, 5);
        }
        start += 8;
        end += 2;
        // time constants of layer1
        foreach(i; start .. end) {
            genToPhen(i, 1, 2);
        }
        start += 2;
        end += 2;
        // gains of layer1
        foreach(i; start .. end) {
            genToPhen(i, 1, 5);
        }

    }

    void evaluateFitness() {
        int relation = abs(capturedSmallObjects - avoidedBigObjects * 2);

        float score = (capturedSmallObjects * config.smallObjectBonus
                    + avoidedBigObjects * config.bigObjectBonus);

        if (relation < 4) relation = 1;
        fitness = score / cast(float)relation;


        //fitness = (capturedSmallObjects * config.smallObjectBonus
        //        - capturedBigObjects * config.bigObjectPenalty);
    }
}
