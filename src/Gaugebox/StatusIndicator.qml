// SPDX-FileCopyrightText: 2026 Serhii Artiushenko
// SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Gaugebox-Commercial

import QtQuick

Item {
    id: control

    property bool active: false
    property color color: "red"
    property Component style: StatusIndicatorStyle {}

    readonly property QtObject __style: style ? style.createObject(control, { control: control }) : null

    implicitWidth: indicatorLoader.implicitWidth
    implicitHeight: indicatorLoader.implicitHeight

    Accessible.role: Accessible.Indicator
    Accessible.name: active ? qsTr("Active") : qsTr("Inactive")

    Loader {
        id: indicatorLoader
        anchors.fill: parent
        sourceComponent: control.__style ? control.__style.indicator : null
    }
}
