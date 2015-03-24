package myapp;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Entity;
import static com.google.appengine.api.datastore.FetchOptions.Builder.*;

import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;


import com.google.gson.Gson;

public class Statistics extends HttpServlet {

    private class Results {
	private String totalNumbers;
	private String maxKey;
	private String simTime;
	private List<ArrayList> perc = new ArrayList<ArrayList>();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
	long simStart = System.currentTimeMillis(); 
	DatastoreService DS = DatastoreServiceFactory.getDatastoreService();

	String sid = request.getSession().getId();
	Queue queue = QueueFactory.getQueue("simulator");
	Map<String, Long> results = new HashMap<String, Long>();
	Query query = new Query(sid);
	int numResults = 0;
	while (numResults < Simulator.NUM_BATCH) {
	    try {
		Thread.sleep(100);
	    } catch (InterruptedException e) {
	    }
	    numResults = DS.prepare(query).countEntities(withLimit(Simulator.NUM_BATCH));
	}
	double simTime = (double)(System.currentTimeMillis() - simStart)/1000; 
	for (Entity e : DS.prepare(query).asIterable()) {
	    mergeMaps(e.getProperties(), results);
	    DS.delete(e.getKey());
	}
	Gson gson = new Gson();
	Results r = new Results();
	// different numbers generated
	r.totalNumbers = Integer.toString(results.keySet().size());
	int totalNumbers = Simulator.NUM_BATCH * Worker.NUM_VALUES;
        // rate of apperance of numbers in [0,Worker.NUM_VALUES] 
        // and max appearance calculation.
	String maxKey = null;
        long maxAppear = 0;
	for (int i=0; i<Worker.RANGE_VALUES; i++) {
	    String key = Integer.toString(i);
	    Long value = 0L;
	    if (results.containsKey(key)) {
		value = results.get(key);
	    }
	    if (value > maxAppear) {
		maxKey = key;
		maxAppear = value;
	    }
	    double percent = ((double)value*100)/totalNumbers;
	    ArrayList graphEntry = new ArrayList();
	    graphEntry.add(key);
	    graphEntry.add(percent);
	    r.perc.add(graphEntry);
	}
	// simulation time
	r.simTime = Double.toString(simTime);
	// key with max appearance
	r.maxKey = maxKey;
	response.getWriter().write(gson.toJson(r)); 
    }

    private void mergeMaps(Map<String, Object> src, Map<String, Long> dest) {
	for (String s: src.keySet()) {
	    Long count = (Long) src.get(s);
	    if (dest.containsKey(s)) {
		count = dest.get(s) + count;
	    }
	    dest.put(s, count);
	}
    }

}