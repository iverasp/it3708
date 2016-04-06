module beertracker.simulator;

import beertracker.object;
import beertracker.agent;

import std.random : uniform;
import std.algorithm;
import std.string, std.conv, std.stdio;

class BeerTrackerSimulator {

    BeerTrackerObject[] objects;
    BeerTrackerAgent agent;
    int width = 30;
    int height = 15;
    int objectToDescend = 0;
    int amountOfObjects;
    int instantiatedObjects;
    int avoidedObjects;
    int capturedSmallObjects;
    int capturedBigObjects;
    int timesteps;
    int timestep;

    this(int n, int timesteps) {
        this.amountOfObjects = n;
        this.timesteps = timesteps;
        objects = new BeerTrackerObject[](amountOfObjects);
        agent = new BeerTrackerAgent();
        generateObject(0);
        instantiatedObjects++;
    }

    void generateObject(ulong i) {
        int size = uniform(1, 7);
        int start = uniform(0, width);
        if (objects[i] is null) objects[i] = new BeerTrackerObject(size, start);
        else {
            objects[i].size = size;
            objects[i].x = start;
            objects[i].y = 0;
        }
    }

    void replaceObject(ulong i) {
        generateObject(i);
    }

    void descendObjects() {
        if (instantiatedObjects < amountOfObjects) generateObject(instantiatedObjects++);
        if (objects[objectToDescend].getY == height - 1) {
            replaceObject(objectToDescend);
            avoidedObjects++;
            //writeln("Avoided objects: " ~ to!string(avoidedObjects));
        }
        else objects[objectToDescend].descend();
        if (objectIntersectsAgent(objectToDescend)) {
            checkWhatAgentCaptured(objectToDescend);
            replaceObject(objectToDescend);
            //writeln("Small objects captured: " ~ to!string(capturedSmallObjects));
            //writeln("Big objects captured: " ~ to!string(capturedBigObjects));
        }
        objectToDescend++;
        if (objectToDescend > instantiatedObjects - 1) objectToDescend = 0;
    }

    void moveAgent(int direction, int steps) {
        this.agent.move(direction, steps); // use CTRNN in future
        timestep++;
    }

    bool completed() {
        return timestep == timesteps;
    }

    bool objectIntersectsAgent(int i) {
        if (objects[i].getY != height - 2) return false;
        int objX1 = objects[i].getX;
        int objX2 = objX1 + objects[i].getSize;
        int agentX1 = agent.getX;
        int agentX2 = agentX1 + agent.getSize;
        return objX1 < agentX2 && objX2 > agentX1;
    }

    void checkWhatAgentCaptured(int i) {
        if (objects[i].getSize >= 5) {
            capturedBigObjects++;
            return;
        }
        int objX1 = objects[i].getX;
        int objX2 = objX1+ objects[i].getSize;
        int agentX1 = agent.getX;
        int agentX2 = agentX1 + agent.getSize;

        if (objX1 >= agentX1 && objX2 <= agentX2) capturedSmallObjects++;
    }

    @property BeerTrackerObject[] getObjects() {
        return this.objects[0 .. instantiatedObjects];
    }
    @property BeerTrackerAgent getAgent() { return this.agent; }
    @property int getCapturedSmallObjects() { return this.capturedSmallObjects; }
    @property int getCapturedBigObjects() { return this.capturedBigObjects; }
    @property int getAvoidedObjects() { return this.avoidedObjects; }
}
