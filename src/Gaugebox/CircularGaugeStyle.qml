// SPDX-FileCopyrightText: 2026 Serhii Artiushenko
// SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Gaugebox-Commercial

import QtQuick
import QtQuick.Shapes

QtObject {
    id: __gbCircularGaugeStyle

    property Item control

    readonly property real outerRadius: control ? Math.min(control.width, control.height) / 2 : 0

    property real minimumValueAngle: -145
    property real maximumValueAngle: 145
    readonly property real angleRange: Math.abs(maximumValueAngle - minimumValueAngle)

    property real needleRotation: control ? valueToAngle(control.__displayValue) : minimumValueAngle

    property real tickmarkStepSize: 10
    readonly property int tickmarkCount: __countSteps(tickmarkStepSize)
    property int minorTickmarkCount: 4
    property real labelStepSize: 10
    readonly property int labelCount: __countSteps(labelStepSize)

    property real tickmarkInset: 0
    property real minorTickmarkInset: 0
    property real labelInset: outerRadius * 0.22

    function valueToAngle(value) {
        if (!control || control.maximumValue === control.minimumValue)
            return minimumValueAngle
        const normalized = (value - control.minimumValue) / (control.maximumValue - control.minimumValue)
        return minimumValueAngle + normalized * (maximumValueAngle - minimumValueAngle)
    }

    function __countSteps(step) {
        if (!control || step <= 0 || control.maximumValue <= control.minimumValue)
            return 0
        return Math.floor((control.maximumValue - control.minimumValue) / step + 1e-9) + 1
    }

    property Component background: null

    property Component tickmark: Rectangle {
        implicitWidth: Math.max(1, __gbCircularGaugeStyle.outerRadius * 0.02)
        implicitHeight: __gbCircularGaugeStyle.outerRadius * 0.08
        antialiasing: true
        color: "#c8c8c8"
    }

    property Component minorTickmark: Rectangle {
        implicitWidth: Math.max(1, __gbCircularGaugeStyle.outerRadius * 0.01)
        implicitHeight: __gbCircularGaugeStyle.outerRadius * 0.04
        antialiasing: true
        color: "#c8c8c8"
    }

    property Component tickmarkLabel: Text {
        text: Number.isInteger(styleData.value) ? styleData.value : styleData.value.toFixed(1)
        color: "#c8c8c8"
        font.pixelSize: Math.max(6, __gbCircularGaugeStyle.outerRadius * 0.1)
    }

    property Component needle: Item {
        id: needleItem

        y: __gbCircularGaugeStyle.outerRadius * 0.15
        implicitWidth: __gbCircularGaugeStyle.outerRadius * 0.07
        implicitHeight: __gbCircularGaugeStyle.outerRadius * 0.98

        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                strokeWidth: -1
                fillGradient: LinearGradient {
                    x1: 0
                    x2: needleItem.width
                    GradientStop { position: 0; color: "#e8572f" }
                    GradientStop { position: 1; color: "#a8321a" }
                }
                startX: needleItem.width / 2
                startY: 0
                PathLine { x: needleItem.width; y: needleItem.height }
                PathLine { x: 0; y: needleItem.height }
                PathLine { x: needleItem.width / 2; y: 0 }
            }
        }
    }

    property Component foreground: Item {
        Rectangle {
            anchors.centerIn: parent
            width: __gbCircularGaugeStyle.outerRadius * 0.18
            height: width
            radius: width / 2
            border.width: Math.max(1, __gbCircularGaugeStyle.outerRadius * 0.01)
            border.color: "#1e1e1e"
            gradient: Gradient {
                GradientStop { position: 0; color: "#7a7a7a" }
                GradientStop { position: 1; color: "#2e2e2e" }
            }
        }
    }
}
