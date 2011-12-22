#example of usage
# <%= popup_calendar :inputField => 'start_date',
#      :ifFormat => '%m/%e/%Y',
#      :button => 'start_date_trigger',
#      :singleClick => true %>

module CalendarHelper

  def calendarSupport?
    return true
  end

  def popup_calendar(options)
<<END
<script type="text/javascript">
Calendar.setup({
#{format_js_hash(options)} 
});
</script>
END
  end

  private
  def format_js_hash(options)
    options.collect { |key,value| key.to_s + ' : ' + value.inspect}.join(",\n")
  end

end
