	var symbol = "";
	var symbolb = "";
	var close;
	var open;
	var low;
	var volume;
	var symbolsAr = '[]';
	var symbols = JSON.parse(symbolsAr);
	//symbols.push({ symbol: '', price: '' })


	let toggle = true;
	var stream;
	let streams = [
    "ethusdt@miniTicker","bnbusdt@miniTicker","btcusdt@miniTicker","xrpusdt@miniTicker",
    "eosusdt@miniTicker","ltcusdt@miniTicker","linkusdt@miniTicker","trxusdt@miniTicker",
    "adausdt@miniTicker", "etcusdt@miniTicker", "neousdt@miniTicker"
  ];

  let trackedStreams = [];

  let ws = new WebSocket("wss://stream.binance.com:9443/ws/" + streams.join('/'));

  ws.onopen = function() {
      //console.log("Binance connected...");
  };

  ws.onmessage = function(evt) {
    //try {
      let msgs = JSON.parse(evt.data);
      //console.log(msgs);
      if (Array.isArray(msgs)) {
        for (let msg of msgs) {
          handleMessage(msg);
        }
      } else {
        handleMessage(msgs)
      }
  }

  ws.onclose = function() {
    console.log("Binance disconnected");
  }
  var symbol;

  function handleMessage(msg) {
    const stream = msg.s;
    //symbol = stream;
    if (document.getElementById('stream_symbol_' + stream) == null) {
    if (trackedStreams.indexOf(stream) === -1) {
		document.getElementById('streams').innerHTML += 
	    "<a class='nav-link tokenElement' vertical-align='center' id='" + stream + "' onclick=updateData(this);>" + 
	    "<li class='nav-item' vertical-align='center'>" + 
	    "<div class='row justify-content-start align-items-between'>" +
	    "<div class='col-4 tokentable' align='left' id='stream_symbol_" + stream + "'></div>" + 
	    "<div class='col-4 tokentable' align='left' id='stream_price_" + stream + "'></div>" +
	    "<div class='col-4 tokentable' align='left' id='stream_change_" + stream + "' style='padding: 0;'></div></div></li></a>";
   
    }
  	}
  	document.getElementById('stream_symbol_' + stream).innerText = stream
    document.getElementById('stream_price_' + stream).innerText = parseFloat(msg.c).toFixed((msg.c > 1000 ? 2 : (msg.c > 100 ? 3 : (msg.c > 10 ? 4 : 5))));
    document.getElementById('stream_change_' + stream).innerText = (parseFloat((msg.c-msg.o)/msg.o*100) < 0 ? parseFloat((msg.c-msg.o)/msg.o*100).toFixed(2) + "%" : "+" + parseFloat((msg.c-msg.o)/msg.o*100).toFixed(2) + "%");
    
    if (document.getElementById(stream + "symbol") != null) {
	    document.getElementById(stream + "symbol").innerText = stream;
	    document.getElementById(stream + "price").innerText = parseFloat(msg.c).toFixed((msg.c > 1000 ? 2 : (msg.c > 100 ? 3 : (msg.c > 10 ? 4 : 5))));
	    document.getElementById(stream + "change").innerText = "(" + (parseFloat((msg.c-msg.o)/msg.o*100) < 0 ? parseFloat((msg.c-msg.o)/msg.o*100).toFixed(2) + "%)" : "+" + parseFloat((msg.c-msg.o)/msg.o*100).toFixed(2) + "%)");
	    document.getElementById(stream + "volume").innerText = parseFloat(msg.q).toFixed(2);
	    document.getElementById(stream + "low").innerText = parseFloat(msg.l).toFixed((msg.l > 1000 ? 2 : (msg.l > 100 ? 3 : (msg.l > 10 ? 4 : 5))));
	    document.getElementById(stream + "high").innerText = " - " + parseFloat(msg.h).toFixed((msg.h > 1000 ? 2 : (msg.h > 100 ? 3 : (msg.h > 10 ? 4 : 5))));
	    document.getElementById(stream + "open").innerText = parseFloat(msg.o).toFixed((msg.o > 1000 ? 2 : (msg.o > 100 ? 3 : (msg.o > 10 ? 4 : 5))));
	}
	if(document.getElementById("_pos_" + stream) != null){
		document.getElementById("_pos_" + stream).innerText = parseFloat((msg.c-document.getElementById("_avg_" + stream).innerHTML)*document.getElementById("_amount_" + stream).innerHTML).toFixed(2);
		document.getElementById("_ch_" + stream).innerText = "(" + parseFloat((msg.c-document.getElementById("_avg_" + stream).innerText)/(document.getElementById("_avg_" + stream).innerText)*100).toFixed(2) + "%)";
	}
	if(document.getElementById("_pos_" + stream) != null){
		var exists = false
		for (var i = 0; i < symbols.length; i++){

			if (symbols[i]['symbol'] == stream) {
				exists = true
			}
		}
		
		if (exists == false)
			symbols.push({ symbol: stream, price: document.getElementById("_pos_" + stream).innerText });
		else {
			for (var i = 0; i < symbols.length; i++) {
		  		if (symbols[i].symbol === stream) {
		    		symbols[i].price = document.getElementById("_pos_" + stream).innerText;
		   		 break;
		  		}
			}
			//console.log(symbols.indexOf("ETHUSDT"))
			//symbols[symbols.indexOf(stream)].price = document.getElementById("_pos_" + stream).innerText;
		}
		sumPl();
	}
	
}

