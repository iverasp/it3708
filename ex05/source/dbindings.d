module dbindings;

import pyd.pyd;

import ea.population;
import ea.individual;
import ea.ea_config;
import tsp.tsp;

public class DBindings { }

// PyD API

extern(C) void PydMain() {
    module_init();
    wrap_class!(
        Population,
        Init!(EaConfig, TSP),
        Repr!(Population.toString),
        Property!(Population.getChildren),
        Property!(Population.getAdults),
        Property!(Population.getAverageFitness),
        Property!(Population.getStandardDeviation),
        //Def!(Population.develop),
        Def!(Population.evaluate),
        Def!(Population.adultSelection),
        Def!(Population.parentSelection),
        Def!(Population.reproduce),
        Def!(Population.generateInformation)
    )();
    wrap_class!(
        Individual,
        Init!(EaConfig, TSP),
        Property!(Individual.getGenotype),
        Property!(Individual.setGenotype),
        Property!(Individual.getFitness),
        Property!(Individual.setFitness),
        Property!(Individual.getValues),
        Def!(Individual.calcValues),
        Def!(Individual.evaluateFitness)
    )();
    wrap_class!(
        EaConfig,
        Init!(),
        Init!(int,int,int,int,string,string,float,int,float,float,float,int,string,float),
        Property!(EaConfig.getGenerations),
        Property!(EaConfig.getPopulationSize),
        Property!(EaConfig.getNumberOfChildren),
        Property!(EaConfig.getGenotypeLength),
        Property!(EaConfig.getAdultSelection),
        Property!(EaConfig.getParentSelection),
        Property!(EaConfig.getTournamentEpsilon),
        Property!(EaConfig.getTournamentGroupSize),
        Property!(EaConfig.getBoltzmannTemperature),
        Property!(EaConfig.getBoltzmannDeltaT),
        Property!(EaConfig.getCrossoverRate),
        Property!(EaConfig.getChildrenPerPair),
        Property!(EaConfig.getMutationType),
        Property!(EaConfig.getMutationRate),
    )();
    wrap_class!(
        TSP,
        Init!(int[][], int[][]),
        Def!(TSP.getTravelValue)
    )();
}
