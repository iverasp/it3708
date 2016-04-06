module beertracker.agent;

import beertracker.object;

class BeerTrackerAgent : BeerTrackerObject {

    this() {
        super(5, 15);
        this.y = 14;
    }

    /*
    Direction is 0 for left, 1 for right
    */
    void move(int direction, int steps) {
        if (direction == 0) steps *= -1;
        this.x = cast(int)((30 + this.x + steps) % 30);
    }

}
