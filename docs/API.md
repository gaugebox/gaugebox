# Спецификация API (шаг 1)

Название продукта — **Gaugebox** (выбрано 13.11.2026; без слова «Qt» в названии —
это товарный знак The Qt Company).

Цель: замена удалённого в Qt 6 модуля `QtQuick.Extras` 1.4 + его стилей из
`QtQuick.Controls.Styles` 1.4. Перенос проекта с Qt 5 должен сводиться к замене импортов:

```qml
// Qt 5
import QtQuick.Extras 1.4
import QtQuick.Controls.Styles 1.4
// Qt 6
import Gaugebox
```

Источник API — официальная документация Qt 5.15 (имена типов, свойств, значения по
умолчанию, поведение). **Код Qt не копируем** — всё пишется с нуля, иначе нельзя
продавать под коммерческой лицензией.

Разрешённые модули Qt (LGPLv3): `QtQuick`, `QtQml`, `QtQuick.Shapes`,
`QtQuick.Controls` (+ `QtQuick.Templates`). Запрещены (GPL/коммерческие): Qt Charts,
Qt Graphs, Qt Quick 3D, Qt Virtual Keyboard; Qt Design Studio Components (ArcItem)
— не используем, пока не проверена лицензия.

## Что было в QtQuick.Extras 1.4 и что с этим делаем

| Тип Qt 5 | Есть в Qt 6? | Решение |
|---|---|---|
| CircularGauge + CircularGaugeStyle | Нет | **v1.0** |
| Gauge + GaugeStyle | Нет | **v1.0** |
| StatusIndicator + StatusIndicatorStyle | Нет | **v1.0** |
| ToggleButton + ToggleButtonStyle | Нет | **v1.0** (поверх Controls 2 `Button { checkable: true }`) |
| PieMenu + PieMenuStyle | Нет | v1.1 |
| DelayButton | Да (QtQuick.Controls) | Не делаем |
| Dial | Да (QtQuick.Controls) | Не делаем |
| Tumbler | Да (QtQuick.Controls) | Не делаем |
| Picture | Нет | Не делаем (нужен QPicture + иконки ISO 7000 из Qt Enterprise) |

Сверх совместимости (Pro-версия, после проверки спроса): тёмная/светлая тема,
зоны (зелёная/жёлтая/красная) на шкале, цифровой индикатор, бак/уровень, термометр,
тренд-график без Qt Charts.

## Механизм стилей

Важно: корень каждого файла стиля имеет уникальный id (`__gbGaugeStyle` и т.п.). Нельзя называть его `style` — в делегатах это имя перекрывается свойством `style` контрола.

В Qt 5 стили — это Controls 1 (`style: XxxStyle { ... }`, свойство типа `Component`).
В Qt 6 Controls 1 нет, поэтому механизм воспроизводим сами:

- у каждого контрола `property Component style: <DefaultStyle> {}`;
- контрол создаёт объект стиля и выставляет ему `control`;
- стиль — `QtObject` со свойствами и делегатами (`Component`), которые контрол
  создаёт через `Loader`/`Repeater`, передавая `styleData.index`, `styleData.value`
  (и `styleData.valuePosition` для Gauge).

## CircularGauge

Свойства контрола:

| Свойство | Тип | По умолчанию | Примечание |
|---|---|---|---|
| value | real | 0 | Для отображения зажимается в [min, max]. **Отличие от Qt 5:** при чтении возвращается то, что записали, без зажима (зажим при записи сломал бы привязки пользователя) |
| minimumValue | real | 0 | |
| maximumValue | real | 100 | |
| stepSize | real | 0 | Стрелка показывает value, округлённое до шага |
| tickmarksVisible | bool | true | Скрывает tickmark, minorTickmark, tickmarkLabel |
| style | Component | CircularGaugeStyle {} | |

CircularGaugeStyle:

