<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport"  content="width=device-width, minimum-scale=1.0, maximum-scale=2.0; charset=UTF-8" />
<title>${pageTitle}</title>




        <style type="text/css">
            #preview {
                display: inline-block;
                width: 30px;
                height: 30px;
                position: relative;
                background-image: url(img/iconfont-tianjia.png);
                background-repeat: no-repeat;
                background-size: cover;
            }
            
            #file1120_unuse {
                width: 100%;
                height: 100%;
                opacity: 0;
                position: absolute;
                left: 0;
                top: 0;
                cursor: pointer;
                z-index: 5;
            }
            
            #imgshow{
      			width: 100%;
      			height: 100%;
    		}
        </style>
        
        
        
 	<script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>

<script type="text/javascript">    



	var isIE = /msie/i.test(navigator.userAgent) && !window.opera;
	function fileChange(target) {
		
		var f = target.files[0];
		fileType = f.type;
		if((/image\/\w+/.test(fileType)) == false) {
			alert("只接受上传图片");
			document.getElementById("errorFlag").value = "只接受上传图片";
			return false;
		}
		var fileSize = 0;
		var filepath = target.value;
		var filemaxsize = 1024 * 4;//4M
		var filebigsize = 1024 * 1;//if the file bigger than 1m, notice user to wait wait
		if (!filepath) {
			document.getElementById("errorFlag").value = "请选择文件";
			return false;
		}
		if (isIE && !target.files) {
			var filePath = target.value;
			var fileSystem = new ActiveXObject("Scripting.FileSystemObject");
			if (!fileSystem.FileExists(filePath)) {
				alert("附件不存在，请重新输入！");
				document.getElementById("errorFlag").value = "附件不存在，请重新输入！";
				return false;
			}
			var file = fileSystem.GetFile(filePath);
			fileSize = file.Size;
		} else {
			fileSize = target.files[0].size;
		}
		
		//alert(target.value);
        //var myImg_origin = document.getElementById('myimg');
        //myImg_origin.src = target.value;
	 	//var canvas = document.getElementById("mycanvas");
	 	//var context = canvas.getContext("2d");
        //canvas.width = 400;
        //canvas.height = 300;
        
        //context.drawImage(myImg_origin, 100, 100);
        //var myImg = document.getElementById('img');
        //myImg.src = canvas.toDataURL("image/png");
		
		
		

		var size = fileSize / 1024;
		if (size > filemaxsize) {
			alert("上传图片大小不能超过" + filemaxsize / 1024 + "M！");
			target.value = "";
			document.getElementById("errorFlag").value = "上传图片大小不能超过"
					+ filemaxsize / 1024 + "M！";
			return false;
		}else if (size > filebigsize) {
			document.getElementById("errorFlag").value = "waitwait";
			return true;
		}else if (size <= 0) {
			alert("上传图片大小不能为0M！");
			target.value = "";
			document.getElementById("errorFlag").value = "上传图片大小不能为0M！";
			return false;
		}
		document.getElementById("errorFlag").value = "ok";
	}
	
	
	function fileChange_backup(target) {
		var fileSize = 0;
		var filetypes = [ ".jpg", ".png", ".jpeg", ".bmp" ];
		var filepath = target.value;
		var filemaxsize = 1024 * 3;//3M
		var filebigsize = 1024 * 1;//if the file bigger than 1m, notice user to wait wait
		if (filepath) {
			var isnext = false;
			var fileend = (filepath.substring(filepath.indexOf("."))).toLowerCase();
			if (filetypes && filetypes.length > 0) {
				for (var i = 0; i < filetypes.length; i++) {
					if (filetypes[i] == fileend) {
						isnext = true;
						break;
					}
				}
			}
			if (!isnext) {
				alert("不接受此文件类型！(只接受图片类型jpg, png, jpeg, bmp)");
				target.value = "";
				document.getElementById("errorFlag").value = "不接受此文件类型！(只接受图片类型jpg, png, jpeg, bmp)";
				return false;
			}
		} else {
			document.getElementById("errorFlag").value = "请选择文件";
			return false;
		}
		if (isIE && !target.files) {
			var filePath = target.value;
			var fileSystem = new ActiveXObject("Scripting.FileSystemObject");
			if (!fileSystem.FileExists(filePath)) {
				alert("附件不存在，请重新输入！");
				document.getElementById("errorFlag").value = "附件不存在，请重新输入！";
				return false;
			}
			var file = fileSystem.GetFile(filePath);
			fileSize = file.Size;
		} else {
			fileSize = target.files[0].size;
		}

		var size = fileSize / 1024;
		if (size > filemaxsize) {
			alert("上传图片大小不能超过" + filemaxsize / 1024 + "M！");
			target.value = "";
			document.getElementById("errorFlag").value = "上传图片大小不能超过"
					+ filemaxsize / 1024 + "M！";
			return false;
		}else if (size > filebigsize) {
			target.value = "waitwait";
		}else if (size <= 0) {
			alert("上传图片大小不能为0M！");
			target.value = "";
			document.getElementById("errorFlag").value = "上传图片大小不能为0M！";
			return false;
		}
		document.getElementById("errorFlag").value = "ok";
	}
	
	
	
    function toVaildForm(){
        var val = document.getElementById("errorFlag").value;
        if(val == "ok"){
            return true;
        }else if(val == "waitwait"){
			alert("图片较大分析需时请耐心等待, 请按确定继续");
			return true;
        }else{
        	alert("请选择图片。" + val);
            return false;
        }
    }
    
    
    function AutoResizeImage(maxWidth,maxHeight,objImg_nouse){
    	
    	maxWidth = document.body.clientWidth * 0.8;
    	var objImg = document.getElementById(objImg_nouse);
    	
    	var img = new Image();
    	img.src = objImg.src;
    	var hRatio;
    	var wRatio;
    	var Ratio = 1;
    	var w = img.width;
    	var h = img.height;
    	wRatio = maxWidth / w;
    	hRatio = maxHeight / h;
    	if (maxWidth ==0 && maxHeight==0){
    	Ratio = 1;
    	}else if (maxWidth==0){//
    	if (hRatio<1) Ratio = hRatio;
    	}else if (maxHeight==0){
    	if (wRatio<1) Ratio = wRatio;
    	}else if (wRatio<1 || hRatio<1){
    	Ratio = (wRatio<=hRatio?wRatio:hRatio);
    	}
    	if (Ratio<1){
    	w = w * Ratio;
    	h = h * Ratio;
    	}
    	objImg.height = h;
    	objImg.width = w;
    	}
   
    function showScore(){
    	document.getElementById("showScore_label").innerText = " " + "${beauty}";
//+ ${pageTitle};
    	//innerHTML 
    	return false;
    }
    
    function showOrHideScore(){
    	//alert("${flag_ShowScore}");
    	if("${flag_ShowScore}" == "1") {
        	document.getElementById("score_title").style.visibility="visible"; 
    	}else{
        	document.getElementById("score_title").style.visibility="hidden"; 
    	}
    }
    
    
    function resizeTheImage(){
    	
		//var eleFile = document.querySelector('#file1120');
		var eleFile = document.getElementById("selPicture");
		var resizedImg = document.getElementById("imgshow");
		
		// 压缩图片需要的一些元素和对象
		var reader = new FileReader(),
			//创建一个img对象
			img = new Image();

		// 选择的文件对象
		var file = null;

		// 缩放图片需要的canvas
		var canvas = document.createElement('canvas');
		var context = canvas.getContext('2d');

		// base64地址图片加载完毕后
		img.onload = function() {
			// 图片原始尺寸
			var originWidth = this.width;
			var originHeight = this.height;
			//alert(originWidth + "||" + originHeight);
			// 最大尺寸限制，可通过国设置宽高来实现压缩程度
			var maxWidth = document.body.clientWidth,
				maxHeight = document.body.clientWidth;//can set 500
			// 目标尺寸
			var targetWidth = originWidth,
				targetHeight = originHeight;
			// 图片尺寸超过XXX x XXX的限制
			if(originWidth > maxWidth || originHeight > maxHeight) {
				if((originWidth / originHeight) > (maxWidth / maxHeight)) {
					// 更宽，按照宽度限定尺寸
					targetWidth = maxWidth;
					targetHeight = Math.round(maxWidth * (originHeight / originWidth));
				} else {
					targetHeight = maxHeight;
					targetWidth = Math.round(maxHeight * (originWidth / originHeight));
				}
			}
			// canvas对图片进行缩放
			canvas.width = targetWidth;
			canvas.height = targetHeight;
			//alert(canvas.width + "||" + canvas.height);
			// 清除画布
			context.clearRect(0, 0, targetWidth, targetHeight);
			// 图片压缩
			context.drawImage(img, 0, 0, targetWidth, targetHeight);
			/*第一个参数是创建的img对象；第二个参数是左上角坐标，后面两个是画布区域宽高*/
			//压缩后的图片base64 url
			/*canvas.toDataURL(mimeType, qualityArgument),mimeType 默认值是'image/jpeg';
			 * qualityArgument表示导出的图片质量，只要导出为jpg和webp格式的时候此参数才有效果，默认值是0.92*/
			var newUrl = canvas.toDataURL('image/jpeg', 0.92); //base64 格式
			//--0804-- preview.style.backgroundImage='url(' + newUrl + ')';
			//console.log(canvas.toDataURL('image/jpeg', 0.92))
			//document.getElementById("imgshow").width = targetWidth;
			//document.getElementById("imgshow").height = targetHeight;
			resizedImg.setAttribute('src',newUrl);

		};

		// 文件base64化，以便获知图片原始尺寸
		reader.onload = function(e) {
			img.src = e.target.result;
		};
		eleFile.addEventListener('change', function(event) {
			file = event.target.files[0];
			// 选择的文件是图片
			if(file.type.indexOf("image") == 0) {
				reader.readAsDataURL(file);
			}
		});
		
    }
    
    function getBlobBydataURI(dataURI,type) {
    	  var binary = atob(dataURI.split(',')[1]);
    	  //var binary = atob(dataURI);
    	  var array = []; 
    	  for(var i = 0; i < binary.length; i++) { 
    	    array.push(binary.charCodeAt(i)); 
    	  } 
    	  return new Blob([new Uint8Array(array)], {type:type }); 
    	} 
    
 	function uploadImg(){
 		
       	document.getElementById("lb_faceGender").innerHTML = "";
       	document.getElementById("lb_faceRace").innerHTML = "";
       	document.getElementById("lb_faceAge").innerHTML = "";
       	document.getElementById("lb_faceShape").innerHTML = "";
       	document.getElementById("lb_faceSmile").innerHTML = "";
       	document.getElementById("lb_faceGlass").innerHTML = "";
      	document.getElementById("lb_faceBeauty").innerHTML = "";
      	document.getElementById("showScore_label").innerHTML = "";

 	      //base64 转 blob 
 	      var $Blob= getBlobBydataURI(document.getElementById("imgshow").getAttribute('src'),'image/png'); 
 	      var formData = new FormData(); 
 	      //(0804) formData.append("files", $Blob ,"file_"+Date.parse(new Date())+".jpeg"); 
 	      formData.append("files", $Blob ,"file_1.png"); 
 	      //组建XMLHttpRequest 上传文件 
 	      var request = new XMLHttpRequest(); 
 	      //上传连接地址 
 	      request.open("POST", '${pageContext.request.contextPath}/doUploadImage', true);
 	      //request.setRequestHeader("content-type","application/x-www-form-urlencoded");
 	      request.onreadystatechange=function() 
 	      { 
 	        if (request.readyState==4) 
 	        { 
 	          if(request.status==200){
 	          	console.log("上传成功");
 	          	var rspText = this.responseText;
 	          	//alert(rspText);
 	          	//var obj = rspText.parseJSON();
 	          	var jsonObj =  JSON.parse(rspText);
 	          	document.getElementById("lb_faceGender").innerHTML = "<font color="+jsonObj[0].resultColor+">" + jsonObj[0].faceGender + "</font>";
 	          	document.getElementById("lb_faceRace").innerHTML = "<font color="+jsonObj[0].resultColor+">" + jsonObj[0].faceRace + "</font>";
 	          	document.getElementById("lb_faceAge").innerHTML = "<font color="+jsonObj[0].resultColor+">" + jsonObj[0].faceAge + "</font>";
 	          	document.getElementById("lb_faceShape").innerHTML = "<font color="+jsonObj[0].resultColor+">" + jsonObj[0].faceShape + "</font>";
 	          	document.getElementById("lb_faceSmile").innerHTML = "<font color="+jsonObj[0].resultColor+">" + jsonObj[0].faceSmile + "</font>";
 	          	document.getElementById("lb_faceGlass").innerHTML = "<font color="+jsonObj[0].resultColor+">" + jsonObj[0].faceGlass + "</font>";
	          	document.getElementById("lb_faceBeauty").innerHTML = "<font color="+jsonObj[0].resultColor+">" + jsonObj[0].faceBeauty + "</font>";
	          	document.getElementById("showScore_label").innerHTML = "<font color="+jsonObj[0].resultColor+">" + jsonObj[0].faceBeautyScore + "</font>";
	          	document.title = jsonObj[0].pageTitle;
	          }else{
 	            console.log("上传失败,检查上传地址是否正确"); 
 	          } 
 	        } 
 	      } 
 	      request.send(formData); 
 	}
 	

