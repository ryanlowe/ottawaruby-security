module ApplicationHelper
  
  def format_head_title(title)
    return SITE_NAME if title.to_s.length < 1
    h(title)+" - "+SITE_NAME
  end
  
  def format_date(datetime,datetime_hover=false,hover_prefix=nil)
    return "" if datetime.nil?
    code = (Time.now.year == datetime.year) ? "%b %d" : "%y/%m/%d"
    date = datetime.strftime(code)
    return date unless datetime_hover
    hover_prefix_s = hover_prefix.nil? ? "" : hover_prefix+" "
    '<span title="'+hover_prefix_s+format_datetime(datetime)+'">'+date+'</span>'
  end
  
  def format_datetime(datetime)
    return "" if datetime.nil?
    code  = "%b %d"
    code += " %Y" unless (Time.now.year == datetime.year)
    code += " at %I:%M:%S %p"
    datetime.strftime(code)
  end
  
end
