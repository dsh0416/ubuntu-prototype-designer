import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtWebKit 3.0

ApplicationWindow {
    id: applicationWindow1
    visible: true
    width: 1280
    height: 800
    minimumWidth: 640
    minimumHeight: 480
    title: "Ubuntu Prototype Designer"

    Rectangle {
        id: rectangle1
        anchors.right: parent.right
        anchors.rightMargin: 480
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        antialiasing: false
        anchors.left: parent.left
        anchors.leftMargin: 0

        TextArea {
            anchors.top: parent.top

            id: editArea
            width: 0
            text:"Hello World"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 44
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.topMargin: 0
        }

        Button {
            id: button1
            y: 765
            text: qsTr("Button")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: 8
        }
    }

    Rectangle
    {
        x: 0
        width: 480
        height: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        WebView
        {
            anchors.fill: parent
            url: "http://www.baidu.com/"

        }
    }

}
