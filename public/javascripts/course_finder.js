$(document).ready(function()
{
  var createLoadDropdown = function(row, href)
  {
    //alert(row);
    //alert(href);
    var cols = row.children().size();
    var tr = $("<tr></tr>");
    tr.addClass("dropdown");
    tr.addClass("dropdown2");
    tr.html("OHMYGODD!");
    tr.insertAfter($(row));
  }
  
  var destroyDropdown = function(row)
  {
    $(row).next().remove();
  }
  
  var addDropdown = function(e)
  {
    $(e).removeClass("dropdown_closed").addClass("dropdown_disabled");
    var row = $(e).parents("tr");
    var href = $(e).attr("href");
    createLoadDropdown(row, href);

    $(e).removeClass("dropdown_disabled").addClass("dropdown_opened");
  }
  
  var removeDropdown = function(e)
  {
    $(e).removeClass("dropdown_opened").addClass("dropdown_disabled");
    var row = $(e).parents("tr");
    destroyDropdown(row);
    $(e).removeClass("dropdown_disabled").addClass("dropdown_closed");
  }
  
  $("body").error(function() {alert("ERRORS!!!"); return false;});
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
	    return true;
	  }
	);

});