// SPDX-FileCopyrightText: 2026 Serhii Artiushenko
// SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Gaugebox-Commercial

import QtQuick

Item {
    id: control

    property real minimumValue: 0
    property real maximumValue: 100
    property real value: 0
    property int orientation: Qt.Vertical
    property int tickmarkAlignment: orientation === Qt.Vertical ? Qt.AlignLeft : Qt.AlignBottom
    property real tickmarkStepSize: 10
    property int minorTickmarkCount: 4
    property font font: Qt.application.font
    property var formatValue: function(value) { return value }
    property Component style: GaugeStyle {}

    readonly property QtObject __style: style ? style.createObject(control, { control: control }) : null

    readonly property bool __horizontal: orientation === Qt.Horizontal
    // Ticks on the panel's left side: vertical AlignLeft, horizontal AlignTop (panel is rotated 90° clockwise).
    readonly property bool __ticksBeforeBar: __horizontal ? tickmarkAlignment === Qt.AlignTop
                                                          : tickmarkAlignment !== Qt.AlignRight

    readonly property real __displayValue: Math.max(minimumValue, Math.min(maximumValue, value))
    readonly property int __tickCount: tickmarkStepSize > 0 && maximumValue > minimumValue
                                       ? Math.floor((maximumValue - minimumValue) / tickmarkStepSize + 1e-9) + 1
                                       : 0

    readonly property real __labelAcross: Math.max(__horizontal ? labelProbeMin.height : labelProbeMin.width,
                                                   __horizontal ? labelProbeMax.height : labelProbeMax.width)
    readonly property real __labelAlong: Math.max(__horizontal ? labelProbeMin.width : labelProbeMin.height,
                                                  __horizontal ? labelProbeMax.width : labelProbeMax.height)
    readonly property real __tickWidth: tickProbe.implicitWidth
    readonly property real __barWidth: valueBarLoader.implicitWidth
    readonly property real __gap: 4
    readonly property real __across: __labelAcross + __gap + __tickWidth + __barWidth
    readonly property real __padding: Math.max(__labelAlong, tickProbe.implicitHeight) / 2
    readonly property real __trackLength: Math.max(0, panel.height - 2 * __padding)
    readonly property real __valuePosition: maximumValue > minimumValue
                                            ? (__displayValue - minimumValue) / (maximumValue - minimumValue) * __trackLength
                                            : 0

    readonly property real __offset: Math.max(0, (panel.width - __across) / 2)
    readonly property real __barX: __offset + (__ticksBeforeBar ? __labelAcross + __gap + __tickWidth : 0)
    readonly property real __ticksX: __offset + (__ticksBeforeBar ? __labelAcross + __gap : __barWidth)
    readonly property real __labelsX: __offset + (__ticksBeforeBar ? 0 : __barWidth + __tickWidth + __gap)

    function __positionOf(v) {
        return maximumValue > minimumValue ? (v - minimumValue) / (maximumValue - minimumValue) * __trackLength : 0
    }

    implicitWidth: __horizontal ? 200 : __across
    implicitHeight: __horizontal ? __across : 200

    Accessible.role: Accessible.ProgressBar
    Accessible.name: formatValue(__displayValue).toString()

    Loader {
        id: labelProbeMin
        visible: false
        sourceComponent: control.__style ? control.__style.tickmarkLabel : null
        property QtObject styleData: QtObject {
            readonly property int index: 0
            readonly property real value: control.minimumValue
        }
    }

    Loader {
        id: labelProbeMax
        visible: false
        sourceComponent: control.__style ? control.__style.tickmarkLabel : null
        property QtObject styleData: QtObject {
            readonly property int index: Math.max(0, control.__tickCount - 1)
            readonly property real value: control.minimumValue + Math.max(0, control.__tickCount - 1) * control.tickmarkStepSize
        }
    }

    Loader {
        id: tickProbe
        visible: false
        sourceComponent: control.__style ? control.__style.tickmark : null
        property QtObject styleData: QtObject {
            readonly property int index: 0
            readonly property real value: control.minimumValue
            readonly property real valuePosition: 0
        }
    }

    Item {
        id: panel

        anchors.centerIn: parent
        width: control.__horizontal ? control.height : control.width
        height: control.__horizontal ? control.width : control.height
        rotation: control.__horizontal ? 90 : 0

        Loader {
            x: control.__barX
            y: control.__padding
            width: control.__barWidth
            height: control.__trackLength
            sourceComponent: control.__style ? control.__style.background : null
        }

        Loader {
            id: valueBarLoader
            x: control.__barX
            y: control.__padding + control.__trackLength - control.__valuePosition
            width: implicitWidth
            height: control.__valuePosition
            sourceComponent: control.__style ? control.__style.valueBar : null
        }

        Loader {
            x: control.__barX
            y: control.__padding
            width: control.__barWidth
            height: control.__trackLength
            sourceComponent: control.__style ? control.__style.foreground : null
        }

        Repeater {
            model: control.__style ? Math.max(0, (control.__tickCount - 1) * control.minorTickmarkCount) : 0

            Loader {
                id: minorLoader

                required property int index
                readonly property int perStep: Math.max(1, control.minorTickmarkCount)
                readonly property real tickValue: control.minimumValue
                                                  + Math.floor(index / perStep) * control.tickmarkStepSize
                                                  + (index % perStep + 1) * control.tickmarkStepSize / (perStep + 1)
                readonly property real tickPosition: control.__positionOf(tickValue)
                property QtObject styleData: QtObject {
                    readonly property int index: minorLoader.index
                    readonly property real value: minorLoader.tickValue
                    readonly property real valuePosition: minorLoader.tickPosition
                }

                sourceComponent: control.__style.minorTickmark
                x: control.__ticksBeforeBar ? control.__ticksX + control.__tickWidth - width : control.__ticksX
                y: control.__padding + control.__trackLength - tickPosition - height / 2
            }
        }

        Repeater {
            model: control.__style ? control.__tickCount : 0

            Loader {
                id: tickLoader

                required property int index
                readonly property real tickValue: control.minimumValue + index * control.tickmarkStepSize
                readonly property real tickPosition: control.__positionOf(tickValue)
                property QtObject styleData: QtObject {
                    readonly property int index: tickLoader.index
                    readonly property real value: tickLoader.tickValue
                    readonly property real valuePosition: tickLoader.tickPosition
                }

                sourceComponent: control.__style.tickmark
                x: control.__ticksBeforeBar ? control.__ticksX + control.__tickWidth - width : control.__ticksX
                y: control.__padding + control.__trackLength - tickPosition - height / 2
            }
        }

        Repeater {
            model: control.__style ? control.__tickCount : 0

            Item {
                id: labelSlot

                required property int index
                readonly property real labelValue: control.minimumValue + index * control.tickmarkStepSize
                readonly property real labelPosition: control.__positionOf(labelValue)

                width: control.__horizontal ? labelLoader.height : labelLoader.width
                height: control.__horizontal ? labelLoader.width : labelLoader.height
                x: control.__ticksBeforeBar ? control.__labelsX + control.__labelAcross - width : control.__labelsX
                y: control.__padding + control.__trackLength - labelPosition - height / 2

                Loader {
                    id: labelLoader
                    anchors.centerIn: parent
                    rotation: control.__horizontal ? -90 : 0
                    sourceComponent: control.__style.tickmarkLabel
                    property QtObject styleData: QtObject {
                        readonly property int index: labelSlot.index
                        readonly property real value: labelSlot.labelValue
                    }
                }
            }
        }
    }
}
