import QtQuick 2.1
import qb.base 1.0
import BasicUIControls 1.0
import qb.components 1.0

Tile {
	id: bitcoinTile
	
	property bool dimState: screenStateController.dimmedColors
	property bool blink : false
	property variant tileArray
	
	
	onClicked: {
		stage.openFullscreen(app.bitcoinScreenUrl)
	}

	Component.onCompleted: {
		tileArray = app.dayTile
		app.bitcoinUpdated.connect(updateBitcoin)
	}

	function updateBitcoin() {
		tileArray = app.dayTile
	}


	Text{
		id: waitText
		text: "Waiting to Scrape" 
		font.pixelSize: isNxt? 25:20
		font.family:  qfont.bold.name
		anchors {
            verticalCenter: parent.verticalCenter
			horizontalCenter: parent.horizontalCenter
        }
		color : "grey"
		visible: ((tileArray[2]).length <1)  & (tileArray[0].length > 1)
	}


	Text{
		id: nocoinsText
		text: "No coins selected" 
		font.pixelSize: isNxt? 25:20
		font.family:  qfont.bold.name
		anchors {
            verticalCenter: parent.verticalCenter
			horizontalCenter: parent.horizontalCenter
        }
		color : "grey"
		visible: (tileArray[0].length <1)
	}

	Grid {
		id: gridContainer1
		columns: 2
		spacing: 1
		visible: (tileArray[0]).length >1
		
		anchors {
			top: parent.top
			topMargin: isNxt? 10:8
			horizontalCenter: parent.horizontalCenter
		}
		Image {visible: (tileArray[0]).length>0;width:isNxt? 40:32; height:isNxt? 40:32; source: tileArray[1] }
		Text {visible: (tileArray[0]).length>0;font.pixelSize: isNxt ? 25:20; font.family: qfont.semiBold.name; text: tileArray[0] }
	}

	Grid {
		id: gridContainer2
		columns: 3
		spacing: 3
		visible: (tileArray[0]).length >1
		
		anchors {
			top: gridContainer1.bottom
			topMargin: isNxt? 10:8
			horizontalCenter: parent.horizontalCenter
		}
		
/*		
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; text: "Waarde: " }
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; text:tileArray[2] }
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; text: " " }
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; text: "24h: "}
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; color: (tileArray[3] == "down")? "red" : "green" ; text: tileArray[4]}
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; color: (tileArray[3] == "down")? "red" : "green" ; text: (tileArray[3] == "down")?  "v" : "^"}	
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; text: "7d: "}
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; color: (tileArray[5] == "down")? "red" : "green" ; text: tileArray[6]}
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; color: (tileArray[5] == "down")? "red" : "green" ; text: (tileArray[5] == "down")?  "v" :  "^"}
*/
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; text: "Waarde: " }
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; text:tileArray[2] }
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; text: " " }
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; text: "24h: "}
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; color: (tileArray[3] == "down")? "red" : "green" ; text: tileArray[4]}
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; text: " " }	
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; text: "7d: "}
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; color: (tileArray[5] == "down")? "red" : "green" ; text: tileArray[6]}
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; text: " " }

	}

	Rectangle { 
		id: bulletCircle
		width: 10 
		height: 10 
		anchors {
			top: parent.top
			right: parent.right
			rightMargin: 2
			topMargin:2
		}
		color:  blink? "red" : "transparent"
		radius: width*0.5 
	}

	Timer {
		id: blinkTimer   //interval to scrape data
		interval:1000
		repeat: true
		running: true
		onTriggered: {blink= !blink}
	}
		
}
	