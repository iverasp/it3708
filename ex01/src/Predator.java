import java.util.ArrayList;
import java.util.concurrent.ThreadLocalRandom;

public class Predator extends Boid {

    private Flock flock;
    private int radius;

    public Predator(Flock flock, int radius) {
        this.flock = flock;
        this.radius = radius;
        this.setX(ThreadLocalRandom.current().nextInt(0, Constants.WIDTH + 1));
        this.setY(ThreadLocalRandom.current().nextInt(0, Constants.HEIGHT + 1));
        this.setAngle(ThreadLocalRandom.current().nextInt(0, 360 + 1));
        this.velocityX = ThreadLocalRandom.current().nextInt(-1, 2) * Constants.MAXVELOCITY;
        this.velocityY = ThreadLocalRandom.current().nextInt(-1, 2) * Constants.MAXVELOCITY;
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
        this.setVelocityX(
                (float) (this.getVelocityX() / maxDirection) * (Constants.MAXVELOCITY - 1)
        );
        this.setVelocityY(
                (float) (this.getVelocityY() / maxDirection) * (Constants.MAXVELOCITY - 1)
        );

        this.setAngle(
                (int) (Math.toDegrees(Math.atan2(this.getVelocityY(), this.getVelocityX())) % 360) - 45
        );
        this.setX((int) (this.getX() + this.getVelocityX() % Constants.WIDTH));
        this.setY((int) (this.getY() + this.getVelocityY() % Constants.HEIGHT));

        wrapAroundWorld();
    }
}
