<?php

require_once 'BaseModel.php';

class KeyTask extends BaseModel
{
    protected $table = 'key_tasks';
    
    protected $fillable = [
        'task_name',
        'owner',
        'conclusion',
        'status',
        'period',
        'create_date',
        'remark'
    ];

    protected $enumCasts = [
        'status' => ['已完成', '进行中', '已暂停']
    ];
    public function create($data) {
        $sql = "INSERT INTO {$this->table} (task_name, owner,conclusion,status,period,create_date,remark) VALUES (?, ?, ?, ?, ?, ?, ?)";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([
            $data['task_name'],
            $data['owner'],
            $data['conclusion'],
            $data['status'],   
            $data['period'],
            $data['create_date'],
            $data['remark']
        ]);
        $query = $this->db->lastInsertId();
        // echo $data['create_date'];

        $sql = "INSERT INTO daily_updates (parent_id, update_date,content,remark) VALUES (?, ?, ?, ?)";
        $stmt = $this->db->prepare($sql);

        $stmt->execute([
            $query,
            $data['create_date'],
            $data['conclusion'],
            $data['remark']
        ]);


        return $this->returnResult($query);
    }

    public function update($id, $data) {
        $sql = "UPDATE {$this->table} SET task_name=?, owner=? , conclusion=? , status=? , period=? , create_date=? , remark=? WHERE id=?";
        $stmt = $this->db->prepare($sql);
        $query = $stmt->execute([
            $data['task_name'],
            $data['owner'],
            $data['conclusion'],
            $data['status'],
            $data['period'],
            $data['create_date'],
            $data['remark'],
            $id
        ]);

        $checkStmt = $this->db->prepare("SELECT id FROM daily_updates WHERE parent_id =? and update_date = ?");
        $checkStmt->execute([$id,date('Ymd')]);
        if ($checkStmt->fetch()) {
            $sql = "UPDATE daily_updates SET update_date=?, content=? , remark=? WHERE parent_id =? and update_date = ?";
            $stmt = $this->db->prepare($sql);
            $stmt->execute([
                $data['create_date'],
                $data['conclusion'],
                $data['remark'],
                $id,
                date('Ymd'),

            ]);
        }else{
            $sql = "INSERT INTO daily_updates (parent_id, update_date,content,remark) VALUES (?, ?, ?, ?)";
            $stmt = $this->db->prepare($sql);

            $stmt->execute([
                $id,
                date('Ymd'),
                $data['conclusion'],
                $data['remark']
            ]);
        }

       

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
