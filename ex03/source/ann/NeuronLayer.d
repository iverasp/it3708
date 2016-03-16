module ann.neuronlayer;

import std.string;
import std.conv;

import ann.neuron;

public class NeuronLayer {

  Neuron[] neurons;

  this(int numberOfNeurons, int numberOfInputs) {
    neurons = new Neuron[](numberOfNeurons);
    foreach(i; 0 .. numberOfNeurons) {
      neurons[i] = new Neuron(numberOfInputs);
    }
  }

  override public string toString() {
    string result = "Layer\n";
    foreach(i; 0 .. neurons.length) {
      result ~= to!string(neurons[i]);
      result ~= "\n";
    }
    return result;
  }
}
