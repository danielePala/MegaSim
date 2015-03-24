package myapp;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
 
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class Login extends HttpServlet {
    @Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
	throws IOException {
		HttpSession session = req.getSession();
		String username = req.getParameter("inputUsername1");
		String password = req.getParameter("inputPassword1");
		if (username.equals("daniele") && password.equals("pala")) {
		    session.setAttribute("Username", username);
		    session.removeAttribute("WrongLogin");
		} else {
		    session.setAttribute("WrongLogin", true);
		}
		resp.sendRedirect("index.jsp");
    }
}
