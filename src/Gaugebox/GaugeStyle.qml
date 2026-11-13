// SPDX-FileCopyrightText: 2026 Serhii Artiushenko
// SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Gaugebox-Commercial

import QtQuick

QtObject {
    id: __gbGaugeStyle

    property Item control

    readonly property real valuePosition: control ? control.__valuePosition : 0

    property Component background: Rectangle {
        radius: 2
        color: "#e4e4e4"
        border.width: 1
        border.color: "#c2c2c2"
    }

    property Component valueBar: Rectangle {
        implicitWidth: 18
        radius: 2
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0; color: "#5aa4e6" }
            GradientStop { position: 1; color: "#2f78c0" }
        }
    }

    property Component foreground: Rectangle {
        radius: 2
        color: "transparent"
        border.width: 1
        border.color: "#a8a8a8"
    }

    property Component tickmark: Item {
        implicitWidth: 12
        implicitHeight: 2

        Rectangle {
            anchors.fill: parent
            anchors.leftMargin: 2
            anchors.rightMargin: 2
            color: "#4a4a4a"
        }
    }

    property Component minorTickmark: Item {
        implicitWidth: 7
        implicitHeight: 1

        Rectangle {
            anchors.fill: parent
            anchors.leftMargin: 2
            anchors.rightMargin: 2
            color: "#8a8a8a"
        }
    }

    property Component tickmarkLabel: Text {
        text: __gbGaugeStyle.control ? __gbGaugeStyle.control.formatValue(styleData.value) : styleData.value
        font: __gbGaugeStyle.control ? __gbGaugeStyle.control.font : Qt.application.font
        color: "#3a3a3a"
    }
}
