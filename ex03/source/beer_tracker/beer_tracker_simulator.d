module beertracker.simulator;

import beertracker.object;
import beertracker.agent;
import ea.ea_config;

import std.random : uniform;
import std.algorithm;
import std.string, std.conv, std.stdio;

class BeerTrackerSimulator {

    BeerTrackerObject object;
    BeerTrackerAgent agent;
    int width = 30;
    int height = 15;
    int avoidedBigObjects;
    int avoidedSmallObjects;
    int capturedSmallObjects;
    int capturedBigObjects;
    int timesteps;
    int timestep;
    EaConfig config;

    this(EaConfig config) {
        this.config = config;
        this.timesteps = config.timesteps;
        int size = uniform(1, 7);
        int start = uniform(0, width - size);
        object = new BeerTrackerObject(size, start);
        agent = new BeerTrackerAgent();
    }

    @property BeerTrackerObject getObject() { return this.object; }
    @property BeerTrackerAgent getAgent() { return this.agent; }
    @property int getAvoidedBigObjects() { return this.avoidedBigObjects; }
    @property int getAvoidedSmallObjects() { return this.avoidedSmallObjects; }
    @property int getCapturedBigObjects() { return this.capturedBigObjects; }
    @property int getCapturedSmallObjects() { return this.capturedSmallObjects; }

    void reset() {
        agent.reset();
        generateObject();
        avoidedBigObjects = 0;
        avoidedSmallObjects = 0;
        capturedBigObjects = 0;
        capturedSmallObjects = 0;
        timestep = 0;
    }

    void generateObject() {
        int size = uniform(1, 7);
        int start = uniform(0, width - size);
        object.size = size;
        object.x = start;
        object.y = 0;
    }

    void replaceObject() {
        generateObject();
    }

    void descendObject() {
        if (object.getY == height - 1) {
            if (object.getSize > 4) { ++avoidedBigObjects; }
            else if (object.getSize < 5) { ++avoidedSmallObjects; }
            replaceObject();
        }
        else { object.descend(); }
        if (objectIntersectsAgent()) {
            checkWhatAgentCaptured();
            replaceObject();
        }
    }

    void moveAgent(int direction, int steps) {
        if (config.pullMode && steps == 0 && object.y < height - 3) {
            object.y = height - 3;
            timestep++;
            descendObject();
            return;
        }
        if (config.noWrap) {
            if (direction == 0 && agent.getX - steps < 0) agent.x = 0;
            else if (direction == 1 && agent.getX + steps + agent.getSize > width)
                agent.x = width - agent.getSize;
            else this.agent.move(direction, steps);
            timestep++;
            descendObject();
        } else {
            this.agent.move(direction, steps);
            timestep++;
            descendObject();
        }
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
        if (object.getSize > 4) {
            ++capturedBigObjects;
            return;
        }
        int objX1 = object.getX;
        int objX2 = objX1 + object.getSize;
        int agentX1 = agent.getX;
        int agentX2 = agentX1 + agent.getSize;
        if (objX1 >= agentX1 && objX2 <= agentX2) {
            ++capturedSmallObjects;
            return;
        }
    }

    int[] getSensors() {
        int numberOfSensors = 5;
        if (config.noWrap) {
            numberOfSensors += 2;
        }
        int[] sensors = new int[](numberOfSensors);
        foreach(i; 0 .. 5) {
            int agentX = (width + agent.getX + i) % width;
            int objX1 = object.getX;
            int objX2 = objX1 + object.getSize;
            sensors[i] = cast(int)(objX1 <= agentX && objX2 >= agentX);
        }
        if (config.noWrap) {
            sensors[5] = cast(int)(agent.getX == 0);
            sensors[6] = cast(int)(agent.getX + agent.getSize == width);
        }
        return sensors;
    }
}