function updateData(msg){
	symbol = msg.id;
	console.log(symbol + "symbol");
	document.getElementById('amountsymbol').innerText = msg.id.replace("USDT", "");
	document.getElementById(symbolb + "symbol").id = symbol + "symbol";
	document.getElementById(symbolb + "price").id = symbol + "price";
	document.getElementById(symbolb + "low").id = symbol + "low";
	document.getElementById(symbolb + "high").id = symbol + "high";
	document.getElementById(symbolb + "open").id = symbol + "open";
	document.getElementById(symbolb + "volume").id = symbol + "volume";
	document.getElementById(symbolb + "change").id = symbol + "change";
	document.getElementById('symbol').value = msg.id.replace("USDT", "");
	symbolb = msg.id;


	if (toggle === true){
		makeChart(msg.id);	
	}
}

function toggleChart(){
	
	if (toggle == true){
		toggle = false;
		document.getElementById('toggle').className = "btn btn-danger";
		document.getElementById('toggle').innerText = "Unlock Chart";
	}
	else{
		toggle = true;
		document.getElementById('toggle').className = "btn btn-success";
		document.getElementById('toggle').innerText = "Lock Chart";
	}
}

$(document).ready( function () {
	updateBalance();
	updatePositions();
	$('form').submit( function () {
		var side = $(document.activeElement).attr('id');
		var symbol = $("input#symbol").val();
		var amount = $("input#amount").val();
		if (side == 'close') {
			symbol = $(document.activeElement).attr('name');
		}
		var data = 'side='+ side + '&symbol=' + symbol + '&amount=' + amount;
		console.log(data);
		console.log(side + " " +symbol + " " + amount);
		$.ajax({
		    type: "POST",
		    url: "order.php",
		    data: data,
			success: function(json) {
       			$('#notification').show();
       			$('#amount').val('');
       			if (side == 'close') {
       				$('#_id_' + symbol).remove();
       				for (var i = 0; i < symbols.length; i++) {
				  		if (symbols[i].symbol === symbol + "USDT") {
				    		symbols[i].price = 0
				   		 break;
				  		}
					}
       			}
       			updatePositions();
		 	}
		});
		return false;
	});
});

function updatePositions(){
	$.getJSON('positionTable.php', function(data) {
	    $.each(data, function(index, array) {
	    	if (document.getElementById('_symbol_' + array['symbol']) == null) {
		        document.getElementById('positionTable').innerHTML += 
		        "<tr id='_id_" + array['symbol'] + "' class='tokenElement'><td style='width: 15%;' id='_symbol_" + array['symbol']  + 
		        "'>" + array['symbol'] + "</td><td id='_amount_" + array['symbol'] + 
		        "USDT'>" + array['amount'] + "</td><td id='_avg_" + array['symbol'] + "USDT'>" + array['avgPrice'] + 
			 	"</td><td><span id='_pos_" + array['symbol'] + "USDT'>-.--</span> USD <span id='_ch_" + array['symbol'] + 
			 	"USDT'></span></td><td align='right'  style='width:50px;'><input type='hidden' value='" + array['symbol'] + 
			 	"id='_symbol2'><button style='width:30px;' id='close' name='" + array['symbol'] + 
			 	"'type='submit' class='btn btn-outline-light'>x</button></td></tr>";
			 }
			 else{
			 	if (array['avgPrice'] != null) {
				 	document.getElementById('_symbol_' + array['symbol']).innerText = array['symbol'];
				 	document.getElementById('_amount_' + array['symbol'] + "USDT").innerText = array['amount'];
				 	document.getElementById('_avg_' + array['symbol'] + "USDT").innerText  = array['avgPrice'];
				}
				else
					document.getElementById('_id_' + array['symbol']).remove();
		
			}
	    });

	});
}

function updateBalance(){
	$.getJSON('accountInfo.php', function(data) {
		document.getElementById('balance').innerText = data;
	});
}

function sumPl(){
	var length = symbols.length;
	var count = 0;
	var openPl = 0;
	
	for (var pl of symbols) {
		//console.log(pl)
		if (pl.price != null){
			count++
			openPl += parseFloat(pl.price)
			console.log(symbols)
		}
	}

	document.getElementById('openPl').innerText = openPl.toFixed(2);
}
