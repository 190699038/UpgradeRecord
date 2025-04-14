<template>
  <div class="crud-container">
    <el-button type="primary" @click="openDialog('create')">新建每日提醒</el-button>
    
    <el-table :data="tableData" border style="width: 100%; margin-top: 20px">
      <el-table-column prop="reminder_time" label="提醒时间" width="180" />
      <el-table-column prop="content" label="提醒内容" show-overflow-tooltip />
      <el-table-column prop="status" label="状态" width="120" :formatter="formatStatus" />
      <el-table-column label="操作" width="200">
        <template #default="scope">
          <el-button size="small" @click="openDialog('edit', scope.row)">编辑</el-button>
          <el-button size="small" type="danger" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="dialogVisible" :title="dialogTitle">
      <el-form :model="formData" label-width="100px">
        <el-form-item label="提醒时间">
          <el-time-picker v-model="formData.reminder_time" format="HH:mm" />
        </el-form-item>
        <el-form-item label="提醒内容">
          <el-input v-model="formData.content" type="textarea" rows="4" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="formData.status">
            <el-option label="启用" value="1" />
            <el-option label="停用" value="0" />
          </el-select>
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
import { ref, onMounted,computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
// import { getDailyReminders, createDailyReminder, updateDailyReminder, deleteDailyReminder } from '@/utils/api'
import api from '@/utils/api.js';

const tableData = ref([])
const dialogVisible = ref(false)
const dialogType = ref('create')
const formData = ref({
  id: '',
  reminder_time: '',
  content: '',
  status: '1'
})

const formatStatus = (row) => {
  return row.status === '1' ? '启用' : '停用'
}

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
      period:selectedWeek.value   })

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
      reminder_time: '',
      content: '',
      status: '1'
    }
  }
  dialogVisible.value = true
}

const submitForm = async () => {
  try {
    if (dialogType.value === 'create') {
      await createDailyReminder(formData.value)
    } else {
      await updateDailyReminder(formData.value.id, formData.value)
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

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.crud-container {
  padding: 20px;
  background: #fff;
  border-radius: 4px;
  box-shadow: 0 2px 12px 0 rgba(0,0,0,.1);
}
</style>