</script>


		
		
		

</head>


<body onload="showOrHideScore();" style="background-image:url(https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530654444483&di=b7fba38870b2628fcdde2f34e0b79bd4&imgtype=0&src=http%3A%2F%2Fpic.qiantucdn.com%2F58pic%2F26%2F42%2F71%2F90X58PICs8c_1024.jpg)">

<table border="1" bgcolor="white" align="center">
  <tr>
    <td align="center">
<!-- 
<input type="file" name="selPicture" id="selPicture" style="width: 330px; height: 23px; font-size: 16px;" onchange="fileChange(this);" />
 -->
<input type="file" accept="image/*" id="selPicture" value="" />
<br/>
<button id='uploadbt' onclick="uploadImg();">开始分析</button>



<!-- <input type="submit" name="upload" id="upload" value="开始分析" style="width: 70px; height: 25px" /> -->
</td>
  </tr>
</table>

<table border="1" bgcolor="white" align="center">
  <tr>
    <td>
<img id="imgshow" src="" alt="" />
	<script type="text/javascript">
        resizeTheImage();
        //AutoResizeImage(500, 500, document.getElementById("imgshow"));
    </script>
</td>
  </tr>
</table>


<table border="1" style="width:100%" align="center">
  <tr>
    <td align="center"><img id="infoIcon" name="infoIcon" src="${picFileName}" /></td>
  </tr>
  <tr><td align="center">

    <table border="0">
    	<tr style="color:lightgrey"><td style="width:50%" align="right"><strong>性别：</strong></td>
    	<td style="width:50%" align="left"><strong><label id = "lb_faceGender"></label></strong></td></tr>
    	<tr style="color:lightgrey"><td style="width:50%" align="right"><strong>人种：</strong></td>
    	<td style="width:50%" align="left"><strong><label id = "lb_faceRace"></label></strong></td></tr>
    	<tr style="color:lightgrey"><td style="width:50%" align="right"><strong>年龄：</strong></td>
    	<td style="width:50%" align="left"><strong><label id = "lb_faceAge"></label></strong></td></tr>
   		<tr style="color:lightgrey"><td style="width:50%" align="right"><strong>脸形：</strong></td>
   		<td style="width:50%" align="left"><strong><label id = "lb_faceShape"></label></strong></td></tr>
    	<tr style="color:lightgrey"><td style="width:50%" align="right"><strong>笑容：</strong></td>
    	<td style="width:50%" align="left"><strong><label id = "lb_faceSmile"></label></strong></td></tr>
    	<tr style="color:lightgrey"><td style="width:50%" align="right"><strong>眼镜：</strong></td>
    	<td style="width:50%" align="left"><strong><label id = "lb_faceGlass"></label></strong></td></tr>
    	
   		<tr style="color:red">
   			<td style="width:50%" align="right"><strong>颜值测评：</strong></td>
   			<td style="width:50%" align="left"><strong><label id = "lb_faceBeauty"></label></strong></td>
   		</tr>
   		<tr style="color:lightgrey">
   			<td style="width:50%" align="right"><strong>查看分数：</strong></td>
   			<td style="width:50%" align="left"><strong><label id = "showScore_label"></label></strong></td>
   		</tr>

    </table>


  </td></tr>
</table>








</body>
</html>