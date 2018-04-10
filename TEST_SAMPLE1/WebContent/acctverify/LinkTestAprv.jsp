<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>1원 계좌검증</title>

<script language="javascript">
function requireAprv(){
	var form = document.frm0;
	form.submit();
}
function requireAprv2(){
	var form = document.frm2;
	form.submit();
}
</script>
<style type="text/css">
	.user {height: 50px}
</style>
</head>
<body>

<form name="frm0" method="post" target="ifrm1" action="./LinkTestAprvProc.jsp">
	기관코드:<input  name="ID" value="">
	암호화KEY:<input  name="CRYPT_KEY" value="">
	호출서비스:<input  name="API_ID" value="CPIF_AFFL_720">
	 <br/>
	<strong>계좌검증요청</strong>
	<table border="1">
		<tr>
		  <td>은행코드</td>
			<td><input type="text" name="fnni_cd" /></td>
		</tr>
		<tr>
		  <td>계좌번호</td>
			<td><input type="text" name="acct_no" /></td>
		</tr>
		<tr>
		  <td>회원명</td>
			<td><input type="text" name="memb_nm" /></td>
		</tr>
		<tr>
		  <td>인증구분</td>
			<td><input type="text" name="verify_tp" /></td>
		</tr>
		<tr>
		  <td>인증번호길이</td>
			<td><input type="text" name="verify_len" /></td>
		</tr>
		<tr>
		  <td>적요문구</td>
			<td><input type="text" name="ptst_txt"  /></td>
		</tr>
		<tr>
			<td colspan="2" align="right"><a href="javascript:requireAprv();">계좌검증요청</a></td>
		</tr>
	</table>
	<br/>	
</form>

<iframe name="ifrm1" width="100%" height="100" frameborder="0"></iframe>
<hr/>
<br/>


<form name="frm2" method="post" target="ifrm2" action="./LinkTestAprvProc.jsp">
	기관코드:<input  name="ID" value="">
	암호화KEY:<input  name="CRYPT_KEY" value="">
	호출서비스:<input  name="API_ID" value="CPIF_AFFL_721">
	 <br/>
	<strong>계좌검증확인</strong>
	<table border="1">
		<tr>
		  <td>검증 거래일자</td>
			<td><input type="text" name="verify_tr_dt" /></td>
		</tr>
		<tr>
		  <td>검증 거래번호</td>
			<td><input type="text" name="verify_tr_no" /></td>
		</tr>
		<tr>
		  <td>검증번호</td>
			<td><input type="text" name="verify_val" /></td>
		</tr>
		<tr>
			<td colspan="2" align="right"><a href="javascript:requireAprv2();">계좌검증확인</a></td>
		</tr>
	</table>
	<br/>	
</form>

<iframe name="ifrm2" width="100%" height="100" frameborder="0"></iframe>
<hr/>
<br/>
</body>
</html>