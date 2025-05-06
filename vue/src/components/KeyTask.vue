<template>
  <div class="crud-container">
    <el-button type="primary" @click="openDialog('create')">新建关键任务</el-button>
    <el-button type="primary" @click="copyKeyTasks" style="margin-left: 8px">复制任务内容</el-button>
    <!-- <el-button type="primary" @click="copyTableContent" style="margin-left: 8px">复制表格内容</el-button> -->
    <el-button type="primary" @click="copyScreenshot" style="margin-left: 8px">复制截图</el-button>
    <el-button type="primary" @click="exportToExcel" style="margin-left: 8px">导出到Excel</el-button>
    <el-select v-model="selectedWeek" placeholder="请选择周" style="margin-left: 8px; width: 240px" @change="handleWeekChange">
      <el-option v-for="week in weekOptions" :key="week.value" :label="week.label" :value="week.value" />
    </el-select>
    <el-select
      v-model="selectedStatus"
      placeholder="状态筛选"
      style="margin-left: 8px; width: 240px">
      <el-option label="全部" value="" />
      <el-option label="已完成" value="已完成" />
      <el-option label="进行中" value="进行中" />
      <el-option label="已暂停" value="已暂停" />
    </el-select>
    <el-table :data="filteredData" border stripe style="width: 100%; margin-top: 20px" :row-style="handleRowStyle"
      :cell-style="cellStyle" header-cell-class-name="table-header" class="custom-table"  :key="refreshKey">
      <el-table-column prop="id" label="序号" width="120" header-align="center" align="center" border />
      <el-table-column prop="task_name" label="任务名称" width="200" header-align="center" align="center" border />
      <el-table-column prop="owner" label="负责人" width="200" header-align="center" align="center" border />
      <el-table-column prop="conclusion" label="当日结论" border>
        <template #default="scope">
          <div style="white-space: pre-line">{{ scope.row.conclusion }}</div>
        </template>
      </el-table-column>
      <el-table-column prop="status" label="状态" header-align="center" width="90" align="center" border />
      <el-table-column prop="period" label="周期" width="100" header-align="center" align="center" border />
      <el-table-column prop="create_date" label="创建日期" width="120" header-align="center" align="center" border />
      <el-table-column label="操作" width="150" header-align="center" align="center" border>
        <template #default="scope">
          <el-button size="small" @click="openDialog('edit', scope.row)">编辑</el-button>
          <el-button size="small" type="danger" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="dialogVisible" :title="dialogTitle">
      <el-form :model="formData" label-width="100px">
        <el-form-item label="任务名称">
          <el-input v-model="formData.task_name" />
        </el-form-item>
        <el-form-item label="负责人">
          <el-input v-model="formData.owner" />
        </el-form-item>
        <el-form-item label="当日结论">
          <el-input v-model="formData.conclusion" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="formData.status">
            <el-option label="已完成" value="已完成" />
            <el-option label="进行中" value="进行中" />
            <el-option label="已暂停" value="已暂停" />
          </el-select>
        </el-form-item>
        <el-form-item label="周期">
          <el-select v-model="formData.period" placeholder="请选择周" style="margin-left: 8px; width: 240px">
            <el-option v-for="week in weekOptionsNew" :key="week.value" :label="week.label" :value="week.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="创建日期">
          <el-date-picker v-model="formData.create_date" type="date" value-format="YYYYMMDD" style="width: 240px" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="formData.remark" />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确认</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, onBeforeUnmount } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus'
// import { getKeyTasks, createKeyTask, updateKeyTask, deleteKeyTask } from '@/utils/api'
import api from '@/utils/api.js';
import { exportTaskToExcel } from '@/utils/excelExporter';
import html2canvas from 'html2canvas';

const tableData = ref([])
const dialogVisible = ref(false)
const dialogType = ref('create')
const formData = ref({
  id: '',
  task_name: '',
  owner: '',
  conclusion: '0',
  status: 1,
  period: '',
  create_date: ''
})
const refreshKey = ref(0)

const dialogTitle = computed(() => {
  return dialogType.value === 'create' ? '新增记录' : '编辑记录'
})

// 新增响应式变量
const selectedStatus = ref('')

// 更新过滤逻辑
const filteredData = computed(() => {
  return tableData.value.filter(item => {
    const weekMatch = item.period === selectedWeek.value
    const statusMatch = !selectedStatus.value || item.status === selectedStatus.value
    return weekMatch && statusMatch
  })
})
const formatPriority = (row) => {
  const map = { '3': '高', '2': '中', '1': '低' }
  return map[row.priority] || '-'
}

const selectedWeek = ref('')

