module ann.matrix;

import std.random;
import std.string;
import std.conv;
import std.stdio;
import std.range, std.array, std.numeric, std.algorithm;
import std.math;

class Matrix {

    float[][] matrix;

    this() {}

    this(int height, int width) {
        matrix = new float[][](height, width);
    }

    this(float[][] mat) {
        matrix = mat;
    }

    this(int[][] mat) {
        matrix = new float[][](1,6);
        foreach(i; 0 .. 6) {
            if (mat[0][i] > 0.5f) matrix[0][i] = 1.0f;
            else matrix[0][i] = 0.0f;
        }
    }

    float[][] toArray() { return this.matrix; }

    override string toString() {
        return to!string(matrix);
    }

    Matrix dup() {
        return new Matrix(matrix.dup);
    }

    void randomize() {
        foreach(i; 0 .. matrix.length) {
            foreach(j; 0 .. matrix[0].length) {
                //matrix[i][j] = uniform(-1.0f, 1.0f);
                matrix[i][j] = uniform(-1, 1);
            }
        }
    }

    // activation function
    void nonLinear(bool derivative = false) {
        foreach(i; 0 .. matrix.length) {
            foreach(j; 0 .. matrix[0].length) {
                if (derivative) matrix[i][j] = matrix[i][j] * (1-matrix[i][j]);
                else matrix[i][j] = 1f/(1f+exp(-matrix[i][j]));
            }
        }
    }

    Matrix opBinaryRight(string op)(Matrix other)if(op=="-") {
        auto result = new Matrix(to!int(matrix.length), to!int(matrix[0].length));
        foreach(i; 0 .. matrix.length) {
            result.matrix[i][] = other.matrix[i][] - matrix[i][];
        }
        return result;
    }

    Matrix transpose() {
        return new Matrix(transpose(matrix));
    }

    T[][] transpose(T)(in T[][] m) pure nothrow {
        auto r = new typeof(return)(m[0].length, m.length);
        foreach (immutable nr, const row; m)
                foreach (immutable nc, immutable c; row)
                        r[nc][nr] = c;
        return r;
    }

    Matrix opBinaryRight(string op)(Matrix other)if(op=="+") {
        auto result = new Matrix(to!int(matrix.length), to!int(matrix[0].length));
        foreach(i; 0 .. matrix.length) {
            result.matrix[i][] = other.matrix[i][] + matrix[i][];
        }
        return result;
    }

    Matrix opBinaryRight(string op)(Matrix other)if(op=="*") {
        if (matrix.length == other.matrix[0].length)
            return new Matrix(matrixMultiplication(other.matrix, matrix));
        //if (matrix.length == other.matrix.length)
        return new Matrix(matrixMultiplication2(other.matrix, matrix));
    }

    Matrix opBinaryRight(string op)(float n)if(op=="*") {
        auto result = new float[][](matrix.length, matrix[0].length);
        foreach(i; 0 .. matrix.length) {
            foreach(j; 0 .. matrix[0].length) {
                result[i][j] = matrix[i][j] * n;
            }
        }
        return new Matrix(result);
    }

    T[][] matrixMultiplication(T)(in T[][] A, in T[][] B) pure nothrow /*@safe*/ {
            const Bt = B[0].length.iota.map!(i=> B.transversal(i).array).array;
            return A.map!(a => Bt.map!(b => a.dotProduct(b)).array).array;
    }

    T[][] matrixMultiplication2(T)(in T[][] A, in T[][] B) pure nothrow {
        auto result = new float[][](A.length, A[0].length);
        foreach (i; 0 .. A.length) {
            foreach (j; 0 .. A[0].length) {
                result[i][j] = A[i][j] * B[i][j];
            }
        }
        return result;
    }

}
