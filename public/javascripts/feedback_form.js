$(document).ready(function()
{
  
  $("input#send_feedback").click(function()
  {
    $("form.feedback").ajaxSubmit(function(){
      $("#feedback_notification").text("(Thanks!)").css("font-weight", "bold")
        .fadeOut().fadeIn().fadeOut().fadeIn().fadeOut();
    });
    return false;
  });

  
    
});