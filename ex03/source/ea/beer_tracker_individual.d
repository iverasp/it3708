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

    // Deprecated (belonging to sigma and boltzmann)
    @property void setFitnessRange(float[] fitnessRange){
        this.fitnessRange = fitnessRange;
    }
    @property float[] getFitnessRange(){ return fitnessRange; }

    @property int getCapturedBigObjects() { return this.capturedBigObjects; }
    @property void setCapturedBigObjects(int o) { this.capturedBigObjects = o; }
    @property int getCapturedSmallObjects() { return this.capturedSmallObjects; }
    @property void setCapturedSmallObjects(int o) { this.capturedSmallObjects = o; }

    void generateGenotype() {
        foreach(i; 0 .. genotypeLength) {
            genotype[i] = uniform(0, 2) == 0;
        }
    }

    float genToPhen(bool[] gen, float min, float max) {
        //writeln(to!string(gen));
        ubyte myInt = 0;
        foreach(i; 0 .. 8L) {
            if (gen[i]) myInt += cast(ubyte)(1<<i);
        }
        float n = cast(float)myInt / cast(float)ubyte.max;
        //writeln(to!string(n));
        return (((n - 0.0f) * (max - min)) / (1.0f - 0.0f)) + min;
    }

    void generatePhenotype() {
        int bitsize = 8;
        // BIAS of layer0
        phenotype[0] = genToPhen(genotype[0 .. bitsize], -10, 0);
        phenotype[1] = genToPhen(genotype[bitsize .. 2*bitsize], -10 ,0);
        // weights of layer0
        foreach(i; 2 .. 16) {
            phenotype[i] = genToPhen(genotype[i * bitsize .. i * bitsize + bitsize], -5, 5);
        }
        // time constants of layer0
        foreach(i; 16 .. 18) {
            phenotype[i] = genToPhen(genotype[i * bitsize .. i * bitsize + bitsize], 1, 2);
        }
        // gains of layer0
        foreach(i; 18 .. 20) {
            phenotype[i] = genToPhen(genotype[i * bitsize .. i * bitsize + bitsize], 1, 5);
        }
        // BIAS of layer1
        int bias0 = 7*2*8;
        int bias1 = bias0 + 1;
        phenotype[20] = genToPhen(genotype[bias0 .. bias0 + bitsize], -10, 0);
        phenotype[21] = genToPhen(genotype[bias1 .. bias1 + bitsize], -10, 0);
        // weights of layer1
        foreach(i; 22 .. 30) {
            phenotype[i] = genToPhen(genotype[i * bitsize .. i * bitsize + bitsize], -5, 5);
        }
        // time constants of layer1
        foreach(i; 30 .. 32) {
            phenotype[i] = genToPhen(genotype[i * bitsize .. i * bitsize + bitsize], 1, 2);
        }
        // gains of layer1
        foreach(i; 32 .. 34) {
            phenotype[i] = genToPhen(genotype[i * bitsize .. i * bitsize + bitsize], 1, 5);
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

        fitness = (capturedSmallObjects * config.smallObjectBonus
                - capturedBigObjects * config.bigObjectPenalty);
    }
}
