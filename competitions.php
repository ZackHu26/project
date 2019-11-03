<?php
	require_once("const.db.php");
	require_once("MySQL.php");

	class Competition
	{
		private $id;
		private $desc; //description
		private $sBalance; // startBalance
		private $sTs; //starttimestamp
		private $eTs; //endtimestamp


		function __construct()
		{
			$sql = new MySQL(DB_HOST, DB_USER, DB_PASS, DB_DB);
			$id = $sql->query("SELECT `id` FROM `competitions` ORDERBY `id` DESC LIMIT 1;", true) +1 ;
		}

		public function getId(){
			return $this->id;
		}
		public function getDesc(){
			return $this->desc;
		}
		public function getsBalance(){
			return $this->sBalance;
		}
		public function getStartTime(){
			return $this->sTs;
		}
		public function getEndTime(){
			return $this->eTs;
		}
		private function setDesc($desc){
			$this->desc = $desc;
		}
		private function setStartTime($sTs){
			$this->sTs = $sTs;
		}
		public function setEndTime($eTs){
			$this->eTs = $eTs;
		}
		private function setsBalance($sBalance){
			$this->sBalance = $sBalance;
		}

	}
?>