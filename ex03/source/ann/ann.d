module ann.ann;

import ann.matrix;
import std.algorithm;
import std.array;
import std.conv;
import std.math;
import std.numeric;
import std.range;
import std.stdio;
import std.string;

class ANN {

    Matrix synapsis0;
    Matrix synapsis1;

    this() {}

    public void setWeightsSynapsis0(double[][] weights) {
        this.synapsis0 = new Matrix(weights);
    }

    public void setWeightsSynapsis1(double[][] weights) {
        this.synapsis1 = new Matrix(weights);
    }

    public double[][] predict(double[][] input) {
        auto layer0 = new Matrix(input);
        auto layer1 = (layer0 * synapsis0).nonLinear();
        auto layer2 = layer1 * synapsis1;
        return layer2.nonLinear().toArray();
    }
}