const weekOptions = computed(() => {
  const weeks = []
  const today = new Date()

  // 获取当前周的周一
  const currentMonday = new Date(today)
  currentMonday.setDate(today.getDate() - today.getDay() + 1)

  // 生成前7周+当前周共8周+当前周共8周数据
  for (let i = 7; i >= 0; i--) {
    const monday = new Date(currentMonday)
    monday.setDate(currentMonday.getDate() - 7 * i)

    const year = monday.getFullYear().toString().slice(-2)
    const month = monday.getMonth() + 1
    const weekNumber = Math.ceil((monday.getDate() + 6) / 7)

    weeks.push({
      value: `${monday.getFullYear()}${String(month).padStart(2, '0')}${String(monday.getDate()).padStart(2, '0')}`,
      label: `${year}年${month}月第${weekNumber}周-${monday.getFullYear()}${String(month).padStart(2, '0')}${String(monday.getDate()).padStart(2, '0')}`
    })
  }
  return weeks
})

const weekOptionsNew = computed(() => {
  const weeks = []
  const today = new Date()

  // 获取当前周的周一
  const currentMonday = new Date(today)
  currentMonday.setDate(today.getDate() - today.getDay() + 1)

  // 生成前7周+当前周共8周+当前周共8周数据
  for (let i = 0; i < 3; i++) {
    const monday = new Date(currentMonday)
    if (i == 0) {
      monday.setDate(currentMonday.getDate() - 7)
    } else if (i == 1) {
      monday.setDate(currentMonday.getDate())
    } else if (i == 2) {
      monday.setDate(currentMonday.getDate() + 7)
    }

    const year = monday.getFullYear().toString().slice(-2)
    const month = monday.getMonth() + 1
    const weekNumber = Math.ceil((monday.getDate() + 6) / 7)

    weeks.push({
      value: `${monday.getFullYear()}${String(month).padStart(2, '0')}${String(monday.getDate()).padStart(2, '0')}`,
      label: `${year}年${month}月第${weekNumber}周-${monday.getFullYear()}${String(month).padStart(2, '0')}${String(monday.getDate()).padStart(2, '0')}`
    })
  }
  return weeks
})


const loadData = async () => {
  try {
    const response = await api.post('/api.php?table=key_tasks&action=list', {
      period: selectedWeek.value
    })
    refreshKey.value++ // 触发重新渲染
    tableData.value = response.data.data
  } catch (error) {
    ElMessage.error('获取数据失败')
  }
}

const openDialog = (type, row) => {
  dialogType.value = type
  if (type === 'edit') {
    formData.value = { ...row }
  } else {
    formData.value = {
      id: '',
      task_name: '',
      owner: '',
      conclusion: '',
      status: '2',
      period: weekOptionsNew.value[1].value,
      create_date: new Date().toISOString().slice(0, 10).replace(/-/g, '')
    }
  }
  dialogVisible.value = true
}

