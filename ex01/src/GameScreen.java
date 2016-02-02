import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.Pane;

public class GameScreen extends Pane {

    private Runnable onStart = () -> {};
    private Simulator simulator;

    public void setOnStart(Runnable onStart)
    {
        this.onStart = onStart;
    }

    public GameScreen(Simulator simulator) {
        this.simulator = simulator;
        setPrefSize(800, 600);
        setStyle("-fx-background-color: #FFF");
        setOnKeyTyped(this::onKeyTyped);
        setOnMouseClicked(this::onMouseClicked);

        /*for (Boid boid : simulator.getFlock().getBoids) {
            getChildren().add(boid);
        }*/
    }

    private void onKeyTyped(KeyEvent event) {
        if (event.getCode() == KeyCode.P) {
            simulator.addPredator();
        }
    }

    private void onMouseClicked(MouseEvent event) {
        simulator.addObstacle((int) event.getX(), (int) event.getY());
    }
}
