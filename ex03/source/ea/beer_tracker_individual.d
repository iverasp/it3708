module ea.beertrackerindividual;

import ea.ea_config;
import std.algorithm;
import std.conv;
import std.random;
import std.string;
import std.stdio;
import std.typecons;
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
        phenotype[position] = max;
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
        // This one needs avoidedObjects
        //auto balance = 0.0f;
        //if (capturedSmallObjects > 2 * capturedBigObjects) {
        //    balance = capturedSmallObjects - 2 * capturedBigObjects;
        //}
        //else { balance = 2 * capturedBigObjects - capturedSmallObjects; }
        //fitness = (capturedSmallObjects * config.smallObjectBonus
        //    - capturedBigObjects * config.bigObjectPenalty) - balance;

        // This one also needs avoidedObjects
        //if (capturedSmallObjects < 2 * capturedBigObjects) {
        //    fitness = capturedSmallObjects * config.smallObjectBonus
        //            - capturedBigObjects * (config.bigObjectPenalty - 5.0f);
        //}
        //else if (capturedSmallObjects > 2 * capturedBigObjects) {
        //    fitness = capturedSmallObjects * (config.smallObjectBonus - 5.0f)
        //            - capturedBigObjects * config.bigObjectPenalty;
        //}
        //else {
        //    fitness = capturedSmallObjects * config.smallObjectBonus
        //            - capturedBigObjects * config.bigObjectPenalty;
        //}

        fitness = capturedSmallObjects * config.smallObjectBonus
                - capturedBigObjects * config.bigObjectPenalty;
    }
}
