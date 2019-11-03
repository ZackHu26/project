<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <meta http-equiv="X-UA-Compatible" content="IE=edge">

	    <title>CryptoTrade</title>
	    <script src="scripts.js"></script>
	    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>

	    <!-- Bootstrap CSS CDN -->
	    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">

		<link rel="stylesheet" type="text/css" href="style.css?version=0">	

		
	</head>
	<body>

    	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js" integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm" crossorigin="anonymous"></script>

		<div class="wrapper">
			<nav class="navbar navbar-expand-lg navbar-light bg-light mynav">
	  			<a class="navbar-brand" href="#home">CryptoTrade</a>
			  	<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
			    	<span class="navbar-toggler-icon"></span>
			  	</button>
			  	<div class="collapse navbar-collapse" id="navbarNav">
		    		<ul class="navbar-nav">
			      		<li class="nav-item">
			        		<a class="nav-link" href="trade.php">Trade</a>
					    </li>
					    <li class="nav-item">
					    	<a class="nav-link" href="#home">Leaderboard</a>
					    </li>
					    	<li class="nav-item active">
					    <a class="nav-link" href="admin.php">Admin<span class="sr-only">(current)</span></a>
					    	</li>
					    <li class="nav-item">
					    	<!--<a class="nav-link disabled" href="#">Disabled</a>-->
					    </li>
		    		</ul>
	  			</div>
			</nav>
			
			<div class="container-fluid">
				<div class="row myrow" >
					<div class="col-md-2 mycol" align="Left">
						<div class="compORuser" style="padding-left:50px; background-color:white;" >
						<ul class="nav  flex-column" style=" padding-bottom:10px;">
							<li class="nav-item" style="width:100%; color:black;">
							<a class="nav-link" href="admin.php">Competitions</a></li>
							<li class="nav-item" style="width: 100%; color:black;">
							<a class="nav-link" href="adminUsers.php">Users</a></li>
						</ul>
						</div>
					</div>
					<div class="col-lg-10" align="left">
						<div class="competitions">
							<div class="col-md-9" align="left">
								<table class="dbfromcomp">
									<thead>
										<tr>
											<th>ID</th>
											<th>Hash</th>
											<th>Salt</th>
											<th>isAdmin</th>
											<th>Email</th>
											<th>Name</th>
											<th>isDisabled</th>
											<th>competitionID</th>
										</tr>
									</thead>
									<tbody>
									<?php
									include_once('MySQL.php');
									include_once('const.db.php');
	
									$mysql = new MySQL(DB_HOST, DB_USER, DB_PASS, DB_DB);

									// Check connection
									if ($mysql->connection()==null) {
									    die("Connection failed: " . $mysql.connection());
									} 

									$sql = "SELECT * FROM competitions";
									$result = $mysql->query($sql);

									if ($result->num_rows > 0) {
									    // output data of each row
									    while($row = $result->fetch_assoc()) {
									        echo "<tr><td>".$row["id"]."</td><td>".$row["hash"]."</td><td>"
											.$row["salt"]."</td><td>".$row["isAdmin"]."</td><td>".
											$row["email"]."</td><td>".$row["email"]."</td><td>".
											$row["name"]."</td><td>".$row["isDisabled"]."</td><td>".
											$row["competitionID"]."</td></tr>";
									    }
										echo "</tbody>";
									    echo "</table>";
									} else {
									    echo "0 results";
									}
									$mysql_close;
									?>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>