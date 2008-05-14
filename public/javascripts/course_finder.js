$(document).ready(function()
{
  var addDropdown = function(e)
  {
    alert("adding dropdown");
    
    $(e).removeClass("dropdown_closed").addClass("dropdown_opened");
  }
  
  var removeDropdown = function(e)
  {
    alert("removing dropdown");
    $(e).removeClass("dropdown_opened").addClass("dropdown_closed");
  }
  
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
	  
	    return true;
	  }
	);
	
	//$("a.dropdown_close").click(function(){ alert("yeaaahh!");return false;});
});