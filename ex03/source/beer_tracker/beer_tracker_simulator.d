module beertracker.simulator;

import beertracker.object;
import beertracker.agent;

import std.random : uniform;
import std.algorithm;
import std.string, std.conv, std.stdio;

class BeerTrackerSimulator {

    BeerTrackerObject object;
    BeerTrackerAgent agent;
    int width = 30;
    int height = 15;
    int avoidedObjects;
    int capturedSmallObjects;
    int capturedBigObjects;
    int timesteps;
    int timestep;

    this(int timesteps) {
        this.timesteps = timesteps;
        int size = uniform(1, 7);
        int start = uniform(0, width);
        object = new BeerTrackerObject(size, start);
        agent = new BeerTrackerAgent();
    }

    void reset() {
        agent.reset();
        generateObject();
        capturedBigObjects = 0;
        capturedSmallObjects = 0;
        avoidedObjects = 0;
        timestep = 0;
    }

    void generateObject() {
        int size = uniform(1, 7);
        int start = uniform(0, width);
        object.size = size;
        object.x = start;
        object.y = 0;
    }

    void replaceObject() {
        generateObject();
    }

    void descendObject() {
        if (object.getY == height - 1) {
            replaceObject();
            avoidedObjects++;
        }
        else object.descend();
        if (objectIntersectsAgent()) {
            checkWhatAgentCaptured();
            replaceObject();
        }
    }

    void moveAgent(int direction, int steps) {
        this.agent.move(direction, steps);
        timestep++;
        descendObject();
    }

    bool completed() {
        return timestep == timesteps;
    }

    bool objectIntersectsAgent() {
        if (object.getY != height - 2) return false;
        int objX1 = object.getX;
        int objX2 = objX1 + object.getSize;
        int agentX1 = agent.getX;
        int agentX2 = agentX1 + agent.getSize;
        return objX1 < agentX2 && objX2 > agentX1;
    }

    void checkWhatAgentCaptured() {
        if (object.getSize >= 5) {
            capturedBigObjects++;
            return;
        }
        int objX1 = object.getX;
        int objX2 = objX1+ object.getSize;
        int agentX1 = agent.getX;
        int agentX2 = agentX1 + agent.getSize;

        if (objX1 >= agentX1 && objX2 <= agentX2) capturedSmallObjects++;
    }

    bool[] getSensors() {
        bool[] sensors = new bool[](5);
        foreach(i; 0 .. 5) {
            int agentX = (width + agent.getX + i) % width;
            int objX1 = object.getX;
            int objX2 = objX1 + object.getSize;
            sensors[i] = objX1 >= agentX && objX2 <= agentX;
        }
        return sensors;
    }

    @property BeerTrackerObject getObject() {
        return this.object;
    }
    @property BeerTrackerAgent getAgent() { return this.agent; }
    @property int getCapturedSmallObjects() { return this.capturedSmallObjects; }
    @property int getCapturedBigObjects() { return this.capturedBigObjects; }
    @property int getAvoidedObjects() { return this.avoidedObjects; }
}
