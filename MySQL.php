<?php
class MySQL {
    
    private $link = null;
    private $info = array(
        'last_query' => null,
        'num_rows' => null,
        'insert_id' => null
    );
    private $connection_info = array();
    
    private $where;
    private $limit;
    private $join;
    private $order;
    
    function __construct($host, $user, $pass, $db){
        $this->connection_info = array('host' => $host, 'user' => $user, 'pass' => $pass, 'db' => $db);
    }
    
    function __destruct(){
        if($this->link instanceof mysqli_result) mysqli_close($this->link);
    }
    
    /**
    * Setter method
    */
    
    private function set($field, $value){
        $this->info[$field] = $value;
    }
    
    /**
    * Getter methods
    */
    
    public function last_query(){
        return $this->info['last_query'];
    }
    
    public function num_rows(){
        return $this->info['num_rows'];
    }
    
    public function insert_id(){
        return $this->info['insert_id'];
    }
    
    /**
    * Create or return a connection to the MySQL server.
    */
    
    private function connection(){
        if(!is_resource($this->link) || empty($this->link)){
            if(($link = mysqli_connect($this->connection_info['host'], $this->connection_info['user'], $this->connection_info['pass'])) && mysqli_select_db($link, $this->connection_info['db'])){
                $this->link = $link;
                mysqli_set_charset($link, 'utf8');
            }else{
                throw new Exception('Could not connect to MySQL database.');
            }
        }
        return $this->link;
    }
    
    /**
    * MySQL Where methods
    */
    
    private function __where($info, $type = 'AND'){
        $link = self::connection();
        $where = $this->where;
        foreach($info as $row => $value){
            if(empty($where)){
                $where = sprintf("WHERE `%s`='%s'", $row, mysqli_real_escape_string($link, $value));
            }else{
                $where .= sprintf(" %s `%s`='%s'", $type, $row, mysqli_real_escape_string($link, $value));
            }
        }
        $this->where = $where;
    }
    
    private function __join($table, $condition, $type = 'INNER') {
        $join = $this->join;
        $join .= " {$type} JOIN {$table} ON ";
        if(is_array($condition)) {
            foreach ($condition as $key => $cond) {
                if($key > 0) {
                    $join .= " AND ";
                }
                $join .= $cond;
            }
        } else {
            $join .= $condition;
        }
        $this->join = $join;
    }
    public function join($table, $condition) {
        self::__join($table, $condition);
        return $this;
    }
    public function leftJoin($table, $condition) {
        self::__join($table, $condition, 'LEFT');
        return $this;
    }
    public function rightJoin($table, $condition) {
        self::__join($table, $condition, 'RIGHT');
        return $this;
    }
    public function crossJoin($table, $condition) {
        self::__join($table, $condition, 'CROSS');
        return $this;
    }
    
    public function where($field, $equal = null){
        if(is_array($field)){
            self::__where($field);
        }else{
            self::__where(array($field => $equal));
        }
        return $this;
    }
    
    public function and_where($field, $equal = null){
        return $this->where($field, $equal);
    }
    
    public function or_where($field, $equal = null){
        if(is_array($field)){
            self::__where($field, 'OR');
        }else{
            self::__where(array($field => $equal), 'OR');
        }
        return $this;
    }
    
    /**
    * MySQL limit method
    */
    
    public function limit($limit){
        $this->limit = 'LIMIT '.$limit;
        return $this;
    }
    
    /**
    * MySQL Order By method
    */
    
    public function order_by($by, $order_type = 'DESC'){
        $order = $this->order;
        if(is_array($by)){
            foreach($by as $field => $type){
                if(is_int($field) && !preg_match('/(DESC|desc|ASC|asc)/', $type)){
                    $field = $type;
                    $type = $order_type;
                }
                if(empty($order)){
                    $order = sprintf("ORDER BY `%s` %s", $field, $type);
                }else{
                    $order .= sprintf(", `%s` %s", $field, $type);
                }
            }
        }else{
            if(empty($order)){
                $order = sprintf("ORDER BY `%s` %s", $by, $order_type);
            }else{
                $order .= sprintf(", `%s` %s", $by, $order_type);
            }
        }
        $this->order = $order;
        return $this;
    }
    
    /**
    * MySQL query helper
    */
    
    private function extra(){
        $extra = '';
        if(!empty($this->where)) $extra .= ' '.$this->where;
        if(!empty($this->join)) $extra .= ' '.$this->join;
        if(!empty($this->order)) $extra .= ' '.$this->order;
        if(!empty($this->limit)) $extra .= ' '.$this->limit;
        // cleanup
        $this->where = null;
        $this->join = null;
        $this->order = null;
        $this->limit = null;
        return $extra;
    }
    
