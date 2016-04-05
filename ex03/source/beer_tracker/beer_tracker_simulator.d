module beertracker.simulator;

import beertracker.object;
import beertracker.agent;

import std.random : uniform;
import std.algorithm;
import std.string, std.conv, std.stdio;

class BeerTrackerSimulator {

    BeerTrackerObject[] objects;
    BeerTrackerAgent agent;
    int[] spawnPositions;
    int width = 30;
    int height = 15;
    int objectToDescend = 0;
    int amountOfObjects;

    this(int n) {
        this.amountOfObjects = n;
        objects = new BeerTrackerObject[](amountOfObjects);
        agent = new BeerTrackerAgent();
        //spawnPositions = new int[](width);
        foreach(i; 0 .. width) spawnPositions ~= i;
        foreach(i; 0 .. n) {
            generateObject(i);
        }
    }

    void generateObject(ulong i) {
        int size = uniform(1, 6);
        int start = spawnPositions[uniform(0, spawnPositions.length)];
        objects[i] = new BeerTrackerObject(size, start);
        writeln("length: " ~ to!string(spawnPositions.length));
        writeln("start: " ~ to!string(start));
        writeln("size: " ~ to!string(size));
        int startIndex, endIndex;
        foreach(int j; 0 .. cast(int)spawnPositions.length) {
            if (spawnPositions[j] == start) startIndex = j;
        }
        spawnPositions =
            spawnPositions[0 .. startIndex + 1] ~ spawnPositions[startIndex + size + 1.. $];
    }

    void replaceObject(ulong i) {
        foreach(j; objects[i].getX .. objects[i].getX + objects[i].getSize) {
            spawnPositions ~= j;
        }
        sort!("a < b")(spawnPositions);
        generateObject(i);
    }

    void descendObjects() {
        if (objects[objectToDescend].getY == height)
            replaceObject(objectToDescend);
        else objects[objectToDescend].descend();
        objectToDescend++;
        if (objectToDescend > amountOfObjects - 1) objectToDescend = 0;
    }

    @property BeerTrackerObject[] getObjects() { return this.objects; }
    @property BeerTrackerAgent getAgent() { return this.agent; }
}
