
## PrettyTable, based on https://stackoverflow.com/questions/28684598/print-an-array-into-a-table-in-ruby
## With smalll aditions and improvements
class PrettyTable

  @labels
  @data

  def initialize(labels)
    @labels = labels
    @data = Array.new
  end

  def add_line line
   @data.push line
  end

  def print
   columns = @labels.each_with_object({}) { |(col,label),h|
     h[col] = { label: label,
                width: [@data.map { |g| g[col].size }.max, label.size].max }
   }

   write_divider columns
   write_header columns
   write_divider columns
   @data.each { |h| write_line(h,columns) }
   write_divider columns
  end

  def write_header columns
   puts "| #{ columns.map { |_,g| g[:label].ljust(g[:width]) }.join(' | ') } |"
  end
  
  def write_divider columns
   puts "+-#{ columns.map { |_,g| "-"*g[:width] }.join("-+-") }-+"
  end
  
  def write_line(h, columns) 
   str = h.keys.map { |k| 
     
     if columns[k] != nil 
       h[k].ljust(columns[k][:width]) 
     else
       nil
     end 
   }.join(" | ")
   puts "| #{str} |"
  end

end