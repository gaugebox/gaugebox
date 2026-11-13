// SPDX-FileCopyrightText: 2026 Serhii Artiushenko
// SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Gaugebox-Commercial

import QtQuick

QtObject {
    id: __gbStatusIndicatorStyle

    property Item control
    property color color: control ? control.color : "red"

    property Component indicator: Item {
        id: root

        readonly property real diameter: Math.min(width, height)
        readonly property bool lit: __gbStatusIndicatorStyle.control ? __gbStatusIndicatorStyle.control.active : false
        readonly property color lensColor: lit ? __gbStatusIndicatorStyle.color : Qt.darker(__gbStatusIndicatorStyle.color, 3.5)

        implicitWidth: 32
        implicitHeight: 32

        Rectangle {
            anchors.centerIn: parent
            width: root.diameter
            height: width
            radius: width / 2
            gradient: Gradient {
                GradientStop { position: 0; color: "#4a4a4a" }
                GradientStop { position: 1; color: "#d4d4d4" }
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: root.diameter * 0.8
            height: width
            radius: width / 2
            border.width: Math.max(1, root.diameter * 0.03)
            border.color: Qt.darker(root.lensColor, 1.6)
            gradient: Gradient {
                GradientStop { position: 0; color: Qt.lighter(root.lensColor, root.lit ? 1.6 : 1.3) }
                GradientStop { position: 1; color: root.lensColor }
            }
        }

        Rectangle {
            x: root.width / 2 - width / 2
            y: root.height / 2 - root.diameter * 0.32
            width: root.diameter * 0.45
            height: root.diameter * 0.22
            radius: height / 2
            color: Qt.rgba(1, 1, 1, root.lit ? 0.45 : 0.18)
        }
    }
}
