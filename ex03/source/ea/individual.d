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
    float[] fitnessRange;

    // These are problem specific variables
    int devouredFood;
    int devouredPoison;

    int possibleFoodsToDevour;
    int possiblePoisonsToDevour;

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

    @property void setDevouredFood(int f) { this.devouredFood = f; }

    @property void setDevouredPoison(int p) { this.devouredPoison = p; }

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

        /*
        float foodPoints = cast(float)devouredFood / cast(float)possibleFoodsToDevour;
        float poisonPoints = cast(float)devouredPoison / cast(float)possiblePoisonsToDevour;
        this.fitness = ((foodPoints - poisonPoints) + 1) / 2;
        */


        fitness = (cast(float)devouredFood * config.getFoodBonus)
                    - (cast(float)devouredPoison * config.getPoisonPenalty);

    }
}
