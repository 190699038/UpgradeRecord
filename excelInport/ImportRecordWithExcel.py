import pandas as pd
from datetime import datetime

def excel_to_sql(excel_path, output_sql_path):
    # 读取Excel文件
    df = pd.read_excel(excel_path, engine='openpyxl')
    
    # 初始化SQL语句列表
    sql_statements = []
    
    # 遍历DataFrame每一行
    for index, row in df.iterrows():
        # 国家代码直接使用Excel中的值
        country = str(row['国家']).strip()
        
        # 保持原始北京时间格式
        update_time = row['北京时间'].strftime('%Y-%m-%d %H:%M:%S') if pd.notnull(row['北京时间']) else 'NULL'

        # 类型字段映射
        # 类型映射（原始值 -> 标准化值）
        type_mapping = {
            'BUG修复': '类型-BUG修复-bug修复',  # 合并重复项
            '游戏': '游戏-新游戏',
            '新游戏': '游戏-新游戏',
            '新功能': '功能-新功能',
            '功能优化': '功能优化-功能优化',
            'bug修复': '类型-BUG修复-bug修复'  # 统一小写形式
        }
        type_value = type_mapping.get(str(row['类型']).strip(), '其他')

        # 平台字段标准化
        # 平台映射（原始值 -> 标准化值）
        platform_mapping = {
            'H5': '前端 - H5(前端)',
            '前端': '前端 - H5(前端)',
            '后端': '服务器(后端)',
            '服务器': '服务器(后端)',
            '数据库': '数据库(数据库)',
            '运维': '运维平台',  # 新增运维平台
            '中间件': '中间件平台'
        }
        platform = platform_mapping.get(str(row['平台']).strip(), '其他')

        # 处理是否需要复盘字段
        is_reviewer = '1' if str(row['是否需要复盘']).strip() in ['是', '需要'] else '0'

        # 构建VALUES部分（增强转义处理）
        values = f"""(
            '{country}',
            E'{row['内容'].replace("'", "''")}',
            '{update_time}',
            E'{row['更新人员'].replace("'", "''")}',
            {(f"E'{row['测试人员'].replace("'", "''")}'" 
                if pd.notnull(row['测试人员']) and str(row['测试人员']).strip() != '' else 'NULL')},
            '{type_value}',
            '{platform}',
            {(f"E'{row['复盘结论'].replace("'", "''")}'" 
                if pd.notnull(row['复盘结论']) and str(row['复盘结论']).strip() != '' else 'NULL')},
            {(f"E'{row['备注'].replace("'", "''")}'" 
                if pd.notnull(row['备注']) and str(row['备注']).strip() != '' else 'NULL')},
            {is_reviewer}
        )"""
        
        # 构建完整SQL语句
        # 字段顺序严格对齐模板
        sql = f"INSERT INTO record.upgrade_record (
            country, content, update_time, updater, tester, 
            type, platform, review_conclusion, remark, is_reviewer
        ) VALUES {values};"
        sql_statements.append(sql)
    
    # 将SQL语句写入文件
    with open(output_sql_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(sql_statements))
    
    print(f"已生成 {len(sql_statements)} 条SQL语句到 {output_sql_path}")

if __name__ == "__main__":
    try:
        # 自动安装依赖库
        try:
            import pandas as pd
            from openpyxl import load_workbook
        except ImportError:
            import subprocess
            subprocess.check_call(['pip', 'install', 'pandas', 'openpyxl'])
            import pandas as pd
            
        excel_file = '巴西升级和复盘记录.xlsx'
        output_file = f'upgrade_records_{datetime.now().strftime("%Y%m%d%H%M%S")}.sql'
        excel_to_sql(excel_file, output_file)
        
    except Exception as e:
        print(f"错误发生: {str(e)}")
        input("按任意键退出...")
