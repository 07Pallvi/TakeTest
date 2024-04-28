package admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import dao.TestDao;

@WebServlet("/DeleteTest")

public class DeleteTest extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public DeleteTest() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String test_id = request.getParameter("test_id");
		try {
			TestDao.deleteTest(test_id);
			response.sendRedirect("/TakeTest/AdminDashboard");
		}catch(Exception e) {
			e.printStackTrace();
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
