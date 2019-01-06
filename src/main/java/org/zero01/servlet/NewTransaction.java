package org.zero01.servlet;
 
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
 
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONException;
import org.json.JSONObject;
import org.zero01.dao.BlockChain;
 
// 该Servlet用于接收并处理新的交易信息
@WebServlet("/transactions/new")
public class NewTransaction extends HttpServlet {
 
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
 
        req.setCharacterEncoding("utf-8");
        // 读取客户端传递过来的数据并转换成JSON格式
        BufferedReader reader = req.getReader();
        String input = null;
        StringBuffer requestBody = new StringBuffer();
        while ((input = reader.readLine()) != null) {
            requestBody.append(input);
        }
        JSONObject jsonValues = null;
		try {
			jsonValues = new JSONObject(requestBody.toString());
		} catch (JSONException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
 
        // 检查所需要的字段是否位于POST的data中
        String[] required = { "sender", "recipient", "amount" };
        for (String string : required) {
            if (!jsonValues.has(string)) {
                // 如果没有需要的字段就返回错误信息
                resp.sendError(400, "Missing values");
            }
        }
 
        // 新建交易信息
        BlockChain blockChain = BlockChain.getInstance();
        int index = 0;
		try {
			index = blockChain.newTransactions(jsonValues.getString("sender"), jsonValues.getString("recipient"),
			        jsonValues.getLong("amount"));
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
 
        // 返回json格式的数据给客户端
        resp.setContentType("application/json");
        PrintWriter printWriter = resp.getWriter();
        try {
			printWriter.println((new JSONObject()).put("message", "Transaction will be added to Block " + index));
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        printWriter.close();
    }
}