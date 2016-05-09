import std.stdio;
import std.string;
import std.conv;

import ea.ea_config;
import ea.population;

public void main() {
    EaConfig ea_config = new EaConfig();
    Population pop = new Population(ea_config);
    foreach(i; 0 .. 100) {
        population.evaluate();
        population.adultSelection();
        population.parentSelection();
        population.reproduce();

    }
}
