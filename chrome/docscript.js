var WebExtract = {
	doLabelClick: function (e) {
		alert("toto");
	}
};

document.addEventListener("load",function() {
   document.body.addEventListener("click", WebExtract.doLabelClick, true);
},false);

