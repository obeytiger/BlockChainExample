package org.zero01.dao;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import org.zero01.util.Encrypt;

public class BlockChain {

	// 存储区块链
	private List<HashMap<String, Object>> chain;
	// 该实例变量用于当前的交易信息列表
	private List<HashMap<String, Object>> currentTransactions;
	private static BlockChain blockChain = null;

	private Set<String> nodes;

	public BlockChain() {
		// 初始化区块链以及当前的交易信息列表
		this.chain = new ArrayList<HashMap<String, Object>>();
		this.currentTransactions = new ArrayList<HashMap<String, Object>>();
		// 创建创世区块
		newBlock(100, "0");

		// 用于存储网络中其他节点的集合
		nodes = new HashSet<String>();
	}

	// 创建单例对象
	public static BlockChain getInstance() {
		if (blockChain == null) {
			synchronized (BlockChain.class) {
				if (blockChain == null) {
					blockChain = new BlockChain();
				}
			}
		}
		return blockChain;
	}

	public List<HashMap<String, Object>> getChain() {
		return chain;
	}

	public void setChain(List<HashMap<String, Object>> chain) {
		this.chain = chain;
	}

	public List<HashMap<String, Object>> getCurrentTransactions() {
		return currentTransactions;
	}

	public void setCurrentTransactions(List<HashMap<String, Object>> currentTransactions) {
		this.currentTransactions = currentTransactions;
	}

	public Set<String> getNodes() {
		return nodes;
	}

	/**
     * @return 得到区块链中的最后一个区块
     */
	public HashMap<String, Object> lastBlock() {
		return getChain().get(getChain().size() - 1);
	}

	public HashMap<String, Object> newBlock() {
		return null;
	}

	
	/**
     * 在区块链上新建一个区块
     * 
     * @param proof
     *            新区块的工作量证明
     * @param previous_hash
     *            上一个区块的hash值
     * @return 返回新建的区块
     */
	public Map<String, Object> newBlock(long proof, String previous_hash) {

		HashMap<String, Object> block = new HashMap<String, Object>();
		block.put("index", getChain().size() + 1);
		block.put("timestamp", System.currentTimeMillis());
		block.put("transactions", getCurrentTransactions());
		block.put("proof", proof);
		// 如果没有传递上一个区块的hash就计算出区块链中最后一个区块的hash
		block.put("previous_hash", previous_hash != null ? previous_hash : hash(getChain().get(getChain().size() - 1)));

		// 重置当前的交易信息列表
		setCurrentTransactions(new ArrayList<HashMap<String, Object>>());

		getChain().add(block);

		return block;
	}

	/**
     * 生成新交易信息，信息将加入到下一个待挖的区块中
     * 
     * @param sender
     *            发送方的地址
     * @param recipient
     *            接收方的地址
     * @param amount
     *            交易数量
     * @return 返回存储该交易事务的块的索引
     */
	public int newTransactions(String sender, String recipient, long amount) {

		HashMap<String, Object> transaction = new HashMap<String, Object>();
		transaction.put("sender", sender);
		transaction.put("recipient", recipient);
		transaction.put("amount", amount);

		getCurrentTransactions().add(transaction);

		return (Integer) lastBlock().get("index") + 1;
	}

	
	/**
     * 生成区块的 SHA-256格式的 hash值
     * 
     * @param block
     *            区块
     * @return 返回该区块的hash
     */
	public static Object hash(Map<String, Object> block) {
		return new Encrypt().getSHA256(new JSONObject(block).toString());
	}

	
	/**
	 * 简单的工作量证明: - 查找一个 p' 使得 hash(pp') 以4个0开头 - p 是上一个块的证明, p' 是当前的证明
	 * 
	 * @param last_proof
	 *            上一个块的证明
	 * @return
	 */
	public long proofOfWork(long last_proof) {
		long proof = 0;
		while (!validProof(last_proof, proof)) {
			proof += 1;
		}
		return proof;
	}

	/**
	 * 验证证明: 是否hash(last_proof, proof)以4个0开头?
	 * 
	 * @param last_proof
	 *            上一个块的证明
	 * @param proof
	 *            当前的证明
	 * @return 以4个0开头返回true，否则返回false
	 */
	public boolean validProof(long last_proof, long proof) {
		String guess = last_proof + "" + proof;
		String guess_hash = new Encrypt().getSHA256(guess);
		return guess_hash.startsWith("0000");
	}

