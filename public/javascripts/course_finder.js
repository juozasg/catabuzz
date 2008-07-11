$(document).ready(function()
{
  $("a[rel=boxy]").boxy({modal: true, fixed: false});
  $(".section_search_results").click(
    function(event)
    {
      if($(event.target).is('.dropdown_closed'))
      {
        addDropdown(event.target);
        return false;

      }
      else if($(event.target).is('.dropdown_opened'))
      {
        removeDropdown(event.target);
        return false;
      }
      else if($(event.target).is('.dropdown_disabled'))
      {
        return false;
      }

      return false;	  
    }
  );

  $(document).ajaxError(
    function(){
      if (window.console && window.console.error) {
        console.error(arguments);
      }
    });

    $("body").error(
      function(){
        if (window.console && window.console.error) {
          console.error(arguments);
        }
      });

});