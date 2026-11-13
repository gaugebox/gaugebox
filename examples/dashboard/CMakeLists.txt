# SPDX-FileCopyrightText: 2026 Serhii Artiushenko
# SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Gaugebox-Commercial

qt_add_executable(dashboard_example
    main.cpp
)

qt_add_qml_module(dashboard_example
    URI Dashboard
    QML_FILES
        dashboard.qml
        DashboardGaugeStyle.qml
        IconGaugeStyle.qml
        TachometerStyle.qml
        TurnIndicator.qml
        ValueSource.qml
    RESOURCES
        images/fuel-icon.png
        images/temperature-icon.png
    IMPORTS
        TARGET gaugebox
)

target_link_libraries(dashboard_example
    PRIVATE
        Qt6::Quick
        gaugebox
        gaugeboxplugin
)
