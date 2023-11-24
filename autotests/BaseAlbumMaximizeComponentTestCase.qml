// SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick 2.15
import QtTest 1.2

import org.kde.kirigami 2.15 as Kirigami
import org.kde.kirigamiaddons.labs.components 1.0

TestCase {
    id: root

    property var model

    readonly property string testImage: dataDir + "/kmail.png"
    readonly property string testVideo: dataDir + "/discover_hl_720p.webm"

    when: windowShown

    width: 800
    height: 600

    // Check that the AlbumMaximizeComponent fills the window.
    function test_maximize() {
        var testAlbum = createTemporaryObject(album, root);
        testAlbum.open();

        compare(testAlbum.width, root.width);
        compare(testAlbum.height, root.height);

        testAlbum.destroy();
    }

    function test_hasItems() {
        var testAlbum = createTemporaryObject(album, root);
        testAlbum.open();

        compare(testAlbum.count == 3, true);

        testAlbum.destroy();
    }

    // Select the image item and check that the current delegate has the correct properties.
    function test_imageParams() {
        var testAlbum = createTemporaryObject(album, root);
        testAlbum.open();

        testAlbum.currentIndex = 0;
        compare(testAlbum.currentItem.type, AlbumModelItem.Image);
        compare(testAlbum.currentItem.source, Qt.resolvedUrl(root.testImage));
        compare(testAlbum.currentItem.tempSource, Qt.resolvedUrl(root.testImage));
        compare(testAlbum.currentItem.caption, "A test image");

        testAlbum.destroy();
    }

    // Select the video item and check that the current delegate has the correct properties.
    function test_videoParams() {
        var testAlbum = createTemporaryObject(album, root);
        testAlbum.open();

        testAlbum.currentIndex = 1;
        compare(testAlbum.currentItem.type, AlbumModelItem.Video);
        compare(testAlbum.currentItem.source, Qt.resolvedUrl(root.testVideo));
        compare(testAlbum.currentItem.tempSource, Qt.resolvedUrl(root.testImage));
        compare(testAlbum.currentItem.caption, "A test video");

        testAlbum.destroy();
    }

    // Select the image item and check that the image only actions are visible.
    function test_imageActions() {
        var testAlbum = createTemporaryObject(album, root);
        testAlbum.open();

        testAlbum.currentIndex = 0;
        compare(testAlbum.actions[2].visible, true);
        compare(testAlbum.actions[3].visible, true);

        testAlbum.destroy();
    }

    // Select the video item and check that the image only actions are not visible.
    function test_videoActions() {
        var testAlbum = createTemporaryObject(album, root);
        testAlbum.open();

        testAlbum.currentIndex = 1;
        compare(testAlbum.actions[2].visible, false);
        compare(testAlbum.actions[3].visible, false);

        testAlbum.destroy();
    }

    // Test that the caption is only visible if showCaption is true and a
    // captions string exists.
    function test_captionVisibility() {
        var testAlbum = createTemporaryObject(album, root);
        testAlbum.open();

        // Check that caption will be visible for the first item with
        // showCaption = true.
        testAlbum.showCaption = true
        testAlbum.currentIndex = 0;
        compare(testAlbum.footer.visible, true);

        // Check that caption will be visible for the second item with
        // showCaption = true.
        testAlbum.currentIndex = 1;
        compare(testAlbum.footer.visible, true);

        // Check that caption will not be visible for the third item with
        // showCaption = true.
        testAlbum.currentIndex = 2;
        compare(testAlbum.footer.visible, false);

        // Check that caption will not be visible for the first item with
        // showCaption = false.
        testAlbum.showCaption = false
        testAlbum.currentIndex = 0;
        compare(testAlbum.footer.visible, false);

        // Check that caption will not be visible for the second item with
        // showCaption = false.
        testAlbum.currentIndex = 1;
        compare(testAlbum.footer.visible, false);

        // Check that caption will not be visible for the third item with
        // showCaption = false.
        testAlbum.currentIndex = 2;
        compare(testAlbum.footer.visible, false);

        testAlbum.destroy();
    }

/* TODO FIXME
    function test_itemRightClick() {
        var testAlbum = createTemporaryObject(album, root);
        testAlbum.open();

        // Make sure the item delegate is ready.
        tryCompare(testAlbum.content.currentItem.children[0], "status", Image.Ready)
        wait(100) // Let the image resize animation happen.
        mouseClick(root, 400, 300, Qt.RightButton)
        compare(testAlbum.signalSpyItemRightClick.count, 1)

        testAlbum.destroy();
    }
*/

    function test_saveItem() {
        var testAlbum = createTemporaryObject(album, root);
        testAlbum.open();

        // Make sure the item delegate is ready.
        tryCompare(testAlbum.currentItem.children[0], "status", Image.Ready)
        wait(200) // Let the image resize animation happen.
        mouseClick(root, 738, 18, Qt.LeftButton)
        compare(testAlbum.signalSpySaveItem.count, 1)

        testAlbum.destroy();
    }

    function test_userCaption() {
        var testAlbum = createTemporaryObject(album, root);
        testAlbum.open();

        // Check that caption will be visible for the first item with
        // showCaption = true.
        testAlbum.showCaption = true
        testAlbum.currentIndex = 0;

        // Make sure the item delegate is ready.
        tryCompare(testAlbum.currentItem.children[0], "status", Image.Ready)
        wait(200) // Let the image resize animation happen.

        mouseClick(root, 702, 18, Qt.LeftButton)
        compare(testAlbum.footer.visible, false)
        mouseClick(root, 702, 18, Qt.LeftButton)
        compare(testAlbum.footer.visible, true)

        testAlbum.destroy();
    }

    Component {
        id: album
        AlbumMaximizeComponent {
            id: albumComponent
            property alias signalSpyItemRightClick: spyItemRightClick
            property alias signalSpySaveItem: spySaveItem

            parent: root
            initialIndex: 0
            model: root.model

            SignalSpy {
                id: spyItemRightClick
                target: albumComponent
                signalName: "itemRightClicked"
            }
            SignalSpy {
                id: spySaveItem
                target: albumComponent
                signalName: "saveItem"
            }
        }
    }
}
