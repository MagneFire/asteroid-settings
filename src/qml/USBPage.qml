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
import Nemo.DBus 2.0
import org.asteroid.controls 1.0
// import org.asteroid.settings 1.0

Item {
    id: root
    property var pop

    PageHeader {
        id: title
        text: qsTrId("id-usb-page")
    }

    ListModel {
        id: usbModesModel
        //% "Charging only"
        ListElement { text: qsTrId("id-charging-only"); icon: "ios-battery-charging"; mode: "charging_only" }
        //% "ADB Mode"
        ListElement { text: qsTrId("id-adb-mode"); icon: "ios-bug-outline"; mode: "adb_mode" }
        //% "SSH Mode"
        ListElement { text: qsTrId("id-ssh-mode"); icon: "ios-git-network"; mode: "developer_mode" }
        //% "MTP Mode"
        ListElement { text: qsTrId("id-mtp-mode"); icon: "ios-folder-outline"; mode: "mtp_mode" }
    }

    ListView {
        id: usbModeLV
        anchors.fill: parent
        model: usbModesModel
        delegate: ListItem {
            title: text
            iconName: icon
            highlight: usbModeLV.currentIndex == index ? 0.2 : 0
            onClicked: usbModeLV.currentIndex = index
        }

        preferredHighlightBegin: height / 2 - Dims.h(21)
        preferredHighlightEnd: height / 2 + Dims.h(21)
        highlightRangeMode: ListView.StrictlyEnforceRange
    }

    IconButton {
        iconName: "ios-checkmark-circle-outline"
        anchors { 
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: Dims.iconButtonMargin
        }

        onClicked: {
            usbmodedDbus.call("set_mode", [usbModesModel.get(usbModeLV.currentIndex).mode])
            usbmodedDbus.call("set_config", [usbModesModel.get(usbModeLV.currentIndex).mode])

            root.pop();
        }
    }

    Component.onCompleted: {
        usbmodedDbus.typedCall('get_config', [], function (mode) {
            if     (mode === "mtp_mode")       usbModeLV.positionViewAtIndex(3, ListView.SnapPosition)
            else if(mode === "developer_mode") usbModeLV.positionViewAtIndex(2, ListView.SnapPosition)
            else if(mode === "adb_mode")       usbModeLV.positionViewAtIndex(1, ListView.SnapPosition)
            else  /*mode === "charging_only"*/ usbModeLV.positionViewAtIndex(0, ListView.SnapPosition)
        });
    }

    DBusInterface {
        id: usbmodedDbus
        bus: DBus.SystemBus
        service: "com.meego.usb_moded"
        path: "/com/meego/usb_moded"
        iface: "com.meego.usb_moded"
    }
}

