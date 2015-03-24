package myapp;

import java.io.IOException;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Transaction;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.ConcurrentModificationException;

public class Worker extends HttpServlet {
    /**
     * DatastoreService object for Datastore access.
     */
    private static final DatastoreService DS = DatastoreServiceFactory
      .getDatastoreService();

    /**
     * Default number of random numbers to generate.
     */
    public static final int NUM_VALUES = 1000;

    /** 
     * Default range for random numbers to generate.
     */
    public static final int RANGE_VALUES = 51;

    /**
     * A random number generator.
     */
    private final Random generator = new Random();

    /**
     * A logger object.
     */
    private static final Logger LOG = Logger.getLogger(Worker.class
						       .getName());

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {

	String sid = request.getParameter("sid");
	String shardNum = request.getParameter("key");
        Key shardKey = KeyFactory.createKey(sid, shardNum);
	Transaction tx = DS.beginTransaction();
	Entity shard;
	try {
	    try {
		shard = DS.get(tx, shardKey);
	    } catch (EntityNotFoundException e) {
		shard = new Entity(shardKey);
	    }
	    for (int i=0; i<NUM_VALUES; i++) {
		long count = 0;
		int newNumber = generator.nextInt(RANGE_VALUES);
		Object prop = shard.getProperty(Integer.toString(newNumber));
		if (prop != null) {
		    count = (Long) prop;
		}
		shard.setUnindexedProperty(Integer.toString(newNumber), count + 1L);
	    }
	    DS.put(tx, shard);
	    tx.commit();
	} catch (ConcurrentModificationException e) {
	    LOG.log(Level.WARNING,
		    "You may need more shards. Consider adding more shards.");
	    LOG.log(Level.WARNING, e.toString(), e);
	} catch (Exception e) {
	    LOG.log(Level.WARNING, e.toString(), e);
	} finally {
	    if (tx.isActive()) {
		tx.rollback();
	    }
	}
    }
}