$(document).ready(function(){
  if(window.history && typeof window.history.pushState === "function"){
    var href = window.location.href;
    if(href.indexOf("remote-state=") != -1){
      var param = Amura.getParamFromURL(window.location.href, "remote-state");
      modal_remote_form_link_click_handler(param);
    }
  }
});

$(document).on("click", '.modal-remote-form-link', function(e){
  e.preventDefault();
  if ($(this).attr("href")){
    var url = $(this).attr("href");
  } else {
    var url = $(this).parents('form').attr('action') + '?' + $(this).parents('form').serialize();
  }
  modal_remote_form_link_click_handler(url);
});

var handle_remote_pushstate = function(){
  if(window.history && typeof window.history.pushState === "function"){
    $("#modal-remote-form-inner").off("hide.bs.modal", handle_remote_pushstate);
    var href = Amura.removeParamFromURL(window.location.href, "remote-state");
    window.history.pushState(null, null, href);
  }
}

var modal_remote_form_link_click_handler = function(remote_href){
  $.blockUI();
  if(!_.isEmpty(remote_href) && remote_href != "javascript:;" && remote_href != "javascript:void(0);"){
    if(window.history && typeof window.history.pushState === "function"){
      var href = window.location.href.split('?')[0]
      $('.modal-backdrop').remove()
      var href = Amura.removeParamFromURL(href, "remote-state");
      if(href.indexOf("?") == -1){
        href += "?";
      }else{
        href += "&";
      }
      href += "remote-state=" + remote_href;
      window.history.pushState(null, null, href);
    }
    $.ajax({
      url: decodeURIComponent(remote_href),
      type: "GET",
      dataType: "html",
      success: function(one){
        if($("#modal-remote-form-container").length == 0){
          $('body').append('<div id="modal-remote-form-container"></div>');
        }
        $("#modal-remote-form-container").html(one);
        $("#modal-remote-form-inner").modal({
          backdrop: 'static',
          show: true,
          keyboard: false,
          focus: true
        });
        $("#modal-remote-form-container [data-toggle='tooltip']").tooltip();
        if(window.history && typeof window.history.pushState === "function"){
          $("#modal-remote-form-inner").on("hide.bs.modal", handle_remote_pushstate);
        }
      },
      error: function(one, two, three){
        handle_remote_pushstate();
        var errors;
        if(one.responseText != undefined) {
          errors = $.parseJSON(one.responseText).errors
        }
        Amura.global_error_handler(errors || "Error while fetching modal remote form");
      },
      complete: function(){
        $.unblockUI();
      }
    });
  }
}
$(document).on("ajax:beforeSend", '.modal-remote-form', function(event){
  $("#modal-remote-form-container .modal-body .modal-remote-form-errors").html('');
});
$(document).on("ajax:success", '.modal-remote-form', function(event){
  var detail = event.detail;
  var data = detail[0], status = detail[1], xhr = detail[2];

  var message = "";
  var resource = $(event.currentTarget).attr("data-resource-type");
  if(resource){
    message += resource + " ";
  }
  if(xhr.status == 201){
    message += "created successfully";
  }else{
    message += "updated successfully";
  }
  Amura.global_success_handler(message);
  var dismiss = $("#modal-remote-form").data("dismiss-modal");
  if(typeof dismiss != "undefined" && dimiss == false){
  }else{
    $("#modal-remote-form-inner").modal("hide");
    setTimeout(function(){
      if($("#modal-remote-form-container").length == 0){
        $('body').append('<div id="modal-remote-form-container"></div>');
      }
      $("#modal-remote-form-container").html("");
    }, 2500);
    // handle location on JSON response
    if(xhr.getResponseHeader('location')){
      window.location = xhr.getResponseHeader('location')
    }else{
      window.location = window.location;
    }
  }
});
$(document).on("ajax:error", '.modal-remote-form', function(event){
  var detail = event.detail;
  var data = detail[0], status = detail[1], xhr = detail[2];
  var resource = $(event.currentTarget).attr("data-resource-type");
  if($("#modal-remote-form-container .modal-body .modal-remote-form-errors").length == 0){
    $("#modal-remote-form-container .modal-body").prepend("<div class='modal-remote-form-errors'></div>");
  }
  if(data && data.errors){
    var html = '<div class="mb-3 alert alert-danger">';
    if(typeof data.errors == 'string'){
      html += '<strong>' + data.errors + '</strong>';
    } else {
      html += '<strong>The form contains ' + data.errors.length + ' errors.</strong>';
      html += '<ul class="mt-3 pl-3">';
      _.each(data.errors, function(error){
        html += '<li>' + error + '</li>';
      });
      html += '</ul>'
    }
    html += '</div>';
  } else{
    html = "We could not update the " + (resource ? resource : "record");
  }
  $("#modal-remote-form-container .modal-body .modal-remote-form-errors").html(html);
});
