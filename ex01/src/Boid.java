import javafx.beans.property.IntegerProperty;
import javafx.beans.property.SimpleIntegerProperty;

import java.util.ArrayList;
import java.util.concurrent.ThreadLocalRandom;


public class Boid {

    private Controls controls;
    private IntegerProperty x = new SimpleIntegerProperty(0);
    private IntegerProperty y = new SimpleIntegerProperty(0);
    private IntegerProperty angle = new SimpleIntegerProperty(0);
    public float velocityX;
    public float velocityY;

    public Boid() {}

    public Boid(int x, int y, int angle, Controls controls) {
        //System.out.println("Boid created at: " + x + "," + y);
        this.controls = controls;
        this.x.set(x);
        this.y.set(y);
        this.angle.set(angle);
        this.velocityX = ThreadLocalRandom.current().nextInt(-1, 2) * Constants.MAXVELOCITYBIRDS;
        this.velocityY = ThreadLocalRandom.current().nextInt(-1, 2) * Constants.MAXVELOCITYBIRDS;
    }

    public int getX() {
        return x.get();
    }

    public int getY() {
        return y.get();
    }

    public void setX(int x) {
        this.x.set(x);
    }

    public void setY(int y) {
        this.y.set(y);
    }

    public void setAngle(int angle) {
        this.angle.set(angle);
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
                        separationForce[0] * controls.getSeparationWeight() +
                        alignmentForce[0] * controls.getAlignmentWeight() +
                        cohesionForce[0] * controls.getCohesionWeight() +
                        avoidObstacle[0] * 50 +
                        avoidPredators[0] * 500;
        this.velocityY +=
                        separationForce[1] * controls.getSeparationWeight() +
                        alignmentForce[1] * controls.getAlignmentWeight() +
                        cohesionForce[1] * controls.getCohesionWeight() +
                        avoidObstacle[1] * 50 +
                        avoidPredators[1] * 500;
        if (Math.abs(this.velocityX) > Constants.MAXVELOCITYBIRDS || Math.abs(this.velocityY) > Constants.MAXVELOCITYBIRDS) {
            double maximumDirection = Math.max(Math.abs(velocityX), Math.abs(velocityY));
            velocityX = (float) (velocityX / maximumDirection) * Constants.MAXVELOCITYBIRDS;
            velocityY = (float) (velocityY / maximumDirection) * Constants.MAXVELOCITYBIRDS;
        }
        angle.set(((int) Math.toDegrees(Math.atan2(velocityY, velocityX)) % 360) - 45);
        x.set((int) (getX() + getVelocityX()) % Constants.WIDTH);
        y.set((int) (getY() + getVelocityY()) % Constants.HEIGHT);

        wrapAroundWorld();
    }

    public void wrapAroundWorld() {
        if (this.getX() >= Constants.WIDTH) this.setX(1);
        if (this.getY() >= Constants.HEIGHT) this.setY(1);
        if (this.getX() <= 1) this.setX(Constants.WIDTH);
        if (this.getY() <= 1) this.setY(Constants.HEIGHT);
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

    public IntegerProperty getAngleProperty() {
        return angle;
    }
}
