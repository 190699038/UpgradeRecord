import pandas as pd
from datetime import datetime

def generate_sql_from_excel():
    try:
        # 读取Excel文件（注意实际文件名包含~$前缀）
        df = pd.read_excel('~$巴西升级和复盘记录.xlsx', engine='openpyxl')
        
        # 替换空值为空字符串
        df = df.fillna('')
        
        # 打开SQL文件准备写入
        with open('output.sql', 'w', encoding='utf-8-sig') as f:
            f.write("USE record;\n\n")
            
            for index, row in df.iterrows():
                # 字段映射和转换
                country = str(row['国家']).strip()
                content = str(row['标题']).strip().replace("'", "''")
                # 时间格式标准化
                # 处理时间格式（增加try-except避免解析失败）
                try:
                    update_time = datetime.strptime(str(row['北京时间']), "%Y-%m-%d %H:%M:%S").strftime("%Y-%m-%d")
                except ValueError:
                    update_time = datetime.strptime(str(row['北京时间']), "%Y-%m-%d %H:%M").strftime("%Y-%m-%d")
                updater = str(row['更新人员']).strip()
                
                # 类型转换
                type_mapping = {
                    '类型-BUG修复': 'bug修复',
                    '游戏-新游戏': '新游戏',
                    '功能-新功能': '新功能',
                    '功能优化-功能优化': '功能优化'
                }
                record_type = type_mapping.get(str(row['类型']).strip(), '')
                
                # 平台转换
                platform_mapping = {
                    '前端': 'H5(前端)',
                    '服务器': '服务器(后端)',
                    '数据库': '数据库(数据库)'
                }
                platform = platform_mapping.get(str(row['平台']).strip(), '')
                
                review_conclusion = str(row['评审结论']).strip().replace("'", "''")
                remark = str(row['备注']).strip().replace("'", "''")
                is_reviewer = '1' if str(row['是否需要复盘']).strip() == '是' else '0'
                
                # 构建SQL语句
                sql = f"""INSERT INTO record.upgrade_record 
                    (country, content, update_time, updater, tester, type, 
                    platform, review_conclusion, remark, is_reviewer)
                VALUES
                    ('{country}', '{content}', '{update_time}', '{updater}', '',
                    '{record_type}', '{platform}', '{review_conclusion}', '{remark}', {is_reviewer});\n"""
                
                f.write(sql)
                
        print("SQL文件生成成功！")
        
    except Exception as e:
        print(f"发生错误：{str(e)}")
        raise  # 重新抛出异常以便查看完整堆栈信息

if __name__ == "__main__":
    generate_sql_from_excel()
