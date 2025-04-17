<?php

require_once 'BaseModel.php';

class DailyReminder extends BaseModel
{
    protected $table = 'daily_reminders';
    
    protected $fillable = [
        'remind_date',
        'content',
        'owner',
        'status',
        'period',
        'remark'
    ];

    protected $enumCasts = [
        'status' => ['已完成', '进行中', '已暂停']
    ];

    public function create($data) {
        var_dump($data);
        $sql = "INSERT INTO {$this->table} (remind_date, content,owner,status,period ,remark) VALUES (?, ?, ?, ?, ?, ?)";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([
            $data['remind_date'],
            $data['content'],
            $data['owner'],
            $data['status'],
            $data['period'],
            $data['remark']
        ]);
        $query = $this->db->lastInsertId();
        return $this->returnResult($query);
    }

    public function update($id, $data) {
        $sql = "UPDATE {$this->table} SET remind_date=?, content=? , owner=? , status=? ,period=?,  remark=? WHERE id=?";
        $stmt = $this->db->prepare($sql);
        $query = $stmt->execute([
            $data['remind_date'],
            $data['content'],
            $data['owner'],
            $data['status'],
            $data['period'],
            $data['remark'],
            $id
        ]);

        return $this->returnResult($query);

    }

    public function list($data) {
        $sql = "SELECT * FROM {$this->table}";
        $params = [];
        $conditions = [];

        if (!empty($data['period'])) {
            $sql .= " WHERE period = ". $data['period'];        
        }
        $sql .= ' order by id asc';
        $stmt = $this->db->prepare($sql);
        $stmt->execute($params);
        $result = $stmt->fetchAll(PDO::FETCH_ASSOC);
        return $this->returnResult($result);
    }

    public function getAll() {
        $stmt = $this->db->query("SELECT * FROM {$this->table}");
        $query =  $stmt->fetchAll(PDO::FETCH_ASSOC);
        return $this->returnResult($query);

    }
}