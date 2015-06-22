// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require_tree .

// foundation
$(function(){ $(document).foundation(); });

var captionLength = 0;
var caption = '';

function cursorAnimation() {
  $('#cursor').animate({
      opacity: 0
  }, 'fast', 'swing').animate({
      opacity: 1
  }, 'fast', 'swing');
}

function type() {
  captionEl.html(caption.substr(0, captionLength++));
  if(captionLength < caption.length+1) {
      setTimeout('type()', 100);
  } else {
      captionLength = 0;
      caption = '';
  }
}

$(function() {
  setTimeout(function() {
    $(".flash").hide(500)
  }, 1500);


  setInterval ('cursorAnimation()', 400);
  captionEl = $('#caption');

  function testTypingEffect() {
    caption = 'Collaborate on clinical data mining projects';
    type();
  }
  testTypingEffect();
});
