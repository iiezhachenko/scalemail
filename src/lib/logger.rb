module Logger
  def build_invalid_config_error(reason)
    "Invalid Docker Machine config: #{reason}."
  end

  def build_wrong_config_format_error(reason)
    "Wrong Docker Machine config format: #{reason}."
  end

  def formatted_log_to_stdout(prefix, string, timestamp=true)
    time = Time.new
    time_string = time.strftime("%H:%M:%S")
    puts "#{time_string if timestamp} #{prefix} #{string}"
  end

  def formatted_log_to_stderr(prefix, string, timestamp=true)
    time = Time.new
    time_string = time.strftime("%H:%M:%S")
    STDERR.puts "#{time_string if timestamp} #{prefix} #{string}"
  end
end
