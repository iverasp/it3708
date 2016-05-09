module ea.ea_config;

class EaConfig {
    this(){
    }

    auto generations = 50;
    auto populationSize = 1500;
    auto numberOfChildren = 1500;
    auto genotypeLength = 18 * 16;
    auto adultSelection = "g";
    auto parentSelection = "t";
    auto tournamentEpsilon = 0.9f;
    auto tournamentGroupSize = 20;
    auto boltzmannTemperature = 1.0f;
    auto boltzmannDeltaT = 0.01f;
    auto crossoverRate = 0.1f;
    auto childrenPerPair = 2;
    auto mutationType = "g";
    auto mutationRate = 1.0f;

    this(
        int generations,
        int populationSize,
        int numberOfChildren,
        int genotypeLength,
        string adultSelection,
        string parentSelection,
        float tournamentEpsilon,
        int tournamentGroupSize,
        float boltzmannTemperature,
        float boltzmannDeltaT,
        float crossoverRate,
        int childrenPerPair,
        string mutationType,
        float mutationRate,
    ) {
        this.generations = generations;
        this.populationSize = populationSize;
        this.numberOfChildren = numberOfChildren;
        this.genotypeLength = genotypeLength;
        this.adultSelection = adultSelection;
        this.parentSelection = parentSelection;
        this.tournamentEpsilon = tournamentEpsilon;
        this.tournamentGroupSize = tournamentGroupSize;
        this.boltzmannTemperature = boltzmannTemperature;
        this.boltzmannDeltaT = boltzmannDeltaT;
        this.crossoverRate = crossoverRate;
        this.childrenPerPair = childrenPerPair;
        this.mutationType = mutationType;
        this.mutationRate = mutationRate;
    }

    @property auto getGenerations(){ return generations; }
    @property auto getPopulationSize(){ return populationSize; }
    @property auto getNumberOfChildren(){ return numberOfChildren; }
    @property auto getGenotypeLength(){ return genotypeLength; }
    @property auto getAdultSelection(){ return adultSelection; }
    @property auto getParentSelection(){ return parentSelection; }
    @property auto getTournamentEpsilon(){ return tournamentEpsilon; }
    @property auto getTournamentGroupSize(){ return tournamentGroupSize; }
    @property auto getBoltzmannTemperature(){ return boltzmannTemperature; }
    @property auto getBoltzmannDeltaT(){ return boltzmannDeltaT; }
    @property auto getCrossoverRate(){ return crossoverRate; }
    @property auto getChildrenPerPair(){ return childrenPerPair; }
    @property auto getMutationType(){ return mutationType; }
    @property auto getMutationRate(){ return mutationRate; }
}
