module ea.population;

import ea.config;
import ea.individual;
import pyd.pyd;
import std.algorithm.sorting;
import std.container;
import std.conv;
import std.math;
import std.random;
import std.stdio;

class Population {
    
    Config config;    
    Individual[] children;
    Individual[] adults;
    Individual[] childrenFitness;
    Individual[][] parents;
    double averageFitness;
    double standardDeviation;

    this(Config config) {
        this.config = config;
        children = generateChildren();
    }

    override string toString() {
        return "Population: " ~ to!string(config.getPopulationSize) ~ " Genotype length: " ~ to!string(config.getGenotypeLength);
    }

    @property Individual[] getAdults() { return adults; }

    Individual[] generateChildren() {
        Individual[] result = new Individual[config.getPopulationSize];
        foreach (i; 0 .. config.getPopulationSize) {
            auto individual = new Individual(config.getGenotypeLength);
            individual.generateGenotype();
            result[i] = individual;
        }
        return result;
    }

    void develop() {
        foreach(i; 0 .. children.length) {
            children[i].generatePhenotype();
        }
    }

    void evaluate() {
        childrenFitness = new Individual[config.getPopulationSize];
        foreach(i; 0 .. children.length) {
            children[i].evaluateFitness();
            childrenFitness[i] = children[i];
        }

        bool myComp(Individual x, Individual y) @safe pure nothrow {
            return x.fitness > y.fitness;
        }

        sort!(myComp)(childrenFitness);

        //foreach(i; 0 .. childrenFitness.length) {
        //    writeln(childrenFitness[i].getFitness);
        //}

        /*
        // TODO: optimize this section
        auto h = heapify(children_fitness);
        for (int i = 0; i < children.length; i++) {
            children[i] = h.front;
            h.removeFront;
        }
        */

    }

    void adultSelection() {
        switch(config.getAdultSelection) {
            case("f"):
                fullReplacement();
            case("o"):
                overProduction();
            case("g"):
                generationMixing();
            default:
                break;
        }
    }

    void fullReplacement() {
        adults = new Individual[config.getPopulationSize];
        foreach(i; 0 .. children.length) {
            adults[i] = children[i];
        }
        children = new Individual[config.getPopulationSize];
    }
    
    void overProduction() {
        adults = new Individual[config.getPopulationSize];
        foreach(i; 0 .. config.getPopulationSize) {
            adults[i] = childrenFitness[i];
        }
        children = new Individual[config.getNumberOfChildren];

        //writeln("#################################");
        //foreach(i; 0 .. adults.length) {
        //    writeln(adults[i].getFitness);
        //}
    }

    void generationMixing() {
    }

    void parentSelection() {
        switch(config.getParentSelection) {
            case("f"):
                fitnessProportionate();
            case("s"):
                sigmaScaling();
            case("t"):
                tournamentSelection();
            case("b"):
                boltzmannScaling();
            default:
                break;
        }
    }
    
    void fitnessProportionate() {
    }

    void sigmaScaling() {
    }

    void tournamentSelection() {
        auto myParents = new Individual[][](config.getNumberOfChildren / config.getChildrenPerPair);
        bool myComp(Individual x, Individual y) @safe pure nothrow {
            return x.fitness < y.fitness;
        }

        auto newParents = 0;
        auto numberOfParents = config.getNumberOfChildren / config.getChildrenPerPair;
        while (newParents < numberOfParents) {
            auto adultPool = adults.dup;
            randomShuffle(adultPool);
            auto groupSize = config.getPopulationSize / config.getTournamentGroupSize;
            auto tournamentGroups = new Individual[][](groupSize, groupSize);
            auto adultIndex = adultPool.length;
            foreach(i; 0 .. groupSize) {
                foreach(j; 0 .. groupSize) {
                    if (adultIndex > -1.0f) {
                        tournamentGroups[i][j] = adultPool[--adultIndex - 1];
                    }
                }
            }
            foreach (i; 0 .. tournamentGroups.length) {
                auto chance = uniform(0.0f, 1.0f);
                if (chance < 1. - config.getTournamentEpsilon) {
                    sort!(myComp)(tournamentGroups[i]);

                    /*
                    writeln("sorted?");
                    foreach (x; 0 .. 10) {
                        write(to!string(tournament_groups[i][x].fitness) ~ ", ");
                    }
                    writeln();
                    */

                }
                auto pair = new Individual[2];
                pair[0] = tournamentGroups[i][tournamentGroups[i].length - 1];
                pair[1] = tournamentGroups[i][tournamentGroups[i].length - 2];
                myParents[newParents] = pair.dup;
                ++newParents;
                if (!newParents < numberOfParents) break;
            }
        parents = myParents.dup;
        }

        /*
        foreach (i; 0 .. parents.length) {
            foreach (j; 0 .. parents[i].length)
            writeln(parents[i][j].phenotype);
        }
        */
    
    }
    
