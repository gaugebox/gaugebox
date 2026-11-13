// SPDX-FileCopyrightText: 2026 Serhii Artiushenko
// SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Gaugebox-Commercial

import QtQuick

QtObject {
    id: __gbToggleButtonStyle

    property Item control

    property Gradient checkedGradient: Gradient {
        GradientStop { position: 0; color: "#8ee07a" }
        GradientStop { position: 1; color: "#2e9a1c" }
    }

    property Gradient uncheckedGradient: Gradient {
        GradientStop { position: 0; color: "#f08a7a" }
        GradientStop { position: 1; color: "#b3261e" }
    }

    property Gradient inactiveGradient: Gradient {
        GradientStop { position: 0; color: "#8a8a8a" }
        GradientStop { position: 1; color: "#4a4a4a" }
    }

    property color checkedDropShadowColor: Qt.rgba(0.35, 0.85, 0.25, 0.45)
    property color uncheckedDropShadowColor: Qt.rgba(0.95, 0.3, 0.2, 0.45)

    property Component background: Item {
        id: bg

        readonly property bool isChecked: __gbToggleButtonStyle.control ? __gbToggleButtonStyle.control.checked : false
        readonly property bool isPressed: __gbToggleButtonStyle.control ? __gbToggleButtonStyle.control.pressed : false
        readonly property real diameter: Math.min(width, height)

        implicitWidth: 90
        implicitHeight: 90

        Rectangle {
            anchors.centerIn: parent
            width: bg.diameter
            height: width
            radius: width / 2
            color: bg.isChecked ? __gbToggleButtonStyle.checkedDropShadowColor
                                : __gbToggleButtonStyle.uncheckedDropShadowColor
        }

        Item {
            x: (bg.width - bg.diameter * 0.92) / 2
            y: (bg.height - bg.diameter * 0.92) / 2
            width: bg.diameter * 0.92
            height: width / 2
            clip: true

            Rectangle {
                width: parent.width
                height: width
                radius: width / 2
                gradient: bg.isChecked ? __gbToggleButtonStyle.checkedGradient
                                       : __gbToggleButtonStyle.inactiveGradient
            }
        }

        Item {
            x: (bg.width - bg.diameter * 0.92) / 2
            y: bg.height / 2
            width: bg.diameter * 0.92
            height: width / 2
            clip: true

            Rectangle {
                y: -parent.height
                width: parent.width
                height: width
                radius: width / 2
                gradient: bg.isChecked ? __gbToggleButtonStyle.inactiveGradient
                                       : __gbToggleButtonStyle.uncheckedGradient
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: bg.diameter * 0.94
            height: Math.max(2, bg.diameter * 0.04)
            color: "#2a2a2a"
        }

        Rectangle {
            anchors.centerIn: parent
            width: bg.diameter * 0.74
            height: width
            radius: width / 2
            border.width: Math.max(1, bg.diameter * 0.02)
            border.color: "#1a1a1a"
            gradient: Gradient {
                GradientStop { position: 0; color: bg.isPressed ? "#3a3a3a" : "#5c5c5c" }
                GradientStop { position: 1; color: bg.isPressed ? "#4a4a4a" : "#2c2c2c" }
            }
        }
    }

    property Component label: Text {
        text: __gbToggleButtonStyle.control ? __gbToggleButtonStyle.control.text : ""
        color: "#ececec"
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        fontSizeMode: Text.Fit
        minimumPixelSize: 6
    }
}
