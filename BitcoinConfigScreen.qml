import QtQuick 2.1
import BasicUIControls 1.0
import qb.components 1.0

Screen {
	id: bitcoinConfigScreen
	screenTitle: "Bitcoin App Setup"

	property string coins: ""
	property string coinsURL : "https://raw.githubusercontent.com/ToonSoftwareCollective/toonanimations/main/bitcoins.txt"
	property variant  coinsArray : []
	property variant  selectedCoinsArray
	property int  numberofItems :0
	property string	selectedTileCoin: ""

	
	onShown: {
		addCustomTopRightButton("Opslaan")
		getCoins()
		selectedCoinsArray = app.selectedCoinsArray
		selectedTileCoin = app.selectedTileCoin
		selectedCoinstoList()
	}

	onCustomButtonClicked: {
		app.selectedCoinsArray = selectedCoinsArray
		app.selectedTileCoin = selectedTileCoin
		app.saveSettings()
		hide()
	}
	
	function selectedCoinstoList(){
		model2.clear()
		for (var x in selectedCoinsArray){
			listview2.model.append({name: selectedCoinsArray[x]})
		}
	}

	function getCoins(){
		var xmlhttp = new XMLHttpRequest()
		xmlhttp.onreadystatechange=function() {
			if (xmlhttp.readyState === 4 && xmlhttp.status === 200) {
				coins = xmlhttp.responseText
				coinsArray = coins.substring(0, coins.length).split(';')
				numberofItems =  coinsArray.length
				model.clear()
				for(var x1 in coinsArray){
						listview1.model.append({name: coinsArray[x1].trim()})
				}
			}
		}
		xmlhttp.open("GET", coinsURL, true)
		xmlhttp.send()
	}
/////////////////////////////////////////////////////////////////////////

	Text {
		id: mytexttop1
		text: "Selecteer de crypto munten die je wilt zien op het scherm"
		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 18:14
		}
		anchors {
			top:parent.top
			left:parent.left
			leftMargin: isNxt ? 10 :8
			topMargin: isNxt ? 5 :4
		}
	}
	
	Text {
		id: mytexttop2
		text: "Selecteer:"
		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 18:14
		}
		anchors {
			top:mytexttop1.bottom
			left:mytexttop1.left
			topMargin: isNxt ? 10 :8
		}
	}
	
	Rectangle{
		id: listviewContainer1
		width: isNxt ? parent.width/2 -100 : parent.width/2 - 80
		height: isNxt ? 220 : 190
		color: "white"
		radius: isNxt ? 5 : 4
		border.color: "black"
			border.width: isNxt ? 3 : 2
		anchors {
			top:		mytexttop2.bottom
			topMargin: 	8
			left:   	mytexttop1.left
		}

		Component {
			id: aniDelegate
			Item {
				width: isNxt ? (parent.width-20) : (parent.width-16)
				height: isNxt ? 22 : 18
				Text {
					id: tst
					text: name
					font.pixelSize: isNxt ? 18:14
				}
			}
		}

		ListModel {
				id: model
		}
		ListView {
			id: listview1
			anchors {
				top: parent.top
				topMargin:isNxt ? 20 : 16
				leftMargin: isNxt ? 12 : 9
				left: parent.left
			}
			width: parent.width
			height: isNxt ? (parent.height-50) : (parent.height-40)
			model:model
			delegate: aniDelegate
			highlight: Rectangle { 
				color: "lightsteelblue"; 
				radius: isNxt ? 5 : 4
			}
			focus: true
		}
	}

