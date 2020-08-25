// _todo_ example of js function, to be removed/modified
$( document ).ready(function() {
  $(document).on('click','#module_id-count_me',function(){

    if($("#module_id-count_me").hasClass("theme-even")) {
      $("#module_id-count_me").removeClass("theme-even");
      $("#module_id-count_me").addClass("theme-odd");
    } else if($("#module_id-count_me").hasClass("theme-odd")) {
      $("#module_id-count_me").removeClass("theme-odd");
      $("#module_id-count_me").addClass("theme-even");
    }

  });
});
