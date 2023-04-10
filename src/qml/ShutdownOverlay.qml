/*
 * Copyright (C) 2023 - Darrel Griët <dgriet@gmail.com>
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
import QtMultimedia 5.4
import org.asteroid.controls 1.0
import Nemo.DBus 2.0

Rectangle {
    property var app
    // property var backgroundState: 1.0
    signal started
    signal finished
    id: root
    // onBackgroundStateChanged: possiblyFinish()
    color: "#000000"

    DBusInterface {
        id: mceDbus

        service: "com.nokia.mce"
        path: "/com/nokia/mce/request"
        iface: "com.nokia.mce.request"

        bus: DBus.SystemBus
    }

    Audio {
        id: shutdownSound
        source: "file:///usr/share/sounds/shutdown.wav"
        onStopped: possiblyFinish()
    }

    function possiblyFinish() {
        // if (bootLogo.paused) {
        //     mceDbus.call("req_display_state_off", undefined)
        // }

        if (bootLogo.paused && shutdownSound.playbackState == Audio.StoppedState) {
            // mceDbus.call("req_display_state_off", undefined)
            finished()
        }
    }

    function start() {
        started()
        app.rightIndicVisible = false
        app.leftIndicVisible = false
        app.topIndicVisible = false
        app.bottomIndicVisible = false
        visible = true
        // timer.start()
        bootLogo.currentFrame = 0
        shutdownSound.play()
    }

    // Timer {
    //     id: timer
    //     interval: 50
    //     running: false
    //     repeat: true
    //     onTriggered: {
    //         if (backgroundState <= 0) {
    //             timer.stop()
    //             return
    //         }
    //         app.outerColor = Qt.rgba(
    //             app.outerColor.r * backgroundState,
    //             app.outerColor.g * backgroundState,
    //             app.outerColor.b * backgroundState
    //         )
    //         app.centerColor = Qt.rgba(
    //             app.centerColor.r * backgroundState,
    //             app.centerColor.g * backgroundState,
    //             app.centerColor.b * backgroundState
    //         )
    //         backgroundState -= 0.1
    //     }
    // }

    AnimatedImage {
        id: bootLogo
        anchors.centerIn: parent
        width: Dims.w(55)
        height: Dims.h(55)
        paused: currentFrame == (frameCount - 1)
        fillMode: Image.PreserveAspectCrop
        source: "qrc:///shutdown.gif"
        visible: !paused
        onPausedChanged: {
            if (paused) {
                mceDbus.call("req_display_state_off", undefined)
                possiblyFinish()
            }
        }
    }
}

