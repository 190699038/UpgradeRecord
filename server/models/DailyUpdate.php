<?php

require_once 'BaseModel.php';

class DailyUpdate extends BaseModel
{
    protected $table = 'daily_updates';
    
    protected $fillable = [
        'parent_id',
        'update_date',
        'content',
        'remark'
    ];
    public function getAll() {
        // echo ($this->table);
        $stmt = $this->db->query("SELECT * FROM {$this->table}");
        $query =  $stmt->fetchAll(PDO::FETCH_ASSOC);
        return $this->returnResult($query);

    }

}