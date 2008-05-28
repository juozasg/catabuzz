$(document).ready(function()
{
  var createLoadDropdown = function(row, href)
  {
    var cols = row.children().size();
    var tr = $("<tr></tr>").addClass("dropdown");    
    var td = $("<td></td").attr("colspan", cols);
    var container = $("<div class='dropdown_container'></div>").appendTo(td);
    
    container.append("lalalal");
    tr.append(td);
    container.hide();
    tr.insertAfter($(row));
    container.load("http://www.google.com");
    container.slideDown('fast');
  }
  
  var destroyDropdown = function(row)
  {
    $(row).next().fadeOut('fast', function() {$(this).remove(); return false;});
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