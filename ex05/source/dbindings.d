module dbindings;

import pyd.pyd;

import ea.population;
import ea.individual;
import ea.ea_config;

public class DBindings { }

// PyD API

extern(C) void PydMain() {
    module_init();
    wrap_class!(
        Population,
        Init!(EaConfig, int),
        Repr!(Population.toString),
        Property!(Population.getChildren),
        Property!(Population.getAdults),
        Property!(Population.getAverageFitness),
        Property!(Population.getStandardDeviation),
        Def!(Population.develop),
        Def!(Population.evaluate),
        Def!(Population.adultSelection),
        Def!(Population.parentSelection),
        Def!(Population.reproduce),
        Def!(Population.generateInformation)
    )();
    wrap_class!(
        Individual,
        Init!(EaConfig),
        Property!(Individual.getPhenotype),
        Property!(Individual.getFitness)
    )();
    wrap_class!(
        EaConfig,
        Init!(),
        Init!(int,int,int,int,string,string,float,int,float,float,float,int,string,float,float,float,float,float,float,float,bool,bool,int),
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
        Property!(EaConfig.getFoodBonus),
        Property!(EaConfig.getPoisonPenalty),
        Property!(EaConfig.getSmallObjectBonus),
        Property!(EaConfig.getBigObjectPenalty),
        Property!(EaConfig.isNoWrap),
        Property!(EaConfig.isPullMode)
    )();
}
