//11-2020
//by oepi-loepi and ToonzDev


import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0;
import FileIO 1.0

App {
		id: bitcoinApp

		property url 		tileUrl : "BitcoinTile.qml"
		property url 		tile2Url : "BitcoinTile2.qml"

		property url 		thumbnailIcon: "qrc:/tsc/BitcoinIcon.png"
		property 		  	BitcoinTile bitcoinTile
		property 		  	BitcoinTile2 bitcoinTile2

		property			BitcoinScreen  bitcoinScreen
		property url 		bitcoinScreenUrl : "BitcoinScreen.qml"
		property			BitcoinConfigScreen  bitcoinConfigScreen
		property url 		bitcoinConfigScreenUrl : "BitcoinConfigScreen.qml"
		//property url 		scraperUrl : "https://www.worldcoinindex.com/setcurrency?currency=EUR"
		property url 		scraperUrl : "https://www.worldcoinindex.com"
		property url 		imageBaseUrl : "https://www.worldcoinindex.com"
		property variant 	items
		property int 		numberofrows : 120
		property int 		numberofcolumns : 7
		property variant 	selectedCoinsArray : []
		property string		selectedTileCoin
		
		property variant 	dayTile :["","","","","","",""]
		
		property url		selectedTileUrl
		property string		selectedTileName
		property string		selectedTileValue
		property string		selectedUd1
		property string		selectedTile7d
		property string		selectedUd2
		property string		selectedTile24h
		
		property int 		cryptoSwitch:1
		
		property variant 	lastPrice : ["","","","","","","","","","","","",""]
		property bool 		cryptoDataRead : false
		property string 	tileCrypt :  ""
		property string 	tileValue :  ""
		property string 	tileLowValue : ""
		property string 	tileHighValue  : ""
		property string 	tileVol : ""
		property string 	tileKop5 : ""
		property string 	tileURL  : ""
		property string 	val : "usd"
		property string 	imageURL : "usd"
		property real 		lowValue : 0.00
		property real 		highValue : 0.00
		property real 		volumeValue : 0.00
		property string 	colourBTC : "black"
		property real 		newPrice : 0		

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

			//get the  user settings from the system file
			try {
				bitcoinSettingsJson = JSON.parse(bitcoinSettingsFile.read())
				selectedTileCoin = bitcoinSettingsJson['selectedTileCoin']
			} catch(e) {}

			try {
				bitcoinSettingsJson = JSON.parse(bitcoinSettingsFile.read())
			} catch(e) {
			}
			
			dayTile[0] = selectedTileCoin
			
			datetimeTimerFiles.running = true;
			coinTimer.running = true;
			
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
		
		function create1DArray(rows) {
		   var x = new Array(rows);
		   for (var i = 0; i < rows; i++) {
				x[i] = ""  //make it a string array

		   }
		   return x;
        }

		function init() {
			registry.registerWidget("screen", bitcoinConfigScreenUrl, this, "bitcoinConfigScreen")
			registry.registerWidget("screen", bitcoinScreenUrl, this, "bitcoinScreen")
			registry.registerWidget("tile", tileUrl, this, "bitcoinTile", {thumbLabel: qsTr("Bitcoin"), thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, baseTileSolarWeight: 10, thumbIconVAlignment: "center"})
			registry.registerWidget("tile", tile2Url, this, "bitcoinTile2", {thumbLabel: qsTr("BTC Ticker"), thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, baseTileSolarWeight: 10, thumbIconVAlignment: "center"})
		}
		
		function getURL() {
			//console.log("*******************Bitcoin app getURL started")
			var xhr2 = new XMLHttpRequest();
			xhr2.open("GET", scraperUrl, true); //check the feeds from the webpage
			xhr2.onreadystatechange = function() {
				if (xhr2.readyState === XMLHttpRequest.DONE) {
					if (xhr2.status === 200 || xhr2.status === 300  || xhr2.status === 302) {
						var response = xhr2.responseText
						var reLength = response.length
							var n10 = response.indexOf("<table id=\"myTable\" class=\"tablesorter")
							var n11 = response.indexOf("<tbody>",n10)
							response = response.substring(n11,reLength)

							if (selectedTileCoin != ""){ //fil dayTile
								dayTile[0] = selectedTileCoin
							}
							
							var newUrl
							var newCoin
							var newValue
							var newUSDEUR
							var newPerc
							var newArray = response.split("<tr class=")
							for (var x in newArray){
								//console.log("*******************Bitcoin x "  + x)
								//console.log("*******************newArray x "  + newArray[x])
								
								var search1= newArray[x].substring(1,30)
								if (search1.indexOf("coinzoeken")>0){
									var n20 = newArray[x].indexOf("url(\'") + "url(\'".length
									var n21 = newArray[x].indexOf("\')",n20)
									newUrl= imageBaseUrl + newArray[x].substring(n20,n21)
									//console.log("*******************Bitcoin [" + x + "][1]"  + x + "URL : "  + newUrl)
									
									var n30 = newArray[x].indexOf("<h1><span>") + "<h1><span>".length
									var n31 = newArray[x].indexOf("</span>",n30)
									newCoin= newArray[x].substring(n30,n31)
									//console.log("*******************Bitcoin [" + x + "][0]"  + x + "Name : "  + newCoin)
									
									
									var n40 = newArray[x].indexOf("lastprice") + "lastprice".length
									var n42 = newArray[x].indexOf("sort-value=\"", n40) + "sort-value=\"".length
									var n45 = newArray[x].indexOf("\"><span>",n42)
									
									var n47 = newArray[x].indexOf("<span>",n42)+ "<span>".length
									var n49 = newArray[x].indexOf("</span>",n47)
									newUSDEUR = newArray[x].substring(n47,n49)
									newValue= newArray[x].substring(n42,n45)
									//console.log("*******************Bitcoin [" + x + "][2]"  + x + "newUSDEUR : "  + newUSDEUR)
									//console.log("*******************Bitcoin [" + x + "][2]"  + x + "Value : "  + newValue)
									
									var n50 = newArray[x].indexOf("data-percentage") + "data-percentage".length
									var n52 = newArray[x].indexOf("<span>", n50) + "<span>".length
									var n55 = newArray[x].indexOf("</span>",n52)
									newPerc= newArray[x].substring(n52,n55)
									//console.log("*******************Bitcoin [" + x + "][3]"  + x + "Perc : "  + newPerc)
									
									if (selectedTileCoin != "" & selectedTileCoin.toLowerCase() == newCoin.toLowerCase()){ //fil dayTile
										dayTile[0] = selectedTileCoin
										dayTile[1] = newUrl
										dayTile[2] = "USD " + newValue
										if(newPerc.indexOf("-")>-1){dayTile[3] = "down"}
										//dayTile[4] = newPerc.substring(1,newValue.length)
										dayTile[4] = newPerc
									}
									
									for(var y in items){
										if (typeof items[y][0] != 'undefined'){
											if (items[y][0].length > 2  & items[y][0].toLowerCase() == newCoin.toLowerCase()){
												items[y][0] = newCoin
												items[y][1] = newUrl
												items[y][2] = "USD " + newValue
												if(newPerc.indexOf("-")>-1){items[y][3] = "down"}
												//items[y][4] = newPerc.substring(1,newPerc.length)
												items[y][4] = newPerc
											}
										}	
									}
									
								}
								
								
							}
							bitcoinUpdated()
					}else{//xhr status = 200
					   //console.log("*******************Bitcoin app website failed")
					}
				}//end of xhr2.readystate
			}//xhr onreadystate
			xhr2.send()
			
		}
		
		
		function parseCryptoinfo(cryptoTxt) {
			var cryptoJSON 	= 	JSON.parse(cryptoTxt);
			cryptoDataRead 	= 	true;
			newPrice 		= 	cryptoJSON["last"]
			tileCrypt		=	tileCrypt
			tileValue      	=	newPrice  + " " + val
			lowValue      	= 	cryptoJSON["low"]
			highValue      	= 	cryptoJSON["high"]
			volumeValue   	=	cryptoJSON["high"]
			tileLowValue    = 	"laagste: "+Math.round(lowValue)+ " " + val
			tileHighValue  	= 	"hoogste: "+Math.round(highValue)+ " " + val
			tileVol       	= 	"volume 24h: "+volumeValue
			colourBTC = "black"
			//console.log("*******************Bitcoin colourBTC old "  + colourBTC)
			//console.log("*******************Bitcoin newPrice "  + newPrice)
			//console.log("*******************Bitcoin cryptoSwitch "  + cryptoSwitch)
			//console.log("*******************Bitcoin lastPrice[cryptoSwitch] old "  + lastPrice[cryptoSwitch])

			if (newPrice > lastPrice[cryptoSwitch]){
				colourBTC = "green"
			}
			if (newPrice < lastPrice[cryptoSwitch]){
				colourBTC = "red"
			}
			lastPrice[cryptoSwitch] = newPrice
			//console.log("*******************Bitcoin colourBTC new "  + colourBTC)
			//console.log("*******************Bitcoin lastPrice[cryptoSwitch] new "  + lastPrice[cryptoSwitch])
			
		}
   
		function getcryptokoers() {
			//console.log("*******************Bitcoin app getcryptokoers started")
			tileCrypt = ""
			tileValue = "";
			tileLowValue = "Please";
			tileHighValue = "wait one";
			tileVol  = "moment";
			newPrice = "";
			tileURL = "";
			var url2
			switch (cryptoSwitch) {
				case 1: { url2 = "https://www.bitstamp.net/api/ticker" ; tileCrypt = "Bitcoin" ; val="usd"; break}
				case 2: { url2 = "https://www.bitstamp.net/api/v2/ticker/btceur" ;tileCrypt = "Bitcoin" ; val="eur" ;break}

				case 3: { url2 = "https://www.bitstamp.net/api/v2/ticker/xrpusd/" ; tileCrypt = "Ripple" ; val="usd"  ; break}
				case 4: { url2 = "https://www.bitstamp.net/api/v2/ticker/xrpeur/" ; tileCrypt = "Ripple"; val="eur"; break}
				case 5: { url2 = "https://www.bitstamp.net/api/v2/ticker/ethusd/" ; tileCrypt = "Ethereum" ; val="usd"  ; break}
				case 6: { url2 = "https://www.bitstamp.net/api/v2/ticker/etheur/" ; tileCrypt = "Ethereum"; val="eur"; break}
				case 7: { url2 = "https://www.bitstamp.net/api/v2/ticker/ltcusd/" ; tileCrypt = "Litecoin" ; val="usd"  ; break}
				case 8: { url2 = "https://www.bitstamp.net/api/v2/ticker/ltceur/" ; tileCrypt = "Litecoin"; val="eur"; break}
				case 9: { url2 = "https://www.bitstamp.net/api/v2/ticker/bchusd/" ; tileCrypt = "BitcoinCash" ; val="usd"  ; break}
				case 10: { url2 = "https://www.bitstamp.net/api/v2/ticker/bcheur/" ; tileCrypt = "BitcoinCash";val="eur"; break}
				// possible values : btcusd, btceur, eurusd, xrpusd, xrpeur, xrpbtc, ltcusd, ltceur, ltcbtc, ethusd, etheur, ethbtc, bchusd, bcheur, bchbtc
				default: {break;}
			}
			
			for(var y in items){
				if (typeof items[y][0] != 'undefined'){
					if (items[y][0].length > 1  & items[y][0].toLowerCase() == tileCrypt.toLowerCase()){
						tileURL = items[y][1]
					}
				}	
			}
			
			var xmlhttp = new XMLHttpRequest()
			xmlhttp.open("GET", url2, true)
			xmlhttp.onreadystatechange = function() {
				if (xmlhttp.readyState === XMLHttpRequest.DONE) {
					if ( xmlhttp.status === 200 ||  xmlhttp.status === 302) {
						parseCryptoinfo(xmlhttp.responseText);
					}
				}
			}
			xmlhttp.send()
		}

		Timer {
			id: datetimeTimerFiles
			interval: 15000         //update every 15 sec
			triggeredOnStart: true
			running:   false
			repeat: true
			onTriggered:  {
					cryptoSwitch++;
					if (cryptoSwitch > 10){cryptoSwitch = 1}
					getcryptokoers()
				}
		}


		Timer {
			id: coinTimer   //interval to scrape data
			interval: 60000
			triggeredOnStart: true
			running:   false
			repeat: true
			onTriggered: getURL()
		}
		
		function saveSettings() {
		
			var setJson = {
				"selectedTileCoin": selectedTileCoin
			}
			bitcoinSettingsFile.write(JSON.stringify(setJson))
			bitcoinSettingsJson = JSON.parse(bitcoinSettingsFile.read())
	
			var bitcoinsSel
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