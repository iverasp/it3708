module ann.ann_config;

class AnnConfig {
    this(){
    }

    // ANN config
	auto dynamicRun = true;
	auto layer0Function = "s";
	auto layer1Function = "s";

    // ANN getters
    @property auto getDynamicRun(){ return dynamicRun; }
    @property auto getLayer0Function(){ return layer0Function; }
    @property auto getLayer1Function(){ return layer1Function; }
