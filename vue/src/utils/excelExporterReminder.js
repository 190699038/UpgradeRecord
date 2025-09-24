import * as XLSX from 'xlsx';
import { saveAs } from 'file-saver';

export const DailyReminderExporter = (data, title) => {
  const worksheetData = [];

  // 标题行
  worksheetData.push([title, '', '', '']); // Add title to the data array

  // 表头
  const headers = ['序号', '状态', '负责人', '当日结论'];
  worksheetData.push(headers);

  // 数据行
  data.forEach((item, index) => {
    worksheetData.push([
      item.id,
      item.status,
      item.owner,
      item.content
    ]);
  });

  const worksheet = XLSX.utils.aoa_to_sheet(worksheetData);

  // 合并标题单元格
  if (!worksheet['!merges']) worksheet['!merges'] = [];
  worksheet['!merges'].push(XLSX.utils.decode_range('A1:D1'));

  // 标题样式
  const titleCell = worksheet['A1'];
  if (titleCell) {
    if (!titleCell.s) titleCell.s = {};
    titleCell.s.font = { bold: true, sz: 14, color: { rgb: 'FFFFFFFF' } };
    titleCell.s.fill = { fgColor: { rgb: 'FF0070C0' } };
    titleCell.s.alignment = { vertical: 'center', horizontal: 'center' };
    titleCell.s.border = {
      top: { style: 'thin' },
      left: { style: 'thin' },
      bottom: { style: 'thin' },
      right: { style: 'thin' }
    };
  }

  // 表头样式
  headers.forEach((header, colIndex) => {
    const cellAddress = XLSX.utils.encode_cell({ r: 1, c: colIndex }); // Header row is 1 (0-indexed array, but 1-indexed in Excel)
    const cell = worksheet[cellAddress];
    if (cell) {
      if (!cell.s) cell.s = {};
      cell.s.font = { bold: true, sz: 14, color: { rgb: 'FFFFFFFF' } };
      cell.s.fill = { fgColor: { rgb: 'FF0070C0' } };
      cell.s.alignment = { vertical: 'center', horizontal: 'center' };
    }
  });

  // 设置列宽
  worksheet['!cols'] = [
    { wch: 15 }, // 序号
    { wch: 35 }, // 任务名称
    { wch: 20 }, // 负责人
    { wch: 108 }  // 当日结论
  ];

  // 数据行样式和自动换行
  for (let R = 2; R < worksheetData.length; ++R) { // Start from 2 to skip title and header rows
    const item = data[R - 2]; // Adjust index for data array
    for (let C = 0; C < headers.length; ++C) {
      const cellref = XLSX.utils.encode_cell({ r: R, c: C });
      if (!worksheet[cellref]) worksheet[cellref] = {};
      if (!worksheet[cellref].s) worksheet[cellref].s = {};

      // 状态条件样式
      if (item.status === '已完成') {
        worksheet[cellref].s.font = { sz: 12, strike: true };
        worksheet[cellref].s.fill = { fgColor: { rgb: 'FFE6FFE6' } };
      } else {
        worksheet[cellref].s.font = { sz: 12 };
      }

      worksheet[cellref].s.alignment = {
        wrapText: true,
        vertical: 'center',
        horizontal: (C === 0 || C === 2) ? 'center' : 'left' // 序号和负责人居中
      };

      worksheet[cellref].s.border = {
        top: { style: 'thin' },
        left: { style: 'thin' },
        bottom: { style: 'thin' },
        right: { style: 'thin' }
      };

      // 交替行颜色
      if ((R - 2) % 2 === 0) { // (R-2) because data starts from R=2
        worksheet[cellref].s.fill = { fgColor: { rgb: 'FFF2F2F2' } };
      }
    }
  }

  // 设置行高 (XLSX.js doesn't directly support row height based on content, this is a workaround)
  // This part is tricky with xlsx library, usually it's handled by Excel itself or more advanced libraries.
  // For now, we'll omit dynamic row height based on content as it's not directly supported by basic xlsx usage.

  const workbook = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(workbook, worksheet, '每日提醒');

  const excelBuffer = XLSX.write(workbook, { bookType: 'xlsx', type: 'array' });
  const blob = new Blob([excelBuffer], { type: 'application/octet-stream' });
  saveAs(blob, `每日提醒_${new Date().toISOString().slice(0,10)}.xlsx`);
};
