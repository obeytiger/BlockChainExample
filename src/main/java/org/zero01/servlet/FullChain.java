package org.zero01.servlet;
 
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
 
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
 
import org.json.JSONObject;
import org.zero01.dao.BlockChain;
 
// 该Servlet用于输出整个区块链的数据
@WebServlet("/chain")
public class FullChain extends HttpServlet {
 
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        BlockChain blockChain = BlockChain.getInstance();
        Map<String, Object> response = new HashMap<String, Object>();
        response.put("chain", blockChain.getChain());
        response.put("length", blockChain.getChain().size());
 
        JSONObject jsonResponse = new JSONObject(response);
        resp.setContentType("application/json");
        PrintWriter printWriter = resp.getWriter();
        printWriter.println(jsonResponse);
        printWriter.close();
    }
}