const submitForm = async () => {
  try {
    // 检查必填项
    console.log(formData.value);
    if (dialogType.value === 'create') {
      await api.post('/api.php?table=key_tasks&action=create', formData.value);

    } else {
      //   await updateKeyTask(formData.value.id, formData.value)
      await api.put(`/api.php?table=key_tasks&action=update&id=${formData.value.id}`, formData.value);

    }
    await loadData()
    dialogVisible.value = false
    ElMessage.success('操作成功')
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

const handleWeekChange = async (value) => {
  try {
    await loadData()
    ElMessage.success('数据已刷新')
  } catch (error) {
    ElMessage.error('刷新失败: ' + (error.message || '未知错误'))
  }}

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm('确定删除该任务？', '警告', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    // await deleteKeyTask(row.id)
    await api.delete(`/api.php?table=key_tasks&action=delete&id=${row.id}`)

    await loadData()
    ElMessage.success('删除成功')
  } catch (error) {
    ElMessage.info('取消删除')
  }
}

onMounted(() => {
  // 设置默认选中当前周
  const today = new Date()
  const currentMonday = new Date(today)
  currentMonday.setDate(today.getDate() - today.getDay() + 1)

  const year = currentMonday.getFullYear()
  const month = String(currentMonday.getMonth() + 1).padStart(2, '0')
  const day = String(currentMonday.getDate()).padStart(2, '0')

  selectedWeek.value = `${year}${month}${day}`
  loadData()
})

const cellStyle = ({ row, column }) => {
  if (column.property === 'status') {
    return {
      color: {
        '已完成': '#67c23a',
        '进行中': '#e6a23c',
        '已暂停': '#909399'
      }[row.status],
      fontWeight: 500
    }
  }
  return null;
};

const handleRowStyle = ({ row }) => {
  if (row.status === '已完成') {
    return {
      backgroundColor: '#f0f9eb',
      textDecoration: 'line-through'
    }
  }
  return null
}

const convertToChinese = (num) => {
  const chineseNumbers = ['一', '二', '三', '四', '五', '六', '七', '八', '九', '十', '十一', '十二', '十三', '十四', '十五', '十六', '十七', '十八', '十九', '二十', '二十一', '二十二', '二十三', '二十四', '二十五', '二十六'];
  return num <= 11 ? chineseNumbers[num - 1] || num : num;
};

const copyTableContent = async () => {
  try {
    const text = '关键任务清单：\n' + tableData.value
      .map(item => `序号: ${item.id} | 任务名称: ${item.task_name} | 负责人: ${item.owner} | 结论内容:\n${item.conclusion}`)
      .join('\n\n');

    if (navigator.clipboard) {
      await navigator.clipboard.writeText(text);
    } else {
      const textarea = document.createElement('textarea');
      textarea.value = text;
      textarea.style.position = 'fixed';
      textarea.style.left = '-9999px';
      document.body.appendChild(textarea);
      textarea.select();
      const success = document.execCommand('copy');
      document.body.removeChild(textarea);
      if (!success) throw new Error('复制失败');
    }
    ElMessage.success('表格内容复制成功');
  } catch (err) {
    console.error('复制错误:', err);
    ElMessage.error('表格复制失败: ' + (err.message || '不支持的浏览器'));
  }
};

const copyKeyTasks = async () => {
  try {
    const text = '本周重点目标进度同步:\n' + tableData.value
      .map((item, index) => `${convertToChinese(index + 1)}、${item.task_name} @${item.owner} \n当日结论：\n${item.conclusion.split('\n').map(line => `\t${line}`).join('\n')} \n`)
      .join('\n');

    // 现代浏览器剪贴板API
    if (navigator.clipboard) {
      await navigator.clipboard.writeText(text);
    } else {
      // 旧版浏览器降级方案
      const textarea = document.createElement('textarea');
      textarea.value = text;
      textarea.style.position = 'fixed';
      textarea.style.left = '-9999px';
      document.body.appendChild(textarea);
      textarea.select();

      const success = document.execCommand('copy');
      document.body.removeChild(textarea);

      if (!success) {
        throw new Error('复制失败');
      }
    }
    ElMessage.success('复制成功');
  } catch (err) {
    console.error('复制错误:', err);
    ElMessage.error('复制失败: ' + (err.message || '不支持的浏览器'));
  }
};

const exportToExcel = () => {
  exportTaskToExcel(tableData.value, '关键任务进度同步');
};

const copyScreenshot = async () => {
  try {
    const originalTable = document.querySelector('.custom-table');
    
    // 克隆整个表格结构
    // 计算前四列总宽度
    const originalHeaders = Array.from(originalTable.querySelectorAll('th')).slice(0, 4);
    const totalWidth = originalHeaders.reduce((sum, header) => sum + header.offsetWidth, 0);

    // 克隆并调整表格结构
    const clonedTable = originalTable.cloneNode(true);
    clonedTable.style.width = `${totalWidth}px`;
    
    // 保留前四列，删除其他列
    clonedTable.querySelectorAll('tr').forEach(tr => {
      Array.from(tr.children).forEach((td, index) => {
        if(index >= 4) td.remove();
      });
    });

    // 创建临时容器并应用精确样式
    const tempDiv = document.createElement('div');
    tempDiv.style.position = 'fixed';
    tempDiv.style.left = '0';
    tempDiv.style.top = '0';
    tempDiv.style.zIndex = '9999';
    tempDiv.style.width = `${totalWidth}px`;
    tempDiv.style.overflow = 'hidden';
    tempDiv.appendChild(clonedTable);
    document.body.appendChild(tempDiv);

    // 同步列宽设置
    clonedTable.querySelectorAll('th, td').forEach((el, index) => {
      if(index < 4) {
        el.style.width = `${originalHeaders[index].offsetWidth}px`;
        el.style.minWidth = `${originalHeaders[index].offsetWidth}px`;
        el.style.maxWidth = `${originalHeaders[index].offsetWidth}px`;
        el.style.whiteSpace = 'nowrap';
        el.style.overflow = 'hidden';
      }
    });

    const canvas = await html2canvas(tempDiv);
    document.body.removeChild(tempDiv);

    canvas.toBlob(blob => {
      navigator.clipboard.write([
        new ClipboardItem({ 'image/png': blob })
      ]);
    });

    ElMessage.success('截图已复制到剪贴板');
  } catch (err) {
    console.error('截图失败:', err);
    ElMessage.error('截图失败: ' + (err.message || '不支持的浏览器'));
  }
};

</script>

<style scoped>
.crud-container {
  padding: 20px;
  background: #fff;
  border-radius: 4px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, .1);

  :deep(.custom-table) {
    th.table-header {
      background: #1890ff;
      color: white;
      font-weight: 600;
      padding: 12px 0;
      border-radius: 4px;
    }

    td {
      padding: 10px 0;
    }

    .el-button {
      margin: 0 4px;
      transition: all 0.3s;

      &:hover {
        transform: translateY(-1px);
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
      }
    }
  }

  .el-table--striped .el-table__body tr.el-table__row--striped td {
    background: #fafafa;
  }

  :deep(.el-table) {
  border: 1px solid #d0d7e5;
  font-family: '微软雅黑';
}

:deep(.el-table th) {
  background: #004bff;
  /* color: white; */
  font-weight: bold;
}

:deep(.el-table__row--striped) {
  background: #f8f9fa;
}

:deep(.el-table__cell) {
  border-right: 1px solid #d0d7e5 !important;
  border-bottom: 1px solid #d0d7e5 !important;
}

}
</style>




