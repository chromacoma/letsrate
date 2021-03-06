$.fn.raty.defaults.path = "/assets";
$.fn.raty.defaults.half_show = true;

window.applyRaty = function(parent_element){
  if (typeof parent_element == 'undefined') {
    parent_element = document;
  }
  $(parent_element).find(".star").each(function() {
    var $readonly = ($(this).attr('data-readonly') == 'true');

    $(this).raty({
      score: function(){
        return $(this).attr('data-rating')
      },
      number: function() {
        return $(this).attr('data-star-count')
      },
      readOnly: $readonly,
      click: function(score, evt) {
        var _this = this;
        if (!_this.readonly) {
          $.post('<%= Rails.application.class.routes.url_helpers.rate_path %>',
          {
            score: score,
            dimension: $(this).attr('data-dimension'),
            id: $(this).attr('data-id'),
            klass: $(this).attr('data-classname')
          },
          function(data) {
            if(data) {
              // success code goes here ...

              if ($(_this).attr('data-disable-after-rate') == 'true') {
                $(_this).raty('set', { readOnly: true, score: score });
              }
            }
          });
        }
		  }
    });
	});
};


$(function(){ 
  applyRaty();
});

