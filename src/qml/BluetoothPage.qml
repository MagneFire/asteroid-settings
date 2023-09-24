/*
 * Copyright (C) 2016 - Sylvia van Os <iamsylvie@openmailbox.org>
 * Copyright (C) 2015 - Florent Revest <revestflo@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.9
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0

import QtQuick.Layouts 1.3

import Connman 0.2
import org.kde.bluezqt 1.0 as BluezQt

Item {
    BluetoothStatus { id: btStatus }
    property QtObject _bluetoothManager: BluezQt.Manager
    property QtObject _adapter: _bluetoothManager.usableAdapter
    property QtObject adapter: _bluetoothManager.usableAdapter

    onAdapterChanged: {
        console.log("ADPATER CHANGE" + adapter)
        if (bluetoothModel.powered && adapter) {
            console.log("bluetoothModel:startDiscovery:onPoweredChanged " + _adapter.powered)
            console.log("bluetoothModel::startDiscovery")
            _adapter.startDiscovery()
        }
    }

    TechnologyModel {
        id: bluetoothModel
        name: "bluetooth"
    }

    BluezQt.DevicesModel {
        id: bluetoothDevicesModel
        filters: BluezQt.DevicesModelPrivate.AllDevices
    }

    Instantiator {
        id: btModelAccessor
        model: bluetoothDevicesModel
        delegate: QtObject { property string address: Address }
    }

    PageHeader {
        id: title
        text: qsTrId("id-bluetooth-page")
    }

    ListView {
        //id: romBrowser
        // Add one to be used as the enable/disable header.
        model: btModelAccessor.count+1
        //model: bluetoothDevicesModel
        visible: bluetoothModel.powered
        anchors.fill: parent
        anchors.leftMargin: Dims.l(15)
        anchors.rightMargin: Dims.l(15)
        //height: Dims.h(34)
        //header: Rectangle {color: "#00FF00"; width: parent.width; height: Dims.h(10)}
        //footer: Rectangle {color: "#FF0000"; width: parent.width; height: Dims.h(10)}
        header: Item {height: Dims.h(15)}
        footer: Item {height: Dims.h(15)}

        //preferredHighlightBegin: romBrowser.height/2 - Dims.h(20)/2
        //preferredHighlightEnd: romBrowser.height/2 + Dims.h(20)/2
        //preferredHighlightBegin: romBrowser.height/2 - currentItem.height/2
        //preferredHighlightEnd: romBrowser.height/2 + currentItem.height/2
        //preferredHighlightBegin: Dims.h(50) - Dims.h(30)// - currentItem.height/2
        //preferredHighlightEnd: Dims.h(50) + Dims.h(10)//romBrowser.height + currentItem.height/2
        //preferredHighlightBegin: Dims.h(20)
        //preferredHighlightEnd: Dims.h(10)
        //bi/*ighlightRangeMode: ListView.StrictlyEnforceRange
        
        delegate: Item {
            property var address: {
                var object = btModelAccessor.objectAt(index-1)
                if (object !== null) {
                    object.address
                } else {
                    null
                }
            }
            property var device: _bluetoothManager.deviceForAddress(address)
            id: item
            //label: model.FriendlyName
            //description: model.Address
            width: parent.width
            height: Dims.h(16)
            //color: index %2 ?"#eee" : "#111"
            //height: Theme.itemHeightLarge
            //showNext: false
            //icon: formatIcon(model.Type)
            onDeviceChanged: {
                console.log(device ? device.friendlyName : "null")
            }

            Item {
                anchors.fill: parent
                visible: !address
                Label {
                    //% "Bluetooth on"
                    property string bluetoothOnStr: qsTrId("id-bluetooth-on")
                    //% "Bluetooth off"
                    property string bluetoothOffStr: qsTrId("id-bluetooth-off")
                    id: time
                    text: btStatus.powered ? bluetoothOnStr : bluetoothOffStr
                    textFormat: Text.RichText
                    //opacity: enableSwitch.checked ? 1.0 : 0.7
                    //font.pixelSize: Dims.l(15)
                    //font.weight: Font.Medium
                    //anchors.top: enableSwitch.top
                    anchors.left: parent.left
                    //anchors.leftMargin: Dims.w(10)
                    height: contentHeight
                    //width: Dims.w(50)

                    /*MouseArea {
                        anchors.fill: parent
                        onClicked: timeEditClicked(alarm)
                    }*/
                }

                Label {
                    //% "Connected"
                    property string connectedStr: qsTrId("id-connected")
                    //% "Not connected"
                    property string notConnectedStr: qsTrId("id-disconnected")
                    id: enabledDays
                    textFormat: Text.RichText
                    text: btStatus.connected ? connectedStr : notConnectedStr
                    //opacity: enableSwitch.checked ? 0.8 : 0.5
                    opacity: 0.8
                    font.pixelSize: Dims.l(5)
                    font.weight: Font.Thin
                    anchors.top: time.bottom
                    //anchors.bottom: enableSwitch.bottom
                    anchors.left: parent.left
                    //anchors.leftMargin: Dims.w(10)
                    height: contentHeight
                    //width: Dims.w(50)

                    /*MouseArea {
                        anchors.fill: parent
                        onClicked: daysEditClicked(alarm)
                    }*/
                }
                Switch {
                    //Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                    width: Dims.l(20)
                    checked: btStatus.powered
                    onCheckedChanged: {
                        if (device == null) {
                            if (btStatus.powered != checked) {
                                btStatus.powered = checked
                                console.log("HENK " + checked)
                            }
                        }
                    }
                    anchors.right: parent.right
                }
                /*StatusPage {
                visible: !address
                    //% "Bluetooth on"
                    property string bluetoothOnStr: qsTrId("id-bluetooth-on")
                    //% "Bluetooth off"
                    property string bluetoothOffStr: qsTrId("id-bluetooth-off")
                    //% "Connected"
                    property string connectedStr: qsTrId("id-connected")
                    //% "Not connected"
                    property string notConnectedStr: qsTrId("id-disconnected")
                    text: "<h3>" + (bluetoothModel.powered ? bluetoothOnStr : bluetoothOffStr) + "</h3>\n" + (bluetoothModel.connected ? connectedStr : notConnectedStr)
                    icon: bluetoothModel.powered ? "ios-bluetooth-outline" : "ios-bluetooth-off-outline"
                    clickable: true
                    onClicked: bluetoothModel.powered = !bluetoothModel.powered
                    activeBackground: bluetoothModel.powered
                }*/
            }


            Item {
                visible: address
                anchors.fill: parent

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: {
                        console.log("CLICKED!")
                        if (device) {
                            if (device.paired) {
                                console.log("PAIRED")
                                //"Paired"
                            } else {
                                console.log("PAIR NOW")
                            }
                            device.trusted = true
                            device.connectToDevice()
                        } else {
                            console.log("NULL!")
                        }
                    }
                }
                Label {
                    id: btName
                    text: device ? device.friendlyName : "null"
                }
                Label {
                    id: btState
                    opacity: 0.8
                    font.pixelSize: Dims.l(5)
                    font.weight: Font.Thin
                    text: {
                        if (device) {
                            if (device.connected) {
                                "Connected"
                            } else if (device.paired) {
                                "Paired"
                            } else {
                                "Not set up"
                            }
                        } else {
                            "null"
                        }
                    }
                    anchors.top: btName.bottom
                }
            }
        }
    }
}

