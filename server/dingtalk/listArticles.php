<?php
require __DIR__ . '/DingTalkClient.php';

try {
    // 检查spaceId参数
    if (empty($_GET['spaceId'])) {
        throw new Exception('缺少必要参数: spaceId');
    }
    
    $spaceId = $_GET['spaceId'];
    $client = new DingTalkClient();
    $articles = $client->listKnowledgeArticles($spaceId);
    
    // 处理返回数据
    $result = [];
    if (isset($articles['items'])) {
        foreach ($articles['items'] as $article) {
            $result[] = [
                'articleId' => $article['articleId'],
                'title' => $article['title'],
                'summary' => $article['summary'] ?? '',
                'creator' => $article['creator'] ?? '',
                'modified' => $article['modified'] ?? 0
            ];
        }
    }
    
    header('Content-Type: application/json');
    echo json_encode($result);
} catch (Exception $e) {
    header('HTTP/1.1 500 Internal Server Error');
    header('Content-Type: application/json');
    echo json_encode([
        'error' => $e->getMessage()
    ]);
}    