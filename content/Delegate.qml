import QtQuick 2.5
import QtQuick.Controls 1.4
import "scripts/script.js" as Script
import "styles" as Style

Package {

    Item { Package.name: 'grid'
        id: gridDelegate
        width: root.width; height: root.height
    }
    Item { Package.name: 'list'
        id: fullDelegate      
        width: root.width; height: root.height
    }

// ===================================================

    Item {
        width: 160; height: 153

        Item {
            id: photoWrapper

            x: 0; y: 0
            width: 140; height: 133

            BorderImage {
                anchors.fill: placeHolder
                anchors {
                    leftMargin: -6
                    topMargin: -6
                    rightMargin: -8
                    bottomMargin: -8
                }
                source: '../images/box-shadow.png'
                border {
                    top: 10
                    left: 10
                    right: 10
                    bottom: 10
                }
            }
            Rectangle {
                id: placeHolder

                property int w: width0
                property int h: height0
                property double s: Script.calculateScale(w, h, photoWrapper.width)

                color: 'white'
                anchors.centerIn: parent
                antialiasing: true
                width:  w * s; height: h * s; z: -1
                visible: originalImage.status != Image.Ready
                Rectangle {
                    color: "#878787"
                    antialiasing: true
                    anchors {
                        fill: parent
                        topMargin: 3
                        bottomMargin: 3
                        leftMargin: 3
                        rightMargin: 3
                    }
                }
            }

            BusyIndicator {
                anchors.centerIn: parent
                running: originalImage.status != Image.Ready
            }
            Image {
                id: originalImage

                anchors.fill: photoWrapper
                antialiasing: true
                source: url
                cache: false
                fillMode: Image.PreserveAspectFit
            }
            ProgressBar {
                anchors.centerIn: parent
                visible: hqImage.status == Image.Loading
                value: hqImage.progress
                style: Style.RoundProgressBarStyle {}
            }
            Image {
                id: hqImage

                anchors.fill: photoWrapper
                antialiasing: true
                source: ""
                visible: false
                cache: false
                fillMode: Image.PreserveAspectFit

                onSourceChanged: {
                    console.log("hqImage source:", source)
                }
            }

            Binding {
                target: root
                property: "downloadProgress"
                value: hqImage.progress
                when: fullDelegate.ListView.isCurrentItem
            }
            Binding {
                target: root
                property: "imageLoading"
                value: (hqImage.status == Image.Loading) ? 1 : 0;
                when: fullDelegate.ListView.isCurrentItem
            }
            MouseArea {
                anchors.fill: photoWrapper
                onClicked: {
                    gridDelegate.GridView.view.currentIndex = index;
                    if (root.state == 'inGrid') {
                        root.state = 'fullscreen'
                    } else {
                        root.state = 'inGrid'
                    }
                }
            }

            states: [
                State {
                    name: 'inGrid'; when: root.state == 'inGrid' || root.state == ''
                    ParentChange {
                        target: photoWrapper
                        parent: gridDelegate;
                        x: 10; y: 0
                    }
                },
                State {
                    name: 'fullscreen'; when: root.state == 'fullscreen'
                    ParentChange {
                        target: photoWrapper
                        parent: fullDelegate
                        x: 0; y: 0;
                        width: root.width; height: root.height
                    }
                    PropertyChanges {
                        target: hqImage
                        source: gridDelegate.GridView.isCurrentItem
                                ? url
                                : ""
                        visible: true
                    }
                }
            ]

            onStateChanged: {
                if(state == 'fullscreen' && gridDelegate.GridView.isCurrentItem)
                    console.log("State changed to 'fullscreen' for '"+display+"' record")
            }

            transitions: [
                Transition {
                    from: 'inGrid'; to: 'fullscreen'
                    SequentialAnimation {
                        PauseAnimation {
                            duration: gridDelegate.GridView.isCurrentItem ? 0 : 600
                        }
                        ParentAnimation {
                            target: photoWrapper; via: foreground
                            NumberAnimation {
                                targets: photoWrapper
                                properties: 'x,y,width,height,opacity'
                                duration: gridDelegate.GridView.isCurrentItem ? 600 : 1
                                easing.type: Easing.OutQuart
                            }
                        }
                    }
                },
                Transition {
                    from: 'fullscreen'; to: 'inGrid'
                    ParentAnimation {
                        target: photoWrapper; via: foreground
                        NumberAnimation {
                            targets: photoWrapper
                            properties: 'x,y,width,height,opacity'
                            duration: gridDelegate.GridView.isCurrentItem ? 600 : 1
                            easing.type: Easing.OutQuart
                        }
                    }
                }
            ]
        }
    }
}