    void boltzmannScaling() {
    }

    void reproduce() {
        children = new Individual[](0);
        foreach (i; 0 .. parents.length) {
            auto chance = uniform(0.0f, 1.0f);
            if (chance < config.getCrossoverRate) {
                foreach (j; 0 .. config.getChildrenPerPair) {
                    auto phenotypeLength = to!int(parents[i][0].phenotype.length);
                    auto crossoverPoint = uniform(1, phenotypeLength + 1);
                    auto newborn = new Individual(config.getGenotypeLength);
                    newborn.genotype = parents[i][0].genotype[0..crossoverPoint].dup ~ parents[i][1].genotype[crossoverPoint..parents[i][1].genotype.length].dup;
                    children.length = children.length + 1;
                    children[children.length - 1] = newborn;
                }

            } else {
                foreach (j; 0 .. config.getChildrenPerPair) {
                    int parentIndex = j % config.getChildrenPerPair;
                    auto newborn = new Individual(config.getGenotypeLength);
                    if (chance < config.getMutationRate) {
                        auto genotype = parents[i][parentIndex].phenotype.dup;
                        auto index = uniform(0, genotype.length);
                        if (genotype[index] == 0) genotype[index] = 1;
                        else genotype[index] = 0;
                        newborn.genotype = genotype;
                    } else {
                        newborn.genotype = parents[i][parentIndex].phenotype.dup;
                    }
                    children.length = children.length + 1;
                    children[children.length - 1] = newborn;
                }
            }
        }
    }

    void generateInformation() {
        double totalFitness = 0;
        int numberOfAdults = 0;
        double varianceNumerator = 0;
        double variance = 0;
        for (int i = 0; i < adults.length; i++) {
            totalFitness += adults[i].fitness;
            ++numberOfAdults;
        }
        averageFitness = totalFitness / numberOfAdults;
        for (int i = 0; i < adults.length; i++) {
            varianceNumerator += pow(adults[i].fitness - averageFitness, 2);
        }
        variance = varianceNumerator / numberOfAdults;
        standardDeviation = sqrt(variance);
    }
}

// PyD API

extern(C) void PydMain() {
    module_init();
    wrap_class!(
        Population,
        Init!(Config),
        Repr!(Population.toString),
        Property!(Population.getAdults),
        Def!(Population.develop),
        Def!(Population.evaluate),
        Def!(Population.adultSelection),
        Def!(Population.parentSelection),
        Def!(Population.reproduce),
        Def!(Population.generateInformation),
    )();
    wrap_class!(
        Individual,
        Init!(int),
        Property!(Individual.getPhenotype),
        Property!(Individual.getFitness)
    )();
    wrap_class!(
        Config,
        Init!(),
        Property!(Config.getPopulationSize),
        Property!(Config.getNumberOfChildren),
        Property!(Config.getGenotypeLength),
        Property!(Config.getAdultSelection),
        Property!(Config.getParentSelection),
        Property!(Config.getTournamentEpsilon),
        Property!(Config.getTournamentGroupSize),
        Property!(Config.getBoltzmannTemperature),
        Property!(Config.getBoltzmannDeltaT),
        Property!(Config.getCrossoverRate),
        Property!(Config.getChildrenPerPair),
        Property!(Config.getMutationType),
        Property!(Config.getMutationRate)
    )();
}
