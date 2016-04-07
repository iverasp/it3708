module flatland.evolve;

import ea.population;
import ea.individual;
import ann.ann;
import flatland.simulator;

import std.typecons;
import std.random;
import std.string;
import std.conv;
import std.algorithm.sorting;
import std.algorithm.mutation;
import std.stdio;

class FlatlandEvolve {

    Population population;
    ANN ann;
    int scenarios;
    int generations;
    int generation = 1;
    int[][][] maps;
    int timesteps;
    bool runDynamic;
    float[] fittestPhenotype;
    float highestFitness;

    this(Population population, ANN ann, int generations, int scenarios, int[][][] maps, int timesteps, bool runDynamic) {
        this.population = population;
        this.ann = ann;
        this.generations = generations;
        this.scenarios = scenarios;
        this.maps = maps;
        this.timesteps = timesteps;
        this.runDynamic = runDynamic;
    }

    void evolve() {

        population.develop();
        foreach(i; 0 .. population.getChildren.length) {
            auto child = population.getChildren[i];
            float[][] synapsis = new float[][](6,3);
            foreach(j; 0 .. 6) {
                synapsis[j] = child.getPhenotype[j*3 .. j*3 + 3];
            }
            ann.setWeightsSynapsis0(synapsis);
            foreach(j; 0 .. scenarios) {
                auto currentMap = copyMap(maps[j]);
                auto sim = new FlatlandSimulator(6, 6, currentMap, timesteps);
                while(!sim.completed()) {
                    int[][] input = sim.getAgent.sense(sim.getCells);
                    auto move = ann.getMove(input);
                    sim.move(move);
                }
                child.addDevouredFood = sim.getDevouredFood;
                child.addDevouredPoison = sim.getDevouredPoison;
                if (runDynamic) {
                    maps[j] = generateMap();
                }
            }
        }
        population.evaluate();
        population.adultSelection();
        population.parentSelection();
        population.reproduce();

        auto fittetInd = population.getAdults.dup;

        bool myComp(Individual x, Individual y) @safe pure nothrow {
            return x.fitness > y.fitness;
        }
        sort!(myComp)(fittetInd);

        fittestPhenotype = fittetInd[0].getPhenotype;
        highestFitness = fittetInd[0].getFitness;
        generation++;

    }

    @property float[] getFittestPhenotype() { return this.fittestPhenotype; }
    @property float getHighestFitness() { return this.highestFitness; }

    int[][] copyMap(int[][] source) {
        int[][] map = new int[][](10,10);
        foreach(i; 0 .. 10) {
            foreach(j; 0 .. 10) {
                map[i][j] = source[i][j];
            }
        }
        return map;
    }

    int[][] generateMap() {
        int[][] map = new int[][](10,10);
        Tuple!(int, int)[string] places;
        foreach(i; 0 .. 10) {
            foreach(j; 0 .. 10) {
                places[to!string(i) ~ to!string(j)] = tuple(i, j);
            }
        }
        places.remove("66");
        foreach(Tuple!(int,int) place; places) {
            if (uniform(0.0f, 1.0f) < 0.33) {
                int x = place[0];
                int y = place[1];
                map[x][y] = 1;
                places.remove(to!string(x)~to!string(y));
            }
        }
        foreach(Tuple!(int,int) place; places) {
            if (uniform(0.0f, 1.0f) < 0.33) {
                int x = place[0];
                int y = place[1];
                map[x][y] = 2;
                places.remove(to!string(x)~to!string(y));
            }
        }

        return map;
    }

}
