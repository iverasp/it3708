module ea.paretofront;

import ea.individual;
import std.stdio;
import std.conv;
import std.string;
import std.math;

public class ParetoFront {

    Individual[] individuals;
    float minCost = float.max;
    float maxCost = float.min_normal;
    float minDistance;
    float maxDistance;

    void calc() {
        if (individuals.length <= 2) return;
        minDistance = individuals[0].distanceValue;
        maxDistance = individuals[$ - 1].distanceValue;
        foreach(individual; individuals) {
            if (minCost > individual.costValue) minCost = individual.costValue;
            if (maxCost < individual.costValue) maxCost = individual.costValue;
        }
        for (int i = 1; i < individuals.length - 1; i++) {
            individuals[i].crowdingDistance =
                calculateCrowdingDistance(individuals[i-1], individuals[i+1]);
        }
    }

    float calculateCrowdingDistance(Individual previous, Individual next) {
        float x1 = (next.distanceValue - previous.distanceValue)
            / (maxDistance - minDistance);
        float x2 = abs(next.costValue - previous.costValue) / (maxCost - minCost);
        return x1 + x2;
    }

    override string toString() {
        return "hello world";
    }

    Individual[] getIndividuals() {
        return individuals;
    }
}
