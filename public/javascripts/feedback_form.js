$(document).ready(function()
{
  
  $("input#send_feedback").click(function()
  {
    $("#feedback_notification").text("(Sending feedback...)").fadeOut('slow').fadeIn('slow').fadeOut('slow').fadeIn('slow');
    $("form.feedback").ajaxSubmit(function(){
      $("#feedback_notification").text("(Thanks!)").css("font-weight", "bold")
        .fadeOut().fadeIn().fadeOut().fadeIn().fadeOut().fadeIn();
    });
    return false;
  });

  
    
});