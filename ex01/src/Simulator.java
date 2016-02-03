import javafx.animation.AnimationTimer;
import javafx.animation.RotateTransition;
import javafx.scene.Node;
import javafx.scene.image.Image;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.Pane;
import javafx.scene.paint.Paint;
import javafx.scene.shape.Circle;
import javafx.scene.shape.Line;
import javafx.scene.shape.Rectangle;
import javafx.scene.transform.Rotate;
import javafx.util.Duration;

import java.util.ArrayList;
import java.util.concurrent.ThreadLocalRandom;

public class Simulator extends Pane {

    private final int FLOCK_SIZE = 200;
    private final int RADIUS = 50;
    private final int BOIDSIZE = 10;

    private Runnable onStart = () -> {};

    private Flock flock;
    private ArrayList<Obstacle> obstacles;
    private ArrayList<Node> obstacleNodes;
    private ArrayList<Predator> predators;
    private SimulatorLoop loop = new SimulatorLoop();

    public void setOnStart(Runnable onStart)
    {
        this.onStart = onStart;
    }

    public Simulator() {
        System.out.println("Simulator started");
        setPrefSize(Constants.WIDTH, Constants.HEIGHT);
        setStyle("-fx-background-color: #FFF");
        setOnKeyPressed(this::onKeyTyped);
        setOnMouseClicked(this::onMouseClicked);

        this.flock = new Flock(FLOCK_SIZE, RADIUS);
        this.obstacles = new ArrayList<>();
        this.obstacleNodes = new ArrayList<>();
        this.predators = new ArrayList<>();

        for (Boid boid : flock.getBoids()) {
            final Circle circle = new Circle(BOIDSIZE, Paint.valueOf("blue"));
            final Line line = new Line(0,0,7,7);
            line.translateXProperty().bind(boid.getXProperty());
            line.translateYProperty().bind(boid.getYProperty());

            Rotate rotation = new Rotate();
            rotation.pivotXProperty().bind(line.startXProperty());
            rotation.pivotYProperty().bind(line.startYProperty());
            rotation.angleProperty().bind(boid.getAngleProperty());
            line.getTransforms().add(rotation);

            circle.translateXProperty().bind(boid.getXProperty());
            circle.translateYProperty().bind(boid.getYProperty());

            getChildren().addAll(circle, line);
        }

        loop.start();
    }

    private class SimulatorLoop extends AnimationTimer {

        private long past = 0;

        @Override
        public void handle(long now) {
            if (past == 0) {
                past = now;
                return;
            }

            double secondsElapsed = (now - past) / 1_000_000_000.0; /* Convert nanoseconds to seconds. */

            /*
             * Avoid large time steps by imposing an upper bound.
             */
            if (secondsElapsed > 0.0333) {
                secondsElapsed = 0.0333;
            }

            updateGame(secondsElapsed);

            past = now;
        }
    }

    public void updateGame(double delta) {
        flock.update(obstacles, predators);
        for (Predator predator : predators) {
            predator.update();
        }
    }

    public void addObstacle(int x, int y) {
        int radius = 20; //ThreadLocalRandom.current().nextInt(0, 20);
        final Circle obstacle = new Circle(x, y, radius, Paint.valueOf("black"));
        getChildren().add(obstacle);
        this.obstacleNodes.add(obstacle);
        this.obstacles.add(new Obstacle(x, y, radius));
    }

    public void removeAllObstacles() {
        System.out.println("Removing obstacles");
        for (Node obstacle : obstacleNodes) {
            getChildren().remove(obstacle);
        }
        obstacleNodes.clear();
    }

    public void addPredator() {
        Predator predator = new Predator(flock, RADIUS);
        final Circle circle = new Circle(BOIDSIZE, Paint.valueOf("red"));
        circle.translateXProperty().bind(predator.getXProperty());
        circle.translateYProperty().bind(predator.getYProperty());

        final Line line = new Line(0,0,7,7);
        line.translateXProperty().bind(predator.getXProperty());
        line.translateYProperty().bind(predator.getYProperty());

        Rotate rotation = new Rotate();
        rotation.pivotXProperty().bind(line.startXProperty());
        rotation.pivotYProperty().bind(line.startYProperty());
        rotation.angleProperty().bind(predator.getAngleProperty());
        line.getTransforms().add(rotation);

        getChildren().addAll(circle, line);
        this.predators.add(predator);
    }

    private void onKeyTyped(KeyEvent event) {
        if (event.getCode() == KeyCode.P) {
            addPredator();
        }
        if (event.getCode() == KeyCode.C) {
            removeAllObstacles();
        }
    }

    private void onMouseClicked(MouseEvent event) {
        addObstacle((int) event.getX(), (int) event.getY());
    }
}
