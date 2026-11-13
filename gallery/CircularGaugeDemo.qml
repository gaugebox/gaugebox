// SPDX-FileCopyrightText: 2026 Serhii Artiushenko
// SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Gaugebox-Commercial

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Gaugebox

ColumnLayout {
    spacing: 16

    Rectangle {
        Layout.alignment: Qt.AlignHCenter
        implicitWidth: gauges.implicitWidth + 48
        implicitHeight: gauges.implicitHeight + 48
        radius: 12
        color: "#202020"

    RowLayout {
        id: gauges
        anchors.centerIn: parent
        spacing: 32

        CircularGauge {
            Layout.preferredWidth: 240
            Layout.preferredHeight: 240
            value: slider.value
        }

        CircularGauge {
            id: speedometer
            Layout.preferredWidth: 240
            Layout.preferredHeight: 240
            maximumValue: 220
            value: slider.value * 2.2

            Behavior on value {
                NumberAnimation { duration: 400 }
            }

            style: CircularGaugeStyle {
                id: speedStyle
                tickmarkStepSize: 20
                labelStepSize: 20
                labelInset: outerRadius * 0.24

                background: Item {
                    Rectangle {
                        anchors.centerIn: parent
                        width: speedStyle.outerRadius * 2
                        height: width
                        radius: width / 2
                        color: "#1e1e1e"
                        border.width: Math.max(1, speedStyle.outerRadius * 0.03)
                        border.color: "#4a4a4a"
                    }

                    Shape {
                        id: redZone
                        anchors.fill: parent
                        preferredRendererType: Shape.CurveRenderer

                        ShapePath {
                            fillColor: "transparent"
                            strokeColor: "#e53935"
                            strokeWidth: speedStyle.outerRadius * 0.05
                            capStyle: ShapePath.FlatCap

                            PathAngleArc {
                                centerX: redZone.width / 2
                                centerY: redZone.height / 2
                                radiusX: speedStyle.outerRadius * 0.87
                                radiusY: radiusX
                                startAngle: speedStyle.valueToAngle(180) - 90
                                sweepAngle: speedStyle.valueToAngle(220) - speedStyle.valueToAngle(180)
                            }
                        }
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: parent.height / 2 + speedStyle.outerRadius * 0.35
                        text: qsTr("%1 km/h").arg(Math.round(speedometer.value))
                        color: "#e0e0e0"
                        font.pixelSize: speedStyle.outerRadius * 0.12
                    }
                }

                tickmark: Rectangle {
                    implicitWidth: Math.max(1, outerRadius * 0.02)
                    implicitHeight: outerRadius * 0.1
                    antialiasing: true
                    color: styleData.value >= 180 ? "#e53935" : "#e0e0e0"
                }

                minorTickmark: Rectangle {
                    implicitWidth: Math.max(1, outerRadius * 0.01)
                    implicitHeight: outerRadius * 0.05
                    antialiasing: true
                    color: styleData.value >= 180 ? "#e53935" : "#9e9e9e"
                }

                tickmarkLabel: Text {
                    text: styleData.value
                    color: styleData.value >= 180 ? "#e53935" : "#e0e0e0"
                    font.pixelSize: Math.max(6, outerRadius * 0.1)
                }
            }
        }

        CircularGauge {
            Layout.preferredWidth: 240
            Layout.preferredHeight: 240
            minimumValue: 0
            maximumValue: 10
            stepSize: 0.5
            value: slider.value / 10

            style: CircularGaugeStyle {
                minimumValueAngle: -90
                maximumValueAngle: 90
                tickmarkStepSize: 1
                labelStepSize: 2
                minorTickmarkCount: 1
            }
        }
    }

    }

    Slider {
        id: slider
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: 400
        from: 0
        to: 100
        value: 65
    }
}
