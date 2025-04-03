import openpyxl
from datetime import datetime

def excel_to_sql(excel_path, sql_path,gj):
    wb = openpyxl.load_workbook(excel_path)
    sheet = wb.active
    
    sql_statements = []
    
    # 字段映射字典
    # enum('新功能', '新游戏', 'bug修复', '功能优化')	
    type_mapping = {
        'bug修复': 'BUG修复',
        '新游戏': '游戏',
        '新功能': '功能',
        '功能优化': '功能优化'
    }
    
    platform_mapping = {
        'H5': '前端',
        '服务器': '服务器',
        '数据库': '数据库'
    }
    
    for row in sheet.iter_rows(min_row=2, values_only=True):
        country = gj  # 默认巴西
        content = str(row[9])
        if(content == 'None' or content == ''):
            content = str(row[1]) or ''
            # 新增处理CHAR(10)后的内容
            if 'CHAR(10)' in content:
                parts = content.split('CHAR(10),"', 1)
                if len(parts) > 1:
                    content = parts[1].rsplit('")', 1)[0].replace('\"', '"')
            #_xlfn.CONCAT("巴西H5上线 (",TEXT(C40,"yyyy/mm/dd hh:mm:ss"),") 更新内容：",CHAR(10),"1、裂变提款限制提示语修改为当地语言")'

        if content == 'None' or content == '':
            continue

        update_time = row[2].strftime('%Y-%m-%d %H:%M:%S') if isinstance(row[2], datetime) else str(row[2])
        updater = str(row[3])
        tester =  ''
        
        # 类型处理
        original_type = str(row[4]).split('-')[-1]
        record_type = type_mapping.get(original_type, original_type)
        
        # 平台处理
        platform = platform_mapping.get(str(row[5]).split('-')[0].strip(), '其他')
        
        is_review = '1' if '是' in str(row[6]) else '0'
        review_conclusion = str(row[7]) if row[7] else ''
        remark = str(row[8]) if row[8] else ''

        
        sql = f"INSERT INTO record.upgrade_record (country, content, update_time, updater, tester, type, platform, review_conclusion, remark,is_review) VALUES ('{country}', '{content}', " \
              f"'{update_time}', '{updater}', '{tester}', '{record_type}', " \
              f"'{platform}', '{review_conclusion}', '{remark}', {is_review});"
        
        sql_statements.append(sql)
    
    with open(sql_path, 'w', encoding='utf-8') as f:
        f.write('USE record;\n\n')
        f.write('\n'.join(sql_statements))

if __name__ == '__main__':
    import os
    
    country_mapping = {
        '巴西': 'BR',
        '美国': 'US',
        '秘鲁': 'PE',
        '墨西哥': 'MX',
        '智利': 'CL'
    }
    
    data_dir = os.path.join(os.path.dirname(__file__), '历史记录数据')
    
    for filename in os.listdir(data_dir):
        if filename.endswith('.xlsx'):
            # 提取国家名称（文件名前半部分）
            country_name = filename.split('升级和复盘记录')[0]
            country_code = country_mapping.get(country_name, '')
            
            if country_code:
                excel_path = os.path.join(data_dir, filename)
                sql_path = f'output_{country_code}.sql'
                excel_to_sql(excel_path, sql_path, country_code)