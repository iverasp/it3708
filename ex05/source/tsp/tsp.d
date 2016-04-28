module tsp.tsp;

class TSP {

    int[][] distances;
    int[][] costs;

    this(int[][] distances, int[][] costs) {
        this.distances = distances;
        this.costs = costs;
    }

    int getTravelValue(int[] cities, bool dist) {
        int[][] values;
        if (dist) values = this.distances;
        else values = this.costs;
        int value = 0;
        foreach(i; 0 .. cities.length - 1) {
            if (cities[i] > cities[i+1]) {
                value += values[cities[i]][cities[i+1]];
            } else {
                value += values[cities[i+1]][cities[i]];
            }
        }
        return value;
    }
}
