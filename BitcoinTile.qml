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
		color: dimState? "white" : "grey" 
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
		color: dimState? "white" : "grey" 
		visible: (tileArray[0].length <1)
	}

	Grid {
		id: regelTile1
		columns: 2
		spacing: 5
		visible: (tileArray[0]).length >1
		
		anchors {
			top: parent.top
			topMargin: isNxt? 10:8
			horizontalCenter: parent.horizontalCenter
		}
		Image {visible: (tileArray[0]).length>0;width:isNxt? 40:32; height:isNxt? 40:32; source: tileArray[1] }
		Text {visible: (tileArray[0]).length>0;font.pixelSize: isNxt ? 25:20; font.family: qfont.semiBold.name; color: dimState? dimmableColors.clockTileColor : colors.clockTileColor ; text: tileArray[0] }
	}

/*
	Grid {
		id: regelTile2
		columns: 3
		spacing: 3
		visible: (tileArray[0]).length >1
		
		anchors {
			top: regelTile1.bottom
			topMargin: isNxt? 10:8
			horizontalCenter: parent.horizontalCenter
		}
		
		
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; color: dimState? dimmableColors.clockTileColor : colors.clockTileColor; text: "Waarde: " }
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; color: dimState? dimmableColors.clockTileColor : colors.clockTileColor;text:tileArray[2] }
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; color: dimState? dimmableColors.clockTileColor : colors.clockTileColor;text: " " }
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; color: dimState? dimmableColors.clockTileColor : colors.clockTileColor;text: "24h: "}
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; color: !dimState? (tileArray[3] == "down")? "red" : "green" : dimmableColors.clockTileColor; text: tileArray[4]}
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; color: !dimState? (tileArray[3] == "down")? "red" : "green" : dimmableColors.clockTileColor; text: (tileArray[3] == "down")?  "v" : "^"}	

		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; color: dimState? dimmableColors.clockTileColor : colors.clockTileColor ;text: "Waarde: " }
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; color: dimState? dimmableColors.clockTileColor : colors.clockTileColor ;text:tileArray[2] }
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; color: dimState? dimmableColors.clockTileColor : colors.clockTileColor ;text: " " }
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; color: dimState? dimmableColors.clockTileColor : colors.clockTileColor ;text: "24h: "}
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; color: !dimState? (tileArray[3] == "down")? "red" : "green" : dimmableColors.clockTileColor ; text: tileArray[4]}
		Text {visible: (tileArray[2]).length>0;font.pixelSize: isNxt ? 22:17; font.family: qfont.semiBold.name; color: dimState? dimmableColors.clockTileColor : colors.clockTileColor ;text: " " }	
	

	}
*/
	
	

   Text {
		id: regelTile2
		text: ""
		font.pixelSize: isNxt? 22:18
		font.family: qfont.bold.name
		anchors {
			top: regelTile1.bottom
			topMargin: isNxt? 12:9
			horizontalCenter: parent.horizontalCenter
		}
		color: dimState? dimmableColors.clockTileColor : app.colourBTC 
		}

   Text {
		id: regelTile3
		text: tileArray[2]
		font.pixelSize: isNxt? 30:24
		font.family: qfont.bold.name	
		anchors {
			top: regelTile2.bottom
			horizontalCenter: parent.horizontalCenter
		}
		color: dimState? dimmableColors.clockTileColor : colors.clockTileColor
   }

   Text {
		id: regelTile4
		text: tileArray[4]
		font.pixelSize: isNxt? 30:24
		font.family: qfont.bold.name
		anchors {
			top: regelTile3.bottom
			horizontalCenter: parent.horizontalCenter
		}
		color: !dimState? (tileArray[3] == "down")? "red" : "green" : dimmableColors.clockTileColor ; 
   }




/*	Rectangle { 
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
*/
		
}
	
