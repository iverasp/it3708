module beertracker.object;

class BeerTrackerObject {

    int x, y;
    int size;

    this(int size, int start) {
        this.size = size;
        this.x = start;
    }

    @property int getX() { return this.x; }
    @property int getY() { return this.y; }
    @property int getSize() { return this.size; }
    void descend() { this.y++; }
}
