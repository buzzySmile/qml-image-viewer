import QtQuick 2.5
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

ProgressBarStyle
{
   panel : Rectangle {
      color: "transparent"
      implicitWidth: 80
      implicitHeight: implicitWidth

      Rectangle
      {
         id: outerRing
         z: 0
         anchors.fill: parent
         radius: Math.max(width, height) / 2
         color: "transparent"
         border.color: "gray"
         border.width: 8
      }

      Rectangle
      {
         id: innerRing
         z: 1
         anchors.fill: parent
         anchors.margins: (outerRing.border.width - border.width) / 2
         radius: outerRing.radius
         color: "transparent"
         border.color: "darkgray"
         border.width: 4

         ConicalGradient
         {
            source: innerRing
            anchors.fill: parent
            gradient: Gradient
            {
               GradientStop { position: 0.00; color: "white" }
               GradientStop { position: control.value; color: "white" }
               GradientStop { position: control.value + 0.01; color: "transparent" }
               GradientStop { position: 1.00; color: "transparent" }
            }
         }
      }

      Text
      {
         id: progressLabel
         anchors.centerIn: parent
         color: "gray"
         text: (control.value * 100).toFixed() + "%"
      }
   }
}