| Свойство | Тип | По умолчанию | |
|---|---|---|---|
| control | CircularGauge | — | только чтение |
| minimumValueAngle | real | -145 | 0° = север, по часовой |
| maximumValueAngle | real | 145 | min > max → против часовой |
| angleRange | real | — | только чтение, всегда положительный |
| outerRadius | real | — | только чтение, min(w,h)/2 |
| needleRotation | real | — | угол стрелки |
| tickmarkStepSize | real | 10 | |
| tickmarkCount | int | — | только чтение |
| minorTickmarkCount | int | 4 | между основными рисками |
| labelStepSize | real | 10 | |
| labelCount | int | — | только чтение |
| tickmarkInset | real | 0 | от outerRadius внутрь |
| minorTickmarkInset | real | 0 | |
| labelInset | real | outerRadius*0.22 | центр текста метки |
| background, foreground, needle, tickmark, minorTickmark, tickmarkLabel | Component | | делегаты |
| valueToAngle(value) | метод → real | | |

Как в Qt 5: background и foreground вписываются в квадрат 2×outerRadius по центру контрола (letterbox); цвета по умолчанию светлые (#c8c8c8) — стиль рассчитан на тёмный фон.

Делегаты tickmark/minorTickmark/tickmarkLabel получают `styleData.index`, `styleData.value`.
Стрелка рисуется «вверх» при rotation 0; от делегата нужны только implicitWidth/implicitHeight,
x/y задают точку вращения.

## Gauge (линейный)

| Свойство | Тип | По умолчанию |
|---|---|---|
| value | real | 0 |
| minimumValue | real | 0 |
| maximumValue | real | 100 |
| orientation | int | Qt.Vertical |
| tickmarkAlignment | int | Vertical: Qt.AlignLeft; Horizontal: Qt.AlignBottom |
| tickmarkStepSize | real | 10 |
| minorTickmarkCount | int | 4 |
| font | font | системный |
| formatValue | var (функция) | без форматирования |
| style | Component | GaugeStyle {} |

GaugeStyle: `control`, `valuePosition` (только чтение, пиксели от низа), делегаты
`background`, `valueBar` (обязателен implicitWidth), `foreground`, `tickmark`,
`minorTickmark`, `tickmarkLabel`. Делегаты рисок получают `styleData.index`,
`styleData.value`, `styleData.valuePosition`.

## StatusIndicator

| Свойство | Тип | По умолчанию |
|---|---|---|
| active | bool | false |
| color | color | "red" (переопределяет цвет стиля) |
| style | Component | StatusIndicatorStyle {} |

StatusIndicatorStyle: `control`, `color`, делегат `indicator` (рисует оба состояния).

## ToggleButton

Основа — `QtQuick.Templates.AbstractButton` с `checkable: true` (в Qt 5 — Button из Controls 1).
Доступны `text`, `checked`, `pressed`, `hovered`, `toggle()`, сигналы `clicked`, `toggled` и т.д.
Не перенесено из Controls 1: `iconSource`, `menu`, `tooltip`, `isDefault`, `action`.

ToggleButtonStyle (сверено с документацией Qt 5.15):

| Свойство | Тип | |
|---|---|---|
| control | ToggleButton | только чтение |
| checkedGradient | Gradient | индикатор «включено» (верхняя дуга) |
| uncheckedGradient | Gradient | индикатор «выключено» (нижняя дуга) |
| inactiveGradient | Gradient | неактивный индикатор |
| checkedDropShadowColor | color | свечение во включённом состоянии |
| uncheckedDropShadowColor | color | свечение в выключенном состоянии |
| background, label | Component | делегаты, как в ButtonStyle |

## Порядок работы

1. Каркас проекта + StatusIndicator + галерея — готово.
2. CircularGauge + стиль — готово (пример стрелки из документации Qt 5 работает без изменений).
3. Gauge + стиль — готово (пример термометра из документации Qt 5 работает без изменений).
4. ToggleButton — готово.
5. Тест переноса — готово: официальный пример Qt 5 Dashboard работает после замены импортов (examples/dashboard, README там же).
6. Бесплатный выпуск на GitHub (GPL) + ответы в старых темах форумов.
