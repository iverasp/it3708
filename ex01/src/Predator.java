import java.util.ArrayList;
import java.util.concurrent.ThreadLocalRandom;

public class Predator extends Boid {

    private Flock flock;
    private int radius;
    private Controls controls;

    public Predator(Flock flock, int radius, Controls controls) {
        this.flock = flock;
        this.radius = radius;
        this.controls = controls;
        this.setX(ThreadLocalRandom.current().nextInt(0, Constants.WIDTH + 1));
        this.setY(ThreadLocalRandom.current().nextInt(0, Constants.HEIGHT + 1));
        this.setAngle(ThreadLocalRandom.current().nextInt(0, 360 + 1));
        this.velocityX = ThreadLocalRandom.current().nextInt(-1, 2) * Constants.MAXVELOCITYPREDATORS;
        this.velocityY = ThreadLocalRandom.current().nextInt(-1, 2) * Constants.MAXVELOCITYPREDATORS;
    }

    public void update(ArrayList<Obstacle> obstacles) {
        ArrayList<BoidRelation> nearBoids = new ArrayList<>();
        for (Boid boid : flock.getBoids()) {
            double distance = Math.hypot(boid.getX() - this.getX(), boid.getY() - this.getY());
            if (distance < this.radius * 2) {
                nearBoids.add(new BoidRelation(boid, distance));
            }
        }

        ArrayList<Obstacle> nearObstacles = new ArrayList<>();
        for (Obstacle obstacle : obstacles) {
            double distance = Math.hypot(obstacle.getX() - this.getX(), obstacle.getY() - this.getY());
            if (distance < (obstacle.getRadius() * 3)) {
                nearObstacles.add(obstacle);
            }
        }

        double[] alignmentForce = {0., 0.};
        double[] cohesionForce = {0., 0.};
        double[] avoidObstacle = {0., 0.};

        if (!nearObstacles.isEmpty()) {
            avoidObstacle[0] = -this.getVelocityY();
            avoidObstacle[1] = this.getVelocityX();
        }

        if (!nearBoids.isEmpty()) {
            alignmentForce = calcAlignment(nearBoids);
            cohesionForce = calcCohesion(nearBoids);
        }

        this.setVelocityX((float) (
                this.getVelocityX() +
                alignmentForce[0] * controls.getAlignmentWeight() +
                cohesionForce[0] * controls.getCohesionWeight() +
                avoidObstacle[0] * 300
        ));
        this.setVelocityY((float) (
                this.getVelocityY() +
                alignmentForce[1] * controls.getAlignmentWeight() +
                cohesionForce[1] * controls.getCohesionWeight() +
                avoidObstacle[1] * 300
        ));

        double maxDirection = Math.max(Math.abs(getVelocityX()), Math.abs(getVelocityY()));
        this.setVelocityX(
                (float) (this.getVelocityX() / maxDirection) * (Constants.MAXVELOCITYPREDATORS - 1)
        );
        this.setVelocityY(
                (float) (this.getVelocityY() / maxDirection) * (Constants.MAXVELOCITYPREDATORS - 1)
        );

        this.setAngle(
                (int) (Math.toDegrees(Math.atan2(this.getVelocityY(), this.getVelocityX())) % 360) - 45
        );
        this.setX((int) (this.getX() + this.getVelocityX() % Constants.WIDTH));
        this.setY((int) (this.getY() + this.getVelocityY() % Constants.HEIGHT));

        wrapAroundWorld();
    }
}
