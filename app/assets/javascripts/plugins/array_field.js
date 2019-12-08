(function($){

  var _addHtmlToCollection = function(collection, value, options){
    var html = "<li class='array-item'>" + value;
    if(options.editable) {
      html += "<a href='javascript:;' tabindex='-1' class='pull-right array-item-close'><i class='mdi mdi-close'></i></a>";
    }
    html += "</li>";
    collection.append(html);
  }

  var _addValueToHiddenField = function(e){
    var wrapper = $(e.target).closest('.array-field-wrapper');
    var element = wrapper.siblings().closest('.array-field');
    var validation = $(element).data('validation');
    var input_field = wrapper.find('.array-field-input');
    var collection = wrapper.find('.array-field-collection');
    var valid = true;
    var error = "";
    if((e.type == "keydown" && e.which == 13) || e.type == "click") {
      e.preventDefault();
      var value = input_field.val();
      if(!_.isEmpty(value)) {
        if(!_.isEmpty(validation)) {
          if(validation == "url") {
            valid = /^(?:(?:(?:https?|ftp):\/\/))?(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})).?)(?::\d{2,5})?(?:[/?#]\S*)?$/i.test( value );
            error = "Please enter valid url";
          }else if(validation == "email") {
            valid = /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/.test( value );
            error = "Please enter valid email address";
          }
        }

        value = value.replace("\"", "&quot;");

        if(wrapper.closest(".form-group").find(".array-field option[value=\"" + value + "\"]").length > 0){
          valid = false;
          error = "Value already exists.";
        }

        if(valid) {
          _addHtmlToCollection(collection, value, {editable: true});
          input_field.val('');
          if( !_.isEmpty(value) ) {
            element.append( new Option(value, value, true, true) );
          }

          input_field.closest(".form-group").find(".help-block").addClass("hidden");
          input_field.closest(".form-group").removeClass("has-error");
        } else {
          input_field.closest(".form-group").addClass("has-error");
          if(input_field.closest(".form-group").find(".help-block").length == 0) {
            input_field.closest(".form-group").append("<span class='help-block'></span>");
          }
          input_field.closest(".form-group").find(".help-block").html(error);
          input_field.closest(".form-group").find(".help-block").removeClass("hidden");
        }
      }
    }
  }

  var _removeValueFromCollection = function(e){
    $(e).off('click');

    var value = $(e.target).closest('.array-item').text();
    var wrapper = $(e.target).closest('.array-field-wrapper');
    var element = wrapper.siblings().closest('.array-field');

    wrapper.siblings().closest('.array-field-wrapper');
    element.find("option[value='" + value + "']").remove();
    $(e.target).closest('li').remove();
  }

  var _initArrayField = function(element, options) {
    options.label = $(element).data('label') || 'Add';
    options.helptext = $(element).data('helptext') || '';
    var wrapper = $(element).siblings().closest('.array-field-wrapper');
    var required = $(element).attr("required") == "required" || $(element).attr("required") == true

    if(wrapper.length == 0) {
      $(element).after('<div class="array-field-wrapper"></div>');
      wrapper = $(element).siblings().closest('.array-field-wrapper');
    }

    options.editable = $(element).data('editable');
    if( _.isUndefined(options.editable) || _.isNull(options.editable) ) {
      options.editable = true;
    }

    var html = "<label for='array-field-text' class='control-label " + (required ? "label-required" : "") + "'>" + options.label + "</label>";

    if(options.editable) {
      html += "<div class='form-group' style='margin-bottom: 5px;'>\
                <div class='input-group'>\
                  <input value='' type='text' class='form-control array-field-input' placeholder='Type & press enter to add' >\
                  <span class='input-group-btn'>\
                    <a class='btn btn-default array-field-btn'><i class='mdi mdi-plus'></i></a>\
                  </span>\
                </div>\
                <ul class='list-group array-field-collection no-margin-bottom'></ul>"
                if(options.helptext != ""){
                    html += "<p class='help-text'>" + options.helptext + "</p>";
                }
      html += "</div>";
    }else{
        html += "<ul class='list-group array-field-collection'></ul>";
    }
    wrapper.html(html);

    var collection = wrapper.find('.array-field-collection');
    var values = !_.isEmpty($(element).val()) ? $(element).val() : [];

    values.forEach(function(value) {
      _addHtmlToCollection(collection, value, options);
    });
  }

  $.fn.arrayField = function(options){
    options = $.extend({},options);
    this.each(function(index, element){
      _initArrayField(element, options);
    });
  }

  $(document).on('click', '.array-field-btn', _addValueToHiddenField);
  $(document).on('keydown','.array-field-input', _addValueToHiddenField);
  $(document).on('click','.array-item-close',_removeValueFromCollection);

}(jQuery));
