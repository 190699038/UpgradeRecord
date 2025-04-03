-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- 主机： 127.0.0.1
-- 生成日期： 2025-04-03 10:39:57
-- 服务器版本： 10.4.32-MariaDB
-- PHP 版本： 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `record`
--

-- --------------------------------------------------------

--
-- 表的结构 `chen_yaopu_review`
--

CREATE TABLE `chen_yaopu_review` (
  `id` int(10) UNSIGNED NOT NULL COMMENT '序号',
  `date` int(11) NOT NULL COMMENT '日期',
  `purpose` text NOT NULL COMMENT '目的',
  `initiator` varchar(50) NOT NULL COMMENT '会议发起人',
  `participants` text NOT NULL COMMENT '参会人',
  `content` text NOT NULL,
  `conclusion` text NOT NULL COMMENT '结论',
  `screenshot_url` varchar(500) DEFAULT NULL COMMENT '截图地址'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='陈堯朴复盘记录';

--
-- 转存表中的数据 `chen_yaopu_review`
--

INSERT INTO `chen_yaopu_review` (`id`, `date`, `purpose`, `initiator`, `participants`, `content`, `conclusion`, `screenshot_url`) VALUES
(1, 20250403, 'AI客服(大R客服)MVP', '陈堯朴', '张纲、陈堯朴、张梁、杨杨 、梁浩', '1. AB方案，目前聚焦方案A  2. 协助 ꔷ 牵头人:张纲 ꔷ 模型设计:张梁  ꔷ 研发支持:梁浩风  ꔷ 客服数据复盘和知识库:杨杨  ꔷ 模型设计协助和评分标准、用户表单设计 - 陈堯朴  ', '1. AB方案，目前聚焦方案A  2. 协助 ꔷ 牵头人:张纲 ꔷ 模型设计:张梁  ꔷ 研发支持:梁浩风  ꔷ 客服数据复盘和知识库:杨杨  ꔷ 模型设计协助和评分标准、用户表单设计 - 陈堯朴  ', NULL),
(2, 20250403, '测试', '叶积建', '叶积建、阿萨德', '\n1. 啊\n2. 的\n3. 的\n4. 好\n\n', '<p><strong style=\"color: #ff0000;\">目的：测试</strong></p><p><br></p><p>发起人：叶积建</p><p>参会人：叶积建、阿萨德</p><p><br></p><p><strong>结论：</strong></p><p>1. 啊</p><p>2. 的</p><p>3. 的</p><p>4. 好</p><p><img src=\"http://10.10.10.95/Record/server/upload/review/rec_2_67ee42c06fd15.png\"></p>', ''),
(4, 20250403, 'xxx', 'xxx', 'xxx', '\n1. \n2. \n3. \n4. \n\n', '<p><strong style=\"color: #ff0000;\">目的：xxx</strong></p><p><br></p><p>发起人：xxx</p><p><br></p><p>参会人：xxx</p><p><br></p><p><strong>结论：</strong></p><p>1. <img src=\"http://10.10.10.95/Record/server/upload/review/rec_0_67ee462fa52ea.png\"></p><p>2. </p><p>3. </p><p>4. </p><p><br></p>', '');

-- --------------------------------------------------------

--
-- 表的结构 `review_record`
--

CREATE TABLE `review_record` (
  `id` int(10) UNSIGNED NOT NULL COMMENT '序号',
  `country` varchar(50) NOT NULL COMMENT '国家',
  `record_id` int(10) UNSIGNED NOT NULL COMMENT '关联升级记录表ID',
  `review_content` text NOT NULL COMMENT '复盘内容',
  `review_time` datetime NOT NULL COMMENT '复盘时间',
  `reviewer` varchar(50) NOT NULL COMMENT '复盘人',
  `conclusion` text NOT NULL COMMENT '复盘结论',
  `screenshot_url` varchar(500) DEFAULT NULL COMMENT '截图地址'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='复盘记录表';

--
-- 转存表中的数据 `review_record`
--

INSERT INTO `review_record` (`id`, `country`, `record_id`, `review_content`, `review_time`, `reviewer`, `conclusion`, `screenshot_url`) VALUES
(5, 'BR', 2, '1.修复部分机型不兼容支付弹窗问题\n【影响范围】：美国线上全部分包', '2025-04-02 08:07:07', '19', '%3Cp%3E%3Cstrong%20style%3D%22color%3A%20rgb(255%2C%20194%2C%20102)%3B%22%3E%3Cem%3E%26nbsp%3B%20%26nbsp%3B%20%26nbsp%3B%3C%2Fem%3E%3C%2Fstrong%3E%3C%2Fp%3E%3Cp%3E%3Cstrong%20style%3D%22color%3A%20rgb(255%2C%20194%2C%20102)%3B%22%3E%20try%20%7B%0A%26nbsp%3B%20%26nbsp%3B%20%26nbsp%3B%20%26nbsp%3B%20if%20(reviewInfo.value.id%20%3D%3D%20null%20%7C%7C%20reviewInfo.value.id%20%3D%3D%20\'\')%20%7B%0A%26nbsp%3B%20%26nbsp%3B%20%26nbsp%3B%20%26nbsp%3B%20%26nbsp%3B%20await%20api.post(\'%2Fapi.php%3Ftable%3Dreview_record%26amp%3Baction%3Dcreate\'%2C%20submitData)%3B%0A%26nbsp%3B%20%26nbsp%3B%20%26nbsp%3B%20%26nbsp%3B%20%7Delse%7B%0A%26nbsp%3B%20%26nbsp%3B%20%26nbsp%3B%20%26nbsp%3B%20%26nbsp%3B%20submitDa%3C%2Fstrong%3E%3C%2Fp%3E%3Ch1%3E%3Cspan%20style%3D%22color%3A%20rgb(255%2C%20194%2C%20102)%3B%22%3E%0A%3C%2Fspan%3E%3Cspan%20style%3D%22color%3A%20rgb(230%2C%200%2C%200)%3B%22%3Eta.id%20%3D%20reviewInfo.value.id%0A%26nbsp%3B%20%26nbsp%3B%20%26nbsp%3B%20%26nbsp%3B%20%26nbsp%3B%20%2F%2F%20await%20api.post(\'%2Fapi.php%3Ftable%3Dreview_record%26amp%3Baction%3Dupdate\'%2C%20submitData)%3B%0A%26nbsp%3B%20%26nbsp%3B%20%26nbsp%3B%20%26nbsp%3B%20%26nbsp%3B%20await%20api.put(%60%2Fapi.php%3Ftable%3Dreview_record%26amp%3Baction%3Dupdate%26amp%3Bid%3D%24%7BreviewInfo.value.id%7D%60%2C%20submitData)%3B%0A%26nbsp%3B%20%26nbsp%3B%20%26nbsp%3B%20%26nbsp%3B%20%7D%0A%26nbsp%3B%20%26nbsp%3B%20%26nbsp%3B%20%26nbsp%3B%20fetchReviewInfo()%3C%2Fspan%3E%0A%3C%2Fh1%3E%3Cp%3E%3Cbr%3E%3C%2Fp%3E%3Cp%3E%3Cstrong%3E%3Cem%3E1.%E4%BF%AE%E5%A4%8D%E9%83%A8%E5%88%86%E6%9C%BA%E5%9E%8B%E4%B8%8D%E5%85%BC%E5%AE%B9%E6%94%AF%E4%BB%98%E5%BC%B9%E7%AA%97%E9%97%AE%E9%A2%98%3C%2Fem%3E%3C%2Fstrong%3E%3C%2Fp%3E%3Cp%3E%3Cstrong%3E%3Cem%3E%E3%80%90%E5%BD%B1%E5%93%8D%E8%8C%83%E5%9B%B4%E3%80%91%EF%BC%9A%E7%BE%8E%E5%9B%BD%E7%BA%BF%E4%B8%8A%E5%85%A8%E9%83%A8%E5%88%86%E5%8C%85%3C%2Fem%3E%3C%2Fstrong%3E%3C%2Fp%3E%3Cp%3E%3Cimg%3E%3Cimg%20src%3D%22http%3A%2F%2F10.10.10.95%2FRecord%2Fserver%2Fupload%2Frec_2_67ece58ac5df6.png%22%3E%3Cimg%3E%3Cimg%3E%3Cimg%3E%3Cimg%3E%3Cimg%3E%3C%2Fp%3E%3Cp%3E%3Cbr%3E%3C%2Fp%3E%3Cp%3E%3Cimg%20src%3D%22http%3A%2F%2F10.10.10.95%2FRecord%2Fserver%2Fupload%2Frec_2_67ece5e909c8d.png%22%3E%3C%2Fp%3E%3Cp%3E%3Cbr%3E%3C%2Fp%3E%3Cp%3E%3Cbr%3E%3C%2Fp%3E%3Cp%3E%3Cimg%20src%3D%22http%3A%2F%2F10.10.10.95%2FRecord%2Fserver%2Fupload%2Frec_2_67ece5f80a36f.png%22%3E%3C%2Fp%3E%3Cp%3E%3Cbr%3E%3C%2Fp%3E', ''),
(6, 'US', 4, '美国H5上线 (2025/03/27 20:20:00) 更新内容：\n1. 互导APK新增FB绑定\nꔷ 【影响范围】：h5us4dk01_001, h5us4fd01_001, h5us4mb01_001, h5us4ps01_001', '2025-04-03 02:39:11', '19', '%3Cpre%20class%3D%22ql-syntax%22%20spellcheck%3D%22false%22%3E%20const%20opsList%20%3D%20%5B%5D%3B%0A%20%20delta.ops.forEach(op%20%3D%26gt%3B%20%7B%0A%20%20%20%20if%20(op.insert%20%26amp%3B%26amp%3B%20typeof%20op.insert%20%3D%3D%3D%20\'string\')%20%7B%0A%20%20%20%20%20%20opsList.push(%7B%0A%20%20%20%20%20%20%20%20insert%3A%20op.insert%2C%0A%20%20%20%20%20%20%7D)%3B%0A%20%20%20%20%7D%0A%20%20%7D)%3B%0A%20%20delta.ops%20%3D%20opsList%3B%0A%20%20return%20delta%3B%0A%E2%80%94%E2%80%94%E2%80%94%E2%80%94%E2%80%94%E2%80%94%E2%80%94%E2%80%94%E2%80%94%E2%80%94%E2%80%94%E2%80%94%E2%80%94%E2%80%94%E2%80%94%E2%80%94%0A%3C%2Fpre%3E%3Cp%3E%3Cbr%3E%3C%2Fp%3E%3Cp%3E%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%E7%89%88%E6%9D%83%E5%A3%B0%E6%98%8E%EF%BC%9A%E6%9C%AC%E6%96%87%E4%B8%BA%E5%8D%9A%E4%B8%BB%E5%8E%9F%E5%88%9B%E6%96%87%E7%AB%A0%EF%BC%8C%E9%81%B5%E5%BE%AA%20CC%204.0%20BY-SA%20%E7%89%88%E6%9D%83%E5%8D%8F%E8%AE%AE%EF%BC%8C%E8%BD%AC%E8%BD%BD%E8%AF%B7%E9%99%84%E4%B8%8A%E5%8E%9F%E6%96%87%E5%87%BA%E5%A4%84%E9%93%BE%E6%8E%A5%E5%92%8C%E6%9C%AC%E5%A3%B0%E6%98%8E%E3%80%82%3C%2Fp%3E%3Cp%3E%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C%2Fp%3E%3Cp%3E%E5%8E%9F%E6%96%87%E9%93%BE%E6%8E%A5%EF%BC%9Ahttps%3A%2F%2Fblog.csdn.net%2Fxh17864388739%2Farticle%2Fdetails%2F115381533%3Cimg%20src%3D%22http%3A%2F%2F10.10.10.95%2FRecord%2Fserver%2Fupload%2Frec_4_67edf43a295a7.png%22%3E%3C%2Fp%3E%3Cp%3E%3Cbr%3E%3C%2Fp%3E%3Cp%3E%3Cbr%3E%3C%2Fp%3E%3Cp%3E%3Cbr%3E%3C%2Fp%3E%3Cp%3E%3Cbr%3E%3C%2Fp%3E%3Cp%3E%3Cbr%3E%3C%2Fp%3E', ''),
(7, 'US', 5, '新增15个PP游戏33333', '2025-04-03 08:17:02', '19', '%3Cp%3Easdf%20%3Cimg%20src%3D%22http%3A%2F%2F10.10.10.95%2FRecord%2Fserver%2Fupload%2Fupdate%2Frec_5_67ee43fb51f7e.png%22%3E%3C%2Fp%3E', ''),
(8, 'US', 7, '1. Google的VIP导流到APK\n2. Facebook 应用内打开流程优化\n3. 手机注册用户解绑+删号\n4. 游戏记录前端入口打开', '2025-04-03 08:28:39', '19', '%3Cp%3E%3Cimg%20src%3D%22http%3A%2F%2F10.10.10.95%2FRecord%2Fserver%2Fupload%2Fupdate%2Frec_7_67ee464a16a95.png%22%3E%3C%2Fp%3E%3Cp%3E%3Cbr%3E%3C%2Fp%3E%3Cp%3E123dddddd%3C%2Fp%3E', '');

-- --------------------------------------------------------

--
-- 表的结构 `upgrade_record`
--

CREATE TABLE `upgrade_record` (
  `id` int(10) UNSIGNED NOT NULL COMMENT '序号',
  `country` varchar(50) NOT NULL COMMENT '国家',
  `content` text NOT NULL COMMENT '升级内容',
  `update_time` datetime NOT NULL COMMENT '更新时间(北京时间)',
  `updater` varchar(50) NOT NULL COMMENT '更新人',
  `tester` varchar(50) NOT NULL COMMENT '测试人员',
  `type` enum('新功能','新游戏','bug修复','功能优化') NOT NULL COMMENT '类型',
  `platform` enum('前端','后端','前后端','数据库') NOT NULL COMMENT '前后端',
  `is_review` int(1) NOT NULL DEFAULT 0,
  `review_conclusion` text DEFAULT NULL COMMENT '复盘结论',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='升级记录表';

--
-- 转存表中的数据 `upgrade_record`
--

INSERT INTO `upgrade_record` (`id`, `country`, `content`, `update_time`, `updater`, `tester`, `type`, `platform`, `is_review`, `review_conclusion`, `remark`) VALUES
(2, 'BR', '333333333', '2025-04-01 09:59:58', '王子腾、梁嘉轩', '王雪斌、王然、钱星瑞', '新游戏', '前端', 1, NULL, 'https://alidocs.dingtalk.com/i/nodes/qnYMoO1rWxD1mxL4sM4ND1XBW47Z3je9?doc_type=wiki_doc'),
(4, 'US', '美国H5上线 (2025/03/27 20:20:00) 更新内容：\n1. 互导APK新增FB绑定\nꔷ 【影响范围】：h5us4dk01_001, h5us4fd01_001, h5us4mb01_001, h5us4ps01_001', '2025-04-02 08:57:26', '梁嘉轩', '王然', '新功能', '前端', 1, NULL, '无2'),
(5, 'US', '9999999999', '2025-04-03 00:00:00', '王子腾、陶俊华', '王雪斌、钱星瑞', '新游戏', '前后端', 1, NULL, '新增升级记录弹窗，在弹窗左上角，加入一个按内容填写升级记录的按钮 ，点击后弹出一个文本框，输入内容\n格式如:\nꔷ 【地区】：智利\nꔷ 【产品】：H5\nꔷ 【上线时间（当地）】：20250402 04:16\nꔷ 【上线时间（国内）】：20250402 15:16\nꔷ 【更新内容】：\n1、救济金提示和充值提现功能优化\n2、下载apk改为安装pwa\n3、侧边栏ios收藏资源替换\nꔷ 【影响范围】：全网\nꔷ 【开发人员】：陶俊华\nꔷ 【测试人员】：钱星瑞\nꔷ 【文档地址/禅道地址】: https://alidocs.dingtalk.com/i/nodes/2Amq4vjg89g7ZwGDijyrdN5RV3kdP0wQ?doc_type=wiki_doc\n\n解析文本内容 \ncountry  对应 -  【地区】：智利\nupdate_time   对应 -  【上线时间（国内）】：20250402 15:16  需要转换成 2025-04-02 15:16:00\nupdater  对应- 【开发人员】：陶俊华 ， 需要重developers中匹配，develop.index(xxx) > 0 '),
(6, 'CL', '1、救济金提示和充值提现功能优化22222\n2、下载apk改为安装pwa\n3、侧边栏ios收藏资源替换', '2025-04-02 15:16:00', '陶俊华', '钱星瑞', '功能优化', '前端', 0, NULL, 'https://alidocs.dingtalk.com/i/nodes/2Amq4vjg89g7ZwGDijyrdN5RV3kdP0wQ?doc_type=wiki_doc'),
(7, 'US', '1. Google的VIP导流到APK\n2. Facebook 应用内打开流程优化\n3. 手机注册用户解绑+删号\n4. 游戏记录前端入口打开', '2025-03-27 07:00:00', '王子腾、陶俊华、梁嘉轩', '钱星瑞、王雪斌', '新功能', '前后端', 1, NULL, 'https://alidocs.dingtalk.com/i/nodes/XPwkYGxZV3R2Lmbks0glZx6eWAgozOKL?doc_type=wiki_doc&iframeQuery=utm_source=portal&utm_medium=portal_recent&rnd=0.4290080201405644');

-- --------------------------------------------------------

--
-- 表的结构 `user`
--

CREATE TABLE `user` (
  `id` int(10) UNSIGNED NOT NULL COMMENT '序号',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `position` varchar(100) NOT NULL COMMENT '岗位'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户信息表';

--
-- 转存表中的数据 `user`
--

INSERT INTO `user` (`id`, `username`, `position`) VALUES
(3, '梁嘉轩', '前端'),
(4, '王子腾', '前端'),
(5, '陶俊华', '前端'),
(6, '曹方毅', '服务端/数据库'),
(7, '郑燕飞', '数据库'),
(8, '谢国良', '服务端'),
(9, '帅维城', '前端'),
(10, '陈苏熙', '前端/服务端'),
(11, '李欣', '服务端'),
(12, '王雪斌', '测试'),
(13, '钱星瑞', '测试'),
(14, '王然', '测试'),
(19, '张锴楠', '产品'),
(20, '张梁', '产品'),
(21, '杨楠', '产品');

--
-- 转储表的索引
--

--
-- 表的索引 `chen_yaopu_review`
--
ALTER TABLE `chen_yaopu_review`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `review_record`
--
ALTER TABLE `review_record`
  ADD PRIMARY KEY (`id`),
  ADD KEY `record_id` (`record_id`);

--
-- 表的索引 `upgrade_record`
--
ALTER TABLE `upgrade_record`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `chen_yaopu_review`
--
ALTER TABLE `chen_yaopu_review`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '序号', AUTO_INCREMENT=5;

--
-- 使用表AUTO_INCREMENT `review_record`
--
ALTER TABLE `review_record`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '序号', AUTO_INCREMENT=9;

--
-- 使用表AUTO_INCREMENT `upgrade_record`
--
ALTER TABLE `upgrade_record`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '序号', AUTO_INCREMENT=8;

--
-- 使用表AUTO_INCREMENT `user`
--
ALTER TABLE `user`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '序号', AUTO_INCREMENT=22;

--
-- 限制导出的表
--

--
-- 限制表 `review_record`
--
ALTER TABLE `review_record`
  ADD CONSTRAINT `review_record_ibfk_1` FOREIGN KEY (`record_id`) REFERENCES `upgrade_record` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
