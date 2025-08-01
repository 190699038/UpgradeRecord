<?php
require __DIR__ . '/DingTalkClient.php';

try {
    $client = new DingTalkClient();
    $spaces = $client->listKnowledgeSpaces();
    
    // 处理返回数据
    $result = [];
    if (isset($spaces['items'])) {
        foreach ($spaces['items'] as $space) {
            $result[] = [
                'spaceId' => $space['spaceId'],
                'name' => $space['name'],
                'articleCount' => $space['articleCount'] ?? 0
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