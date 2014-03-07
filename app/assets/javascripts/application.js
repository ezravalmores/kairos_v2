// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.es.js
//= require turbolinks
//= require_tree .

$(document).ready(function() {	
   $('#flash_notice').delay(500).slideDown('slow').delay('8000').slideUp('slow'); 
   $('#flash_warning').delay(500).slideDown('slow').delay('8000').slideUp('slow'); 		
});

function toggleMaster(checkbox, master) {
  master = $j(master)
  if (!master) return
  if (master.checked && !checkbox.checked) {
    master.checked = false;
  }
}

function toggleItems(master, className) {
  var items = document.getElementsByClassName(className);
  if (master.checked) {
    for (i = 0; i < items.length; i++) { items[i].checked = true; }
  } else {
    for (i = 0; i < items.length; i++) { items[i].checked = false; }
  }
}
