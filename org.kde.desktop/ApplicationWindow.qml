import QtQuick.Templates @QQC2_VERSION@ as T
import "private" as P

T.ApplicationWindow {
	id: control

	P.FocusRing {
		target: control.activeFocusItem
		parent: this.T.Overlay.overlay
	}
}

