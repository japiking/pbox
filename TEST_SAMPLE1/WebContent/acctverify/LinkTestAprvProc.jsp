<%@ page contentType="text/html;charset=utf-8" %>

<%@page import="java.util.Enumeration"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.checkpay.util.SecurityUtil"%>
<%
	request.setCharacterEncoding("UTF-8");

	String ID        = SecurityUtil.null2void(request.getParameter("ID"), "");
	String CRYPT_KEY = SecurityUtil.null2void(request.getParameter("CRYPT_KEY"), "");
	String API_ID    = SecurityUtil.null2void(request.getParameter("API_ID"), "") + ".jct";
	
	String EV = "";
	String W = "";
	
	Date d = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	String trx_dt = sdf.format(d);
	sdf.applyPattern("HHmmss");
	String trx_tm = sdf.format(d);                                                                                                                              

	String ci		= SecurityUtil.null2void(request.getParameter("ci"), "");
	String user_id	= SecurityUtil.null2void(request.getParameter("user_id"), "");

	JSONObject param = new JSONObject();
	Enumeration<String> enumeration	= request.getParameterNames();
	if( enumeration != null ){
		while( enumeration.hasMoreElements() ){
			String paramName	= SecurityUtil.null2void((String) enumeration.nextElement());
			String paramValue	= request.getParameter(paramName);
			if(paramName.equals("CRYPT_KEY") || paramName.equals("CRYPT_KEY_IV") || paramName.equals("API_ID") || paramName.equals("ID"))
				continue;
			
			if(paramName.contains("ifrm"))
				continue;
			
			param.put(paramName, 	SecurityUtil.null2void(paramValue));
		}
	}
	
	EV = SecurityUtil.EncryptAesBase64(trx_dt+trx_tm+param.toString(), CRYPT_KEY, true);
	W = SecurityUtil.getHmacSha256(param.toString(), CRYPT_KEY, true);

	String url = "https://dev.checkpay.co.kr/"+API_ID+"?ID=" + ID
			                                           + "&RQ_DTIME=" + trx_dt+trx_tm 
			                                           + "&TNO=" + trx_dt+trx_tm 
			                                           + "&EV=" + EV 
			                                           + "&VV=" + W 
			                                           + "&EM=AES" 
			                                           + "&VM=HmacSHA256";
	
	if(API_ID.contains(".jct")){
	//데이터조회/요청(결제내역 조회/간편결제 취소)
		HttpURLConnection con = null;                                                                                                                                                            
		BufferedWriter bwriter = null;                                                                                                                                                           
		DataInputStream in = null;                                                                                                                                                               
		ByteArrayOutputStream bout = null;                                                                                                                                                       
		try {                                                                                                                                                                                    
			URL req = new URL(url);                                                                                                                                    
			con = (HttpURLConnection)req.openConnection();                                                                                                                                       
			con.setConnectTimeout(3 * 1000); 		// 3초                                                                                                                                         
			con.setReadTimeout(10 * 1000); 			// 10초
			con.setDoOutput(true);
			con.setDoInput(true);
			con.setRequestMethod("POST");                                                                                                                                                          
			con.setRequestProperty("Content-Type", 			"application/json;charset=UTF-8");
			
			bwriter = new BufferedWriter(new OutputStreamWriter(con.getOutputStream()));                                                                                                         
			bwriter.flush();                                                                                                                                                                     
	
	
			in = new DataInputStream(con.getInputStream());                                                                                                                                      
			bout = new ByteArrayOutputStream();                                                                                                                                                  
	                                                                                                                                                                                             
	        while (true) {                                                                                                                                                                       
		        byte[] buf = new byte[2048];                                                                                                                                                     
	            int n = in.read(buf);                                                                                                                                                            
	            if (n == -1) break;                                                                                                                                                              
	            bout.write(buf, 0, n);                                                                                                                                                           
	        }                                                                                                                                                                                    
	        bout.flush();                                                                                                                                                                        
		} catch(Exception e) {                                                                                                                                                                   
			e.printStackTrace();                                                                                                                                                                 
			return;                                                                                                                                                       
		} finally {                                                                                                                                                                              
			try {                                                                                                                                                                                
				if ( bwriter != null ) bwriter.close();                                                                                                                                          
				if ( in != null ) in.close();                                                                                                                                                    
				if ( bout != null ) bout.close();                                                                                                                                                
				if ( con != null ) con.disconnect();                                                                                                                                             
			} catch(Exception se) {                                                                                                                                                              
				                                                                                                                                                                                 
			}                                                                                                                                                                                    
		}                                                                                                                                                                                        
	  
	    //응답결과 데이터 수신                                                                                                                                                                                           
	    String respData = new String(bout.toByteArray());       
	    JSONObject rtn = JSONObject.fromObject(respData);
	    
		
	    String RC = rtn.getString("RC");
	    String RM = URLDecoder.decode(rtn.getString("RM"), "UTF-8");
	    out.println("return:" + URLDecoder.decode(rtn.toString(), "UTF-8"));
	    
	    String rEV = rtn.getString("EV");
	    String rW = rtn.getString("VV");
	    if ( RC.equals("0000")){
	    	//정상일 경우 - 데이터 복호화
	    	String decEV = SecurityUtil.DecryptAesBase64(rEV, CRYPT_KEY, true);
		    out.println("<br/><br/>EV :" + decEV);
		    
		    //수신 데이터 JSONObject형식으로 변환
		    JSONObject jsonEV = JSONObject.fromObject(decEV.substring(14));
	    }
	}
%>	