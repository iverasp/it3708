package core;

import javafx.application.Application;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.paint.Color;
import javafx.scene.transform.Scale;
import javafx.scene.transform.Transform;
import javafx.stage.Stage;
import org.apache.commons.cli.*;

/**
 * Created by iver on 15/02/16.
 */
public class Main extends Application {

    static CommandLine line = null;

    @Override
    public void start(Stage primaryStage) throws Exception {

        System.out.println("JavaFX application started");



        Simulator simulator = new Simulator(primaryStage, line);
        //Thread t = new Thread(simulator);
        Group content = new Group();
        content.getChildren().addAll(simulator);

        simulator.setOnStart(() -> {
            content.getChildren().clear();
            content.getChildren().add(simulator);
            simulator.requestFocus();
        });

        Scene scene = new Scene(new Group(content), 800, 600, Color.WHITE);

        Scale scale = Transform.scale(1, 1, 0, 0);
        content.getTransforms().add(scale);
        /*
        primaryStage.setScene(scene);
        primaryStage.setTitle("Evolution");
        primaryStage.show();

        simulator.requestFocus();
        */
        //t.start();
    }

    public static void main(String... args) {

        CommandLineParser parser = new DefaultParser();
        Options options = new Options();
        options.addOption(OptionBuilder.withLongOpt("population")
                .withDescription("population size")
                .hasArg()
                .withArgName("POP")
                .create());
        options.addOption(OptionBuilder.withLongOpt("genotype")
                .withDescription("genotype size")
                .hasArg()
                .withArgName("GENO")
                .create());
        options.addOption(OptionBuilder.withLongOpt("generation")
                .withDescription("generation size")
                .hasArg()
                .withArgName("GEN")
                .create());
        options.addOption(OptionBuilder.withLongOpt("crossover")
                .withDescription("crossover rate")
                .hasArg()
                .withArgName("CROSS")
                .create());
        options.addOption(OptionBuilder.withLongOpt("mutation")
                .withDescription("mutation rate")
                .hasArg()
                .withArgName("MUT")
                .create());
        options.addOption(OptionBuilder.withLongOpt("adult")
                .withDescription("adult selection mechanism")
                .hasArg()
                .withArgName("ADULT")
                .create());
        options.addOption(OptionBuilder.withLongOpt("parent")
                .withDescription("parent selection mechanism")
                .hasArg()
                .withArgName("PARENT")
                .create());
        options.addOption(OptionBuilder.withLongOpt("k")
                .withDescription("k")
                .hasArg()
                .withArgName("K")
                .create());
        options.addOption(OptionBuilder.withLongOpt("S")
                .withDescription("S")
                .hasArg()
                .withArgName("S")
                .create());
        options.addOption(OptionBuilder.withLongOpt("L")
                .withDescription("L")
                .hasArg()
                .withArgName("L")
                .create());
        options.addOption(OptionBuilder.withLongOpt("epsilon")
                .withDescription("epsilon")
                .hasArg()
                .withArgName("E")
                .create());
        options.addOption(OptionBuilder.withLongOpt("problem")
                .withDescription("problem to run")
                .hasArg()
                .withArgName("PROBLEM")
                .create());
        options.addOption(OptionBuilder.withLongOpt("z")
                .withDescription("z")
                .hasArg()
                .withArgName("Z")
                .create());
        options.addOption(OptionBuilder.withLongOpt("s")
                .withDescription("s")
                .hasArg()
                .withArgName("SYMBOLS")
                .create());
        options.addOption(OptionBuilder.withLongOpt("adult_ratio")
                .withDescription("adult to child ratio")
                .hasArg()
                .withArgName("ADULTRATIO")
                .create());


        HelpFormatter formatter = new HelpFormatter();
        formatter.printHelp("Main", options);

        try {
            line = parser.parse(options, args);
        } catch (ParseException e) {
            System.out.println(e.getMessage());

        }

        Application.launch(Main.class, args);
    }
}
