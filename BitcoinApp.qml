//11-2020
//by oepi-loepi and ToonzDev


import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0;
import FileIO 1.0

App {
		id: bitcoinApp

		property url 		tileUrl : "BitcoinTile.qml"
		property url 		thumbnailIcon: "qrc:/tsc/BitcoinIcon.png"
		property 		    BitcoinTile bitcoinTile
		property			BitcoinScreen  bitcoinScreen
		property url 		bitcoinScreenUrl : "BitcoinScreen.qml"
		property			BitcoinConfigScreen  bitcoinConfigScreen
		property url 		bitcoinConfigScreenUrl : "BitcoinConfigScreen.qml"
		property url 		scraperUrl : "https://coinmarketcap.com/"
		property variant 	items
		property int 		numberofrows : 13
		property int 		numberofcolumns : 7
		property variant 	selectedCoinsArray
		property string		selectedTileCoin
		
		property variant 	dayTile :["","","","","","",""]
		
		property url		selectedTileUrl
		property string		selectedTileName
		property string		selectedTileValue
		property string		selectedUd1
		property string		selectedTile7d
		property string		selectedUd2
		property string		selectedTile24h


		property variant bitcoinSettingsJson : {
			'selectedTileCoin': ""
		}

		signal bitcoinUpdated()	
		
		FileIO {id: bitcoinSettingsFile; source: "file:///mnt/data/tsc/bitcoin_userSettings.json"}
		FileIO {id: bitcoin_selectedCoins;	source: "file:///mnt/data/tsc/appData/bitcoin_selectedCoins.txt"}

		Component.onCompleted: {
		
			var array = create2DArray(numberofrows,numberofcolumns)
			items = array
			
			try {
				var bitcoinsString = bitcoin_selectedCoins.read() ; 
				if (bitcoinsString.length >2 ){
					selectedCoinsArray = bitcoinsString.split(',')
					for (var t in selectedCoinsArray){
						if (t<= numberofrows){
							items[t][0] = (selectedCoinsArray[t]).trim()
						}
					}
				}
			} catch(e) {
			}

			//get the user settings from the system file
			try {
				bitcoinSettingsJson = JSON.parse(bitcoinSettingsFile.read())
				selectedTileCoin = bitcoinSettingsJson['selectedTileCoin']
			} catch(e) {}

			try {
				bitcoinSettingsJson = JSON.parse(bitcoinSettingsFile.read())
			} catch(e) {
			}
			
			dayTile[0] = selectedTileCoin
			
		}
		
		
		
		
		function create2DArray(rows,columns) {
		   var x = new Array(rows);
		   for (var i = 0; i < rows; i++) {
			   x[i] = new Array(columns);
				for (var c = 0; c < columns; c++) {
					x[i][c] = ""  //make it a string array
				}
		   }
		   return x;
        }

		function init() {
			registry.registerWidget("screen", bitcoinConfigScreenUrl, this, "bitcoinConfigScreen")
			registry.registerWidget("screen", bitcoinScreenUrl, this, "bitcoinScreen")
			registry.registerWidget("tile", tileUrl, this, "bitcoinTile", {thumbLabel: qsTr("Bitcoin"), thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, baseTileSolarWeight: 10, thumbIconVAlignment: "center"})
		}
		

		function getURL() {
			////console.log("*******************Bitcoin app getURL started")
			var xhr2 = new XMLHttpRequest();
			xhr2.open("GET", scraperUrl, true); //check the feeds from the webpage
			xhr2.onreadystatechange = function() {
				if (xhr2.readyState === XMLHttpRequest.DONE) {
					if (xhr2.status === 200) {
						var response = xhr2.responseText
						if (response.indexOf("<title>Cryptocurrency Prices") >0){ //it is a valid site
							if (selectedTileCoin != ""){ //fil dayTile
								dayTile[0] = selectedTileCoin
								var n10 = response.indexOf("a href=\"/currencies/" + selectedTileCoin + "/\" class=\"cmc-link\">")
								var n12 = response.indexOf("<img class=\"coin-logo\" src=\"",n10) + ("<img class=\"coin-logo\" src=\"").length
								var n14 = response.indexOf("\"",n12)
								dayTile[1] = response.substring(n12,n14)
								var n20 = response.indexOf("<a href=\"/currencies/" + selectedTileCoin , n14) + 5
								var n21 = response.indexOf("/markets/\" class=\"cmc-link\">" , n20) + ("/markets/\" class=\"cmc-link\">").length
								var n22 = response.indexOf("</a>",n21)
								dayTile[2]= response.substring(n21,n22)
								var n30 = response.indexOf("<span class=\"icon-Caret-" , n22)+ ("<span class=\"icon-Caret-").length
								var n32 = response.indexOf("\">",n30)
								dayTile[3] = response.substring(n30,n32)
								var n40 = response.indexOf("></span>" , n32) + ("></span>").length
								var n42 = response.indexOf("</span>",n40)
								dayTile[4] = response.substring(n40,n42)
								var n50 = response.indexOf("<span class=\"icon-Caret-" , n42)+ ("<span class=\"icon-Caret-").length
								var n52 = response.indexOf("\">",n50)
								dayTile[5] = response.substring(n50,n52)
								var n60 = response.indexOf("></span>" , n52) + ("></span>").length
								var n62 = response.indexOf("</span>",n60)
								dayTile[6] = response.substring(n60,n62)
							}

							for(var x in items){
								if (typeof items[x][0] != 'undefined'){
									if (items[x][0].length > 2){
										
										//console.log("*******************Bitcoin scraping for  : "  + items[x][0])

										var n10 = response.indexOf("a href=\"/currencies/" + items[x][0].toLowerCase() + "/\" class=\"cmc-link\">")
										var n12 = response.indexOf("<img class=\"coin-logo\" src=\"",n10) + ("<img class=\"coin-logo\" src=\"").length
										var n14 = response.indexOf("\"",n12)
										items[x][1] = response.substring(n12,n14)
										//console.log("*******************Bitcoin bitcoinImgUrl : "  + items[x][1])

										var n20 = response.indexOf("<a href=\"/currencies/" + items[x][0].toLowerCase() , n14) + 5
										//console.log("*******************Bitcoin n20 "  + n20)
										
										var n21 = response.indexOf("/markets/\" class=\"cmc-link\">" , n20) + ("/markets/\" class=\"cmc-link\">").length
										//console.log("*******************Bitcoin n21 "  + n21)
										var n22 = response.indexOf("</a>",n21)
										//console.log("*******************Bitcoin n22 "  + n22)
										items[x][2]= response.substring(n21,n22)
										//console.log("*******************Bitcoin " + items[x][0] + " Value : "  + items[x][2])

										var n30 = response.indexOf("<span class=\"icon-Caret-" , n22)+ ("<span class=\"icon-Caret-").length
										var n32 = response.indexOf("\">",n30)
										items[x][3] = response.substring(n30,n32)
										//console.log("*******************Bitcoin " + items[x][0] + " UpDown : "  + items[x][3])

										var n40 = response.indexOf("></span>" , n32) + ("></span>").length
										var n42 = response.indexOf("</span>",n40)
										items[x][4] = response.substring(n40,n42)
										//console.log("*******************Bitcoin " + items[x][0] + " DayChange : "  + items[x][4])

										var n50 = response.indexOf("<span class=\"icon-Caret-" , n42)+ ("<span class=\"icon-Caret-").length
										var n52 = response.indexOf("\">",n50)
										items[x][5] = response.substring(n50,n52)
										//console.log("*******************Bitcoin " + items[x][0] + " UpDownWk : "  + items[x][5])

										var n60 = response.indexOf("></span>" , n52) + ("></span>").length
										var n62 = response.indexOf("</span>",n60)
										items[x][6] = response.substring(n60,n62)
										
									}//item[x][0] is not empty
								}//item[x][0] is not undefined
						   } //for var

					   }//site is valid
					   bitcoinUpdated()
					}//xhr status = 200
				}//end of xhr2.readystate
			}//xhr onreadystate
			xhr2.send()
			
		}
		
		
		Timer {
			id: voetbalTimer   //interval to scrape data
			interval: 60000
			repeat: true
			running: true
			triggeredOnStart: false
			onTriggered: getURL()
		}
		
		function saveSettings() {
		
			var setJson = {
				"selectedTileCoin": selectedTileCoin
			}
			bitcoinSettingsFile.write(JSON.stringify(setJson))
			bitcoinSettingsJson = JSON.parse(bitcoinSettingsFile.read())
	
			var bitcoinsSel
			//if (selectedCoinsArray){
				if (typeof selectedCoinsArray[0] != 'undefined'){
					if (selectedCoinsArray[0].length > 1){
						bitcoinsSel = selectedCoinsArray[0]
						items[0][0]=selectedCoinsArray[0]
						for (var t = 1; t < selectedCoinsArray.length ; t++){
							bitcoinsSel +=	"," + selectedCoinsArray[t]
							items[t][0]=selectedCoinsArray[t].trim()
						}
					}
				}
			//}
			
			bitcoin_selectedCoins.write(bitcoinsSel)

			for (var i = 0; i < numberofrows; i++) {
				for (var c = 0; c < numberofcolumns; c++) {
					items[i][c] = "f" //empty the array
					bitcoinScreen.tileArray[i][c] = ""
				}
		    }
		   
			try {
				var bitcoinsString = bitcoin_selectedCoins.read() ; 
				if (bitcoinsString.length >2 ){
					selectedCoinsArray = bitcoinsString.split(',')
					for (var t in selectedCoinsArray){
						if (t<= numberofrows){
							items[t][0] = (selectedCoinsArray[t]).trim()
						}
					}
				}
			} catch(e) {
			}
			getURL()
			bitcoinUpdated()
		}
	}