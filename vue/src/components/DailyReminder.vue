<template>
  <div class="crud-container">
    <el-button type="primary" @click="openDialog('create')">新建每日提醒</el-button>
    <el-button type="primary" @click="copyReminders" style="margin-left: 8px">复制提醒内容</el-button>
    <el-button type="primary" @click="exportToExcel" style="margin-left: 8px">导出到Excel</el-button>
    <el-button type="primary" @click="copyScreenshot" style="margin-left: 8px">复制截图</el-button>

    <el-select v-model="selectedWeek" @change="handleWeekChange" placeholder="请选择周"
      style="margin-left: 8px; width: 240px">
      <el-option v-for="week in weekOptions" :key="week.value" :label="week.label" :value="week.value" />
    </el-select>

    <el-select v-model="selectedStatus" placeholder="状态筛选" style="margin-left: 8px; width: 240px">
      <el-option label="全部" value="" />
      <el-option label="已完成" value="已完成" />
      <el-option label="进行中" value="进行中" />
      <el-option label="已暂停" value="已暂停" />
    </el-select>

    <el-table :data="filteredData" border style="margin-top: 20px" :row-style="handleRowStyle" class="custom-table">
      <el-table-column  label="序号" width="90" v-if="!isScreenshotting" header-align="center"
        align="center" border >
        <template #default="scope">
          {{ scope.$index + 1 }}
        </template>
      </el-table-column>
      <!-- <el-table-column prop="remind_date" label="提醒日期" width="180" v-if="!isScreenshotting" header-align="center"
        align="center" border /> -->
      <!-- <el-table-column prop="content" label="提醒内容" show-overflow-tooltip /> -->
      <el-table-column prop="content" label="提醒内容" border >
        <template #default="scope">
          <div style="white-space: pre-line">{{ scope.row.content }}</div>
        </template>
      </el-table-column>

      <el-table-column prop="owner" label="执行人" width="180" header-align="center" align="center" border />
      <el-table-column prop="period" label="周期" width="180" v-if="!isScreenshotting" header-align="center"
        align="center" border />
      <el-table-column prop="status" label="状态" width="120" header-align="center" align="center" border />
      <el-table-column label="操作" width="200" v-if="!isScreenshotting" header-align="center" align="center" border>
        <template #default="scope" header-align="center" align="center" border>
          <el-button size="small" @click="openDialog('edit', scope.row)">编辑</el-button>
          <el-button size="small" type="danger" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="dialogVisible" :title="dialogTitle">
      <el-form :model="formData" label-width="100px">
        <el-form-item label="提醒时间">
          <el-date-picker v-model="formData.remind_date" type="date" format="YYYYMMDD" value-format="YYYYMMDD"
            style="width: 240px" />
        </el-form-item>
        <el-form-item label="提醒内容">
          <el-input v-model="formData.content" type="textarea" :rows="4" />
        </el-form-item>
        <el-form-item label="负责人">
          <el-input v-model="formData.owner" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="formData.status" placeholder="请选择状态" style="margin-left: 8px; width: 240px">
            <el-option label="已完成" value="已完成" />
            <el-option label="进行中" value="进行中" />
            <el-option label="已暂停" value="已暂停" />
          </el-select>
        </el-form-item>
        <el-form-item label="周期">
          <el-select v-model="formData.period" placeholder="请选择周" style="margin-left: 8px; width: 240px">
            <el-option v-for="week in weekOptions" :key="week.value" :label="week.label" :value="week.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="formData.remark" type="textarea" :rows="1" />
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
import { ref, onMounted, computed, nextTick } from 'vue'
import html2canvas from 'html2canvas';
import { ElMessage, ElMessageBox } from 'element-plus'
// import { getDailyReminders, createDailyReminder, updateDailyReminder, deleteDailyReminder } from '@/utils/api'
import api from '@/utils/api.js';
import { DailyReminderExporter } from '@/utils/excelExporterReminder';

const tableData = ref([])
const selectedStatus = ref('')

const filteredData = computed(() => {
  return tableData.value.filter(item => {
    const weekMatch = item.period === selectedWeek.value
    const statusMatch = !selectedStatus.value || item.status === selectedStatus.value
    return weekMatch && statusMatch
  })
})
const dialogVisible = ref(false)
const dialogType = ref('create')
const formData = ref({
  id: '',
  remind_date: '',
  content: '',
  owner: '',
  status: '进行中',
  period: '',
  remark: ''
})

const dialogTitle = computed(() => {
  return dialogType.value === 'create' ? '新增记录' : '编辑记录'
})


const loadData = async () => {
  // try {
  //   const { data } = await getDailyReminders()
  //   tableData.value = data
  // } catch (error) {
  //   ElMessage.error('获取数据失败')
  // }
  try {
    const response = await api.post('/api.php?table=daily_reminders&action=list', {
      period: selectedWeek.value
    })

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
      remind_date: '',
      content: '',
      status: '进行中',
      period: selectedWeek.value,
      remark: ''
    }





  }
  dialogVisible.value = true
}

