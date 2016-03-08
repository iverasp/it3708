import std.stdio;
import std.random;
import std.conv;
import std.string;
import std.math;

public class NN {

  double[][] input;
  double[][] output;
  double[][] synapsis0;
  double[][] synapsis1;

  this() {
    input = [[0,0,1],
            [0,1,1],
            [1,0,1],
            [1,1,1]];
    output = [[0],
              [1],
              [1],
              [0]];
    synapsis0 = getWeight(to!int(input.length), to!int(input[0].length), -1, 1);
    synapsis1 = getWeight(to!int(output.length), to!int(output[0].length), -1, 1);
  }

  /* returns a 2d array of size height x width,
    initialized with random values [start, end) */
  private double[][] getWeight(int height, int width, int start, int end) {
    double[][] result = new double[][](height, width);
    foreach (i; 0 .. height) {
      foreach (j; 0 .. width) {
        result[i][j] = uniform(to!float(start), to!float(end));
      }
    }
    return result;
  }

  private double nonLinear(double x, bool derivative) {
    if (derivative) return x * (1f-x);
    return 1f/(1f+exp(-x));
  }


  private double[][] dotProduct(double[][] x, double[][] y) {
    double[][] result = new double[][](x.length, x.length);
    foreach(i; 0 .. x.length) {
      foreach(j; 0 .. x. length) {
        foreach(v; 0 .. x.length) {
          result[i][j] += x[i][v] * y[v][j];
        }
      }
    }
    return result;
  }


  public void runNN(int range) {
    foreach(i; 0 .. range) {
      auto layer0 = input.dup;
      double[][] layer1 = (dotProduct(layer0, synapsis0));
      //double layer2 = nonLinear(dotProduct(layer1, synapsis1));
      writeln(to!string(layer1));
    }
  }

}
