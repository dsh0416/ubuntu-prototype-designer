import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

ApplicationWindow {
    visible: true
    width: 1280
    height: 800
    minimumWidth: 640
    minimumHeight: 480
    title: "Ubuntu Prototype Designer"

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10

            Text {
                text: "<html>\n<body>"
                textFormat: Text.PlainText
                id: "templateHeaderText"
            }

            TextArea {
                anchors.top: templateHeaderText.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right

                id: editArea
                text:"Hello World"
            }

        }

    }
}
