import javafx.beans.property.IntegerProperty;
import javafx.beans.property.SimpleIntegerProperty;

import java.util.ArrayList;
import java.util.concurrent.ThreadLocalRandom;


public class Boid {


    private IntegerProperty x = new SimpleIntegerProperty(0);
    private IntegerProperty y = new SimpleIntegerProperty(0);
    private int angle;
    private float velocityX;
    private float velocityY;

    private int maxVelocity = 12;
    public int separationWeight = 120;
    public int alignmentWeight = 60;
    public int cohersionWeight = 20;

    public Boid() {}

    public Boid(int x, int y, int angle) {
        System.out.println("Boid created at: " + x + ":" + y);
        this.x.set(x);
        this.y.set(y);
        this.angle = angle;
        this.velocityX = ThreadLocalRandom.current().nextInt(-1, 2) * maxVelocity;
        this.velocityY = ThreadLocalRandom.current().nextInt(-1, 2) * maxVelocity;
    }

    public int getX() {
        return x.get();
    }

    public int getY() {
        return y.get();
    }

    public IntegerProperty getXProperty() {
        return this.x;
    }

    public IntegerProperty getYProperty() {
        return this.y;
    }

    public float getVelocityX() {
        return velocityX;
    }

    public float getVelocityY() {
        return velocityY;
    }

    public void setVelocityX(float velocityX) {
        this.velocityX = velocityX;
    }

    public void setVelocityY(float velocityY) {
        this.velocityY = velocityY;
    }

    public void update(ArrayList<BoidRelation> neighbors, Obstacle obstacle, ArrayList<BoidRelation> predators) {
        double[] alignmentForce = calcAlignment(neighbors);
        double[] separationForce = calcSeparation(neighbors);
        double[] cohesionForce = calcCohesion(neighbors);
        double[] avoidObstacle = {0., 0.};
        double[] avoidPredators = {0., 0.};

        if (obstacle != null) {
            avoidObstacle = new double[]{-this.getVelocityY(), this.getVelocityX()};
        }
        if (!predators.isEmpty()) {
            avoidPredators = calcSeparation(predators);
        }

        this.velocityX +=
                        separationForce[0] * separationWeight +
                        alignmentForce[0] * alignmentWeight +
                        cohesionForce[0] * cohersionWeight +
                        avoidObstacle[0] * 500 +
                        avoidPredators[0] * 500;
        this.velocityY +=
                        separationForce[1] * separationWeight +
                        alignmentForce[1] * alignmentWeight +
                        cohesionForce[1] * cohersionWeight +
                        avoidObstacle[1] * 500 +
                        avoidPredators[1] * 500;
        if (Math.abs(this.velocityX) > maxVelocity || Math.abs(this.velocityY) > maxVelocity) {
            double maximumDirection = Math.max(Math.abs(velocityX), Math.abs(velocityY));
            velocityX = (float) (velocityX / maximumDirection) * maxVelocity;
            velocityY = (float) (velocityY / maximumDirection) * maxVelocity;
        }
        angle = (int) Math.toDegrees(Math.atan2(velocityY, velocityX)) % 360;
        x.set((int) (getX() + getVelocityX()) % 600);
        y.set((int) (getY() + getVelocityY()) % 800);
    }

    public double[] calcSeparation(ArrayList<BoidRelation> neighbors) {
        double[] result = {0., 0.};
        for (BoidRelation relation : neighbors) {
            if (relation.getDistance() == 0) {
                result[0] -= relation.getBoid().getVelocityX();
                result[1] -= relation.getBoid().getVelocityY();
            } else {
                result[0] -= (relation.getBoid().getX() - this.getX()) / relation.getDistance();
                result[1] -= (relation.getBoid().getY() - this.getY()) / relation.getDistance();
            }
        }
        return result;
    }

    public double[] calcAlignment(ArrayList<BoidRelation> neighbors) {
        if (neighbors.isEmpty()) return new double[]{this.getVelocityX(), this.getVelocityY()};
        double averageX = 0;
        double averageY = 0;
        for (BoidRelation relation : neighbors) {
            averageX += relation.getBoid().getVelocityX();
            averageY += relation.getBoid().getVelocityY();
        }
        averageX /= neighbors.size();
        averageY /= neighbors.size();
        return new double[]{averageX, averageY};

    }

    public double[] calcCohesion(ArrayList<BoidRelation> neighbors) {
        if (neighbors.isEmpty()) return new double[]{this.getX(), this.getY()};
        double averageX = 0;
        double averageY = 0;
        for (BoidRelation relation : neighbors) {
            averageX += relation.getBoid().getX();
            averageY += relation.getBoid().getY();
        }
        averageX /= neighbors.size();
        averageY /= neighbors.size();
        averageX -= this.getX();
        averageY -= this.getY();
        return new double[]{averageX, averageY};
    }
}
