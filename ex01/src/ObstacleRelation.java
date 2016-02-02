/**
 * Created by iver on 02/02/16.
 */
public class ObstacleRelation {

    private Obstacle obstacle;
    private double distance;

    public ObstacleRelation(Obstacle obstacle, double distance) {
        this.obstacle = obstacle;
        this.distance = distance;
    }

    public Obstacle getObstacle() {
        return obstacle;
    }

    public double getDistance() {
        return distance;
    }
}
