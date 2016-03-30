module ann.ann;

import std.math;
import std.numeric;
import std.range;
import std.array;
import std.algorithm;

import std.string;
import std.conv;
import std.stdio;

import ann.matrix;

class ANN {

    Matrix synapsis0;
    Matrix synapsis1;

    this() {}

    public void setWeightsSynapsis0(double[][] weights) {
        this.synapsis0 = new Matrix(weights);
        writeln(to!string(synapsis0));
    }

    public void setWeightsSynapsis1(double[][] weights) {
        this.synapsis1 = new Matrix(weights);
        writeln(to!string(synapsis1));
    }

    public double[][] predict(double[][] input) {
        auto layer0 = new Matrix(input);
        writeln(to!string(layer0));
        auto layer1 = (layer0 * synapsis0).nonLinear();
        writeln(to!string(layer1));
        auto layer2 = layer1 * synapsis1;
        writeln(to!string(layer2));
        return layer2.nonLinear().toArray();
    }
}
