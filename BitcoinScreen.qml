import QtQuick 2.1
import BasicUIControls 1.0
import qb.components 1.0

Screen {
	id: bitcoinScreen
	screenTitle: "Bitcoin App"

	property bool blink : false
	property variant tileArray
	property int textSize : isNxt ? 20:16
	property string fontName : "qfont.semiBold.name"
	property int leftShift : isNxt ? 100:80
	property int rowheight : isNxt ? 40:32
	property int imageheight : isNxt ? 48:30
	property int left1 : leftShift + parent.width* 3/100
	property int left2 : leftShift + parent.width* 10/100
	property int left3 : leftShift + parent.width* 30/100
	property int left4 : leftShift + parent.width* 50/100
	property int left5 : leftShift + parent.width* 70/100

	onShown: {    
		addCustomTopRightButton("Instellingen")
    	}
	
	onCustomButtonClicked: {
		stage.openFullscreen(app.bitcoinConfigScreenUrl)
	}
	
	Component.onCompleted: {
		tileArray = app.items
		app.bitcoinUpdated.connect(updateBitcoin)
	}

	function updateBitcoin() {
		tileArray = app.items
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
		visible: ((tileArray[0][1]).length <1)  & (tileArray[0][0].length > 1)
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
		visible: (tileArray[0][0].length <1)
	}
	
	Text {id: head1 ; anchors.top : parent.top; anchors.left: parent.left ; anchors.leftMargin:left1; visible: (tileArray[0][0]).length>0;font.pixelSize: textSize ; font.family: fontName; text:"" }
	Text {id: head2 ; anchors.top : head1.top ; anchors.left: parent.left ; anchors.leftMargin:left2 ; visible: (tileArray[0][0]).length>0;font.pixelSize: textSize; font.family: fontName; text:"Naam" }
	Text {id: head3 ; anchors.top : head1.top ; anchors.left: parent.left ; anchors.leftMargin:left3; visible: (tileArray[0][0]).length>0;font.pixelSize: textSize; font.family: fontName; text:"Waarde" }
	Text {id: head4 ; anchors.top : head1.top ; anchors.left: parent.left ; anchors.leftMargin:left4; visible: (tileArray[0][0]).length>0;font.pixelSize: textSize; font.family: fontName; text:"7d" }
	Text {id: head5 ; anchors.top : head1.top ; anchors.left: parent.left ; anchors.leftMargin:left5; visible: (tileArray[0][0]).length>0;font.pixelSize: textSize; font.family: fontName; text:"24h" }

	Column {
		id: columnContainer1
		width: parent.width
		anchors {
			top: head1.top
			topMargin: isNxt ? 40:32
		}
		visible: (tileArray[0][1]).length >1
		Repeater {
			id: repeater1
			model: tileArray.length
			Item {
				height: rowheight
				width: parent.width
				Image {id: im1 ; anchors.left: parent.left ; anchors.leftMargin:left1 ;visible: (tileArray[index][0]).length>0; height:imageheight; fillMode: Image.PreserveAspectFit ;source: tileArray[index][1] }
				Text {id: txt1 ; anchors.left: parent.left ; anchors.leftMargin:left2 ;visible: (tileArray[index][0]).length>0;font.pixelSize:  textSize; font.family: qfont.semiBold.name; text:tileArray[index][0] }
				Text {id: txt2 ; anchors.left: parent.left ; anchors.leftMargin:left3 ;visible: (tileArray[index][0]).length>0;font.pixelSize:  textSize; font.family: qfont.semiBold.name;  text:tileArray[index][2] }
				Text {id: txt3 ; anchors.left: parent.left ; anchors.leftMargin:left4 ;visible: (tileArray[index][0]).length>0;font.pixelSize:  textSize; font.family: qfont.semiBold.name;  color: (tileArray[index][3] == "down")? "red" : "green" ; text:tileArray[index][4] }
				Text {id: txt4 ; anchors.left: parent.left ; anchors.leftMargin:left5 ;visible: (tileArray[index][0]).length>0;font.pixelSize:  textSize; font.family: qfont.semiBold.name; color: (tileArray[index][5] == "down")? "red" : "green" ; text:tileArray[index][6]}		
			}
		}
	}
	

	

	Rectangle { 
		id: bulletCircle
		width: 10 
		height: 10 
		anchors {
			top: parent.top
			right: parent.right
			rightMargin: 10
			topMargin:10
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




