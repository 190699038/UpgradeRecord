import * as XLSX from 'xlsx';
import { saveAs } from 'file-saver';

export const exportUpdateListToExcel = (data, title, headers) => {
  const worksheetData = [headers];

  data.forEach(item => {
    const rowData = headers.map(header => {
      switch (header) {
        case '序号': return item.id;
        case '国家': return item.country;
        case '内容': return item.content;
        case '更新时间': return item.update_time;
        case '影响范围': return item.impact;
        default: return '';
      }
    });
    worksheetData.push(rowData);
  });

  const worksheet = XLSX.utils.aoa_to_sheet(worksheetData);

  // 设置列宽
  const wscols = headers.map(header => {
    const col = { wch: 30 }; // Default width
    if (header === '内容') {
      col.width = 150; // Adjust width for content column if needed
    }
    return col;
  });
  worksheet['!cols'] = wscols;

  // 设置内容列的自动换行
  for (let R = 1; R < worksheetData.length; ++R) { // Start from 1 to skip header row
    for (let C = 0; C < headers.length; ++C) {
      if (headers[C] === '内容') {
        const cellref = XLSX.utils.encode_cell({ r: R, c: C });
        if (!worksheet[cellref]) worksheet[cellref] = {};
        worksheet[cellref].s = { alignment: { wrapText: true } };
      }
    }
  }

  const workbook = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(workbook, worksheet, title);

  const excelBuffer = XLSX.write(workbook, { bookType: 'xlsx', type: 'array' });
  const blob = new Blob([excelBuffer], { type: 'application/octet-stream' });
  saveAs(blob, `${title}.xlsx`);
};