# SPDX-FileCopyrightText: 2026 Serhii Artiushenko
# SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Gaugebox-Commercial

cmake_minimum_required(VERSION 3.21)

project(Gaugebox
    VERSION 0.1.0
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.8 REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.8)

add_subdirectory(src/Gaugebox)
add_subdirectory(gallery)

add_subdirectory(examples/dashboard)
