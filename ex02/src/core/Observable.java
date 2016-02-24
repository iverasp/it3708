package core;

/**
 * Created by iver on 24/02/16.
 */
public interface Observable {

    void add(Listener listener);
    void remove(Listener listener);
}
