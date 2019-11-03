

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <meta http-equiv="X-UA-Compatible" content="IE=edge">

	    <title>CryptoTrade</title>
	    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	    
	    
		<script src="scripts.js"></script>
	    <!-- Bootstrap CSS CDN -->
	    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">
		
		<link rel="stylesheet" type="text/css" href="style.css?version=0">	

		
	</head>
	<body>

    	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js" integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm" crossorigin="anonymous"></script>

		<div class="wrapper">
			<nav class="navbar navbar-expand-lg navbar-light bg-light mynav">
	  			<a class="navbar-brand" href="#">CryptoTrade</a>
			  	<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
			    	<span class="navbar-toggler-icon"></span>
			  	</button>
			  	<div class="collapse navbar-collapse" id="navbarNav">
		    		<ul class="navbar-nav">
			      		<li class="nav-item active">
			        		<a class="nav-link" href="trade.php">Trade <span class="sr-only">(current)</span></a>
					    </li>
					    <li class="nav-item">
					    	<a class="nav-link" href="#home">Leaderboard</a>
					    </li>
					    	<li class="nav-item">
					    <a class="nav-link" href="admin.php">Admin</a>
					    	</li>
					    <li class="nav-item">
					    	<!--<a class="nav-link disabled" href="#">Disabled</a>-->
					    </li>
		    		</ul>
	  			</div>
			</nav>
			
			<div class="container-fluid">
				<div class="row myrow" >
					<div class="col-lg-3 col-md-12 col-sm-12 col-xs-12 mycol" align="center">
						<div class="tileLeft tradingview_2b8a8" align="left">
							<div class="mb-1">TICKERS 
								<button class="btn btn-success" style="padding: 1px; font-size: 0.7em;" id="toggle" align='right' onclick="toggleChart();">Lock Chart</button>
							</div>
								<ul class="nav nav-pills nav-stacked">
									<li class='nav-item' style="width: 100%;">
										<div class='row tokenHeader justify-content-left align-items-between mb-1'>
											<div class='col-4' align='left' style="padding-left: 20px;">
												<b>SYMBOL</b>
											</div>
											<div class='col-4' align='left'>
												<b>LAST</b>
											</div>
											<div class='col-4' align='left' style='padding-left: 0;'>
												<b>24H</b>
											</div>
										</div>
									</li>
								</ul>
							<ul class="nav nav-pills nav-stacked tokenList">
								<div id="streams" class="order">
								</div>
							</ul>
							<div class="mt-2">
								<h2 id="symbol"></h2>
								<h2 style="font-size: 1.5em;"><span id="price"></span>
									<span id="change"></span>
								</h2>
								<div id="open"></div>
								<span id="low"></span>
								<span id="high"></span>
								<h4 style="font-size: 0.5em;" id="volume"></h4>
							</div>
							<div>
								<form action='#' id="orderForm">
									<input type="hidden" id="order" value="order">
									<input type="hidden" id="symbol" value="BTC">
									<div style="position: relative; bottom: 0px;">
										<div class="input-group mb-3 mt-3">
								  			<input autocomplete="off" class="form-control" aria-label="AMOUNT" aria-describedby="basic-addon2" id="amount">
								  			<div class="input-group-append">
								    			<span class="input-group-text" id="amountsymbol">BTC</span>
								  			</div>
										</div>
								  		<div class="form-group" style="padding: 0">
								  			<div class="row">
								  				<div class="col-6" style="padding-right: 5px;">
								  					<button type="submit" class="btn btn-success" id="buy" name="buy" value="buy">
								  						Buy
								  					</button>
								  				</div>
								  				<div class="col-6" style="padding-left: 5px;">
								  					<button type="submit" class="btn btn-danger" id="sell" name="sell" value="sell">
								  						Sell
								  					</button>
								  				</div>						  			
									  		</div>
								  		</div>
								  	</div>
								  	<div style="display: none;" class="alert alert-danger" role="alert" id="success">
									</div>
									<div style="display: none;" class="alert alert-success" role="alert" id="error">
									</div>
									<div id="value">Total value: </div>
								</form>
							</div>
						</div>
					</div>
					<div class="col-lg-9 col-md-0 col-sm-12 col-xs-12 mycol">
						<div class="tradingview_2b8a8 tileRight" id="tradingview_2b8a8">
							<script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
							<script type="text/javascript">
								makeChart("BTCUSDT");
								function makeChart(s){
									new TradingView.widget({
										"autosize": true,
										"symbol": "BINANCE:" + s,
										"interval": "3H",
										"timezone": "Etc/UTC",
										"theme": "Dark",
										"style": "1",
										"locale": "en",
										"toolbar_bg": "#f1f3f6",
										"enable_publishing": false,
										"withdateranges": true,
										"hide_side_toolbar": false,
										"allow_symbol_change": true,

										"studies": [
										  "RSI@tv-basicstudies"
										],
										"show_popup_button": true,
										"popup_width": 1000,
										"popup_height": 650,
										"container_id": "tradingview_2b8a8"
									});
								}
							</script>
						</div>
					</div>
				</div>
				<div class="row justify-content-center myrow">
					<div class="col-lg-3 col-md-12 col-sm-12 col-xs-12 mycol">
						<div class="balance">
							<div class="mb-1">ACCOUNT INFORMATION</div>
							<div style="font-size: 0.8em;">
								Equity: <span id="balance"></span> USD <br>
								Combined P/L: <span id="openPl">-.--</span> USD <br>
								Unused Margin: <span id="margin"></span> USD <br>
							</div>
						</div>
					</div>
					<div class="col-lg-9 col-md-12 col-sm-12 col-xs-12 mycol">
						<div class="tileRight">
							<div class="mb-1">POSITIONS</div>
							<form action="#">
								<table>
									<thead>
										<th style='width: 15%;'>SYMBOL</th>
										<th>AMOUNT</th>
										<th>AVGPRICE</th>
										<th>P/L</th>
										<th style="width: 50px;">CLOSE</th>
									</thead>
									<tbody id="positionTable">
									</tbody>
								</table>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>