	/**
	 * 注册节点
	 * 
	 * @param address
	 *            节点地址
	 * @throws MalformedURLException
	 */
	public void registerNode(String address) throws MalformedURLException {
		URL url = new URL(address);
		String node = url.getHost() + ":" + (url.getPort() == -1 ? url.getDefaultPort() : url.getPort());
		nodes.add(node);
	}

	/**
	 * 检查是否是有效链，遍历每个区块验证hash和proof，来确定一个给定的区块链是否有效
	 * 
	 * @param chain
	 * @return
	 */
	public boolean validChain(List<HashMap<String, Object>> chain) {
		Map<String, Object> lastBlock = chain.get(0);
		int currentIndex = 1;
		while (currentIndex < chain.size()) {
			Map<String, Object> block = chain.get(currentIndex);
			System.out.println(lastBlock.toString());
			System.out.println(block.toString());
			System.out.println("\n-------------------------\n");

			// 检查block的hash是否正确
			if (!block.get("previous_hash").equals(hash(lastBlock))) {
				return false;
			}

			lastBlock = block;
			currentIndex++;
		}
		return true;
	}

	/**
	 * 共识算法解决冲突，使用网络中最长的链. 遍历所有的邻居节点，并用上一个方法检查链的有效性， 如果发现有效更长链，就替换掉自己的链
	 * 
	 * @return 如果链被取代返回true, 否则返回false
	 * @throws IOException
	 * @throws JSONException
	 */
	public boolean resolveConflicts() throws IOException, JSONException {
		Set<String> neighbours = this.nodes;
		List<HashMap<String, Object>> newChain = null;

		// 寻找最长的区块链
		long maxLength = this.chain.size();

		// 获取并验证网络中的所有节点的区块链
		for (String node : neighbours) {

			URL url = new URL("http://" + node + "/BlockChainWeb/chain");
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.connect();

			if (connection.getResponseCode() == 200) {
				BufferedReader bufferedReader = new BufferedReader(
						new InputStreamReader(connection.getInputStream(), "utf-8"));
				StringBuffer responseData = new StringBuffer();
				String response = null;
				while ((response = bufferedReader.readLine()) != null) {
					responseData.append(response);
				}
				bufferedReader.close();

				JSONObject jsonData = new JSONObject(responseData.toString());
				long length = jsonData.getLong("length");

				// --- Fuck you chain
				List<HashMap<String, Object>> chainchain = new ArrayList<HashMap<String, Object>>();
				JSONArray ja = jsonData.getJSONArray("chain");
				if (ja!=null && ja.length() > 0) {
					for (int i = 0; i < ja.length(); i++) {
						JSONObject job = ja.getJSONObject(i); // 遍历 jsonarray 数组，把每一个对象转成 json 对象

						int myIndex = job.getInt("index");
						Long myTime = job.getLong("timestamp");

						// ------ Fuck you transaction
						List<HashMap<String, Object>> myTRN = new ArrayList<HashMap<String, Object>>();
						JSONArray jaTransactions = job.getJSONArray("transactions");
						if (jaTransactions!=null && jaTransactions.length() > 0) {
							for (int ii = 0; ii < jaTransactions.length(); ii++) {
								JSONObject tempTRN = jaTransactions.getJSONObject(ii);
								HashMap<String, Object> result = new HashMap<>();
								result.put("sender", tempTRN.getString("sender"));
								result.put("recipient", tempTRN.getString("recipient"));
								result.put("amount", tempTRN.getLong("amount"));
								myTRN.add(result);
							}
						}
						// ------ Fuck you transaction

						Long myProof = job.getLong("proof");
						String myPreHash = job.getString("previous_hash");

						HashMap<String, Object> result = new HashMap<>();
						result.put("index", myIndex);
						result.put("timestamp", myTime);
						result.put("transactions", myTRN);
						result.put("proof", myProof);
						result.put("previous_hash", myPreHash);

						chainchain.add(result);
						// System.out.println(job.get("name")+"=") ; // 得到 每个对象中的属性值
					}
				}
				// Map<String, Object> blockblock get

				// List<Map<String, Object>> chain = (List)
				// jsonData.getJSONArray("chain").toList();

				// 检查长度是否长，链是否有效
				if (length > maxLength && validChain(chainchain)) {
					maxLength = length;
					newChain = chainchain;
				}
			}

		}
		// 如果发现一个新的有效链比我们的长，就替换当前的链
		if (newChain != null) {
			this.chain = newChain;
			return true;
		}
		return false;
	}
}
