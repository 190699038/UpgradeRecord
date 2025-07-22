<?php
// DingTalkAPI.php
header('Access-Control-Allow-Origin: *'); // 允许所有域名跨域访问 [9,10](@ref)
header('Access-Control-Allow-Methods: GET, OPTIONS'); // 允许的请求方法
header('Access-Control-Allow-Headers: Content-Type, Authorization'); // 允许的请求头
header('Content-Type: application/json; charset=utf-8');

// 处理OPTIONS预检请求
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit(0);
}

// 1. 钉钉应用配置
$appKey = 'your_app_key'; // 替换为实际AppKey
$appSecret = 'your_app_secret'; // 替换为实际AppSecret
$accessToken = null;

// 2. 钉钉认证 - 获取access_token
function getDingTalkAccessToken($appKey, $appSecret) {
    $tokenUrl = "https://oapi.dingtalk.com/gettoken?appkey=$appKey&appsecret=$appSecret";
    $response = file_get_contents($tokenUrl);
    $result = json_decode($response, true);
    
    if ($result['errcode'] == 0) {
        return $result['access_token'];
    } else {
        http_response_code(500);
        echo json_encode(['error' => '钉钉认证失败: ' . $result['errmsg']]);
        exit;
    }
}

// 3. 读取钉钉文档
function getDingTalkDocument($docId, $accessToken) {
    $apiUrl = "https://oapi.dingtalk.com/v1.0/doc/documents/$docId";
    $options = [
        'http' => [
            'header' => "Authorization: Bearer $accessToken\r\n",
            'method' => 'GET'
        ]
    ];
    $context = stream_context_create($options);
    $response = file_get_contents($apiUrl, false, $context);
    
    if ($response === FALSE) {
        http_response_code(500);
        echo json_encode(['error' => '文档请求失败']);
        exit;
    }
    return $response;
}

// 4. 前端接口路由处理
if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['docid'])) {
    try {
        // 获取AccessToken
        if (!$accessToken) {
            $accessToken = getDingTalkAccessToken($appKey, $appSecret);
        }
        
        // 读取文档
        $docId = $_GET['docid'];
        $document = getDingTalkDocument($docId, $accessToken);
        
        // 返回文档数据
        echo $document;
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['error' => $e->getMessage()]);
    }
} else {
    http_response_code(400);
    echo json_encode(['error' => '无效请求参数']);
}
?>