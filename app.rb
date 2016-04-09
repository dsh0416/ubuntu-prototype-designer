require 'qml'

QML.run do |app|
  app.load_path Pathname(__FILE__) + '../qml/app.qml'
end