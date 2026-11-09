/*
    SPDX-FileCopyrightText: 2026 Tobias Fella <tobias.fella@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick
import QtTest
import org.kde.desktop as Desktop

TestCase {
    id: root

    name: "ToolTip"
    width: 400
    height: 400
    visible: true
    when: windowShown

    Component {
        id: toolTipComponent
        Desktop.ToolTip {}
    }

    function test_ampersands_data() {
        return [
            { tag: "plain text", input: "Open File", expected: "Open File" },
            { tag: "leading mnemonic", input: "&Open", expected: "Open" },
            { tag: "mnemonic inside word", input: "Op&en", expected: "Open" },
            { tag: "multiple mnemonics", input: "&File and &Edit", expected: "File and Edit" },
            { tag: "mnemonic before digit", input: "Option &1", expected: "Option 1" },
            { tag: "standalone ampersand", input: "Tom & Jerry", expected: "Tom & Jerry" },
            { tag: "trailing ampersand", input: "Tom &", expected: "Tom &" },
            { tag: "named entity", input: "Tom &amp; Jerry", expected: "Tom &amp; Jerry" },
            { tag: "decimal entity", input: "Tom &#38; Jerry", expected: "Tom &#38; Jerry" },
            { tag: "hex entity", input: "Tom &#x26; Jerry", expected: "Tom &#x26; Jerry" },
            { tag: "mnemonic and entity", input: "&Save &amp; Quit", expected: "Save &amp; Quit" },
            { tag: "mnemonic followed by more words", input: "&Open the file now", expected: "Open the file now" },
        ];
    }

    function test_ampersands(data) {
        const toolTip = createTemporaryObject(toolTipComponent, root, { text: data.input });
        verify(toolTip);
        const label = toolTip.contentItem.children[0];
        verify(label);
        compare(label.text, data.expected);
    }
}
