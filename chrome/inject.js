var TessClient = {
   label: undefined
};

chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
  if (request.method == 'setLabel') {
  alert("Recieved setLabel: "+request.value);
      TessClient.label = request.value;
  }
});

var s = document.createElement('script');
s.src = chrome.extension.getURL('docscript.js');
(document.head||document.documentElement).appendChild(s);
