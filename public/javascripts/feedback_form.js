$(document).ready(function()
{
  $("input#send_feedback").click(function()
  {
    $("#feedback_notification").text("(Thanks for suggestions!)").css("font-weight", "bold")
      .fadeOut().fadeIn().fadeOut().fadeIn().fadeOut().fadeIn();
    
  });
  
  
  
});