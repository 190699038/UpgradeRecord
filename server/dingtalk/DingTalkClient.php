<?php
require __DIR__ . '/config.php';

class DingTalkClient {
    private $config;
    private $accessToken;

    public function __construct() {
        $this->config = require __DIR__ . '/config.php';
        $this->accessToken = $this->getAccessToken();
    }

    /**
     * 获取访问凭证
     */
    private function getAccessToken() {
        $cacheFile = $this->config['cache_path'] . 'access_token.json';
        echo($cacheFile);
        // 检查缓存文件是否存在且未过期
        if (file_exists($cacheFile) && time() - filemtime($cacheFile) < 7200) {
            $cacheData = json_decode(file_get_contents($cacheFile), true);
            return $cacheData['access_token'];
        }
        
        // 获取新的access_token
        $url = "https://oapi.dingtalk.com/gettoken?appkey={$this->config['app_key']}&appsecret={$this->config['app_secret']}";
        $response = $this->sendRequest($url);
        
        if (isset($response['access_token'])) {
            // 保存到缓存
            $cacheData = [
                'access_token' => $response['access_token'],
                'expire_time' => time() + 7200
            ];
            file_put_contents($cacheFile, json_encode($cacheData));
            
            return $response['access_token'];
        }
        
        throw new Exception("获取access_token失败: " . ($response['errmsg'] ?? '未知错误'));
    }

    /**
     * 发送HTTP请求
     */
    private function sendRequest($url, $method = 'GET', $data = null) {
        $ch = curl_init();
        
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
                "x-acs-dingtalk-access-token: { $this->accessToken }",
                "Content-Type: application/json"
                ]);
        
        if ($method === 'POST') {
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
            // curl_setopt($ch, CURLOPT_HTTPHEADER, [
            //     'Content-Type: application/json',
            //     'Accept: application/json'
            // ]);
        }
        
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $error = curl_error($ch);
        
        curl_close($ch);
        
        if ($error) {
            throw new Exception("请求失败: $error");
        }
        
        if ($httpCode >= 400) {
            throw new Exception("HTTP错误 $httpCode");
        }
        
        return json_decode($response, true);
    }

    /**
     * 获取知识库列表
     */
    public function listKnowledgeSpaces() {
        $url = "https://api.dingtalk.com/v1.0/knowledge/knowledgespaces/list";
        
        $data = [
            "pageSize" => 100,
            "pageIndex" => 0
        ];
        
        return $this->sendRequest($url, 'POST', $data);
    }

    /**
     * 获取知识库文章列表
     */
    public function listKnowledgeArticles($spaceId) {
        $url = "https://api.dingtalk.com/v1.0/knowledge/knowledgespaces/{$spaceId}/articles/list";
        
        $data = [
            "pageSize" => 100,
            "pageIndex" => 0
        ];
        
        return $this->sendRequest($url, 'POST', $data);
    }

    /**
     * 获取文章内容
     */
    public function getKnowledgeArticleContent($spaceId, $articleId) {
        $url = "https://api.dingtalk.com/v1.0/knowledge/knowledgespaces/{$spaceId}/articles/{$articleId}/content";
        
        return $this->sendRequest($url);
    }
}    