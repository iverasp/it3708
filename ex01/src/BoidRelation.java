
public class BoidRelation {

    private Boid boid;
    private double distance;

    public BoidRelation(Boid boid, double distance) {
        this.boid = boid;
        this.distance = distance;
    }

    public Boid getBoid() {
        return boid;
    }

    public double getDistance() {
        return distance;
    }
}
