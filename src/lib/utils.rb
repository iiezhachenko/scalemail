require_relative './logger'

module Utils
  include Logger

  def run_os_command(host_name, command, stream_stdout=true, stream_stderr=true)
    process_hash = {}
    process = Open4::popen4('sh') do |pid, stdin, stdout, stderr|
      stdin.puts command
      stdin.close
      if stream_stdout
        stdout.each do |line|
          formatted_log_to_stdout("OUT [#{host_name}]", line)
          process_hash[:stdout] ||= ''
          process_hash[:stdout] += line
        end
      end
      if stream_stderr
        stderr.each do |line|
          formatted_log_to_stderr("ERROR [#{host_name}]", line)
          process_hash[:stderr] ||= ''
          process_hash[:stderr] += line
        end
      end
      process_hash[:pid] = pid
    end
    process_hash[:process] = process
    process_hash
  end
end
