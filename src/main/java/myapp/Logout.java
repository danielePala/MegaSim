package myapp;

import java.io.IOException;
 
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
 
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class Logout extends HttpServlet {
    @Override
	public void doGet(HttpServletRequest req, HttpServletResponse resp) 
	throws IOException {
	HttpSession session = req.getSession();
	session.removeAttribute("Username");
	resp.sendRedirect("index.jsp");
    }
}
