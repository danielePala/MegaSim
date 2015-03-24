package myapp;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import static com.google.appengine.api.taskqueue.TaskOptions.Builder.*;

public class Simulator extends HttpServlet {
    public static final int NUM_BATCH = 10;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {

        // Add the task to the default queue.
	String sid = request.getSession().getId();
        Queue queue = QueueFactory.getQueue("simulator");
	for (int i=0; i<NUM_BATCH; i++) {
	    queue.add(withUrl("/worker").param("key", Integer.toString(i)).param("sid", sid));
	}

        response.sendRedirect("results.jsp");
    }
}