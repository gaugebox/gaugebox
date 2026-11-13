// SPDX-FileCopyrightText: 2026 Serhii Artiushenko
// SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Gaugebox-Commercial

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Gaugebox

ColumnLayout {
    spacing: 16

    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: 24

        Repeater {
            model: ["red", "green", "orange", "#2196f3"]

            StatusIndicator {
                required property string modelData
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40
                color: modelData
                active: activeSwitch.checked
            }
        }

        StatusIndicator {
            id: blinker
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
            color: "green"

            Timer {
                running: true
                repeat: true
                interval: 500
                onTriggered: blinker.active = !blinker.active
            }
        }
    }

    Switch {
        id: activeSwitch
        Layout.alignment: Qt.AlignHCenter
        text: qsTr("Active")
        checked: true
    }
}
