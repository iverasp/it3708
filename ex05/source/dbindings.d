module dbindings;

import pyd.pyd;
import ea.population;
import ea.individual;
import ea.ea_config;
import ea.paretofront;
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
        Def!(Population.evaluate),
        Def!(Population.reproduce),
        Def!(Population.generateInformation),
        Def!(Population.getFronts),
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
        Def!(Individual.evaluateFitness),
        Def!(Individual.getDistanceValue),
        Def!(Individual.getCostValue),
    )();
    wrap_class!(
        EaConfig,
        Init!(),
        Init!(int,int,int,int,float,int,float,int,float),
        Property!(EaConfig.getGenerations),
        Property!(EaConfig.getPopulationSize),
        Property!(EaConfig.getNumberOfChildren),
        Property!(EaConfig.getGenotypeLength),
        Property!(EaConfig.getTournamentEpsilon),
        Property!(EaConfig.getTournamentGroupSize),
        Property!(EaConfig.getCrossoverRate),
        Property!(EaConfig.getChildrenPerPair),
        Property!(EaConfig.getMutationRate),
    )();
    wrap_class!(
        TSP,
        Init!(int[][], int[][]),
        Def!(TSP.getTravelValue),
    )();
    wrap_class!(
        ParetoFront,
        Def!(ParetoFront.getIndividuals),
    )();
}
