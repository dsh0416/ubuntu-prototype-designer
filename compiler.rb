require 'nokogiri'
require 'nokogiri-styles'
require 'json'

class QMLCompiler
  def initialize
    @ast = Hash.new
    @ast[:children] = Array.new

    @src = Array.new
    @txt = Array.new
    @btn = Array.new
  end

  def node_search(parent, set)
    set.each do |child|
      node = Hash.new
      node[:name] = child.name
      if child.styles['width'].nil?
        node[:width] = 'parent.width * 0.6'
      else
        node[:width] = child.styles['width'].gsub(/px/, '')
      end
      node[:height] = child.styles['height'].gsub(/px/, '') unless child.styles['height'].nil?
      node[:id] = child['id'] unless child['id'].nil?

      # Parse label p
      next if node[:name] == 'text'

      if node[:name] == 'p'
        node[:name] = 'Label'
        node[:text] = "\"" + child.children[0].content  + "\""
        unless /\{\{(.*?)\}\}/.match(child.children[0].content).nil?
          @txt << /\{\{(.*?)\}\}/.match(child.children[0].content)[1]
          node[:text] = "myType.#{/\{\{(.*?)\}\}/.match(child.children[0].content)[1]}"
        end
        parent[:children] << node
        next
      end

      # Parse label img
      if node[:name] == 'img'
        node[:name] = 'Image'
        node[:source] = "\"" + child['src'] + "\""

        unless /\{\{(.*?)\}\}/.match(child['src']).nil?
          @src << /\{\{(.*?)\}\}/.match(child['src'])[1]
          node[:source] = "myType.#{/\{\{(.*?)\}\}/.match(child['src'])[1]}"
        end

        parent[:children] << node
        next
      end

      # Parse label input
      if node[:name] == 'input'
        if child['type'] == 'button'
          node[:name] = 'Button'
          unless child['id'].nil?
            @btn << "#{child['id']}Clicked"
            node[:onClicked] = "myType.#{child['id']}Clicked()"
          end
        else
          node[:name] = 'TextField'
        end
        node[:text] = "\"" + child['value'] + "\"" unless child['value'].nil?
        unless /\{\{(.*?)\}\}/.match(child['value']).nil?
          @txt << /\{\{(.*?)\}\}/.match(child['value'])[1]
          node[:text] = "myType.#{/\{\{(.*?)\}\}/.match(child['value'])[1]}"
        end
        parent[:children] << node
        next
      end


      node[:children] = Array.new
      parent[:children] << node
      node_search(node, child.children)
    end
  end

  def parse(str)
    html_doc = Nokogiri::HTML(str).xpath('//body')
    node_search(@ast, html_doc)
  end

  def generate_qml
    template = 'import QtQuick 2.4
import Ubuntu.Components 1.3
import Untitled 1.0
MainView {
    objectName: "mainView"
    applicationName: ""
    width: units.gu(100)
    height: units.gu(75)

    Page {
        title: "Test"

        Column {
            spacing: units.gu(1)
            anchors {
                margins: units.gu(2)
                fill: parent
            }

result

            MyType {
                id: myType
            }

        }
    }
}'
    result = ''
    @ast[:children][0][:children].each do |node|
      result +="            #{node[:name]} {\n"
      node.each_key do |key|
        result += "                #{key}: #{node[key]}\n" unless key == 'name'.to_sym
      end
      result += "            }\n"
    end
    template.gsub(/result/, result)
  end

  def generate_cpp
    template = '#ifndef MYTYPE_H
#define MYTYPE_H

#include <QObject>

class MyType : public QObject
{
    Q_OBJECT
properties

public:
invoke
    explicit MyType(QObject *parent = 0);
    ~MyType();

Q_SIGNALS:
signals

protected:
protects
};

#endif // MYTYPE_H
'


    property = ''
    signal = ''
    protect = ''

    invoke = ''

    @src.concat(@txt).each do |p|
      property += "Q_PROPERTY( QString #{p} READ #{p} WRITE set#{p} NOTIFY #{p}Changed )\n"
      signal += "void #{p}Changed();\n"
      protect += "QString #{p}() { return m_#{p}; }
    void set#{p}(QString msg) { m_#{p} = msg; Q_EMIT #{p}Changed(); }

    QString m_#{p};\n"
    end

    @btn.each do |b|
      invoke += "Q_INVOKABLE void #{b}();\n"
    end

    template.gsub(/properties/, property).gsub(/signals/, signal).gsub(/protects/, protect).gsub(/invoke/, invoke)
  end

end