// SPDX-FileCopyrightText: 2026 Serhii Artiushenko
// SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Gaugebox-Commercial

import QtQuick
import QtQuick.Templates as T

T.AbstractButton {
    id: control

    property Component style: ToggleButtonStyle {}

    readonly property QtObject __style: style ? style.createObject(control, { control: control }) : null

    checkable: true
    padding: Math.min(width, height) * 0.2

    implicitWidth: implicitBackgroundWidth + leftInset + rightInset
    implicitHeight: implicitBackgroundHeight + topInset + bottomInset

    background: Loader {
        sourceComponent: control.__style ? control.__style.background : null
    }

    contentItem: Loader {
        sourceComponent: control.__style ? control.__style.label : null
    }
}
