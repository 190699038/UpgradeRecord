<?php
require __DIR__ . '/DingTalkClient.php';

try {
    // 检查参数
    if (empty($_GET['spaceId']) || empty($_GET['articleId'])) {
        throw new Exception('缺少必要参数: spaceId 或 articleId');
    }
    
    $spaceId = $_GET['spaceId'];
    $articleId = $_GET['articleId'];
    
    $client = new DingTalkClient();
    $content = $client->getKnowledgeArticleContent($spaceId, $articleId);
    
    header('Content-Type: application/json');
    echo json_encode($content);
} catch (Exception $e) {
    header('HTTP/1.1 500 Internal Server Error');
    header('Content-Type: application/json');
    echo json_encode([
        'error' => $e->getMessage()
    ]);
}    