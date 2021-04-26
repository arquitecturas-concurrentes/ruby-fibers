require 'colorize'

class Reporter
  def self.format_report(msg, type, color, timestamp)
    String.disable_colorization = false
    if timestamp
      puts "[#{Time.now.iso8601} - #{type}] #{msg}".colorize(color: color, background: :black)
    else
      puts "[#{type}] #{msg}".colorize(color: color, background: :black)
    end
  end

  def self.report_error(msg, timestamp=true)
    format_report msg, 'Error', :red, timestamp
  end

  def self.report_info(msg, timestamp=true)
    format_report msg, 'Info', :cyan, timestamp
  end

  def self.report_system(msg, timestamp=true)
    format_report msg, 'System', :green, timestamp
  end

  def self.report_warning(msg, timestamp=true)
    format_report msg, 'Warning', :yellow, timestamp
  end
end