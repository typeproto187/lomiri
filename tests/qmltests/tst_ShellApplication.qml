/*
 * Copyright (C) 2017 Canonical, Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import Ubuntu.Components 1.3
import LightDM.FullLightDM 0.1 as LightDM
import LightDMController 0.1
import Unity.Application 0.1
import Unity.Test 0.1

import "../../qml"
import "Stage"

Rectangle {
    id: root
    color: "grey"
    width: units.gu(100)
    height: units.gu(71)

    QtObject {
        id: args
        property bool hasFullscreen: false
        property bool hasFrameless: false
        property bool hasGeometry: true
        property size windowGeometry: Qt.size(root.width, root.height)
        property string deviceName: "desktop"
        property string mode: "full-greeter"
    }
    property alias applicationArguments: args

    Component.onCompleted: {
        // must set the mock mode before loading the Shell
        LightDMController.userMode = "single";
    }

    Flickable {
        id: controls
        contentHeight: controlRect.height

        anchors.top: root.top
        anchors.bottom: root.bottom
        anchors.right: root.right
        width: units.gu(30)

        Rectangle {
            id: controlRect
            anchors { left: parent.left; right: parent.right }
            color: "darkgrey"
            height: childrenRect.height + units.gu(2)

            Column {
                anchors { left: parent.left; right: parent.right; top: parent.top; margins: units.gu(1) }
                spacing: units.gu(1)

                Flow {
                    spacing: units.gu(1)
                    anchors { left: parent.left; right: parent.right }

                    Button {
                        text: "Show Greeter"
                        activeFocusOnPress: false
                        onClicked: {
                            LightDM.Greeter.showGreeter();
                        }
                    }
                    Button {
                        text: "Hide Greeter"
                        activeFocusOnPress: false
                        onClicked: {
                            LightDM.Greeter.hideGreeter()
                        }
                    }
                }

                MouseTouchEmulationCheckbox {
                    id: mouseEmulation
                    checked: true
                }

                Row {
                    anchors { left: parent.left; right: parent.right }
                    CheckBox {
                        id: autohideLauncherCheckbox
                        onCheckedChanged:  {
                            GSettingsController.setAutohideLauncher(checked)
                        }
                    }
                    Label {
                        text: "Autohide launcher"
                    }
                }

                Label { text: "Applications"; font.bold: true }

                Button {
                    text: "Start all apps"
                    width: parent.width
                    activeFocusOnPress: false
                    onClicked: {
                        for (var i = 0; i < ApplicationManager.availableApplications.length; i++) {
                            var appId = ApplicationManager.availableApplications[i];
                            ApplicationManager.startApplication(appId)
                        }
                    }
                }

                Repeater {
                    id: appCheckBoxRepeater
                    model: ApplicationManager.availableApplications
                    ApplicationCheckBox {
                        appId: modelData
                    }
                }

                Label {
                    text: "Fingerprint"
                }
                Row {
                    Button {
                        text: "Success"
                        onClicked: {
                            var biometryd = testCase.findInvisibleChild(shellContainer, "biometryd");
                            var uid = 0;
                            for (var i = 0; i < LightDM.Users.count; i++) {
                                if (LightDM.Users.data(i, LightDM.UserRoles.NameRole) == AccountsService.user) {
                                    uid = LightDM.Users.data(i, LightDM.UserRoles.UidRole);
                                    break;
                                }
                            }
                            biometryd.operation.mockSuccess(uid);
                        }
                    }

                    Button {
                        text: "Failure"
                        onClicked: {
                            var biometryd = testCase.findInvisibleChild(shellContainer, "biometryd");
                            biometryd.operation.mockFailure("error");
                        }
                    }
                }
            }
        }
    }

    ShellApplication {
    }
}
