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
        $sql = "INSERT INTO {$this->table} (task_name, owner,conclusion,status,period,create_date,remark,task_fx,task_type) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([
            $data['task_name'],
            $data['owner'],
            $data['conclusion'],
            $data['status'],   
            $data['period'],
            $data['create_date'],
            $data['remark'],
            $data['task_fx'],
            $data['task_type']
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
        $sql = "UPDATE {$this->table} SET task_name=?, owner=? , conclusion=? , status=? , period=?  , remark=? , task_fx = ?, task_type = ? WHERE id=?";
        $stmt = $this->db->prepare($sql);
        $query = $stmt->execute([
            $data['task_name'],
            $data['owner'],
            $data['conclusion'],
            $data['status'],
            $data['period'],
            $data['remark'],
            $data['task_fx'],
            $data['task_type'],
            $id
        ]);

        $checkStmt = $this->db->prepare("SELECT id FROM daily_updates WHERE parent_id =? and update_date = ?");
        $checkStmt->execute([$id,date('Ymd')]);
        if ($checkStmt->fetch()) {
            $sql = "UPDATE daily_updates SET  content=? , remark=? WHERE parent_id =? and update_date = ?";
            $stmt = $this->db->prepare($sql);
            $stmt->execute([
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

        $bAddWhere = false;
        if (!empty($data['period'])) {
            $bAddWhere = true;
            $sql .= " WHERE period = ". $data['period'];        
        }
        
        if (!empty($data['type_fx'])) {
            if($bAddWhere){
                 $sql .= " AND task_fx = '". $data['type_fx']."'";  
            }else{
                 $sql .= " WHERE task_fx = '". $data['type_fx']."'";  
            }
            $bAddWhere = true;
        }
         if (!empty($data['status'])) {
             if($bAddWhere){
                 $sql .= " AND status = '". $data['status']."'";  
            }else{
                 $sql .= " WHERE status = '". $data['status']."'";  
            }
            $bAddWhere = true;
        }
        
        
        $sql .= '  order by task_fx asc , id asc';
        // echo($sql);
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
    
    
    public function sendDingTalkText($data){
        
        
        $token = $data['token']; 
        $title = $data['title'];
        $content = $data['content'];
        
        $url = 'https://oapi.dingtalk.com/robot/send?access_token='.$token;

        // 3. 组装消息体
        $sendData = [
            'msgtype' => 'markdown',
            'markdown' => [
                'title' => $title,
                'text' => $content // 直接使用Markdown原生语法[4](@ref)
            ],
            'at' => [
                'atMobiles' => [],
                'isAtAll' => false
            ]
        ];
    

        // 4. 发送请求（带重试机制）
        return $this->sendRequest($url, $sendData);
        // return 'sucess';

    }
    
    
    
        // 发送HTTP请求（私有方法）
    private function sendRequest(string $url, array $data, int $retry = 2): array {
        $ch = curl_init();
        $payload = json_encode($data);
        
        curl_setopt_array($ch, [
            CURLOPT_URL => $url,
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => $payload,
            CURLOPT_HTTPHEADER => [
                'Content-Type: application/json;charset=utf-8',
                'Content-Length: ' . strlen($payload)
            ],
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT => 5
        ]);

        // 重试逻辑（应对网络波动）[2](@ref)
        while ($retry-- >= 0) {
            $response = curl_exec($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            
            if ($httpCode === 200) {
                $result = json_decode($response, true);
                if ($result['errcode'] == 0) {
                    curl_close($ch);
                    return $result; // 成功返回
                }
            }
        }
        
        curl_close($ch);
        throw new Exception("钉钉消息发送失败: " . ($response ?? '未知错误'));
    }
    

}
