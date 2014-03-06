module ApplicationHelper
  def flash_notice(message, type)
    # note: you must have a div with id='notices' or rename the div appended to below with your element which
    # is the container for the flash messages
    flash.discard
    notice = <<-EOF
      $("html, body").animate({ scrollTop: 0 }, 1000);
      $('div#for_flash').replaceWith("<div id='for_flash'></div>");
      $('div#for_flash').prepend("<div class='#{type}'><h3>#{message}</h3></div>");
      $('#for_flash').delay(500).slideDown('slow').delay('8000').slideUp('slow'); 
    EOF
    notice.html_safe
  end
  
  def js_flash_notice(message, type)
    # note: you must have a div with id='notices' or rename the div appended to below with your element which
    # is the container for the flash messages
    if flash[:notice]
      flash.discard
      notice = <<-EOF
        $('div#js_for_flash').replaceWith("<div id='js_for_flash'></div>");
        $('div#js_for_flash').prepend("<div class='alert alert-block alert-success'><h4>Well Done!</h4>#{message}</div>");
        $('#js_for_flash').delay(2000).slideDown('slow').delay('8000').slideUp('slow'); 
      EOF
    else
      flash.discard
      notice = <<-EOF
        $('div#js_for_flash').replaceWith("<div id='js_for_flash'></div>");
        $('div#js_for_flash').prepend("<div class='alert alert-error alert-block'><h4>Warning!</h4>#{message}</div>");
        $('#js_for_flash').delay(2000).slideDown('slow').delay('8000').slideUp('slow'); 
      EOF
    end    
    notice.html_safe
  end
  
  def options_for_employees
    people = Person.fetch_employees(current_user.organization,current_user.role,current_user.department)
    container = people
  end
  
end

