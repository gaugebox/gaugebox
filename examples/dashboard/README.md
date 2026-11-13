# Qt 5 Dashboard example, ported to Qt 6 with Gaugebox

Original: Qt 5.15 `qtquickcontrols/examples/quickcontrols/extras/dashboard`
(BSD license, headers kept in every file).

Changes made to port it — nothing else was touched:

1. `import QtQuick.Controls.Styles 1.4` and `import QtQuick.Extras 1.4` → `import Gaugebox`
2. `import QtQuick.Controls 1.4` removed (Controls 1 does not exist in Qt 6; the example did not use it)
3. `"qrc:/images/..."` → `"images/..."` (Qt 6 QML modules place resources under the module path)
