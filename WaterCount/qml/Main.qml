import QtQuick 2.7
import Ubuntu.Components 1.3
import QtQuick.Window 2.0
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import io.thp.pyotherside 1.3
Window {
    id: root
    //objectName: 'mainView'
    //applicationName: 'watercount.aaron'
    //automaticOrientation: false

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
            glassImage.source = result
            console.log("after call of progressImage")
        })
        py.call('main.returnUnit', [], function(result) {
            unitInput.text = result
            console.log("after call of returnUnit")
        })
        py.call('main.returnGoal', [], function(result) {
            goalInput.text = result
            console.log("after call of returnGoal")
        })
        py.call('main.storeGoal', [goalInput.text], function(result) {
            console.log("after call of storeGoal")
        })
        py.call('main.storeUnit', [unitInput.text], function(result) {
            console.log("after call of storeUnit")
        })
        py.call('main.progressPercent', [], function(result) {
            progressBar.width = progressBar.parent.width * result
            progressText.text = "" + 100 * result + "%"
            console.log("after call of progressPercent")
        })
      }
    }

    Rectangle{
    z: -1
      anchors.fill: parent
      color: "#587684"
      Image{
        id: glassImage
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        source: "../assets/glass1.png"
        height: root.height / 2.5
        width: height
        MouseArea {
            anchors.fill: parent
            onPressed: glassImage.scale = 0.8
            onReleased: {
              py.call('main.addWater', [unitInput.text], function(result) {
                  console.log("after call of addWater")
              })
              py.call('main.progressImage', [], function(result) {
                  glassImage.source = result
                  console.log("after call of progressImage")
              })
              py.call('main.progressPercent', [], function(result) {
                  progressBar.width = progressBar.parent.width * result
                  progressText.text = "" + 100 * result + "%"
                  console.log("after call of progressPercent")
              })
              glassImage.scale = 1.0
            }
        }
      }
      Rectangle{
        anchors.top: glassImage.bottom
        anchors.topMargin: parent.width / 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.width / 20
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 20
        anchors.right: parent.right
        anchors.rightMargin: parent.width / 20
        color: "#455a64"
        radius: 20
        Rectangle{
          id: settingsRectangle
          height: parent.height / 4
          anchors.top: parent.top
          anchors.topMargin: parent.height / 20
          anchors.left: parent.left
          anchors.leftMargin: parent.width / 20
          anchors.right: parent.right
          anchors.rightMargin: parent.width / 20
          color: "#488ead"
          radius: 20
          Item{
            id: settingsLogo
            width: parent.width / 3
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            Image{
              width: height
              height: parent.height / 2
              anchors.centerIn: parent
              source: "../assets/settings.png"
            }
          }
          Item{
            id: valueField
            width: parent.width / 3
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: settingsLogo.right
            Rectangle{
              anchors.horizontalCenter: parent.horizontalCenter
              anchors.top: parent.top
              anchors.topMargin: parent.height / 4
              z: -1
              width: parent.width / 2
              height: goalInput.height
              color: "#b3e5fc"
              radius: 10
              Text{
                anchors.bottom: parent.top
                anchors.left: parent.left
                text: "Goal(ml):"
              }
              TextInput{
                id: goalInput
                anchors.centerIn: parent
                text: "2000"

              }
            }
            Rectangle{
              anchors.horizontalCenter: parent.horizontalCenter
              anchors.bottom: parent.bottom
              anchors.bottomMargin: parent.height / 4
              z: -1
              width: parent.width / 2
              height: unitInput.height
              color: "#b3e5fc"
              radius: 10
              Text{
                anchors.bottom: parent.top
                anchors.left: parent.left
                text: "Unit:(ml)"
              }
              TextInput{
                id: unitInput
                anchors.centerIn: parent
                text: "250"

            }
          }
        }
      }
      Rectangle{
        id: saveButton
        height: parent.height / 8
        anchors.top: settingsRectangle.bottom
        anchors.topMargin: parent.height / 20
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 20
        anchors.right: parent.right
        anchors.rightMargin: parent.width / 20
        color: "#ff7400"
        radius: 20
        Text{
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
          font.bold: true
          scale: 1.5
          text: "save"
        }
        MouseArea {
            anchors.fill: parent
            onPressed: {
              saveButton.scale = 0.8
              py.call('main.storeGoal', [goalInput.text], function(result) {
                  console.log("after call of storeGoal")
              })
            }
            onReleased: {
              py.call('main.storeUnit', [unitInput.text], function(result) {
                  console.log("after call of storeUnit")
              })
              py.call('main.progressImage', [], function(result) {
                  glassImage.source = result
                  console.log("after call of progressImage")
              })
              py.call('main.progressPercent', [], function(result) {
                  progressBar.width = progressBar.parent.width * result
                  progressText.text = "" + 100 * result + "%"
                  console.log("after call of progressPercent")
              })
              saveButton.scale = 1.0
            }
        }
      }
      Rectangle{
        height: parent.height / 7
        anchors.top: saveButton.bottom
        anchors.topMargin: parent.height / 20
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 20
        anchors.right: parent.right
        anchors.rightMargin: parent.width / 20
        color: "#488ead"
        radius: 20
        Item{
          id: statsLogo
          width: parent.width / 3
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          anchors.left: parent.left
          Image{
            width: height
            height: settingsLogo.height / 2
            anchors.centerIn: parent
            source: "../assets/stats.png"
          }
        }
        Item{
          id: flagLogo
          width: parent.width / 3
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          anchors.right: parent.right
          Image{
            width: height
            height: settingsLogo.height / 2
            anchors.centerIn: parent
            source: "../assets/flag.png"
          }
        }
        Item{
          anchors.left: statsLogo.right
          anchors.right: flagLogo.left
          height: parent.height
          Text{
            id: progressText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height / 20
          }
          Rectangle{
            id: progressBar
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height / 3
            color: "#ff7400"
            radius: 30
          }
        }
      }
    }
  }
}
