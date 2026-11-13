// SPDX-FileCopyrightText: 2026 Serhii Artiushenko
// SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Gaugebox-Commercial

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    width: 960
    height: 560
    visible: true
    title: qsTr("Gaugebox Gallery")

    header: TabBar {
        id: tabs

        TabButton { text: qsTr("CircularGauge") }
        TabButton { text: qsTr("Gauge") }
        TabButton { text: qsTr("StatusIndicator") }
        TabButton { text: qsTr("ToggleButton") }
    }

    StackLayout {
        anchors.fill: parent
        currentIndex: tabs.currentIndex

        Item {
            CircularGaugeDemo { anchors.centerIn: parent }
        }

        Item {
            GaugeDemo { anchors.centerIn: parent }
        }

        Item {
            StatusIndicatorDemo { anchors.centerIn: parent }
        }

        Item {
            ToggleButtonDemo { anchors.centerIn: parent }
        }
    }
}
