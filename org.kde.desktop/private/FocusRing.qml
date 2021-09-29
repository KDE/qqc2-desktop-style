import QtQuick 2.15
import QtQuick.Controls @QQC2_VERSION@ as QQC2
import org.kde.kirigami 2.15 as Kirigami
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import QtGraphicalEffects 1.15

Item {
    id: control

    required property Item target
    readonly property Item resolvedTarget: {
        if ( !target.background instanceof StylePrivate.StyleItem ) return null

        if ( target instanceof QQC2.CheckBox
          || target instanceof QQC2.RadioButton
          || target instanceof QQC2.Switch
           ) {
            return target.indicator
        }
        if ( target instanceof QQC2.Slider
           ) {
            return target.handle
        }
        if ( target instanceof QQC2.AbstractButton
          || target instanceof QQC2.TextField
          || target instanceof QQC2.Button
          || target instanceof QQC2.ToolButton
          || target instanceof QQC2.ComboBox
          || target instanceof QQC2.SpinBox
          || target instanceof RangeSliderHandle
           ) {
            return target
        }
        return null
    }

    readonly property bool isCheck: target instanceof QQC2.CheckBox
    readonly property bool isRadio: target instanceof QQC2.RadioButton
    readonly property bool becomeCircle: isRadio || target instanceof RangeSliderHandle

    function tryit(fn, def) {
        try {
            return fn() ?? def
        } catch (e) {
            return def
        }
    }

    visible: resolvedTarget !== null

    x: tryit(() => resolvedTarget.Kirigami.ScenePosition.x, 0)
    y: tryit(() => resolvedTarget.Kirigami.ScenePosition.y, 0)
    z: tryit(() => resolvedTarget.z + 2, 0)
    width: tryit(() => resolvedTarget.width, 0)
    height: tryit(() => resolvedTarget.height, 0)

    Rectangle {
        id: decoration

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: isCheck || isRadio ? undefined : parent.right

        anchors.margins: -2
        anchors.leftMargin: isCheck || isRadio ? -1 : -2
        anchors.topMargin: {
            if (isCheck) return 2
            if (isRadio) return -1

            return -2
        }
        anchors.bottomMargin: {
            if (isCheck) return 2
            if (isRadio) return -1

            return -2
        }
        width: {
            if (!(isCheck || isRadio)) {
                return -1
            }

            return 22
        }

        radius: {
            if (!control.becomeCircle) {
                return tryit(() => control.resolvedTarget.radius, 6)
            }
            return width/2
        }
        color: Qt.rgba(Kirigami.Theme.focusColor.r, Kirigami.Theme.focusColor.g, Kirigami.Theme.focusColor.b, Kirigami.Theme.focusColor.a * 0.5)

        layer.enabled: true
        layer.effect: OpacityMask {
            invert: true
            maskSource: Item {
                width: decoration.width
                height: decoration.height
                Rectangle {
                    color: "green"
                    anchors.fill: parent
                    anchors.margins: 3
                    radius: control.becomeCircle ? width/2 : 3
                }
            }
        }
    }
}
