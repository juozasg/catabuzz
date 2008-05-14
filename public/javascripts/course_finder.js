$(document).ready(function()
{
  var createLoadDropdown = function(row, href)
  {
    alert(row);
    alert(row.html());
    //console.log(row.html());
    console.log(href);
  }
  
  var destroyDropdown = function(row)
  {
    
  }
  
  var addDropdown = function(e)
  {
    $(e).removeClass("dropdown_closed").addClass("dropdown_disabled");
    var row = $(e).parents("tr");
    createLoadDropdown(row);
    //createLoadDropdown($(e).parent(), $(e).href());
    $(e).removeClass("dropdown_disabled").addClass("dropdown_opened");
  }
  
  var removeDropdown = function(e)
  {
    $(e).removeClass("dropdown_opened").addClass("dropdown_disabled");
    destroyDropdown($(e).parent())
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