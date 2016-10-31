import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQml.Models 2.2
import "content"

ApplicationWindow {
    id: mainWindow

    width: photosGridView.cellWidth*3
    height: photosGridView.cellHeight*3
    visible: true

    Rectangle {
        id: root
        anchors.fill: parent

        property real downloadProgress: 0
        property bool imageLoading: false

        ListModel {
            id: myModel
            ListElement { display: "One"; width0: 280; height0: 180;
                url: "http://static.simpledesktops.com/uploads/desktops/2016/07/07/b3d9be-background.png"}
            ListElement { display: "Two"; width0: 280; height0: 180;
                url: "http://static.simpledesktops.com/uploads/desktops/2016/04/26/Dots.png"}
            ListElement { display: "Three"; width0: 280; height0: 180;
                url: "http://static.simpledesktops.com/uploads/desktops/2016/02/08/sunRising.png" }
            ListElement { display: "Four"; width0: 280; height0: 180;
                url: "http://static.simpledesktops.com/uploads/desktops/2015/11/18/garlic_siracha.png" }
            ListElement { display: "Five"; width0: 280; height0: 180;
                url: "http://static.simpledesktops.com/uploads/desktops/2015/09/23/Take_OFF.png" }
            ListElement { display: "Six"; width0: 280; height0: 180;
                url: "http://static.simpledesktops.com/uploads/desktops/2015/08/20/Sunset_by_Banned.png" }
            ListElement { display: "Seven"; width0: 280; height0: 180;
                url: "http://static.simpledesktops.com/uploads/desktops/2015/07/28/splash7.png" }
            ListElement { display: "Eight"; width0: 280; height0: 180;
                url: "http://static.simpledesktops.com/uploads/desktops/2015/06/26/Overlap.png" }
        }

        DelegateModel {
            id: visualModel
            delegate: Delegate {}
            model: myModel
        }

        GridView {
            id: photosGridView

            x: 0; y: 0; cellWidth: 160; cellHeight: 153
            width: root.width; height: root.height - progressBar.height
            model: visualModel.parts.grid
            interactive: true
            /*Rectangle {
                anchors.centerIn: parent
                width: parent.width-10; height: parent.height-10
                color: "transparent"
                border.color: "red"
                border.width: 5
            }*/
            onCurrentIndexChanged: {
                photosListView.positionViewAtIndex(currentIndex, ListView.Contain)
            }
        }

        ListView {
            id: photosListView;

            width: root.width; height: root.height - progressBar.height
            orientation: Qt.Horizontal
            model: visualModel.parts.list;
            interactive: false

            highlightRangeMode: ListView.StrictlyEnforceRange
            snapMode: ListView.SnapOneItem
            /*Rectangle {
                anchors.centerIn: parent
                width: parent.width-10; height: parent.height-10
                color: "transparent"
                border.color: "green"
                border.width: 5
            }*/
            onCurrentIndexChanged: {
                photosGridView.positionViewAtIndex(currentIndex, GridView.Contain)
            }
        }

        state: 'inGrid'
        states: [
            State {
                name: 'inGrid'
                PropertyChanges { target: photosGridView; interactive: true; visible: true }
                PropertyChanges { target: photosListView; visible: false }
            },
            State {
                name: 'fullscreen'; extend: 'inGrid'
                PropertyChanges { target: photosGridView; interactive: false; visible: false }
                PropertyChanges { target: photosListView;  visible: true }
            }
        ]

        MouseArea {
            anchors.fill: root
            z: root.state == 'inGrid' ? -1 : 0
            onClicked: root.state = 'inGrid'
        }
    }

    Item {
        id: foreground
        anchors.fill: parent
    }

    ProgressBar {
        id: progressBar

        width: parent.width; height: 15
        anchors.bottom: parent.bottom
        opacity: root.imageLoading

        value: root.downloadProgress
    }
}
