/*
 * Copyright (C) 2022  walking-octopus
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * dict is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.12
import QtQuick.Layouts 1.3
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3
import Qt.labs.settings 1.0
import "Components"
import "./Components/RequestQML.js" as Request

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'dict.walking-octopus'
    automaticOrientation: true

    width: units.gu(85)
    height: units.gu(75)
    anchorToKeyboard: true

    property string lang: "English"
    property string term: "👋 Salutations!"
    property string partOfSpeech: "Interjection"
    property var definitions: ["A greeting.", "For example, «Salutations, user!»"]

    property bool isLoading: false

    Settings {
        category: "PersistantLanguage"
        property alias selectedLanguage: languageBox.text
    }

    Toast { id: toast }

    Page {
        anchors.fill: parent

        title: header.title
        header: PageHeader {
            id: header
            // flickable: scrollView.flickableItem

            title: i18n.tr('Dictionary')
            contents: RowLayout {
                anchors.centerIn: parent
                width: Math.min(parent.width, units.gu(40))

                TextField {
                    id: languageBox
                    Layout.preferredWidth: units.gu(7.5)

                    inputMethodHints: Qt.ImhNoPredictiveText
                    hasClearButton: false

                    placeholderText: "en"
                    text: placeholderText

                    primaryItem: Icon {
                        width: units.gu(2); height: width
                        name: "language-chooser"
                    }

                    onAccepted: searchBox.forceActiveFocus()

                    Shortcut {
                        sequence: "Ctrl+I"
                        onActivated: languageBox.forceActiveFocus()
                    }
                }

                TextField {
                    id: searchBox

                    Layout.fillWidth: true

                    inputMethodHints: Qt.ImhNoPredictiveText
                    placeholderText: i18n.tr("Word or phrase to look up...")

                    primaryItem: Icon {
                        width: units.gu(2); height: width
                        name: "find"
                    }

                    Shortcut {
                        sequence: "Ctrl+L"
                        onActivated: searchBox.forceActiveFocus()
                    }

                    // curl 'https://en.wiktionary.org/api/rest_v1/page/definition/define' -s | jq .[][].definitions[].definition);

                    onAccepted: {
                        let query = searchBox.text;
                        searchBox.text = "";

                        isLoading = true;

                        Request.request("https://en.wiktionary.org/api/rest_v1/page/definition/" + encodeURIComponent(query.toLowerCase().replace(/[`.,!?;:\-'"]/gi, '')))
                            .then((r) => {
                                const data = JSON.parse(r);
                                // console.log(JSON.stringify(data));

                                console.log(JSON.stringify(data));

                                if (data["type"] != undefined && data["type"].includes("not_found") || data[languageBox.text] == undefined) {
                                    isLoading = false;
                                    toast.show(i18n.tr("Definition not found!"));
                                    return
                                }

                                // TODO: Show the first two definitions
                                // TODO: Show examples

                                term = query;
                                partOfSpeech = data[languageBox.text][0]["partOfSpeech"];
                                lang = data[languageBox.text][0]["language"];
                                definitions = data[languageBox.text][0]["definitions"].map(x => x["definition"].trim()).filter(x => !!x);

                                isLoading = false;
                            })
                            .catch((e) => {
                                console.error(`Error: ${e}`);
                                toast.show(i18n.tr("Network error!"));
                                isLoading = false;
                            });
                    }
                }
            }

            trailingActionBar.actions: [
                Action {
                    iconName: "toolkit_chevron-ltr_3gu"
                    text: i18n.tr("Lookup")
                    onTriggered: searchBox.accepted()
                }
            ]

            ProgressBar {
                indeterminate: true
                visible: isLoading

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
            }
        }

        ScrollView {
            anchors {
                top: header.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            contentItem: contentFlickable

            Flickable {
                id: contentFlickable
                anchors.fill: parent
                anchors.margins: units.gu(2.5)
                contentHeight: contentLayout.height

                Column {
                    id: contentLayout
                    width: parent.width
                    spacing: units.gu(0.6)

                    Label {
                        text: lang
                        textSize: Label.Small
                        color: theme.palette.normal.backgroundSecondaryText // #666666
                    }

                    Label {
                        text: term
                        textSize: Label.XLarge
                        font.bold: true
                    }

                    Label {
                        text: partOfSpeech
                        font.italic: true
                        color: theme.palette.normal.backgroundSecondaryText
                    }

                    Divider {}

                    Divider { // This is a hack
                        color: "transparent"
                        height: units.gu(0.25)
                    }

                    Column {
                        anchors.margins: units.gu(5)
                        spacing: units.gu(1.8)
                        width: parent.width

                        Repeater {
                            model: definitions

                            Label {
                                text: "  •  " + modelData
                                width: parent.width - units.gu(1)
                                wrapMode: Text.Wrap

                                linkColor: "#488cdf"
                                onLinkActivated: {
                                    let linkItems = link.toString().split("/")
                                    let query = linkItems.concat().pop();
                                    Qt.openUrlExternally("https://en.wikipedia.org/wiki/" + encodeURIComponent(query));
                                }
                            }
                        }
                    }
                }
            }
        }

        Label {
            text: i18n.tr("View this page on Wiktionary")
            textSize: Label.Small
            color: theme.palette.normal.backgroundSecondaryText

            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: units.gu(2)

            TapHandler {
                onTapped: Qt.openUrlExternally("https://en.wiktionary.org/wiki/" + encodeURIComponent(
                    term.toLowerCase().replace(/[`.,!?;:\-'"]/gi, '')
                ))
            }
        }
    }


}
