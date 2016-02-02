import java.util.ArrayList;

public class Predator extends Boid {

    private Flock flock;
    private int radius;

    public Predator(Flock flock, int radius) {
        this.flock = flock;
        this.radius = radius;
    }

    public void update() {
        ArrayList<BoidRelation> nearBoids = new ArrayList<>();
        for (Boid boid : flock.getBoids()) {
            double distance = Math.hypot(boid.getX() - this.getX(), boid.getY() - this.getY());
            if (distance < this.radius * 2) {
                nearBoids.add(new BoidRelation(boid, distance));
            }
        }

        double[] alignmentForce = {0., 0.};
        double[] cohesionForce = {0., 0.};

        if (!nearBoids.isEmpty()) {
            alignmentForce = calcAlignment(nearBoids);
            cohesionForce = calcCohesion(nearBoids);
        }

        this.setVelocityX((float) (
                this.getVelocityX() +
                alignmentForce[0] * alignmentWeight +
                cohesionForce[0] * cohersionWeight
        ));
        this.setVelocityY((float) (
                this.getVelocityY() +
                alignmentForce[1] * alignmentWeight +
                cohesionForce[1] * cohersionWeight
        ));

        double maxDirection = Math.max(Math.abs(getVelocityX()), Math.abs(getVelocityY()));

    }
}
