<template>
  <div class="crud-container">
    <el-button type="primary" @click="openDialog('create')">新建关键任务</el-button>
    <el-select 
      v-model="selectedWeek"
      placeholder="请选择周"
      style="margin-left: 8px; width: 240px"
    >
      <el-option
        v-for="week in weekOptions"
        :key="week.value"
        :label="week.label"
        :value="week.value"
      />
    </el-select>

    <el-table :data="tableData" border style="width: 100%; margin-top: 20px">
        <el-table-column prop="id" label="序号" width="120" header-align="center" align="center" border/>
      <el-table-column prop="task_name" label="任务名称" width="200" border/>
      <el-table-column prop="owner" label="负责人" width="200" header-align="center" align="center" border/>
      <el-table-column prop="conclusion" label="当日结论" border/>
      <el-table-column prop="status" label="状态" header-align="center" align="center" border/>
      <el-table-column prop="period" label="周期" width="200" header-align="center" align="center" border/>
      <el-table-column prop="create_date" label="创建日期" width="200" header-align="center" align="center" border/>
      <el-table-column label="操作" width="200"  header-align="center" align="center" border>
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
          <el-input v-model="formData.conclusion" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="formData.priority">
            <el-option label="已完成" value="0" />
            <el-option label="进行中" value="1" />
            <el-option label="已暂停" value="2" />
          </el-select>
        </el-form-item>
        <el-form-item label="周期">
            <el-select 
                v-model="formData.period"
                placeholder="请选择周"
                style="margin-left: 8px; width: 240px"
                >
                <el-option
                    v-for="week in weekOptionsNew"
                    :key="week.value"
                    :label="week.label"
                    :value="week.value"
                />
                </el-select>
        </el-form-item>
        <el-form-item label="创建日期">
          <el-date-picker
            v-model="formData.create_date"
            type="date"
            value-format="YYYYMMDD"
            style="width: 240px"
          />
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

const tableData = ref([])
const dialogVisible = ref(false)
const dialogType = ref('create')
const formData = ref({
    id: '',
      task_name: '',
      owner: '',
      conclusion: '0',
      status: 1 ,
      period: '',
      create_date: ''
})

const dialogTitle = computed(() => {
  return dialogType.value === 'create' ? '新增记录' : '编辑记录'
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
    if(i == 0){
        monday.setDate(currentMonday.getDate() - 7 )
    }else if(i == 1){
        monday.setDate(currentMonday.getDate() )
    }else if(i == 2){
        monday.setDate(currentMonday.getDate() + 7 )
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
      task_name: '',
      owner: '',
      conclusion: '',
      status: '2',
      period: weekOptionsNew.value[1].value,
      create_date: new Date().toISOString().slice(0,10).replace(/-/g, '')
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
        await api.put(`/api.php?table=review_record&action=update&id=${formData.value.id}`, formData.value);

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
    await ElMessageBox.confirm('确定删除该任务？', '警告', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    await deleteKeyTask(row.id)
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
</script>

<style scoped>
.crud-container {
  padding: 20px;
  background: #fff;
  border-radius: 4px;
  box-shadow: 0 2px 12px 0 rgba(0,0,0,.1);
}
</style>