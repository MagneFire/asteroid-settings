/*
 * Copyright (C) 2021 - Darrel Griët <dgriet@gmail.com>
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
import org.asteroid.settings 1.0 //

Application {
    id: app

    centerColor: "#4b45b9"
    outerColor: "#161537"
    /*Component { id: timeLayer;       Item       { } } //TimePage
    Component { id: dateLayer;       Item       { } } //DatePage
    Component { id: languageLayer;   Item   { } } //LanguagePage
    Component { id: bluetoothLayer;  Item  { } } //BluetoothPage
    Component { id: displayLayer;    Item    { } } //DisplayPage
    Component { id: soundLayer;      Item      { } } //SoundPage
    Component { id: unitsLayer;      Item      { } } //UnitsPage
    Component { id: wallpaperLayer;  Item  { } } //WallpaperPage
    Component { id: watchfaceLayer;  Item  { } } //WatchfacePage
    Component { id: launcherLayer;   Item  { } } //LauncherPage
    Component { id: usbLayer;        Item        { } } //USBPage
    Component { id: poweroffLayer;   Item   { } } //PoweroffPage
    Component { id: rebootLayer;     Item     { } } //RebootPage
    Component { id: aboutLayer;      Item      { } } //AboutPage*/

    Component { id: timeLayer;       TimePage       { } }
    Component { id: dateLayer;       DatePage       { } }
    Component { id: languageLayer;   LanguagePage   { } }
    Component { id: bluetoothLayer;  BluetoothPage  { } }
    Component { id: displayLayer;    DisplayPage    { } }
    Component { id: soundLayer;      SoundPage      { } }
    Component { id: unitsLayer;      UnitsPage      { } }
    Component { id: wallpaperLayer;  WallpaperPage  { } }
    Component { id: watchfaceLayer;  WatchfacePage  { } }
    Component { id: launcherLayer;   LauncherPage  { } }
    Component { id: usbLayer;        USBPage        { } }
    Component { id: poweroffLayer;   PoweroffPage   { } }
    Component { id: rebootLayer;     RebootPage     { } }
    Component { id: aboutLayer;      AboutPage      { } }

    //Item { id: tiltToWake } //TiltToWake
    TiltToWake { id: tiltToWake }

    LayerStack {
        id: layerStack
        firstPage: firstPageComponent
    }

    Component {
        id: firstPageComponent

        Item {
            ListView {
                id: appsView
                anchors.fill: parent
                preferredHighlightBegin: appsView.height/2 - appsView.height/12
                preferredHighlightEnd: appsView.height/2 + appsView.height/12
                highlightRangeMode: ListView.StrictlyEnforceRange

                model: ListModel {

                    Component.onCompleted: {
                        append({
                            //% "Time"
                            title: qsTrId("id-time-page"),
                            iconName: "ios-clock-outline",
                            newLayer: timeLayer
                        })
                        append({
                            //% "Date"
                            title: qsTrId("id-date-page"),
                            iconName: "ios-calendar-outline",
                            newLayer: dateLayer
                        })

                        append({
                            //% "Language"
                            title: qsTrId("id-language-page"),
                            iconName: "ios-globe-outline",
                            newLayer: languageLayer
                        })
                        append({
                            //% "Bluetooth"
                            title: qsTrId("id-bluetooth-page"),
                            iconName: "ios-bluetooth-outline",
                            newLayer: bluetoothLayer
                        })
                        append({
                            //% "Display"
                            title: qsTrId("id-display-page"),
                            iconName: "ios-sunny-outline",
                            newLayer: displayLayer
                        })
                        if (DeviceInfo.hasSpeaker) {
                            append({
                                //% "Sound"
                                title: qsTrId("id-sound-page"),
                                iconName: "ios-volume-up",
                                newLayer: soundLayer
                            })
                        }
                        append({
                            //% "Units"
                            title: qsTrId("id-units-page"),
                            iconName: "ios-speedometer-outline",
                            newLayer: unitsLayer
                        })
                        append({
                            //% "Wallpaper"
                            title: qsTrId("id-wallpaper-page"),
                            iconName: "ios-images-outline",
                            newLayer: wallpaperLayer
                        })
                        append({
                            //% "Watchface"
                            title: qsTrId("id-watchface-page"),
                            iconName: "ios-color-wand-outline",
                            newLayer: watchfaceLayer
                        })
                        append({
                            //% "Launcher"
                            title: qsTrId("id-launcher-page"),
                            iconName: "ios-apps-outline",
                            newLayer: launcherLayer
                        })
                        append({
                            //% "USB"
                            title: qsTrId("id-usb-page"),
                            iconName: "ios-usb",
                            newLayer: usbLayer
                        })
                        append({
                            //% "Power Off"
                            title: qsTrId("id-poweroff-page"),
                            iconName: "ios-power-outline",
                            newLayer: poweroffLayer
                        })
                        append({
                            //% "Reboot"
                            title: qsTrId("id-reboot-page"),
                            iconName: "ios-sync",
                            newLayer: rebootLayer
                        })
                        append({
                            //% "About"
                            title: qsTrId("id-about-page"),
                            iconName: "ios-help-circle-outline",
                            newLayer: aboutLayer
                        })
                    }
                }
                delegate: MouseArea {
                    // We want items to move to the left when an item is near the middle of the screen:
                    //  / 1
                    // | 2
                    //  \ 3
                    // To achieve this we need to know the current y location of the element. This is provided by the FileModel.
                    // Using the index of the item and the current location of the top of the listview(contentY) we can find the location of a specific item.
                    // Next we use the Pythagoras rule (x^2+y^2=r^2) to align the item around the left edge.
                    // Rewriting Pythagoras rule: sqrt(r^2 - y^2) => sqrt(listview_height/2^2 - location_item_y^2)
                    // Finally we add a small padding (Dims.w(5)) so that the item is not touching the left 'bezel'.
                    property var screenRadius: appsView.height/2
                    property var itemLocationY: (item.height * (appsView.contentY/item.height - index) - item.height/2)
                    property var bezelOffset: screenRadius - Math.sqrt(Math.pow(screenRadius, 2) - Math.pow((screenRadius + itemLocationY),2))
                    property var normalizedBezelOffset: 1.0 - (bezelOffset / screenRadius)

                    id: item
                    height: appsView.height/6
                    width: appsView.width
                    enabled: !appsView.dragging
                    opacity: normalizedBezelOffset

                    onClicked: layerStack.push(newLayer)

                    Item {
                        width: parent.width
                        height: parent.height
                        anchors.left: parent.left
                        anchors.leftMargin: (DeviceInfo.hasRoundScreen ? bezelOffset : 0) + Dims.w(5)

                        Icon {
                            id: icon
                            width: parent.height
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            name: iconName
                        }
                        Label {
                            id: iconText
                            anchors.left: icon.right
                            width: parent.width
                            anchors.leftMargin: parent.width * 0.04
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: (Math.exp((normalizedBezelOffset)) - 1) * Dims.l(6)
                            font.letterSpacing: Dims.l(0.2)
                            font.styleName: "Bold"
                            style: (normalizedBezelOffset >= 0.99) ? Text.Outline : Text.Normal
                            text: title
                        }
                    }
                }
            }
        }
    }
}
