$(document).ready(function()
{
    /*
  $("a#feedback").click(function (e) {
    e.preventDefault();
//    $.modal();
    var href = $("a#feedback").attr("href");
    $.get(href + "?ajax", function(data) {
      $.modal(data, {containerCss: {position: 'absolute'}});
    });
  
    var container = $("<div>aaa</div>").modal({onOpen: function (dialog) {
        alert(dialog);
      
        
      }
    });
    
    //$.modal($("<div class='inc: feedback'>lala " + Math.random() * 1000 +"</div>"));
    //container.load(href)
    //return true;
  });
  */

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