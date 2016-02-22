import javafx.application.Application;
import javafx.stage.Stage;

/**
 * Created by iver on 15/02/16.
 */
public class Main extends Application {
    @Override
    public void start(Stage primaryStage) throws Exception {
        System.out.println("JavaFX application started");
    }

    public static void main(String... args) {
        Application.launch(Main.class, args);
    }
}
