var TessLabeler = {
  yesElement: null,
  noElement: null,
  redirectElement: null,
  labelElement: null,
  init: function() {
    var self = this;
    self.yesElement = document.getElementById('yes');
    self.noElement = document.getElementById('no');
    self.labelElement = document.getElementById('label');
    self.redirectElement = document.getElementById('redirect');
    self.yesElement.addEventListener('click', function() { self.label(true); });
    self.noElement.addEventListener('click', function() { self.label(false); });
    self.labelElement.style.display = 'block';
    self.redirectElement.style.display = 'none';
    document.getElementById('show').addEventListener('click', function() {
      alert('GO');
      chrome.tabs.getCurrent(function (tab) {
        alert(tab.title);
        // var getElementsByAttribute = function (attr) {
        //   var match = [];
        //   var elements = document.getElementsByTagName("*");
        //   for (var ii = 0, ln = elements.length; ii < ln; ii++) {
        //     if (elements[ii].hasAttribute(attr)) {
        //       match.push(elements[ii]);
        //     }
        //   }
        //   return match;
        // };
        // var baz = getElementsByAttribute('data-tess-label');
        // for (var xx = 0, ln = baz.length; xx < ln; xx++) {
        //   baz[xx].style.border = 'solid black 1px';
        //   baz[xx].innerHTML = baz[xx].innerHTML + ' ' + baz[xx].getAttribute('data-tess-label').toUpperCase();
        // }
      });
      alert('OG');
    });
  }, label: function(yes_no) {
    var self = this;
    chrome.tabs.query({ active: true, currentWindow: true }, function(tabs) {
      chrome.tabs.sendMessage(tabs[0].id, {
        type: 'label', yes_no: yes_no
      });
      self.redirectElement.innerHTML = '';
      self.labelElement.style.display = 'none';
      self.redirectElement.style.display = 'block';
      chrome.tabs.sendMessage(tabs[0].id, {
        type: 'get_link'
      }, function(response) {
        var centerElement = document.createElement('center');
        if (response.url === undefined) {
          setTimeout(function() { window.close(); }, 3000);
          centerElement.innerText = 'No links available...';
        } else {
          var urlElement = document.createElement('a');
          urlElement.href = response.url;
          urlElement.innerText = 'Next page ?';
          urlElement.addEventListener('click', function() {
            chrome.tabs.sendMessage(tabs[0].id, { type: 'redirect', url: response.url });
            window.close();
          });
          centerElement.appendChild(urlElement);
        }
        self.redirectElement.appendChild(centerElement);
      });
    });
  }
};

document.addEventListener('DOMContentLoaded', function () { TessLabeler.init(); });

// vim: ft=javascript et sw=2 sts=2