/////////////////////////////////////////////////////////////////////////

	IconButton {
		id: upButton
		anchors {
			top: listviewContainer1.top
			left:  listviewContainer1.right
			leftMargin : isNxt? 3 : 2
		}

		iconSource: "qrc:/tsc/up.png"
		onClicked: {
		    if (listview1.currentIndex>0){
                        listview1.currentIndex  = listview1.currentIndex -1
            }
		}	
	}

	IconButton {
		id: downButton
		anchors {
			bottom: listviewContainer1.bottom
			left:  listviewContainer1.right
			leftMargin : isNxt? 3 : 2

		}

		iconSource: "qrc:/tsc/down.png"
		onClicked: {
		    if (numberofItems>=listview1.currentIndex){
                        listview1.currentIndex  = listview1.currentIndex +1
            }
		}	
	}


	NewTextLabel {
		id: addText
		width: isNxt ? 120 : 96;  
		height: isNxt ? 40:32
		buttonActiveColor: "lightgreen"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		buttonText:  "Voeg Toe"
		anchors {
			top: listviewContainer1.bottom
			left: listviewContainer1.left
			topMargin: isNxt? 5: 4
			}
		onClicked: {
			var exists = false			
			var selectedCoin = coinsArray[listview1.currentIndex].toLowerCase().trim()
			for (var i in selectedCoinsArray){
				if (selectedCoin == selectedCoinsArray[i].toLowerCase().trim()){
					exists = true
				}
			}
			if (!exists){
				listview2.model.append({name: coinsArray[listview1.currentIndex]})
				selectedCoinsArray.push(selectedCoin)
			}	
		}
	}

	NewTextLabel {
		id: addTile
		width: isNxt ? 250 : 200;  
		height: isNxt ? 40:32
		buttonActiveColor: "lightgreen"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		buttonText:  "Selecteer voor Tegel"
		anchors {
			top: addText.top
			left: addText.right
			rightMargin: isNxt? 5: 4
			}
		onClicked: {
			if (coinsArray[listview1.currentIndex].length>1){
				selectedTileCoin = coinsArray[listview1.currentIndex]
			}
		}	

	}

	Text {
		id: selectedTilecoinText
		text: "Geselecteerd voor tegel: " + selectedTileCoin
		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 20:16
		}
		anchors {
			top: addText.bottom
			left:addText.left
			topMargin: isNxt? 10: 8
		}
	}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	Text {
		id: mytext1
		text: "Geselecteerde crypto munten: "
		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 18:14
		}
		anchors {
			top: mytexttop2.top
			left:parent.left
			leftMargin: parent.width/2
		}
	}

	Rectangle{
		id: listviewContainer2
		width: isNxt ? parent.width/2 -100 : parent.width/2 - 80
		height: isNxt ? 220 : 190
		color: "white"
		radius: isNxt ? 5 : 4
		border.color: "black"
			border.width: isNxt ? 3 : 2
		anchors {
			top:		listviewContainer1.top
			left:   	mytext1.left
		}

		Component {
			id: aniDelegate2
			Item {
				width: isNxt ? (parent.width-20) : (parent.width-16)
				height: isNxt ? 22 : 18
				Text {
					id: tst
					text: name
					font.pixelSize: isNxt ? 18:14
				}
			}
		}

		ListModel {
				id: model2
		}


		ListView {
			id: listview2
			anchors {
				top: parent.top
				topMargin:isNxt ? 20 : 16
				leftMargin: isNxt ? 12 : 9
				left: parent.left
			}
			width: parent.width
			height: isNxt ? (parent.height-50) : (parent.height-40)
			model:model2
			delegate: aniDelegate
			highlight: Rectangle { 
				color: "lightsteelblue"; 
				radius: isNxt ? 5 : 4
			}
			focus: true
		}
	}


/////////////////////////////////////////////////////////////////////////

	IconButton {
		id: upButton2
		anchors {
			top: listviewContainer2.top
			left:  listviewContainer2.right
			leftMargin : isNxt? 3 : 2
		}

		iconSource: "qrc:/tsc/up.png"
		onClicked: {
		    if (listview2.currentIndex>0){
                        listview2.currentIndex  = listview2.currentIndex -1
            }
		}	
	}

	IconButton {
		id: downButton2
		anchors {
			bottom: listviewContainer2.bottom
			left:  listviewContainer2.right
			leftMargin : isNxt? 3 : 2

		}

		iconSource: "qrc:/tsc/down.png"
		onClicked: {
		    if (numberofItems>=listview2.currentIndex){
                        listview2.currentIndex  = listview2.currentIndex +1
            }
		}	
	}

	NewTextLabel {
		id: removeText
		width: isNxt ? 120 : 96;  
		height: isNxt ? 40:32
		buttonActiveColor: "lightgreen"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		buttonText:  "Verwijder"
		anchors {
			top: listviewContainer2.bottom
			left: listviewContainer2.left
			topMargin: isNxt? 5: 4
			}
		onClicked: {
			if (selectedCoinsArray[listview2.currentIndex].length >0 ){
				listview2.model.remove(listview2.currentIndex)
				selectedCoinsArray.splice(listview2.currentIndex, 1);
			}
		}
	}
	
	Column {
		id: columnContainer2
		width: parent.width
		anchors {
			bottom: parent.bottom
			bottomMargin: isNxt ? 8:6
			left:parent.left
			leftMargin: isNxt ? 8:6
		}
		
		Text {font.pixelSize: isNxt ? 12:10; font.family: qfont.semiBold.name; text:"All rights reserved. Nor TSC Team or the writer of this app can be held repsonsible for the correctness of all or parts of data data discplayed." }
		Text {font.pixelSize: isNxt ? 12:10; font.family: qfont.semiBold.name; text:"For correct data and values we would like to refer to the official datasources. Please use the internet to find so." }
	}
}




