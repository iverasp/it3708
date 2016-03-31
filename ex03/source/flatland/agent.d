module flatland.agent;

import std.conv;
import std.string;
import std.stdio;

import flatland.direction;

public class Agent {

    int x, y;
    Direction direction = Direction.north;
    int poisonsEaten, foodsEaten;

    this(int x, int y) {
        this.x = x;
        this.y = y;
    }

    int getPoisonsEaten() { return poisonsEaten; }

    int getFoodsEaten() { return foodsEaten; }

    void setX(int x) { this.x = x; }

    void setY(int y) { this.y = y; }

    int getX() { return x; }

    int getY() { return y; }

    int[][] sense(int[][] cells) {
        int[] result = new int[](3);
        switch (direction) {
            case Direction.north:
            result = [
            cells[(y - 1) % cells.length][x], // north
            cells[y][(x - 1) % cells.length], // west
            cells[y][(x + 1) % cells.length] // east
            ];
            break;
            case Direction.east:
            result = [
            cells[y][(x + 1) % cells.length], // east
            cells[(y - 1) % cells.length][x], // north
            cells[(y + 1) % cells.length][x] // south
            ];
            break;
            case Direction.south:
            result = [
            cells[(y + 1) % cells.length][x], // south
            cells[y][(x + 1) % cells.length], // east
            cells[y][(x - 1) % cells.length] // west
            ];
            break;
            case Direction.west:
            result = [
            cells[y][(x - 1) % cells.length], // west
            cells[(y + 1) % cells.length][x], // south
            cells[(y - 1) % cells.length][x] // north
            ];
            break;
            default: assert(0); break;
            }
        int[][] input = new int[][](3,2);
        foreach(i; 0 .. 3) {
            if (result[i] == 1) input[i][0] = 1;
            if (result[i] == 2) input[i][1] = 1;
        }
        return input;

    }

    int[][] moveForward(int[][] cells) {
        switch (direction) {
            case Direction.north:
            y = cast(int)((cells.length + y - 1) % cells.length);
            break;
            case Direction.east:
            x = cast(int)((x + 1) % cells.length);
            break;
            case Direction.south:
            y = cast(int)((y + 1) % cells.length);
            break;
            case Direction.west:
            x  = cast(int)((cells.length + x - 1) % cells.length);
            break;
            default: assert(0);
        }
        if (cells[y][x] == 1) foodsEaten++;
        if (cells[y][x] == 2) poisonsEaten++;
        cells[y][x] = 0;
        return cells;
    }

    void turnLeft() {
        direction = to!Direction((4 + direction - 1) % 4);
    }

    void turnRight() {
        direction = to!Direction((direction + 1) % 4);
    }
}
