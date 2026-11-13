# SPDX-FileCopyrightText: 2026 Serhii Artiushenko
# SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Gaugebox-Commercial

qt_add_executable(gaugebox_gallery
    main.cpp
)

qt_add_qml_module(gaugebox_gallery
    URI Gallery
    QML_FILES
        Main.qml
        CircularGaugeDemo.qml
        GaugeDemo.qml
        StatusIndicatorDemo.qml
        ToggleButtonDemo.qml
    IMPORTS
        TARGET gaugebox
)

target_link_libraries(gaugebox_gallery
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
        gaugebox
        gaugeboxplugin
)
