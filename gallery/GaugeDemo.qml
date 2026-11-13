// SPDX-FileCopyrightText: 2026 Serhii Artiushenko
// SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Gaugebox-Commercial

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Gaugebox

ColumnLayout {
    spacing: 24

    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: 48

        Gauge {
            Layout.preferredHeight: 260
            value: slider.value
        }

        Gauge {
            id: thermometer
            Layout.preferredHeight: 260
            minimumValue: -20
            maximumValue: 60
            value: slider.value * 0.8 - 20
            tickmarkAlignment: Qt.AlignRight
            minorTickmarkCount: 1
            formatValue: function(value) { return value + "°C" }

            style: GaugeStyle {
                valueBar: Rectangle {
                    implicitWidth: 16
                    color: Qt.rgba((thermometer.value + 20) / 80, 0, 1 - (thermometer.value + 20) / 80, 1)
                }
            }
        }

        ColumnLayout {
            spacing: 24

            Gauge {
                Layout.preferredWidth: 360
                orientation: Qt.Horizontal
                value: slider.value
                formatValue: function(value) { return value + "%" }
            }

            Gauge {
                Layout.preferredWidth: 360
                orientation: Qt.Horizontal
                tickmarkAlignment: Qt.AlignTop
                maximumValue: 50
                tickmarkStepSize: 5
                minorTickmarkCount: 0
                value: slider.value / 2
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
