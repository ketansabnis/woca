FileIcon = (function(){
  var init = function(delete_link, icon_el){
    $(delete_link).click(function(e){
      e.preventDefault()
      var href = $(e.currentTarget).attr("href");
      $.ajax({
        url: href,
        type: "DELETE",
        dataType: "json",
        success: function(one, two, three){
          $(e.target).closest(".asset").remove();
        }
      })
    })
    _.each($(icon_el), function(el){
      var content_type = $(el).data("content-type");
      $(el).addClass(iHub.mime2class(content_type));
    })
  }
  return {
    init: init
  }
})()
