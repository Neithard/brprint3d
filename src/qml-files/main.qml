/*=====================================================================

 BRPrint3D, Open Source 3D Printing Host

 Copyright (C) 2016 BRPrint3D Authors

 This file is part of the BRPrint3D project

 BRPrint3D is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 BRPrint3D is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with BRPrint3D. If not, see <http://www.gnu.org/licenses/>.

 ======================================================================*/

import QtQuick 2.6
import QtQuick.Window 2.1
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

ApplicationWindow{
    id: mainWindow
    visible: true
    color: "#31363b"
    title: "Br-Print3D"
    //Define Minimum and Maximum width/height for the app window
    minimumWidth: 800
    minimumHeight: 600
    maximumWidth: 1920
    maximumHeight: 1080

    //Define default width/height
    width: Screen.width
    height: Screen.height

    property color textColor: "#eff0f1"


    menuBar: MenuBar{
        Menu{
            title: qsTr("File")
            MenuItem {
                text: qsTr("Open Gcode")
                action: fileOpenAction
            }
            MenuItem {text: qsTr("Close")}
        }

        Menu{
            title: qsTr("Language")
            MenuItem {text: qsTr("English")}
            MenuItem {text: qsTr("Portuguese")}
        }

        Menu{
            title: qsTr("About")
            MenuItem {text: qsTr("Br-Print3D")}
            MenuItem {text: qsTr("KDE")}
            MenuItem {text: qsTr("How to Contribute")}
        }

        Menu{
            title: qsTr("Help")
            MenuItem {text: qsTr("Documentation")}
        }
    }
    toolBar: ToolBar{
        RowLayout{
            spacing: 5
            anchors.fill: parent

            ToolButton{ action: fileOpenAction }

            ToolButton{ action: connectAction  }

            Item { Layout.fillWidth: true }

            ToolButton{
                action: startAction
                Layout.alignment: Qt.AlignRight
            }

            ToolButton{
                action: pauseAction
                Layout.alignment: Qt.AlignRight
            }

            ToolButton{
                action: stopAction
                Layout.alignment: Qt.AlignRight
            }

            ToolButton{
                action: emergencyAction
                Layout.alignment: Qt.AlignRight
            }
        }
    }

    //-------------Settings Bar-------------------------------------------------------
    Rectangle{
        id: backgroundRec
        width: parent.width /9.5
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        color: "#232629"

        Column{
            spacing: 5
            anchors.fill: parent

            Rectangle{
                color:"#3daee9"
                width: parent.width
                height: 30
                Text {
                    id: title
                    text: qsTr("Br-Print3D")
                    color: textColor
                }
            }

            SettingsButton{
                id: connectionSettings
                text: qsTr("Connection Settings")
                clickControl: connectionSettingsTab.visible ? true : false
                onClicked: {
                    connectionSettingsTab.visible = !connectionSettingsTab.visible
                    bedSettingsTab.visible = false
                    extruderSettingsTab.visible = false
                    gcodeEditorTab.visible = false
                    filamentSettingstab.visible = false
                }
            }

            SettingsButton{
                id: gcodeEditor
                text: qsTr("GCode Settings")
                clickControl: gcodeEditorTab.visible ? true : false
                onClicked: {
                    gcodeEditorTab.visible = !gcodeEditorTab.visible
                    connectionSettingsTab.visible = false
                    bedSettingsTab.visible = false
                    extruderSettingsTab.visible = false
                    filamentSettingstab.visible = false
                }
            }

            SettingsButton{
                id: bedSettings
                text: qsTr("Bed Settings")
                clickControl:bedSettingsTab.visible ? true : false
                onClicked: {
                    bedSettingsTab.visible = !bedSettingsTab.visible
                    connectionSettingsTab.visible = false
                    extruderSettingsTab.visible = false
                    gcodeEditorTab.visible = false
                    filamentSettingstab.visible = false
                }
            }

            SettingsButton{
                id: extruderSettings
                text: qsTr("Extruder Settings")
                clickControl:extruderSettingsTab.visible ? true : false
                onClicked: {
                    extruderSettingsTab.visible = !extruderSettingsTab.visible
                    connectionSettingsTab.visible = false
                    bedSettingsTab.visible = false
                    gcodeEditorTab.visible = false
                    filamentSettingstab.visible = false
                }
            }
            SettingsButton{
                id: filamenSettings
                text: qsTr("Filament Settings")
                clickControl: filamentSettingstab.visible ? true : false
                onClicked: {
                    filamentSettingstab.visible = !filamentSettingstab.visible
                    gcodeEditorTab.visible = false
                    connectionSettingsTab.visible = false
                    bedSettingsTab.visible = false
                    extruderSettingsTab.visible = false
                }
            }
        }//End of column
    }

    //---------------------Settings (Show/Hide) ---------------
    Item {
        id: tabs
        anchors.left: backgroundRec.right
        anchors.bottom: backgroundRec.bottom
        anchors.top: backgroundRec.top
        width: visibleChildren.length !== 0 ? mainWindow.width/4 : 0
        clip: true
        ConnectionSettings{
            id: connectionSettingsTab
            anchors.fill: parent
            visible: false
        }
        BedSettings{
            anchors.fill: parent
            id: bedSettingsTab
            visible: false

        }
        ExtruderSettings{
            id: extruderSettingsTab
            anchors.fill: parent
            visible: false

        }
        GCodeEditor{
            anchors.fill: parent
            id: gcodeEditorTab
            visible: false
        }
        FilamentSettings{
            anchors.fill: parent
            id: filamentSettingstab
            visible: false
        }
    }

    //----------------3DView----------------------------------
    Rectangle{
        id: _3dView
        color: "#fcfcfc"
        anchors.left: tabs.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.right: realTime.left

        height: Screen.height

        Text{
            text: qsTr("3D View")
            anchors.centerIn: parent
        }
    }
    //--------------Real Time Widget ------------------------
    RealTimeWidget{
        id: realTime
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.right: parent.right
    }

    //----------Others---------------------------------------

    Action {
        id: fileOpenAction
        text: "Open"
        onTriggered: {
            fileDialog.selectExisting = true
            fileDialog.open()
        }
    }

    Action{
        id: connectAction
        text: qsTr("Connect")
    }

    Action{
        id: startAction
        text: qsTr("Start")
    }

    Action{
        id: pauseAction
        text: qsTr("Pause")
    }

    Action{
        id: stopAction
        text: qsTr("Stop")
    }

    Action{
        id: emergencyAction
        text: qsTr("Emergency Stop")
    }

    FileDialog{
        id: fileDialog
        title: qsTr("Select a Gcode file:")
        folder: shortcuts.home
        nameFilters: [ "GCode Files (*.gcode *.gco)" ]
        onAccepted: {
            gcodeHandler.fileUrl = fileDialog.fileUrl
        }
    }
}

