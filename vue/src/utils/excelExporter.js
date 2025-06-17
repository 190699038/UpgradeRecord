import ExcelJS from 'exceljs';

export const exportTaskToExcel = (data, title) => {
  const workbook = new ExcelJS.Workbook();
  const worksheet = workbook.addWorksheet('关键任务');

  // 标题行
  const titleRow = worksheet.addRow([title]);
  worksheet.mergeCells('A1:D1');
  
  // 集中设置合并单元格样式
  const titleCell = worksheet.getCell('A1');
  titleCell.font = { bold: true, size: 14, color: { argb: 'FFFFFFFF' } };
  titleCell.fill = {
    type: 'pattern',
    pattern: 'solid',
    fgColor: { argb: 'FF0070C0' }
  };
  titleCell.alignment = { vertical: 'middle', horizontal: 'center' };
  titleCell.border = {
    top: { style: 'thin' },
    left: { style: 'thin' },
    bottom: { style: 'thin' },
    right: { style: 'thin' }
  };
  

  // 表头
  const headerRow = worksheet.addRow(['序号', '当日结论']);
  // 仅在前四列应用样式
  ['A2', 'B2'].forEach(cellAddress => {
    const cell = worksheet.getCell(cellAddress);
    cell.font = { bold: true, size: 14, color: { argb: 'FFFFFFFF' } };
    cell.fill = {
      type: 'pattern',
      pattern: 'solid',
      fgColor: { argb: 'FF0070C0' }
    };
    cell.alignment = { vertical: 'middle', horizontal: 'center' };
  });

  // 数据行
  data.forEach((item, index) => {
    const row = worksheet.addRow([
      item.id,
      item.conclusion
    ]);

    // 交替行颜色
    if (index % 2 === 0) {
      row.eachCell(cell => {
        cell.fill = {
          type: 'pattern',
          pattern: 'solid',
          fgColor: { argb: 'FFF2F2F2' }
        };
      });
    }

    row.eachCell(cell => {
      // 状态条件样式
      if (item.status === '已完成') {
        cell.font = { size: 12, strike: true };
        cell.fill = {
          type: 'pattern',
          pattern: 'solid',
          fgColor: { argb: 'FFE6FFE6' }
        };
      } else {
        cell.font = { size: 12 };
      }
      cell.alignment = { 
        wrapText: true, 
        vertical: 'middle',
        horizontal: cell.col === 1 || cell.col === 3 ? 'center' : 'left'
      };
      cell.border = {
        top: { style: 'thin' },
        left: { style: 'thin' },
        bottom: { style: 'thin' },
        right: { style: 'thin' }
      };
    });
  });

  // 设置行高和列宽
  worksheet.columns = [
    { width: 15 }, // 序号
    { width: 500 }  // 当日结论
  ];

  worksheet.eachRow(row => {
    const maxLines = row.values.reduce((max, cell) => {
      const cellLines = (cell?.toString() || '').split('\n').length;
      return Math.max(max, cellLines);
    }, 1);
    row.height = maxLines * 20;
  });

  // 生成文件
  workbook.xlsx.writeBuffer().then(buffer => {
    const blob = new Blob([buffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = `关键任务_${new Date().toISOString().slice(0,10)}.xlsx`;
    link.click();
  });
};
