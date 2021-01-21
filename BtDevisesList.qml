/*
 * Copyright (C) 2020 Chupligin Sergey <neochapay@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this library; see the file COPYING.LIB.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */
import QtQuick 2.6

//import QtQuick.Controls 1.0
//import QtQuick.Controls.Nemo 1.0
//import QtQuick.Controls.Styles.Nemo 1.0
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0
import org.asteroid.settings 1.0

ListView {
    id: btDeviceList


    anchors.fill: parent
                height: Dims.h(34)
    //width: parent.width
//    height: childrenRect.height

//    clip: true

    delegate: Item {
        id: item
        //label: model.FriendlyName
        //description: model.Address
        width: parent.width
        height: Dims.h(20)
        //height: Theme.itemHeightLarge
        //showNext: false
        //icon: formatIcon(model.Type)
        Label {
            text: model.FriendlyName
        }
        IconButton {
            width: Dims.w(20)
            height: width
            iconName: "ios-add-circle-outline"
            edge: undefinedEdge
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: Dims.h(10)
            onClicked: {
                var device = _bluetoothManager.deviceForAddress(model.Address)
                if(!device) {
                    return
                }
                if(device.paired) {
                    //disconect
                    //console.log("UNPAIR!!!")
                    //btInterface.call("unPair", [Address])
                    //device.cancelPairing()
                    console.log("CONNECT!!!")
                    //btInterface.call("unPair", [Address])
                    device.connectToDevice()
                } else {
                    //connect
                    console.log("PAIR!!!")
                    device.pair()
                    //btInterface.call("pair", [Address])
                }
            }
        }

        /*onClicked: {
            if(model.paired) {
                btInterface.call("connectDevice", [Address])
            }
        }*/

        /*actions:[
            Button {
                iconSource: model.paired ? "image://theme/chain-broken" : "image://theme/link"
                onClicked: {
                    var device = _bluetoothManager.deviceForAddress(model.Address)
                    if(!device) {
                        return
                    }

                    if(model.paired) {
                        //disconect
                        console.log("UNPAIR!!!")
                        //btInterface.call("unPair", [Address])
                        device.cancelPairing()
                    } else {
                        //connect
                        console.log("PAIR!!!")
                        device.pair()
                        //btInterface.call("pair", [Address])
                    }
                }
            }
        ]*/
    }
}
