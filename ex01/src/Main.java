import javafx.application.Application;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.paint.Color;
import javafx.stage.Stage;


public class Main extends Application {

    @Override
    public void start(Stage primaryStage) throws Exception {

        System.out.println("JavaFX Application started");

        Simulator simulator = new Simulator();
        Group content = new Group();
        content.getChildren().add(simulator);

        simulator.setOnStart(() -> {
            content.getChildren().clear();
            content.getChildren().add(simulator);
            simulator.requestFocus();
        });

        Scene scene = new Scene(new Group(content), 800, 600, Color.WHITE);

        primaryStage.setScene(scene);
        primaryStage.setTitle("BoidsFX");
        primaryStage.show();

        simulator.requestFocus();
    }

    public static void main(String... args) {
        Application.launch(Main.class, args);
    }
}
