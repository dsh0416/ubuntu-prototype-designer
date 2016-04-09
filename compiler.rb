require 'nokogiri'
require 'json'

class QMLCompiler
  def initialize
    @ast = Hash.new
    @ast[:children] = Array.new
  end

  def node_search(parent, set)
    set.each do |child|
      node = Hash.new
      node[:name] = child.name
      node[:content] = child.content if node[:name] == 'text'

      node[:children] = Array.new
      parent[:children] << node
      node_search(node, child.children)
    end
  end

  def parse(str)
    html_doc = Nokogiri::HTML(str).xpath('//body')
    node_search(@ast, html_doc)
  end

  def generate
    JSON.generate @ast
  end
end

q = QMLCompiler.new
q.parse <<-HTML
<html>
  <body>
    <div><div><div></div></div></div>
    <div></div>
  </body>
</html>
HTML

puts q.generate
