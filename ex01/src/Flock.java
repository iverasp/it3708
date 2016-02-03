import java.util.ArrayList;
import java.util.concurrent.ThreadLocalRandom;


public class Flock {

    private int radius;
    private ArrayList<Boid> boids;

    public Flock(int size, int radius, Controls controls) {
        System.out.println("Flock created of size: " + size);
        this.radius = radius;
        this.boids = new ArrayList<>();
        for (int i = 0; i < size; i++) {
            addBoid(controls);
        }
    }

    public void addBoid(Controls controls) {
        this.boids.add(
                new Boid(
                        ThreadLocalRandom.current().nextInt(0, Constants.WIDTH + 1),
                        ThreadLocalRandom.current().nextInt(0, Constants.HEIGHT + 1),
                        ThreadLocalRandom.current().nextInt(0, 360 + 1),
                        controls
                )
        );
    }

    public void update(ArrayList<Obstacle> obstacles, ArrayList<Predator> predators) {
        for (Boid boid : this.boids) {
            ArrayList<BoidRelation> neighbors = new ArrayList<>();
            ArrayList<BoidRelation> nearPredators = new ArrayList<>();
            Obstacle nearObstacle = null;

            for (Obstacle obstacle : obstacles) {
                if (obstacle.isWithin(boid.getX(), boid.getY())) {
                    nearObstacle = obstacle;
                    break;
                }
            }

            for (Boid otherBoid : this.boids) {
                if (otherBoid == boid) continue;
                double distance = Math.hypot(otherBoid.getX() - boid.getX(), otherBoid.getY() - boid.getY());
                if (distance < this.radius)
                    neighbors.add(new BoidRelation(otherBoid, distance));
            }

            for (Predator predator : predators) {
                double distance = Math.hypot(predator.getX() - boid.getX(), predator.getY() - boid.getY());
                if (distance < this.radius)
                    nearPredators.add(new BoidRelation(predator, distance));
            }

            boid.update(neighbors, nearObstacle, nearPredators);
        }
    }

    public ArrayList<Boid> getBoids() {
        return boids;
    }
}
