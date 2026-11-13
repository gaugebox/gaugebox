// SPDX-FileCopyrightText: 2026 Serhii Artiushenko
// SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Gaugebox-Commercial

import QtQuick

Item {
    id: control

    property real minimumValue: 0
    property real maximumValue: 100
    property real value: 0
    property real stepSize: 0
    property bool tickmarksVisible: true
    property Component style: CircularGaugeStyle {}

    readonly property QtObject __style: style ? style.createObject(control, { control: control }) : null

    readonly property real __displayValue: {
        let v = Math.max(minimumValue, Math.min(maximumValue, value))
        if (stepSize > 0)
            v = Math.min(maximumValue, minimumValue + Math.round((v - minimumValue) / stepSize) * stepSize)
        return v
    }

    readonly property real __radius: __style ? __style.outerRadius : 0
    readonly property real __centerX: width / 2
    readonly property real __centerY: height / 2

    implicitWidth: backgroundLoader.item ? backgroundLoader.implicitWidth : 250
    implicitHeight: backgroundLoader.item ? backgroundLoader.implicitHeight : 250

    Accessible.role: Accessible.ProgressBar
    Accessible.name: __displayValue.toString()

    // Background and foreground are letterboxed into a centred square, as in Qt 5.
    Loader {
        id: backgroundLoader
        x: control.__centerX - control.__radius
        y: control.__centerY - control.__radius
        width: control.__radius * 2
        height: control.__radius * 2
        sourceComponent: control.__style ? control.__style.background : null
    }

    Repeater {
        model: control.tickmarksVisible && control.__style
               ? Math.max(0, (control.__style.tickmarkCount - 1) * control.__style.minorTickmarkCount)
               : 0

        Loader {
            id: minorLoader

            required property int index
            readonly property int perStep: control.__style.minorTickmarkCount
            readonly property real step: control.__style.tickmarkStepSize
            readonly property real tickValue: control.minimumValue
                                              + Math.floor(index / perStep) * step
                                              + (index % perStep + 1) * step / (perStep + 1)
            property QtObject styleData: QtObject {
                readonly property int index: minorLoader.index
                readonly property real value: minorLoader.tickValue
            }

            sourceComponent: control.__style.minorTickmark
            x: control.__centerX - width / 2
            y: control.__centerY - control.__radius + control.__style.minorTickmarkInset
            transform: Rotation {
                origin.x: minorLoader.width / 2
                origin.y: control.__radius - control.__style.minorTickmarkInset
                angle: control.__style.valueToAngle(minorLoader.tickValue)
            }
        }
    }

    Repeater {
        model: control.tickmarksVisible && control.__style ? control.__style.tickmarkCount : 0

        Loader {
            id: tickLoader

            required property int index
            readonly property real tickValue: control.minimumValue + index * control.__style.tickmarkStepSize
            property QtObject styleData: QtObject {
                readonly property int index: tickLoader.index
                readonly property real value: tickLoader.tickValue
            }

            sourceComponent: control.__style.tickmark
            x: control.__centerX - width / 2
            y: control.__centerY - control.__radius + control.__style.tickmarkInset
            transform: Rotation {
                origin.x: tickLoader.width / 2
                origin.y: control.__radius - control.__style.tickmarkInset
                angle: control.__style.valueToAngle(tickLoader.tickValue)
            }
        }
    }

    Repeater {
        model: control.tickmarksVisible && control.__style ? control.__style.labelCount : 0

        Loader {
            id: labelLoader

            required property int index
            readonly property real labelValue: control.minimumValue + index * control.__style.labelStepSize
            readonly property real angleRad: control.__style.valueToAngle(labelValue) * Math.PI / 180
            readonly property real distance: control.__radius - control.__style.labelInset
            property QtObject styleData: QtObject {
                readonly property int index: labelLoader.index
                readonly property real value: labelLoader.labelValue
            }

            sourceComponent: control.__style.tickmarkLabel
            x: control.__centerX + distance * Math.sin(angleRad) - width / 2
            y: control.__centerY - distance * Math.cos(angleRad) - height / 2
        }
    }

    Item {
        x: control.__centerX
        y: control.__centerY
        rotation: control.__style ? control.__style.needleRotation : 0

        Loader {
            sourceComponent: control.__style ? control.__style.needle : null
            x: -width / 2
            y: -height
        }
    }

    Loader {
        x: control.__centerX - control.__radius
        y: control.__centerY - control.__radius
        width: control.__radius * 2
        height: control.__radius * 2
        sourceComponent: control.__style ? control.__style.foreground : null
    }
}
