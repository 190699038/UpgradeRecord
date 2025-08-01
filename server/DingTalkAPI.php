<?php
// DingTalkAPI.php
header('Access-Control-Allow-Origin: *'); // 允许跨域
header('Access-Control-Allow-Methods: GET, OPTIONS'); 
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json; charset=utf-8');

// 处理OPTIONS预检请求
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit(0);
}

// 1. 钉钉应用配置
$appKey = 'dingzuppjje8doj1mqqm'; // 替换为实际AppKey
$appSecret = '_e8KB_6fnl8Ze1pfvXS6DWy5-gVpdv_WMgtgZrFY5yric2JRiBELm6shgVx5O-r7'; // 替换为实际AppSecret
$accessToken = null;

// 2. 钉钉认证 - 获取access_token
function getAccessToken($appKey, $appSecret) {
    $url = "https://api.dingtalk.com/v1.0/oauth2/accessToken";
    $data = json_encode(['appKey' => $appKey, 'appSecret' => $appSecret]);
    
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        'Content-Length: ' . strlen($data)
    ]);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); // 测试环境可临时关闭证书验证
    
    $response = curl_exec($ch);
    if (curl_errno($ch)) {
        error_log("cURL Error: " . curl_error($ch));
    }
    curl_close($ch);
    
    $result = json_decode($response, true);
    echo($result['accessToken']);
    return $result['accessToken'] ?? null;
}

function getWorkspace($accessToken){
    
    $url = "https://api.dingtalk.com/v1.0/doc/workspaces?operatorId=GqUNTVwCXociE&includeRecent=false";
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "x-acs-dingtalk-access-token: {$accessToken}",
        "Content-Type: application/json"
    ]);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);
    
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    if (curl_errno($ch)) {
        throw new Exception("request failed: " . curl_error($ch));
    }
    curl_close($ch);

    if ($httpCode != 200) {
        throw new Exception("api return error: HTTP {$httpCode}");
    }
    return $response;
}



// 3. 读取钉钉文档
// 2. 获取用户文档工作空间（新接口）
function getDocument($operatorId, $accessToken) {
    // $url = "https://api.dingtalk.com/v2.0/wiki/mineWorkspaces?operatorId=3YxXAjQkDKV8NmNy";
    $url = "https://api.dingtalk.com/v1.0/hi-docs/".$operatorId."/content";
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "x-acs-dingtalk-access-token: {$accessToken}",
        "Content-Type: application/json"
    ]);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);
    
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    if (curl_errno($ch)) {
        throw new Exception("request failed: " . curl_error($ch));
    }
    curl_close($ch);

    if ($httpCode != 200) {
        throw new Exception("api return error: HTTP {$httpCode}");
    }
    return $response;
}

function getDocumentContent($docId, $accessToken) {
    $url = "https://oapi.dingtalk.com/document/workspace/get?access_token={$accessToken}&doc_id={$docId}";
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    
    if ($httpCode != 200) {
        throw new Exception("API请求失败，HTTP状态码: {$httpCode}");
    }
    
    $data = json_decode($response, true);
    if (isset($data['errcode']) && $data['errcode'] == 0) {
        return $data['content']; // 返回HTML或Markdown格式内容
    } else {
        var_dump($data);
        throw new Exception("获取文档失败: " . ($data['errmsg'] ?? '未知错误'));
    }
}



// 4. 前端接口路由处理
if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['docid'])) {
    try {
        // 获取AccessToken（带简单缓存）
        if (!$accessToken) {
            $accessToken = getAccessToken($appKey, $appSecret);
        }
        
        // 读取文档
        $docId = $_GET['docid'];
        // $document = getDocument($docId, $accessToken);
        $document = getWorkspace($accessToken);
        
        // 返回文档数据
        echo $document;
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['error' => $e->getMessage()]);
    }
} else {
    http_response_code(400);
    echo json_encode(['error' => '参数错误: 需提供docid']);
}
?>∂