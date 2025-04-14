USE record;

INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '所有自研游戏引用引擎地址更换为 https://jugaslot.com/games/cocos_static_libs/cocos2d-js-min.js', '2025-03-19 16:30:00', '陈苏熙', '', 'BUG修复', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1.pp pg游戏 首充清理玩家未完成的多回合记录，防止玩家突破风控(方案优化)', '2025-03-13 20:20:00', '谢国良', '', 'BUG修复', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、轮盘，野牛，黄金派对，发财龙，野狼黄金游戏修复游戏中首充时断线重连数据未清除的bug。', '2025-03-13 20:20:00', '李欣', '', 'BUG修复', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', 'DB更新游戏内首充到账身金和免费提款额切换优化方案', '2025-03-13 16:50:00', '郑燕飞', '', '功能优化', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、修复玩家充值填写完信息后按键无反应的问题', '2025-03-07 13:47:00', '王子腾', '', 'BUG修复', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、IFrame游戏加载卡住修复', '2025-03-07 13:47:00', '陶俊华', '', '功能优化', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、成为VIP之后的流水才参与JP统计，并用于JP抽奖', '2025-02-27 15:20:00', '谢国良', '', '功能优化', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、自研游戏保存多回合数据1个月，每次进入游戏房间清理其他游戏的回合记录', '2025-02-21 15:00:00', '谢国良', '', '功能优化', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、野牛游1、pp pg游戏 首充清理玩家未完成的多回合记录，防止玩家突破风控(替换原redis scan方案)戏获得奖金额溢出问题修复', '2025-02-19 16:30:00', '谢国良', '', '功能优化', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、野牛游戏获得奖金额溢出问题修复', '2025-01-16 17:13:00', '董展(Mipawn),王子金,谢国良', '', '功能优化', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、机器人客服号可切换备份', '2025-01-16 17:13:00', '董展(Mipawn),王子金,谢国良', '', '功能优化', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、H5服务新增db连接池功能，减少转发服务压力(全量）', '2025-01-16 16:10:00', '谢国良', '', '功能优化', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、h5服务新增db连接池功能，减少转发服务压力(导入25%量）', '2025-01-15 15:30:00', '谢国良', '', '功能优化', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1.修复充值金额有小数，在游戏房间内无法到账的问题', '2025-01-13 15:00:00', '谢国良', '', 'BUG修复', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、裂变提款限制提示语修改为当地语言', '2025-01-13 16:00:00', '谢国良', '', 'BUG修复', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1. 修复crazy777游戏4次double成功后，只能获得第三次double奖励的bug。', '2025-01-02 15:30:00', '李欣', '', 'BUG修复', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、 修复与uc连接异常断开，重连过程中，写分等记录丢失问题', '2024-12-31 17:00:00', '谢国良
李欣', '', 'BUG修复', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、闪电游戏断线重连功能优化。断线后特殊状态保存缓存20秒，期间首充到账后清除缓存', '2024-12-31 15:30:00', '李欣', '', 'BUG修复', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1.新增PG游戏*18', '2024-12-27 18:00:00', '陶俊华', '', '功能优化', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、自研子游戏修复加载页不显示logo的问题', '2024-12-25 17:05:00', '陶俊华', '', '功能优化', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1.uc H5服务上线linux版本(有负载，目前导入流量10%)', '2024-12-25 17:00:00', '谢国良', '', '功能优化', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '闪电游戏特殊模式断线后保存20秒', '2024-12-24 19:30:00', '李欣', '', '游戏', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、新增PG游戏 * 6', '2024-12-20 18:16:00', '梁嘉轩
李欣
帅维城', '', '游戏', '前端', '', '', 1);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、修复PG及PP子游戏登录程序因协议解释失败，导致用户卡在登录加载页面不动的问题', '2024-12-19 14:50:00', '陈苏熙', '', '游戏', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、提款证件类型长度校验中，服务端新增CE和护照类型校验', '2024-12-17 11:26:00', '谢国良', '', '功能', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、引导用户加入TG频道曝光加强', '2024-12-16 16:10:00', '陶俊华', '', '功能', '前端', '', '', 1);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、修复发财龙倍数显示异常问题', '2024-12-15 18:50:00', '陈苏熙', '', '游戏', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、修复h5pemain登出bug
2、修复jackpot抽奖后抽奖次数不更新bug
3、PP游戏支持菜单登出', '2024-12-12 15:45:00', '董展', '', '功能优化', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '客服OA和人工切换配置，以便紧急情况下可切换', '2024-12-10 17:35:00', '董展', '', '功能优化', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '修复PP所有子游戏，IOS手机没有音效及背景音乐的问题', '2024-12-10 09:50:00', '陈苏熙', '', 'BUG修复', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、首充后余额弹窗优化。更清晰地表达各种金额的作用
2、新用户注册的引导弹框可关闭
3、用户条款增加定期重置内容', '2024-12-09 17:15:00', '董展', '', '功能', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、机器人客服上线', '2024-12-05 14:07:00', '董展', '', '功能', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、修复IOS用户无法打开支付链接的bug
2、底部裂变导航栏名字更改，展示为秘鲁', '2024-12-04 20:50:00', '谢国良', '', 'BUG修复', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、PG游戏小浣熊购买后重连无法继续旋转问题修复', '2024-12-03 17:30:00', '谢国良', '', 'BUG修复', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、修复订阅链接传参丢失的问题
2、优化诱导功能请求数据的逻辑', '2024-12-03 16:45:00', '王子腾', '', 'BUG修复', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '1、修复轮盘子游戏快速点击转动导致的数值闪现和错位问题', '2024-11-27 20:45:00', '陈苏熙', '', 'BUG修复', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '秘鲁H5上线 (2024-11-25 21:10) 更新内容：
修复用户订阅通知填备用链接时未携带userid无法成功发放奖励的BUG
', '2024-11-25 21:10:00', '王子腾', '', 'BUG修复', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '秘鲁H5上线 (2024-11-23 15:35) 更新内容：
修复子游戏 Crazy777 同时点击多个 Double 可能导致收分异常的问题
', '2024-11-23 15:35:00', '陈苏熙', '', 'BUG修复', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '秘鲁H5上线(2024-11-21 17:17)更新内容：
1、诱导 BUG 修复：进入首页后数据未及时获取导致的显示错误，奖励数值修改后提款失败导致的任务奖励错误
2、邮箱 BUG 修复：修复邮箱领取 jackpot、freecash类型邮件后，点击查看详情按钮黑屏的问题
3、自研子游戏加载页新增网页 LOGO 及加载动画
4、提款信息新增外国身份证、护照信息填写
5、第一次发起支付时新增证件信息填写
5、HOT 分类下游戏顺序调整
6、问卷 banner 下线', '2024-11-21 17:17:00', '董展
陶俊华', '', '功能优化', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '秘鲁H5上线(2024-11-21 15:35)更新内容：
自研游戏加载页增加AFVN LOGO显示，兼容不同域名', '2024-11-21 15:35:00', '陈苏熙', '', '功能优化', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '秘鲁H5上线(2024-11-21 14:50)更新内容：
修复了在PP和PG游戏中，玩家通过购买特殊模式有概率突破风控赢金币的问题', '2024-11-21 14:50:00', '谢国良
李欣', '', 'BUG修复', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '秘鲁H5上线(2024-11-20 17:47)更新内容：
PP回合服务优化：降低小倍率回合被重复随机到的概率', '2024-11-20 17:47:00', '谢国良', '', 'BUG修复', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '秘鲁H5上线(2024-11-20 14:31)更新内容：
古罗马、水果机、闪电、雷神、万圣节、轮盘、宝藏子游戏加入启动、加载、加载完成埋点事件，用于加载速率分析', '2024-11-20 14:31:00', '陈苏熙', '', '功能优化', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '秘鲁H5上线 更新内容：
linux版本子游戏房间上线.目前更新pg游戏： 1)万胜狂欢夜;2)忍者VS武侍', '2024-11-19 16:30:57', '谢国良', '', '功能', '服务器', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '秘鲁H5上线 更新内容：
秘鲁6个投放一致性机台功能上线（尚未投放）', '2024-11-18 21:30:49', '王子腾', '', '功能', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '秘鲁H5上线 更新内容：
1、PP游戏 * 180 上线（包含3款指定游戏）
2、HOT分类游戏顺序调整', '2024-11-15 21:15:00', '梁嘉轩、谢国良、李欣', '', '游戏', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '秘鲁H5上线 更新内容：
1、提款交互优化（银行卡信息和个人信息分开输入）
2、信任元素图片修改优化（加载页+主页底部）
3、流水活动阶梯数值修改
4、诱导任务2及任务3奖励修改
5、游戏模糊素材图更新
6、首页banner更新，新增【喜爱游戏问卷】和【新游预告】', '2024-11-15 17:12:00', '董展', '', '功能', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '秘鲁H5上线
pg游戏增加税收统计（差额2%），只累计，不影响用户奖励', '2024-11-15 17:30:00', '李欣', '', '功能优化', '服务器', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '秘鲁H5上线
1、新增whatsapp裂变
2、新增飞机兑换码', '2024-11-11 20:00:00', '王子腾', '', '功能', '前端', '', '', 1);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '秘鲁H5上线
1、所有提现页输入选项校验文案更新
2、dni等输入框新增失焦自动去除空格', '2024-11-11 13:40:00', '王子腾', '', '功能', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '秘鲁更新
1、JP抽奖调整(算法基本保持与巴西一致)', '2024-11-08 23:00:00', '谢国良', '', '功能', '服务器', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '秘鲁H5上线
提现信息，证件号保存时校验证件号长度，若不符合8位数字时，toast提示', '2014-11-06 16:50:00', '王子腾', '', '功能', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '秘鲁 H5 更新
1. 提现接口身份证长度8位验证(7pslot 7peslot均更新)
2. 提现接口账号长度验证 (7pslot 7peslot均更新)', '2024-11-06 17:40:00', '王子腾', '', '功能', '前端', '', '', 0);
INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('PE', '秘鲁H5 墨西哥版本迁移完成，开始投放', '2024-11-05 20:55:00', '王子腾', '', '功能', '前端', '', '', 0);