    /**
    * MySQL Query methods
    */
    
    public function query($qry, $return = false){
        $link = self::connection();
        self::set('last_query', $qry);
        $result = mysqli_query($link, $qry);
        if($result instanceof mysqli_result){
            self::set('num_rows', mysqli_num_rows($result));
        }
        if($return){
            if(preg_match('/LIMIT 1/', $qry)){
                $data = mysqli_fetch_assoc($result);
                mysqli_free_result($result);
                return $data;
            }else{
                $data = array();
                while($row = mysqli_fetch_assoc($result)){
                    $data[] = $row;
                }
                mysqli_free_result($result);
                return $data;
            }
        }
        return true;
    }
    
    public function get($table, $select = '*'){
        $link = self::connection();
        if(is_array($select)){
            $cols = '';
            foreach($select as $col){
                $cols .= "{$col},";
            }
            $select = substr($cols, 0, -1);
        }
        $sql = sprintf("SELECT %s FROM %s%s", $select, $table, self::extra());
        self::set('last_query', $sql);
        if(!($result = mysqli_query($link,$sql))){
            throw new Exception('Error executing MySQL query: '.$sql.'. MySQL error '.mysqli_errno($link).': '.mysqli_error($link));
            $data = false;
        }elseif($result instanceof mysqli_result){
            $num_rows = mysqli_num_rows($result);
            self::set('num_rows', $num_rows);
            if($num_rows === 0){
                $data = false;
            }elseif(preg_match('/LIMIT 1/', $sql)){
                $data = mysqli_fetch_assoc($result);
            }else{
                $data = array();
                while($row = mysqli_fetch_assoc($result)){
                    $data[] = $row;
                }
            }
        }else{
            $data = false;
        }
        mysqli_free_result($result);
        return $data;
    }
    
    public function insert($table, $data){
        $link = self::connection();
        $fields = '';
        $values = '';
        foreach($data as $col => $value){
            $fields .= sprintf("`%s`,", $col);
            $values .= sprintf("'%s',", mysqli_real_escape_string($link, $value));
        }
        $fields = substr($fields, 0, -1);
        $values = substr($values, 0, -1);
        $sql = sprintf("INSERT INTO %s (%s) VALUES (%s)", $table, $fields, $values);
        self::set('last_query', $sql);
        if(!mysqli_query($link,$sql)){
            throw new Exception('Error executing MySQL query: '.$sql.'. MySQL error '.mysqli_errno($link).': '.mysqli_error($link));
        }else{
            self::set('insert_id', mysqli_insert_id($link));
            return true;
        }
    }
    
    public function update($table, $info){
        if(empty($this->where)){
            throw new Exception("Where is not set. Can't update whole table.");
        }else{
            $link = self::connection();
            $update = '';
            foreach($info as $col => $value){
                $update .= sprintf("`%s`='%s', ", $col, mysqli_real_escape_string($link, $value));
            }
            $update = substr($update, 0, -2);
            $sql = sprintf("UPDATE %s SET %s%s", $table, $update, self::extra());
            self::set('last_query', $sql);
            if(!mysqli_query($link,$sql)){
                throw new Exception('Error executing MySQL query: '.$sql.'. MySQL error '.mysqli_errno($link).': '.mysqli_error($link));
            }else{
                return true;
            }
        }
    }
    
    public function delete($table){
        if(empty($this->where)){
            throw new Exception("Where is not set. Can't delete whole table.");
        }else{
            $link = self::connection();
            $sql = sprintf("DELETE FROM %s%s", $table, self::extra());
            self::set('last_query', $sql);
            if(!mysqli_query($link,$sql)){
                throw new Exception('Error executing MySQL query: '.$sql.'. MySQL error '.mysqli_errno($link).': '.mysqli_error($link));
            }else{
                return true;
            }
        }
    }

    /**
    * Create event
    */

    public function createEvent($name, $timestamp, $definition){
        $link = self::connection();
        $sql = sprintf("CREATE EVENT %s ON SCHEDULE AT '%s' ON COMPLETION NOT PRESERVE ENABLE DO %s", 
            $name, $timestamp, $definition);
        self::set('last_query', $sql);
        if(!mysqli_query($link,$sql)){
            throw new Exception('Error executing MySQL query: '.$sql.'. MySQL error '.mysqli_errno($link).': '.mysqli_error($link));
        }else{
            return true;
        }
    }  
}
