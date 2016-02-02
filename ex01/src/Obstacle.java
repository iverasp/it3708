
public class Obstacle {

    private int x;
    private int y;
    private int radius;

    public Obstacle(int x, int y, int radius) {
        this.x = x;
        this.y = y;
        this.radius = radius;
    }

    public boolean isWithin(int x, int y) {
        return Math.pow(x - this.x, 2) + Math.pow(y - this.y, 2) < Math.pow(this.radius, 2);
    }
}
