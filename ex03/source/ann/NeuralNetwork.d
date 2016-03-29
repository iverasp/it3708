module ann.neuralnetwork;

import ann.neuronlayer;

public class NeuralNetwork {

  NeuronLayer inputLayer;
  NeuronLayer outputLayer;
  NeuronLayer[] hiddenLayers;
  int numberOfInputs;
  int numberOfOutputs;
  int numberOfHiddenLayers;
  int neuronsToHiddenLayer;

  double BIAS = -1;

  this(int noi, int nou, int nohl, int nthl) {
    numberOfInputs = noi;
    numberOfOutputs = nou;
    numberOfHiddenLayers = nohl;
    neuronsToHiddenLayer = nthl;
    createNetwork();
  }

  private void createNetwork() {
    inputLayer = new NeuronLayer(neuronsToHiddenLayer, numberOfInputs);
    outputLayer = new NeuronLayer(numberOfOutputs, neuronsToHiddenLayer);
    hiddenLayers = new NeuronLayer[](numberOfHiddenLayers);
    foreach(i; 0 .. numberOfHiddenLayers)
      hiddenLayers[i] = new NeuronLayer(neuronsToHiddenLayer, neuronsToHiddenLayer);
  }

  public double[] getWeights() {
    int numberOfNeurons = 2 +
      numberOfHiddenLayers +
      numberOfOutputs +
      (neuronsToHiddenLayer*(numberOfHiddenLayers+1));
    double[] weights = new double[](numberOfNeurons);

    /*
    foreach(i; 0 .. neuronsToHiddenLayer) {
      weights[i] = inputLayer.neurons[i];
    }
    */

    return weights;
  }

}
