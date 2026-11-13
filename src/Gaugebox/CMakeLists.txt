# SPDX-FileCopyrightText: 2026 Serhii Artiushenko
# SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Gaugebox-Commercial

qt_add_library(gaugebox STATIC)

qt_add_qml_module(gaugebox
    URI Gaugebox
    QML_FILES
        CircularGauge.qml
        CircularGaugeStyle.qml
        Gauge.qml
        GaugeStyle.qml
        StatusIndicator.qml
        StatusIndicatorStyle.qml
        ToggleButton.qml
        ToggleButtonStyle.qml
)

target_link_libraries(gaugebox
    PUBLIC
        Qt6::Quick
)
