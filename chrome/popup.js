function doSetLabel(x) {
	chrome.tabs.query({active: true, currentWindow: true},
		function(tabs) {
			chrome.tabs.sendMessage(tabs[0].id, {
				method: 'setLabel',
				value: x
			},
			function(response) {
				console.log(response);
			});
		}
   );
}

window.onload = function(e) {
  var priceBtn = document.getElementById("price");
  priceBtn.onclick = function () { doSetLabel('price'); };

  var titleBtn = document.getElementById("title");
  titleBtn.onclick = function () { doSetLabel('title'); };
};
