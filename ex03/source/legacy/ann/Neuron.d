module ann.neuron;

import std.random;
import std.string;
import std.conv;
import std.algorithm;

public class Neuron {

  int numberOfInputs;
  double[] weights;

  this(int n) {
    numberOfInputs = n;
    weights = new double[](numberOfInputs + 1);

    // last element of weights is the bias
    foreach(i; 0 .. numberOfInputs + 1) {
      weights[i] = uniform(0.0f, 1.0f);
    }
  }

  public double sum() {
    return weights.sum - weights[$];
  }

  override public string toString() {
    return "Weights: " ~ to!string(weights[0 .. $ - 1]) ~ " Bias: " ~ to!string(weights[$]);
  }
}
