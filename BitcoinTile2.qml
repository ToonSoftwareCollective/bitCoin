import QtQuick 2.1
import qb.components 1.0
Tile {
	id: bitcoinTile2
	property bool dimState: screenStateController.dimmedColors
	
	onClicked: {
		app.cryptoSwitch++;
		if (app.cryptoSwitch > 10){ app.cryptoSwitch = 1};
		app.getcryptokoers()
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
		Image {width:isNxt? 40:32; height:isNxt? 40:32; source: app.tileURL}
		Text {font.pixelSize: isNxt ? 25:20; font.family: qfont.semiBold.name; color: dimState? "white" : "black" ; text: app.tileCrypt}
	}

   Text {
		id: regelTile2
		text: app.tileValue
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
		text: app.tileLowValue
		font.pixelSize: isNxt? 22:18
		font.family: qfont.bold.name	
		anchors {
			top: regelTile2.bottom
			horizontalCenter: parent.horizontalCenter
		}
		color: dimState? dimmableColors.clockTileColor : colors.clockTileColor
   }

   Text {
		id: regelTile4
		text: app.tileHighValue
		font.pixelSize: isNxt? 22:18
		font.family: qfont.bold.name
		anchors {
			top: regelTile3.bottom
			horizontalCenter: parent.horizontalCenter
		}
		color: dimState? dimmableColors.clockTileColor : colors.clockTileColor
   }

   Text {
		id: regelTile5
		text: app.tileVol
		font.pixelSize: isNxt? 22:18
		font.family: qfont.bold.name
		anchors {
		top: regelTile4.bottom
		horizontalCenter: parent.horizontalCenter
		}
		color: dimState? dimmableColors.clockTileColor : colors.clockTileColor
	}

	MouseArea {
		height : parent.height
		width : parent.width/4
		anchors {
			top: parent.top
			right: parent.right
		}
		onClicked: {
			stage.openFullscreen(app.bitcoinScreenUrl)
		}
	}

}