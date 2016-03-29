module flatland.simulator;

import std.string;
import std.conv;
import std.stdio;

import flatland.agent;

public class Simulator {

    Agent agent;
    int[][] cells;
    int foods;
    int poisons;
    int timestep;
    int timesteps;
    int[] moves;

    this(int x, int y, int[][] cells, int timesteps) {
        agent = new Agent(x, y);
        this.timesteps = timesteps;
        moves = new int[](timesteps);
        this.cells = cells;
        foreach(i; 0 .. cells.length) {
            foreach(j; 0 .. cells.length) {
                if (cells[i][j] == 1) foods++;
                if (cells[i][j] == 2) poisons++;
            }
        }
    }

    void move(int direction) {
        switch (direction) {
            case 0: break;
            case 1:
            agent.turnLeft();
            break;
            case 2:
            agent.turnRight();
            break;
            default: assert(0);
        }
        cells = agent.moveForward(cells);
        moves[timestep] = direction;
        timestep++;
    }

    void printStats() {
        writeln("Foods eaten: " ~ to!string(agent.getFoodsEaten()) ~ " / " ~ to!string(foods));
        writeln("Poisons eaten: " ~ to!string(agent.getPoisonsEaten()) ~ " / " ~ to!string(poisons));
    }

    bool completed() {
        return timestep >= timesteps;
    }

    float getFitness() {
        float foodPoints = cast(float)agent.getFoodsEaten() / cast(float)foods;
        float poisonPoints = cast(float)agent.getPoisonsEaten() / cast(float)poisons;
        return foodPoints - poisonPoints;
    }

    int[] getMoves() { return moves; }
}
