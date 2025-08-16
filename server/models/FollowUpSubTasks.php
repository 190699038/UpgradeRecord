<?php

require_once 'BaseModel.php';

class FollowUpSubTasks extends BaseModel
{
    protected $table = 'sub_tasks';
    
    protected $fillable = [
        'parent_task_id',
        'sub_task_content',
        'sub_completion_status',
        'executor',
        'remark',
        'end_date',
        'creation_date'
    ];
    public function getAll() {
        // echo ($this->table);
        $stmt = $this->db->query("SELECT * FROM {$this->table}");
        $query =  $stmt->fetchAll(PDO::FETCH_ASSOC);
        return $this->returnResult($query);

    }

    public function list($data) {
         // 构建基础SQL查询
        $sql = "SELECT m.task_content, st.* FROM main_tasks m "
             . "JOIN {$this->table} st ON m.id = st.parent_task_id "
             . "WHERE m.completion_status = 0";
        
        $params = [];
        
        // 添加条件过滤
        if (!empty($data['creation_date'])) {
            $sql .= " AND st.creation_date = ?";
            $params[] = $data['creation_date'];
        }
        
        if (isset($data['sub_completion_status']) && $data['sub_completion_status'] >= 0) {
            $sql .= " AND st.sub_completion_status = ?";
            $params[] = $data['sub_completion_status'];
        }
        
        if (!empty($data['executor'])) {
            $sql .= " AND st.executor = ?";
            $params[] = $data['executor'];
        }
        if (!empty($data['parent_task_ids'])) {
            // 处理IN查询，支持逗号分隔的ID字符串
            $taskIds = is_array($data['parent_task_ids']) ? $data['parent_task_ids'] : explode(',', $data['parent_task_ids']);
            $taskIds = array_filter(array_map('trim', $taskIds)); // 去除空值和空格
            
            if (!empty($taskIds)) {
                $placeholders = str_repeat('?,', count($taskIds) - 1) . '?';
                $sql .= " AND st.parent_task_id IN ({$placeholders})";
                $params = array_merge($params, $taskIds);
            }
        }
        
        
        // 可选：添加排序
        // $sql .= " ORDER BY st.id DESC";
        
        // 执行查询
        $stmt = $this->db->prepare($sql);
        $stmt->execute($params);
        $result = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        return $this->returnResult($result);

    }


    public function create($data) {
        $sql = "INSERT INTO {$this->table} (parent_task_id,sub_task_content,sub_completion_status,executor,remark,creation_date) VALUES ( ?,?,?,?,?,?)";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([
            $data['parent_task_id'],
            $data['sub_task_content'],
            $data['sub_completion_status'],
            $data['executor'],
            $data['remark'],
            date('Ymd')
        ]);
        $obj = $this->db->lastInsertId();
        return $this->returnResult($obj);
    }

    public function update($id, $data) {
        $sql = "UPDATE {$this->table} SET sub_task_content=?, sub_completion_status=?, executor=?, remark=?, end_date=? WHERE id=?";
        $stmt = $this->db->prepare($sql);
        $obj =  $stmt->execute([
            $data['sub_task_content'],
            $data['sub_completion_status'],
            $data['executor'],
            $data['remark'],  
            $data['end_date'],
            $id
        ]);
        return $this->returnResult($obj);

    }
    
    //拷贝上一天的子任务
    public function copy_yesterday(){
        try {
            // 1. 查找上一次有任务的日期
            $sql = "SELECT DISTINCT creation_date FROM {$this->table} WHERE creation_date < ? ORDER BY creation_date DESC LIMIT 1";
            $stmt = $this->db->prepare($sql);
            $stmt->execute([date('Ymd')]);
            $lastDate = $stmt->fetchColumn();
            
            if (!$lastDate) {
                return $this->returnResult(null, false, '没有找到上一次的任务记录');
            }
            
            // 2. 获取上一次的所有子任务
            $sql = "SELECT * FROM {$this->table} WHERE creation_date = ?";
            $stmt = $this->db->prepare($sql);
            $stmt->execute([$lastDate]);
            $lastTasks = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            if (empty($lastTasks)) {
                return $this->returnResult(null, false, '上一次没有任务记录');
            }
            
            // 3. 复制任务到今天
            $todayDate = date('Ymd');
            $copiedCount = 0;
            
            foreach ($lastTasks as $task) {
                $sql = "INSERT INTO {$this->table} (parent_task_id, sub_task_content, sub_completion_status, executor, remark, creation_date, end_date) VALUES (?, ?, ?, ?, ?, ?, ?)";
                $stmt = $this->db->prepare($sql);
                $result = $stmt->execute([
                    $task['parent_task_id'],
                    $task['sub_task_content'],
                    0, // 任务状态设为0
                    $task['executor'],
                    $task['remark'],
                    $todayDate, // 创建日期改成今天
                    null // 结束日期设置为空
                ]);
                
                if ($result) {
                    $copiedCount++;
                }
            }
            
            return $this->returnResult([
                'copied_count' => $copiedCount,
                'source_date' => $lastDate,
                'target_date' => $todayDate
            ], true, "成功复制了 {$copiedCount} 个任务从 {$lastDate} 到 {$todayDate}");
            
        } catch (Exception $e) {
            return $this->returnResult(null, false, '复制任务失败: ' . $e->getMessage());
        }
    }

}