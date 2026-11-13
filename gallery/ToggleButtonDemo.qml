// SPDX-FileCopyrightText: 2026 Serhii Artiushenko
// SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Gaugebox-Commercial

import QtQuick
import QtQuick.Layouts
import Gaugebox

RowLayout {
    spacing: 40

    ColumnLayout {
        spacing: 12

        ToggleButton {
            id: pump
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("PUMP")
        }

        StatusIndicator {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            color: "green"
            active: pump.checked
        }
    }

    ToggleButton {
        Layout.preferredWidth: 120
        Layout.preferredHeight: 120
        text: qsTr("FAN")
        checked: true
    }

    ToggleButton {
        text: qsTr("LIGHT")
        checked: true

        style: ToggleButtonStyle {
            checkedGradient: Gradient {
                GradientStop { position: 0; color: "#7ec8ff" }
                GradientStop { position: 1; color: "#1e6fc0" }
            }
            checkedDropShadowColor: Qt.rgba(0.2, 0.55, 1, 0.45)
        }
    }
}
