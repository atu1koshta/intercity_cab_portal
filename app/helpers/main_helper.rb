module MainHelper
  def datetime_in_utc(datetime_str)
    time_in_ist = Time.strptime(datetime_str, '%Y-%m-%d %H:%M:%S').localtime('+05:30')
    time_in_ist.utc
  rescue ArgumentError
    puts "Invalid datetime format. Please provide datetime in 'YYYY-MM-DD HH:MM:SS' format."
    nil
  end
end
