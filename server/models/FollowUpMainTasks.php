<?php

require_once 'BaseModel.php';

class FollowUpMainTasks extends BaseModel
{
    protected $table = 'main_tasks';
    
    protected $fillable = [
        'task_content',
        'completion_status',
        'creation_date',
        'end_date'
    ];
    public function getAll() {
        // echo ($this->table);
        $stmt = $this->db->query("SELECT * FROM {$this->table} WHERE completion_status = 0");
        // echo("SELECT * FROM {$this->table} WHERE completion_status = 0");
        $query =  $stmt->fetchAll(PDO::FETCH_ASSOC);
        return $this->returnResult($query);

    }

    public function create($data) {
        $sql = "INSERT INTO {$this->table} (task_content,creation_date) VALUES ( ?,?)";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([
            $data['task_content'],
            date('Ymd')
        ]);
        $obj = $this->db->lastInsertId();
        return $this->returnResult($obj);
    }

    public function update($id, $data) {
        $sql = "UPDATE {$this->table} SET task_content=?, completion_status=?, end_date=? WHERE id=?";
        $stmt = $this->db->prepare($sql);
        $obj =  $stmt->execute([
            $data['task_content'],
            $data['completion_status'],
            $data['end_date'],        
            $id
        ]);
        return $this->returnResult($obj);


    }

}