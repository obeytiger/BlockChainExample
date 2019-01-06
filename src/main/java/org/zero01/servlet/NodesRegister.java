package org.zero01.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.zero01.dao.BlockChain;

// 用于注册节点的Servlet
@WebServlet("/nodes/register")
public class NodesRegister extends HttpServlet {

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
		JSONObject jsonValues;
		try {
			jsonValues = new JSONObject(requestBody.toString());

			// 获得节点集合数据，并进行判空
			List<String> nodes = new ArrayList<String>();
			JSONArray ja = jsonValues.getJSONArray("nodes");
			if (ja != null && ja.length() > 0) {
				for (int i = 0; i < ja.length(); i++) {
					String job = ja.getString(i);
					nodes.add(job);
				}
			}
			// List<String> nodes = (List) jsonValues.getJSONArray("nodes").toList();

			if (nodes.size() == 0) {
				resp.sendError(400, "Error: Please supply a valid list of nodes");
			}

			// 注册节点
			BlockChain blockChain = BlockChain.getInstance();
			for (String address : nodes) {
				blockChain.registerNode(address);
			}

			// 向客户端返回处理结果
			Map<String, Object> response = new HashMap<String, Object>();
			response.put("message", "New nodes have been added");
			response.put("total_nodes", blockChain.getNodes().toArray());

			resp.setContentType("application/json");
			PrintWriter printWriter = resp.getWriter();
			printWriter.println(new JSONObject(response));
			printWriter.close();

		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}
