-- 重点任务记录表
CREATE TABLE `key_tasks` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '序号',
  `task_name` VARCHAR(100) NOT NULL COMMENT '任务名称',
  `owner` VARCHAR(50) NOT NULL COMMENT '负责人',
  `conclusion` TEXT COMMENT '结论',
  `status` ENUM('已完成','进行中','已暂停') NOT NULL COMMENT '状态',
  `period` VARCHAR(50) NOT NULL COMMENT '周期',
  `create_date` DATE NOT NULL COMMENT '创建日期',
  `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='重点任务记录表';

-- 每日重点内容更新表
CREATE TABLE `daily_updates` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '序号',
  `parent_id` INT UNSIGNED NOT NULL COMMENT '父记录ID',
  `update_date` DATE NOT NULL COMMENT '日期',
  `content` TEXT NOT NULL COMMENT '内容',
  `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
  FOREIGN KEY (`parent_id`) REFERENCES `key_tasks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='每日重点内容更新表';

-- 当日提醒内容记录表
CREATE TABLE `daily_reminders` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '序号',
  `remind_date` DATE NOT NULL COMMENT '日期',
  `content` TEXT NOT NULL COMMENT '提醒内容',
  `owner` VARCHAR(50) NOT NULL COMMENT '负责人',
  `status` ENUM('已完成','进行中','已暂停') NOT NULL COMMENT '状态',
  `period` VARCHAR(50) NOT NULL COMMENT '周期',
  `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
  FOREIGN KEY (`period`) REFERENCES `key_tasks` (`period`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='当日提醒内容记录表';
