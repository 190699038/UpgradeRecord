<template>
  <div class="follow-up-main-task">
    <div class="filter-container">
      <el-button type="primary" @click="openDialog('create')">新增主任务</el-button>

      <!-- <el-date-picker
        v-model="searchParams.start_date"
        type="date"
        placeholder="开始日期"
        value-format="YYYYMMDD"
      />
      <el-date-picker
        v-model="searchParams.end_date"
        type="date"
        placeholder="结束日期"
        value-format="YYYYMMDD"
      /> -->
      <el-button type="primary" @click="fetchRecords">查询</el-button>
    </div>

    <el-table :data="tableData" border class="custom-table" :span-method="objectSpanMethod">
      <el-table-column label="序号" width="80" header-align="center" align="center">
        <template #default="scope">
          {{ scope.$index + 1 }}
        </template>
      </el-table-column>
      <el-table-column prop="task_content" label="任务内容" header-align="center">
        <template #default="{ row }">
          <div class="wrap-cell">{{ row.task_content }}</div>
        </template>
      </el-table-column>
      <el-table-column prop="creation_date" label="创建日期" header-align="center" align="center" width="120" />
      <!-- <el-table-column prop="end_date" label="结束日期" header-align="center" align="center" width="120" /> -->
      <el-table-column label="操作" width="150" header-align="center" align="center">
        <template #default="scope">
          <el-button size="small" @click="handleEdit(scope.row)">编辑</el-button>
          <el-button size="small" type="danger" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="dialogVisible" :title="dialogType === 'edit' ? '编辑主任务' : '新增主任务'" width="50%">
      <el-form ref="formRef" :model="formData" :rules="formRules" label-width="100px">
        <el-form-item label="任务内容" prop="task_content">
          <el-input
            v-model="formData.task_content"
            type="textarea"
            :rows="3"
            placeholder="请输入任务内容"
          />
        </el-form-item>
        <!-- <el-form-item label="创建日期" prop="creation_date">
          <el-date-picker
            v-model="formData.creation_date"
            type="date"
            placeholder="选择创建日期"
            value-format="YYYYMMDD"
          />
        </el-form-item> -->
        <el-form-item label="结束日期" prop="end_date">
          <el-date-picker
            v-model="formData.end_date"
            type="date"
            placeholder="选择结束日期"
            value-format="YYYYMMDD"
          />
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
import { ref, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import api from '../utils/api'

const tableData = ref([])
const searchParams = ref({
  start_date: '',
  end_date: ''
})

// 计算合并单元格的方法
const objectSpanMethod = ({ row, column, rowIndex, columnIndex }) => {
  // 只对任务内容列（索引为1）进行合并
  if (columnIndex === 1) {
    if (rowIndex > 0) {
      // 获取当前行和前一行的任务内容
      const currentContent = tableData.value[rowIndex].task_content
      const prevContent = tableData.value[rowIndex - 1].task_content
      
      // 如果当前行与前一行内容相同
      if (currentContent === prevContent) {
        // 返回 [0, 0] 表示不显示当前单元格
        return [0, 0]
      } else {
        // 计算后续有多少行与当前行内容相同
        let count = 1
        for (let i = rowIndex + 1; i < tableData.value.length; i++) {
          if (tableData.value[i].task_content === currentContent) {
            count++
          } else {
            break
          }
        }
        // 返回 [count, 1] 表示合并count行
        return [count, 1]
      }
    } else {
      // 第一行，计算后续有多少行与当前行内容相同
      const currentContent = tableData.value[0].task_content
      let count = 1
      for (let i = 1; i < tableData.value.length; i++) {
        if (tableData.value[i].task_content === currentContent) {
          count++
        } else {
          break
        }
      }
      // 返回 [count, 1] 表示合并count行
      return [count, 1]
    }
  }
}

const fetchRecords = async () => {
  try {
    const response = await api.post('/api.php?table=follow_up_main_tasks', searchParams.value)
    tableData.value = response.data.data
  } catch (error) {
    console.error('获取主任务记录失败:', error)
    ElMessage.error('获取主任务记录失败')
    tableData.value = []
  }
}

const dialogVisible = ref(false)
const dialogType = ref('create')
const formRef = ref(null)

const formRules = ref({
  task_content: [{ required: true, message: '请输入任务内容', trigger: 'blur' }],
  // creation_date: [{ required: true, message: '请选择创建日期', trigger: 'change' }],
  // end_date: [{ required: true, message: '请选择结束日期', trigger: 'change' }]
})

const formData = ref({
  id: 0,
  task_content: '',
  creation_date: '',
  end_date: ''
})

const handleEdit = (row) => {
  dialogType.value = 'edit'
  formData.value = { 
    ...row,
    creation_date: String(row.creation_date).replace(/[^0-9]/g, ''),
    end_date: String(row.end_date).replace(/[^0-9]/g, '')
  }
  dialogVisible.value = true
}

const submitForm = async () => {
  try {
    await formRef.value.validate()
    
    const payload = {
      ...formData.value
    }

    const url = dialogType.value === 'edit' 
      ? `/api.php?table=follow_up_main_tasks&action=update&id=${formData.value.id}`
      : '/api.php?table=follow_up_main_tasks&action=create'

    await api[dialogType.value === 'edit' ? 'put' : 'post'](url, payload)
    ElMessage.success(dialogType.value === 'edit' ? '修改成功' : '创建成功')
    dialogVisible.value = false
    fetchRecords()
  } catch (error) {
    if (!error.response) {
      ElMessage.warning('请完善必填项')
    } else {
      console.error('操作失败:', error)
      ElMessage.error(error.response?.data?.message || '操作失败')
    }
  }
}

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm('确定要删除这条记录吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    await api.delete(`/api.php?table=follow_up_main_tasks&action=delete&id=${row.id}`)
    ElMessage.success('删除成功')
    fetchRecords()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除失败:', error)
      ElMessage.error('删除失败')
    }
  }
}

const openDialog = (type, row = {}) => {
  dialogType.value = type
  formData.value = {
    id: 0,
    task_content: '',
    creation_date: new Date().toISOString().slice(0,10).replace(/-/g,''),
    end_date: ''
  }
  dialogVisible.value = true
}

onMounted(() => {
  const end = new Date()
  const start = new Date()
  start.setDate(start.getDate() - 30) // 默认查询最近30天的数据
  
  searchParams.value.start_date = start.toISOString().slice(0,10).replace(/-/g,'')
  searchParams.value.end_date = end.toISOString().slice(0,10).replace(/-/g,'')
  fetchRecords()
})

// 暴露方法给父组件
defineExpose({
  fetchRecords
})
</script>

<style scoped>
.follow-up-main-task {
  width: 70%;
  margin: 0 auto; /* 添加居中显示 */
}

.filter-container {
  margin-bottom: 20px;
  display: flex;
  gap: 10px;
  align-items: center;
}

.wrap-cell {
  white-space: normal;
  word-break: break-all;
  line-height: 1.5;
}

.custom-table {
  width: 100%;
  margin-top: 15px;
}
</style>