import QtQuick 2.9
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.Controls 2.2
import Lomiri.Components 1.3
import io.thp.pyotherside 1.3
MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'watercount.aaron'
    //automaticOrientation: false
    backgroundColor: "#587684"
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
    PageStack{
      id: pageStack
      Component.onCompleted: push(page0)
      Page{
        id: page0
        visible: false
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
                  Haptics.play()
                  glassImage.scale = 1.0
                }
            }
          }

          Image{
            width: parent.height / 20
            height: width
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: width / 3
            anchors.rightMargin: width / 3
            source: "../assets/help.png"
            MouseArea {
              anchors.fill: parent
              onPressed: parent.scale = 0.8
              onReleased: {
                parent.scale = 1
                pageStack.push(page1)
                progression: true


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
                    text: i18n.tr("Goal(ml):")
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
                    text: i18n.tr("Unit(ml):")
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
              text: i18n.tr("save")
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
              Rectangle{
                anchors.centerIn: parent
                width: parent.width * 0.75
                height: parent.height * 0.75
                color: "#ff7400"
                radius: 20
                Image{
                  anchors.centerIn: parent
                  width: height
                  height: parent.height * 0.75
                  source: "../assets/undo.png"
                }
                MouseArea {
                    anchors.fill: parent
                    onPressed: parent.scale = 0.8
                    onReleased: {
                      py.call('main.undoRedo', ["undo"], function(result) {
                          console.log("after call of undoRedo")
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
                      parent.scale = 1
                    }
                }
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
      Page{
        id: page1
        visible: false
        Rectangle{
          anchors.fill: parent
          color: "#587684"
          Image{
            id: aboutLogo
            source: "../assets/logo.png"
            width: parent.height/ 5
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: aboutRectangle.bottom
            anchors.topMargin: aboutRectangle.height / 2
            MouseArea {
                anchors.fill: parent
                onPressed: parent.scale = 0.8
                onReleased: {
                  pageStack.push(page0)
                  progression: true
                  parent.sale = 1

                }
            }
          }
          Rectangle{
            id: aboutRectangle
            width: parent.width
            height: aboutLabel.height * 2
            color: "#455a64"
            Label{
              id: aboutLabel
              anchors.top: parent.top
              anchors.topMargin: units.gu(2)
              anchors.left: parent.left
              anchors.leftMargin: units.gu(2)
              text: i18n.tr("About:")
              color: "black"
              textSize: Label.XLarge
              font.bold: true
            }
          }
          Rectangle{
            color: "#455a64"
            width: parent.width
            anchors.bottom: parent.bottom
            anchors.top: aboutLogo.bottom
            anchors.topMargin: aboutLogo.height / 3
            Text{
              id: firstAbout
              anchors.top: parent.top
              anchors.left: parent.left
              anchors.topMargin: parent.height / 20
              anchors.leftMargin: parent.width / 20
              text:i18n.tr("Developed by: AaronTheIssueGuy")
            }
            Text{
              id: secondAbout
              anchors.top: firstAbout.top
              anchors.left: parent.left
              anchors.topMargin: parent.height / 20
              anchors.leftMargin: parent.width / 20
              onLinkActivated: Qt.openUrlExternally(link)
              text: i18n.tr("Source code(GitHub): Aarontheissueguy/WaterCount")
            }
            Text{
              id: thirdAbout
              anchors.top: secondAbout.top
              anchors.left: parent.left
              anchors.topMargin: parent.height / 20
              anchors.leftMargin: parent.width / 20
              text:i18n.tr("Version: 1.1.1")
            }
            Text{
              anchors.top: thirdAbout.top
              anchors.left: parent.left
              anchors.topMargin: parent.height / 20
              anchors.leftMargin: parent.width / 20
              text: i18n.tr("Water is important for the body \n(that should not be new to \nyou). If you are like me you tend to drink very little of it.\nFor this reason I created WaterCount. Like this I can\nmake sure my tiny brain gets enough liquid. You can\nset a custom goal and the size of your\nwater bottles (unit). Make sure to report bugs \nand request features on GitHub. For the \nnear future I plan to add a few more stats. \nDon't worry your \npast data will be included once that happens.")
            }
          }
        }
      }
  }
}
