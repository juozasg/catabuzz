function updateLoadingText(h4class)
{
  
  var div = $(h4class);
  var e = div.find("h4");
  var str = $(e).text();
  var dots = str.slice(str.indexOf("."), str.lastIndexOf(".") + 1);
  var numDots = dots.length;
  
  if(numDots >= 3)
  {
    numDots = 0;
  }
  else
  {
    numDots ++;
  }
  
  str = "";
  while(numDots > 0)
  {
    str += ".";
    numDots--;
  }
  
  str = "Loading" + str;
  $(e).text(str);
}

var counter = 0;

var createLoadDropdown = function(row, href)
{
  var cols = row.children().size();
  var tr = $("<tr></tr>").addClass("dropdown");    
  var td = $("<td></td").attr("colspan", cols);
  
  tr.append(td);
  tr.insertAfter($(row));
  
  var loadingContainer = $("<div class='loading_container'></div>").appendTo(td);
  var container = $("<div class='dropdown_container'></div>").appendTo(td);

  container.hide();
  loadingContainer.hide();
    
  loadingContainer.append("<h4>Loading.</h4>").addClass("loading_" + counter);
  loadingContainer.fadeIn('fast');

  // flash ... in loading container
  var interval = setInterval('updateLoadingText(".loading_' + counter + '");', 500);

  counter++;
  container.load(href + "?ajax", function()
  {
    clearInterval(interval);
    loadingContainer.hide();
    loadingContainer.remove();
    container.slideDown('fast');
  }
  );
  
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

	
