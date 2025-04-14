from turtle import pu
import pandas as pd
from datetime import datetime

def excel_to_sql(excel_path, output_file='chen_yaopu_output.sql'):
    df = pd.read_excel(excel_path, engine='openpyxl')
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('USE record;\n')
        
        for index, row in df.iterrows():
            # 处理日期格式转换
            date_str = row.iloc[0].strftime('%Y%m%d') if pd.notnull(row.iloc[0]) else 'NULL'
            purpose = str(row.iloc[2]).replace("'", "''")

            initiator = str(row.iloc[3]).replace("'", "''")
            participants = str(row.iloc[4]).replace("'", "''")
            content = str(row.iloc[5]).replace("'", "''")
        
            conclusion = '<p><strong style="color: #ff0000;">目的：xxx</strong></p><p><br></p><p>发起人：xxx</p><p><br></p><p>参会人：xxx</p><p><br></p><p><strong>结论：</strong></p>'
            conclusion = conclusion.replace("目的：xxx", '目的：'+purpose)
            conclusion = conclusion.replace("发起人：xxx",'发起人：'+ initiator)
            conclusion = conclusion.replace("参会人：xxx", '参会人：'+participants)

            array = content.split('\n')
            for i in range(len(array)):
                line = '<p>'+array[i]+'</p>'
                conclusion = conclusion + line

            screenshot_url = 'none'



            # 构建SQL语句
            sql = f"""INSERT INTO chen_yaopu_review (date, purpose, initiator, participants, content, conclusion, screenshot_url)
VALUES (
    '{date_str}',
    '{purpose}',
    '{initiator}',
    '{participants}',
    '{content}',
    '{conclusion}',
    '{screenshot_url}'
);\n"""
            f.write(sql)

if __name__ == "__main__":
    excel_to_sql('2025年-陈堯朴沟通记录.xlsx')