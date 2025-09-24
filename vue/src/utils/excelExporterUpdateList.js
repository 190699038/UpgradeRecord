import ExcelJS from 'exceljs';
import { saveAs } from 'file-saver';

export const exportUpdateListToExcel = (data, title, headers) => {
  const workbook = new ExcelJS.Workbook();
  const worksheet = workbook.addWorksheet(title);

  // 设置表头
  worksheet.addRow(headers);

  // 设置数据行
  data.forEach(item => {
    const rowData = headers.map(header => {
      // 根据表头映射数据
      switch (header) {
        case '序号': return item.id;
        case '国家': return item.country;
        case '内容': return item.content;
        case '更新时间': return item.update_time;
        case '影响范围': return item.impact;
        default: return '';
      }
    });
    worksheet.addRow(rowData);
  });

  // 设置列宽
  worksheet.columns = headers.map(header => ({
    header,
    width: 20,
  }));

  // 生成Excel文件并下载
  workbook.xlsx.writeBuffer().then(buffer => {
    const blob = new Blob([buffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
    saveAs(blob, `${title}.xlsx`);
  });
};