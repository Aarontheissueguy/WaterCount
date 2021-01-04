import QtQuick 2.7
//import Ubuntu.Components 1.3
import QtQuick.Window 2.0
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import io.thp.pyotherside 1.3
Window {
    id: root
    //objectName: 'mainView'
    //applicationName: 'watercount.aaron'
    //automaticOrientation: true

    width: 1080 //units.gu(45)
    height: 1920//units.gu(75)
    Python {
      id: py
      Component.onCompleted: { // functions that run at the start of the app to overwrite the default Values with user defined ones
          // Print version of plugin and Python interpreter
          console.log('PyOtherSide version: ' + pluginVersion());
          console.log('Python version: ' + pythonVersion());

          addImportPath(Qt.resolvedUrl('../src/'));
          importModule('main', function() {});
          console.log('after importModule');
          py.call('main.makeDirs', [], function(result) {
              console.log("after call of Makedirs")

          })
          py.call('main.progressImage', [], function(result) {
              console.log("after call of progressImage")
              progressImage.source = result
          })
          py.call('main.returnGoal', [], function(result) {
              console.log("after call of returnGoal")
              goal.text = result
          })
          py.call('main.returnUnit', [], function(result) {
              console.log("after call of returnUnit")
              unit.text = result
          })
          py.call('main.progressPercent', [], function(result) {
              console.log("after call of progressPercent")
              progressBar.width = result * rectangleBg.width
          })
        }
    }
    Image{
      id: progressImage //changes depending on the progress (glass1.png,glass2.png,...)
      source: Qt.resolvedUrl('../assets/glass1.png') //overwritten instantly by line 26
      width: root.width / 1.5
      height: progressImage.width
      x: root.width / 2 - progressImage.width / 2
      y: root.height / 8
      MouseArea {
          anchors.fill: parent
          hoverEnabled: false
          onPressed: {
            parent.scale = 0.8
          }
          onReleased: {
            py.call('main.addWater', [unit.text], function(result) {
                console.log("after call of addWater")
            })
            py.call('main.progressImage', [], function(result) {
                console.log("after call of progressImage")
                progressImage.source = result
            })
            py.call('main.progressPercent', [], function(result) {
                console.log("after call of progressPercent")
                progressBar.width = result * rectangleBg.width
            })
            parent.scale = 1

          }
      }

    }
    //The following part is pretty messy and should be updated in the future. There shouldnt be binding loops though.
    Rectangle{
      id: goalRectangle
      anchors.left: progressImage.left
      anchors.top: progressImage.bottom
      anchors.topMargin: progressImage.height / 15
      anchors.leftMargin: goalText.width
      width: goal.width + 10
      height: goal.height + 10
      color: "grey" //#455a64
      TextInput{ //input field to define the goal amount
        id: goal
        anchors.centerIn: parent
        text: "2000"
        font.pixelSize: progressImage.width / 15
        Text{
          id: goalText
          anchors.verticalCenter: parent.verticalCenter
          anchors.right: parent.left
          text: "Goal: "
          font.pixelSize: progressImage.width / 15
        }
        Text{
          anchors.verticalCenter: parent.verticalCenter
          anchors.left: parent.right
          text: " ml"
          font.pixelSize: progressImage.width / 15
        }
      }
    }
    Rectangle{
      id: saveGoalRectangle //save button for the goal value
      width: saveGoalText.width + 10
      height: saveGoalText.height + 10
      color: "grey"
      anchors.right: progressImage.right
      anchors.verticalCenter: goalRectangle.verticalCenter
      Text{
        id: saveGoalText
        text: "Save"
        font.pixelSize: goal.font.pixelSize
        anchors.centerIn:  parent
      }
      MouseArea {
          anchors.fill: parent
          onPressed: {
            saveGoalRectangle.scale = 0.8
            saveGoalText.font.pixelSize = saveGoalText.font.pixelSize * 0.8
          }
          onReleased: {
            py.call('main.storeGoal', [goal.text], function(result) {
                console.log("after call of storeGoal")
            })
            py.call('main.progressImage', [], function(result) {
                console.log("after call of progressImage")
                progressImage.source = result
            })
            py.call('main.progressPercent', [], function(result) {
                console.log("after call of progressPercent")
                progressBar.width = result * rectangleBg.width
            })
            saveGoalRectangle.scale = 1
            saveGoalText.font.pixelSize = saveGoalText.font.pixelSize * 1.2

          }
      }
    }
    Rectangle{
      id: unitRectangle
      anchors.left: progressImage.left
      anchors.top: goalRectangle.bottom
      anchors.topMargin: progressImage.height / 15
      anchors.leftMargin: unitText.width
      width: unit.width + 10
      height: unit.height + 10
      color: "grey" //#455a64
      TextInput{ //Inputfield to define the amount of water added per click/touch
        id: unit
        anchors.centerIn: parent
        text: "250"
        font.pixelSize: progressImage.width / 15
        Text{
          id: unitText
          anchors.verticalCenter: parent.verticalCenter
          anchors.right: parent.left
          text: "Unit: "
          font.pixelSize: progressImage.width / 15
        }
        Text{
          anchors.verticalCenter: parent.verticalCenter
          anchors.left: parent.right
          text: " ml"
          font.pixelSize: progressImage.width / 15
        }
      }
    }
    Rectangle{
      id: saveUnitRectangle //save button for the unit value
      width: saveGoalText.width + 10
      height: saveGoalText.height + 10
      color: "grey"
      anchors.right: progressImage.right
      anchors.verticalCenter: unitRectangle.verticalCenter
      Text{
        id: saveUnitText
        text: "Save"
        font.pixelSize: unit.font.pixelSize
        anchors.centerIn:  parent
      }
      MouseArea {
          anchors.fill: parent
          onPressed: {
            saveUnitRectangle.scale = 0.8
            saveUnitText.font.pixelSize = saveUnitText.font.pixelSize * 0.8
          }
          onReleased: {
            py.call('main.storeUnit', [unit.text], function(result) {
                console.log("after call of storeUnit")
            })
            py.call('main.progressImage', [], function(result) {
                console.log("after call of progressImage")
                progressImage.source = result
            })
            saveUnitRectangle.scale = 1
            saveUnitText.font.pixelSize = saveUnitText.font.pixelSize * 1.2

          }
      }
    }
    Rectangle{ //should become the parent of above content bindings will need to be updated though
      anchors.fill: parent //basicly colors the whole background
      z: -2
      color: "#587684"
    }
    Rectangle{ //should become parent of the Inputfields to make things more structured
      id: rectangleBg
      clip: true //clips the progressbar after it reached 100%. Could be replaced with a JavaScript expression.
      anchors.left: progressImage.left
      anchors.right: progressImage.right
      anchors.top: progressImage.bottom
      anchors.bottom: parent.bottom
      anchors.leftMargin: -(progressImage.width / 8)
      anchors.rightMargin: -(progressImage.width / 8)
      anchors.bottomMargin: (progressImage.width / 8)
      z:-1
      color: "#455a64"
      Rectangle{
        clip: true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height / 10
        id: progressBar
        color: "lightblue"
        height: parent.height/ 15
      }
      Text{
        anchors.bottom: progressBar.top
        anchors.bottomMargin: progressBar.height
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Progress:"
        font.pixelSize: progressImage.width / 15
      }
    }
}
