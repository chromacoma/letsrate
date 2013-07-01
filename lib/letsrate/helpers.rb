module Helpers
  def rating_for(rateable_obj, dimension=nil, options={})

    if dimension.nil?
      klass = rateable_obj.average
    else
      klass = rateable_obj.average "#{dimension}"
    end

    if klass.nil?
      avg = 0
    else
      avg = klass.avg
    end

    star = options[:star] || 5

    disable_after_rate = options[:disable_after_rate] || false

    readonly = options[:readonly] || false
    if !readonly && disable_after_rate
      readonly = current_user.present? ? !rateable_obj.can_rate?(current_user.id, dimension) : true
    end
    
    if readonly
      hints = ['not rated', 'bad', 'average', 'good', 'great', 'amazing']
      title = hints[avg]
      content = ''
      1.upto(star).each do |idx|
        img = idx <= avg ? 'star-on.png' : 'star-off.png'
        content += image_tag(img, title:title, alt: idx)
        content += '&nbsp;'
      end
      content_tag :div, content.html_safe
    else
      content_tag :div, '', "data-dimension" => dimension, :class => "star", "data-rating" => avg,
                            "data-id" => rateable_obj.id, "data-classname" => rateable_obj.class.name,
                            "data-disable-after-rate" => disable_after_rate,
                            "data-readonly" => readonly,
                            "data-star-count" => star
    end
  end
end

class ActionView::Base
  include Helpers
end