const submitForm = async () => {
  // try {
  //   if (dialogType.value === 'create') {
  //     await createDailyReminder(formData.value)
  //   } else {
  //     await updateDailyReminder(formData.value.id, formData.value)
  //   }
  //   await loadData()
  //   dialogVisible.value = false
  //   ElMessage.success('操作成功')
  // } catch (error) {
  //   ElMessage.error('操作失败')
  // }
  try {
    // 检查必填项
    console.log(formData.value);
    if (dialogType.value === 'create') {
      await api.post('/api.php?table=daily_reminders&action=create', formData.value);

    } else {
      //   await updateKeyTask(formData.value.id, formData.value)
      await api.put(`/api.php?table=daily_reminders&action=update&id=${formData.value.id}`, formData.value);

    }
    await loadData()
    dialogVisible.value = false
    ElMessage.success('操作成功')
  } catch (error) {
    ElMessage.error('操作失败')
  }


}

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm('确定删除该记录？', '警告', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    // await deleteDailyReminder(row.id)
    await api.delete(`/api.php?table=daily_reminders&action=delete&id=${row.id}`)

    await loadData()
    ElMessage.success('删除成功')
  } catch (error) {
    ElMessage.info('取消删除')
  }
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

const handleWeekChange = () => {
  loadData();
};
const copyReminders = async () => {
  if (tableData.value.length === 0) {
    ElMessage.warning('暂无数据可复制');
    return;
  }

  const text = "提醒事项:\n" + tableData.value
    .map((item, index) => `${index + 1}. ${item.content} - @${item.owner}`)
    .join('\n');

  try {
    if (navigator.clipboard) {
      await navigator.clipboard.writeText(text);
    } else {
      const textarea = document.createElement('textarea');
      textarea.value = text;
      document.body.appendChild(textarea);
      textarea.select();
      document.execCommand('copy');
      document.body.removeChild(textarea);
    }
    ElMessage.success('复制成功');
  } catch (err) {
    console.error('复制失败:', err);
    ElMessage.error('复制失败，请手动选择文本复制');
  }
};




const exportToExcel = () => {
  DailyReminderExporter(tableData.value, '每日提醒');
};

const isScreenshotting = ref(false);

const copyScreenshot = async () => {
  // isScreenshotting.value = true;
  try {
    const originalTable = document.querySelector('.custom-table');
    
    // 克隆整个表格结构
    // 计算前四列总宽度
    const originalHeaders = Array.from(originalTable.querySelectorAll('th')).slice(0, 2);
    let totalWidth = originalHeaders.reduce((sum, header) => sum + header.offsetWidth, 0);
    if(totalWidth > 800) {
      totalWidth = 800
    }

    // 克隆并调整表格结构
    const clonedTable = originalTable.cloneNode(true);
    clonedTable.style.width = `${totalWidth}px`;
    
    // 保留前四列，删除其他列
    clonedTable.querySelectorAll('tr').forEach(tr => {
      Array.from(tr.children).forEach((td, index) => {
        if(index >= 2) td.remove();
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
    // clonedTable.querySelectorAll('th, td').forEach((el, index) => {
    //   if(index < 8) {
    //     el.style.width = `${originalHeaders[index].offsetWidth}px`;
    //     el.style.minWidth = `${originalHeaders[index].offsetWidth}px`;
    //     el.style.maxWidth = `${originalHeaders[index].offsetWidth}px`;
    //     el.style.whiteSpace = 'nowrap';
    //     el.style.overflow = 'hidden';
    //   }
    // });

    const canvas = await html2canvas(tempDiv, {
  scale: window.devicePixelRatio * 2,
  scrollX: -window.scrollX,
  scrollY: -window.scrollY,
  width: tempDiv.scrollWidth,
  windowWidth: tempDiv.scrollWidth,
  useCORS: true,
  logging: true,
  scale: window.devicePixelRatio * 2,
  scrollX: -window.scrollX,
  scrollY: -window.scrollY,
  width: tempDiv.scrollWidth,
  windowWidth: tempDiv.scrollWidth
});
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
const handleRowStyle = ({ row }) => {
  if (row.status === '已完成') {
    return {
      backgroundColor: '#f0f9eb',
      textDecoration: 'line-through'
    }
  }
  return null
}
</script>

<style scoped>
.crud-container {
  padding: 20px;
  background: #fff;
  border-radius: 4px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, .1);
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

.el-table {
  table-layout: fixed;
}

.el-table__body {
  width: 100% !important;
}


.custom-table {
  border-collapse: collapse;
  width: 100%;
  background-color: #f9f9f9;
}

.custom-table th, .custom-table td {
  border: 1px solid #dcdcdc;
  padding: 8px;
  text-align: left;
  font-family: 'Arial', sans-serif;
  font-size: 14px;
  color: #333;
}

.custom-table th {
  background-color: #f2f2f2;
  font-weight: bold;
}

.custom-table tr:nth-child(even) {
  background-color: #f2f2f2;
}

.custom-table tr:hover {
  background-color: #e0e0e0;
}
</style>