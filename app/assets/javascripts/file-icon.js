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
      $(el).addClass(FileIcon.mime2class(content_type));
    })
  };
  var mime2class = function(content_type){
    var class_name = "asset-icon-";
    if(content_type){
      return content_type = content_type.split("/"), (content_type[0] != "image" && content_type[1]? " " + class_name + content_type[1].replace(/(\.|\+)/g,"-"):class_name + "image")
    }else{
      return "";
    }
  };
  return {
    init: init,
    mime2class: mime2class
  }
})()
