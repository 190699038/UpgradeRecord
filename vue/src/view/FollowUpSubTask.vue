<template>
  <div class="follow-up-sub-task">
    <div class="filter-container">
      <el-button type="primary" @click="openDialog('create')">新增子任务</el-button>

      <el-date-picker
        v-model="searchParams.creation_date"
        type="date"
        placeholder=""
        value-format="YYYYMMDD"
      />
      <el-select 
        v-model="selectedTaskIds" 
        placeholder="选择主任务" 
        clearable 
        multiple 
        collapse-tags
        collapse-tags-tooltip
        style="width: 250px"
        @change="handleMainTaskChange"
      >
        <el-option
          label="全部"
          value="all"
        />
        <el-option
          v-for="item in mainTasks"
          :key="item.id"
          :label="item.task_content"
          :value="item.id"
        />
      </el-select>
      <el-button type="primary" @click="fetchRecords">查询</el-button>
      <el-button type="primary" @click="copyYesterdayTasks">拷贝昨日任务</el-button>
      <el-button type="success" @click="captureAndCopyTable">截图并复制</el-button>
      <el-button type="warning" @click="copyRichText">复制富文本</el-button>

    </div>

    <!-- 截图表格 -->
    <el-table 
      ref="screenshotTable" 
      :data="tableData" 
      border 
      class="custom-table screenshot-table" 
      :span-method="objectSpanMethod" 
      :row-style="getRowStyle"
      v-show="showScreenshotTable"
      style="margin-bottom: 20px;"
    >
      <el-table-column label="序号" width="80" header-align="center" align="center">
        <template #default="scope">
          {{ scope.$index + 1 }}
        </template>
      </el-table-column>
      <el-table-column prop="parent_task_content" label="所属主任务" header-align="center" width="200">
        <template #default="{ row }">
          <div class="wrap-cell parent-task-content">{{ row.parent_task_content }}</div>
        </template>
      </el-table-column>
      <el-table-column prop="sub_task_content" label="子任务内容" header-align="center" width="450">
        <template #default="{ row }">
          <div class="wrap-cell sub-task-content">{{ row.sub_task_content }}</div>
        </template>
      </el-table-column>
      <el-table-column prop="sub_completion_status" label="完成状态" header-align="center" align="center" width="100">
        <template #default="{ row }">
          <span :style="{ 
            color: parseInt(row.sub_completion_status) === 1 ? '#67c23a' : '#909399',
            fontWeight: 'bold',
            padding: '4px 8px',
            borderRadius: '4px',
            backgroundColor: parseInt(row.sub_completion_status) === 1 ? '#f0f9ff' : '#f4f4f5'
          }">
            {{ parseInt(row.sub_completion_status) === 1 ? '已完成' : '未完成' }}
          </span>
        </template>
      </el-table-column>
      <el-table-column prop="executor" label="执行人" header-align="center" align="center" width="100" />
    </el-table>

    <!-- 原始完整表格 -->
    <el-table :data="tableData" border class="custom-table" :span-method="objectSpanMethod" :row-style="getRowStyle" v-show="!showScreenshotTable">
      <el-table-column label="序号" width="80" header-align="center" align="center">
        <template #default="scope">
          {{ scope.$index + 1 }}
        </template>
      </el-table-column>
      <el-table-column prop="parent_task_content" label="所属主任务" header-align="center" width="200">
        <template #default="{ row }">
          <div class="wrap-cell parent-task-content">{{ row.parent_task_content }}</div>
        </template>
      </el-table-column>
      <el-table-column prop="sub_task_content" label="子任务内容" header-align="center">
        <template #default="{ row }">
          <div class="wrap-cell sub-task-content">{{ row.sub_task_content }}</div>
        </template>
      </el-table-column>
      <el-table-column prop="sub_completion_status" label="完成状态" header-align="center" align="center" width="100">
        <template #default="{ row }">
          <el-tag :type="parseInt(row.sub_completion_status) === 1 ? 'success' : 'info'">
            {{ parseInt(row.sub_completion_status) === 1 ? '已完成' : '未完成' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="executor" label="执行人" header-align="center" align="center" width="100" />
      <el-table-column prop="remark" label="备注" header-align="center" width="200">
        <template #default="{ row }">
          <div class="wrap-cell">{{ row.remark }}</div>
        </template>
      </el-table-column>
      <el-table-column prop="creation_date" label="创建日期" header-align="center" align="center" width="120" />
      <el-table-column prop="end_date" label="结束日期" header-align="center" align="center" width="120" />
      <el-table-column label="操作" width="220" header-align="center" align="center">
        <template #default="scope">
          <el-button size="small" @click="handleEdit(scope.row)">编辑</el-button>
          <el-button size="small" type="success" @click="handleComplete(scope.row)" :disabled="parseInt(scope.row.sub_completion_status) === 1">完成</el-button>
          <el-button size="small" type="danger" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="dialogVisible" :title="dialogType === 'edit' ? '编辑子任务' : '新增子任务'" width="50%">
      <el-form ref="formRef" :model="formData" :rules="formRules" label-width="100px">
        <el-form-item label="所属主任务" prop="parent_task_id">
          <el-select v-model="formData.parent_task_id" placeholder="选择主任务" style="width: 100%">
            <el-option
              v-for="item in mainTasks"
              :key="item.id"
              :label="item.task_content"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="子任务内容" prop="sub_task_content">
          <el-input
            v-model="formData.sub_task_content"
            type="textarea"
            :rows="3"
            placeholder="请输入子任务内容"
          />
        </el-form-item>
        <el-form-item label="完成状态" prop="sub_completion_status">
          <el-radio-group v-model="formData.sub_completion_status">
            <el-radio :value="1">已完成</el-radio>
                <el-radio :value="0">未完成</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="执行人" prop="executor">
          <el-input v-model="formData.executor" placeholder="请输入执行人" />
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input
            v-model="formData.remark"
            type="textarea"
            :rows="2"
            placeholder="请输入备注"
          />
        </el-form-item>
        <el-form-item label="创建日期" prop="creation_date">
          <el-date-picker
            v-model="formData.creation_date"
            type="date"
            placeholder="选择创建日期"
            value-format="YYYYMMDD"
          />
        </el-form-item>
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
        <el-button type="success" @click="quickComplete">一键完成</el-button>
        <el-button type="primary" @click="submitForm">确认</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, nextTick } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import api from '../utils/api'

const tableData = ref([])
const mainTasks = ref([])

// 计算合并单元格的方法
const objectSpanMethod = ({ row, column, rowIndex, columnIndex }) => {
  // 只对所属主任务列（索引为1）进行合并
  if (columnIndex === 1) {
    if (rowIndex > 0) {
      // 获取当前行和前一行的主任务ID和内容
      const currentParentId = tableData.value[rowIndex].parent_task_id
      const prevParentId = tableData.value[rowIndex - 1].parent_task_id
      
      // 如果当前行与前一行主任务ID相同
      if (currentParentId === prevParentId) {
        // 返回 [0, 0] 表示不显示当前单元格
        return [0, 0]
      } else {
        // 计算后续有多少行与当前行主任务ID相同
        let count = 1
        for (let i = rowIndex + 1; i < tableData.value.length; i++) {
          if (tableData.value[i].parent_task_id === currentParentId) {
            count++
          } else {
            break
          }
        }
        // 返回 [count, 1] 表示合并count行
        return [count, 1]
      }
    } else {
      // 第一行，计算后续有多少行与当前行主任务ID相同
      const currentParentId = tableData.value[0].parent_task_id
      let count = 1
      for (let i = 1; i < tableData.value.length; i++) {
        if (tableData.value[i].parent_task_id === currentParentId) {
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

// 根据主任务ID返回不同的行类名
const getRowClassName = ({ row, rowIndex }) => {
  const colors = ['bg-color-1', 'bg-color-2', 'bg-color-3', 'bg-color-4', 'bg-color-5', 'bg-color-6']
  const taskId = row.parent_task_id
  // 使用主任务ID的哈希值来确定颜色索引，确保相同主任务始终使用相同颜色
  const colorIndex = taskId % colors.length
  return colors[colorIndex]
}



const searchParams = ref({
  creation_date: '',
  parent_task_ids: '',
  sub_completion_status: -1
})

// 用于el-select多选的数组
const selectedTaskIds = ref([])

// 控制截图表格显示
const showScreenshotTable = ref(false)
const screenshotTable = ref(null)

const fetchMainTasks = async () => {
  try {
    const response = await api.post('/api.php?table=follow_up_main_tasks', {})
    mainTasks.value = response.data.data
  } catch (error) {
    console.error('获取主任务列表失败:', error)
    ElMessage.error('获取主任务列表失败')
    mainTasks.value = []
  }
}

const copyYesterdayTasks = async () => {
  try {
    const response = await api.post('/api.php?table=follow_up_sub_tasks&action=copy_yesterday')
    ElMessage.success('拷贝昨日任务成功')
    fetchRecords()
  } catch (error) {
    console.error('拷贝昨日任务失败:', error)
    ElMessage.error('拷贝昨日任务失败')
  }
}


// 处理主任务选择变化
const handleMainTaskChange = (value) => {
  if (value.includes('all')) {
    // 如果选择了"全部"，清空其他选项
    if (value.length > 1) {
      // 如果"全部"不是最后选择的，保留"全部"
      if (value[value.length - 1] === 'all') {
        selectedTaskIds.value = ['all']
        searchParams.value.parent_task_ids = 'all'
      } else {
        // 如果"全部"不是最后选择的，移除"全部"
        const filteredValues = value.filter(item => item !== 'all')
        selectedTaskIds.value = filteredValues
        searchParams.value.parent_task_ids = filteredValues.join(',')
      }
    } else {
      selectedTaskIds.value = ['all']
      searchParams.value.parent_task_ids = 'all'
    }
  } else {
    // 将数组转换为逗号分隔的字符串
    selectedTaskIds.value = value
    searchParams.value.parent_task_ids = value.join(',')
  }
}

const fetchRecords = async () => {
  try {
    // 构建查询参数
    const queryParams = { ...searchParams.value }
    
    // 如果选择了"全部"或没有选择任何主任务，不传递parent_task_ids参数
    if (queryParams.parent_task_ids === 'all' || queryParams.parent_task_ids === '') {
      delete queryParams.parent_task_ids
    }
    
    const response = await api.post('/api.php?table=follow_up_sub_tasks&action=list', queryParams)
    tableData.value = response.data.data.map(item => {
      // 查找对应的主任务内容
      const mainTask = mainTasks.value.find(task => task.id === item.parent_task_id)
      return {
        ...item,
        parent_task_content: mainTask ? mainTask.task_content : '未知主任务'
      }
    })
  } catch (error) {
    console.error('获取子任务记录失败:', error)
    ElMessage.error('获取子任务记录失败')
    tableData.value = []
  }
}

const dialogVisible = ref(false)
const dialogType = ref('create')
const formRef = ref(null)

const formRules = ref({
  parent_task_id: [{ required: true, message: '请选择所属主任务', trigger: 'change' }],
  sub_task_content: [{ required: true, message: '请输入子任务内容', trigger: 'blur' }],
  executor: [{ required: true, message: '请输入执行人', trigger: 'blur' }],
  creation_date: [{ required: true, message: '请选择创建日期', trigger: 'change' }]
})

const formData = ref({
  id: 0,
  parent_task_id: '',
  sub_task_content: '',
  sub_completion_status: 0,
  executor: '',
  remark: '',
  creation_date: '',
  end_date: ''
})

const handleEdit = (row) => {
  dialogType.value = 'edit'
  formData.value = { 
    ...row,
    creation_date: String(row.creation_date).replace(/[^0-9]/g, ''),
    end_date: row.end_date ? String(row.end_date).replace(/[^0-9]/g, '') : ''
  }
  dialogVisible.value = true
}

const quickComplete = async () => {
  // 设置完成状态为已完成
  formData.value.sub_completion_status = 1
  // 设置结束日期为今日
  const today = new Date()
  const year = today.getFullYear()
  const month = String(today.getMonth() + 1).padStart(2, '0')
  const day = String(today.getDate()).padStart(2, '0')
  formData.value.end_date = `${year}${month}${day}`
  
  // 调用确认功能
  // await submitForm()
}

const submitForm = async () => {
  try {
    await formRef.value.validate()
    
    const payload = {
      ...formData.value
    }

    const url = dialogType.value === 'edit' 
      ? `/api.php?table=follow_up_sub_tasks&action=update&id=${formData.value.id}`
      : '/api.php?table=follow_up_sub_tasks&action=create'

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

const handleComplete = async (row) => {
  try {
    await ElMessageBox.confirm('确定要将此任务标记为完成吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'info'
    })
    
    // 设置完成状态和今日日期
    const today = new Date()
    const year = today.getFullYear()
    const month = String(today.getMonth() + 1).padStart(2, '0')
    const day = String(today.getDate()).padStart(2, '0')
    const todayStr = `${year}${month}${day}`
    
    const payload = {
      ...row,
      sub_completion_status: 1,
      end_date: todayStr
    }
    
    await api.put(`/api.php?table=follow_up_sub_tasks&action=update&id=${row.id}`, payload)
    ElMessage.success('任务已标记为完成')
    fetchRecords()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('标记完成失败:', error)
      ElMessage.error('标记完成失败')
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
    
    await api.delete(`/api.php?table=follow_up_sub_tasks&action=delete&id=${row.id}`)
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
    parent_task_id: '',
    sub_task_content: '',
    sub_completion_status: 0,
    executor: '',
    remark: '',
    creation_date: new Date().toISOString().slice(0,10).replace(/-/g,''),
    end_date: ''
  }
  dialogVisible.value = true
}

onMounted(() => {
  const end = new Date()
  const start = new Date()
  start.setDate(start.getDate()) // 默认查询最近30天的数据
  
  searchParams.value.creation_date = start.toISOString().slice(0,10).replace(/-/g,'')  
  fetchMainTasks().then(() => {
    fetchRecords()
  })
})

// 根据主任务ID返回行样式
const getRowStyle = ({ row }) => {
  const taskId = row.parent_task_id
  const colors = [
    '#f0f9ff', // 浅蓝色
    '#f0fdf4', // 浅绿色
    '#fefce8', // 浅黄色
    '#fef2f2', // 浅红色
    '#faf5ff', // 浅紫色
    '#f0fdfa'  // 浅青色
  ]
  const colorIndex = taskId % colors.length
  return {
    backgroundColor: colors[colorIndex]
  }
}

// 截图并复制到剪贴板
const captureAndCopyTable = async () => {
  try {
    ElMessage.info('正在生成截图...')
    
    // 显示截图表格
    showScreenshotTable.value = true
    
    // 等待DOM更新
    await nextTick()
    
    // 再次等待确保表格完全渲染
    await new Promise(resolve => setTimeout(resolve, 500))
    
    // 动态导入html2canvas
    const html2canvas = (await import('html2canvas')).default
    
    // 获取截图表格元素
    const tableElement = screenshotTable.value?.$el
    
    if (!tableElement) {
      throw new Error('无法找到表格元素')
    }
    
    console.log('表格元素:', tableElement)
    
    // 生成截图
    const canvas = await html2canvas(tableElement, {
      backgroundColor: '#ffffff',
      scale: 1.5, // 提高清晰度
      useCORS: true,
      allowTaint: true,
      logging: false, // 关闭日志
      width: tableElement.scrollWidth,
      height: tableElement.scrollHeight
    })
    
    // 创建新的canvas用于裁剪
    const croppedCanvas = document.createElement('canvas')
    const ctx = croppedCanvas.getContext('2d')
    
    // 计算实际内容宽度（前5列的总宽度）
     const actualWidth = 80 + 200 + 450 + 100 + 100 // 序号+主任务+子任务+状态+执行人
     const scaledWidth = actualWidth * 1.5 // 考虑scale因子
    
    // 设置裁剪后的canvas尺寸
    croppedCanvas.width = scaledWidth
    croppedCanvas.height = canvas.height
    
    // 将原canvas的内容绘制到新canvas上，只保留左侧有内容的部分
    ctx.drawImage(canvas, 0, 0, scaledWidth, canvas.height, 0, 0, scaledWidth, canvas.height)
    
    console.log('截图生成成功，原始canvas尺寸:', canvas.width, 'x', canvas.height)
    console.log('裁剪后canvas尺寸:', croppedCanvas.width, 'x', croppedCanvas.height)
    
    // 将裁剪后的canvas转换为blob
    croppedCanvas.toBlob(async (blob) => {
      try {
        if (!blob) {
          throw new Error('生成图片失败')
        }
        
        // 检查浏览器是否支持剪贴板API
        if (navigator.clipboard && navigator.clipboard.write) {
          // 复制到剪贴板
          await navigator.clipboard.write([
            new ClipboardItem({
              'image/png': blob
            })
          ])
          
          ElMessage.success('表格截图已复制到剪贴板')
        } else {
          // 如果不支持剪贴板API，直接下载
          throw new Error('浏览器不支持剪贴板API')
        }
      } catch (error) {
        console.error('复制到剪贴板失败:', error)
        ElMessage.warning('复制到剪贴板失败，正在下载图片')
        
        // 如果复制失败，提供下载选项
        const url = croppedCanvas.toDataURL('image/png')
        const link = document.createElement('a')
        link.download = `表格截图_${new Date().toISOString().slice(0,10)}.png`
        link.href = url
        document.body.appendChild(link)
        link.click()
        document.body.removeChild(link)
        
        ElMessage.success('图片已下载到本地')
      }
    }, 'image/png')
    
  } catch (error) {
    console.error('截图失败:', error)
    ElMessage.error(`截图失败: ${error.message}`)
  } finally {
    // 隐藏截图表格
    showScreenshotTable.value = false
  }
}

// 复制富文本到剪贴板
// 处理子任务内容，多行数据直接缩进展示
const formatSubTaskContent = (content) => {
  if (!content) return ''
  
  const lines = content.split('\n')
  
  // 如果只有一行，直接返回
  if (lines.length === 1) {
    return content
  }
  
  // 多行数据，每行都添加缩进
  let formattedContent = ''
  lines.forEach((line, lineIndex) => {
    if (lineIndex > 0) {
      formattedContent += '\n      ' // 换行后添加缩进
    }
    formattedContent += line
  })
  
  return formattedContent
}

const copyRichText = async () => {
  try {
    if (!tableData.value || tableData.value.length === 0) {
      ElMessage.warning('没有数据可复制')
      return
    }

    // 按主任务分组
    const groupedData = {}
    tableData.value.forEach(item => {
      const parentTaskId = item.parent_task_id
      const parentTaskContent = item.parent_task_content
      
      if (!groupedData[parentTaskId]) {
        groupedData[parentTaskId] = {
          content: parentTaskContent,
          subTasks: []
        }
      }
      
      groupedData[parentTaskId].subTasks.push({
        content: item.sub_task_content,
        status: parseInt(item.sub_completion_status) === 1 ? '已完成' : '未完成',
        remark: item.remark || '无'
      })
    })

    // 生成富文本格式
    let richText = ''
    let mainTaskIndex = 1
    
    Object.values(groupedData).forEach(group => {
      // 主任务标题（加粗，不缩进）
      richText += `**${getChineseNumber(mainTaskIndex)}、${group.content}**\n`
      
      // 子任务列表
       group.subTasks.forEach((subTask, index) => {
         const originalContent = subTask.content || ''
         const isMultiLine = originalContent.includes('\n')
         const statusAndRemark = `   【${subTask.status}】   ${subTask.remark}`
         
         if (isMultiLine) {
           // 多行内容：不添加序号，直接缩进显示
           const formattedContent = formatSubTaskContent(originalContent)
           richText += `    ${formattedContent}${statusAndRemark}\n`
         } else {
           // 单行内容：添加圆圈序号
           const formattedContent = formatSubTaskContent(originalContent)
           richText += `    ${getCircledNumber(index + 1)} ${formattedContent}${statusAndRemark}\n`
         }
       })
      
      richText += '\n'
      mainTaskIndex++
    })

    // 创建HTML格式的富文本
    const htmlText = richText
      .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
      .replace(/\n/g, '<br>')
      .replace(/  /g, '&nbsp;&nbsp;') // 保持缩进

    // 复制到剪贴板
    if (navigator.clipboard && navigator.clipboard.write) {
      const clipboardItem = new ClipboardItem({
        'text/html': new Blob([htmlText], { type: 'text/html' }),
        'text/plain': new Blob([richText.replace(/\*\*(.*?)\*\*/g, '$1')], { type: 'text/plain' })
      })
      
      await navigator.clipboard.write([clipboardItem])
      ElMessage.success('富文本已复制到剪贴板，可直接粘贴到钉钉')
    } else {
      // 降级方案：复制纯文本
      await navigator.clipboard.writeText(richText.replace(/\*\*(.*?)\*\*/g, '$1'))
      ElMessage.success('文本已复制到剪贴板')
    }
    
  } catch (error) {
    console.error('复制富文本失败:', error)
    ElMessage.error('复制失败，请重试')
  }
}

// 获取中文数字
const getChineseNumber = (num) => {
  const chineseNumbers = ['', '一', '二', '三', '四', '五', '六', '七', '八', '九', '十']
  if (num <= 10) {
    return chineseNumbers[num]
  }
  return num.toString()
}

// 获取带圆圈的数字
const getCircledNumber = (num) => {
  const circledNumbers = ['', '①', '②', '③', '④', '⑤', '⑥', '⑦', '⑧', '⑨', '⑩']
  if (num <= 10) {
    return circledNumbers[num]
  }
  return `(${num})`
}

// 暴露方法给父组件
defineExpose({
  fetchRecords
})
</script>

<style scoped>
.follow-up-sub-task {
  width: 96%;
  margin: 0 auto;
  padding: 20px;
  background-color: #f8f9fa;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.wrap-cell {
  white-space: normal;
  word-break: break-all;
  line-height: 1.6;
  padding: 8px 12px;
}

.filter-container {
  margin-bottom: 24px;
  display: flex;
  gap: 12px;
  align-items: center;
  padding: 16px;
  background-color: #ffffff;
  border-radius: 6px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08);
}

.custom-table {
  width: 100%;
  margin-top: 16px;
  border-radius: 6px;
  overflow: hidden;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
}

.custom-table .el-table {
  border: 2px solid #c0c4cc !important;
}

.custom-table .el-table td,
.custom-table .el-table th {
  border-bottom: 2px solid #c0c4cc !important;
  border-right: 2px solid #c0c4cc !important;
}

.custom-table .el-table tbody tr:hover td {
  border-bottom: 2px solid #c0c4cc !important;
  border-right: 2px solid #c0c4cc !important;
}

.custom-table .el-table--border {
  border: 2px solid #c0c4cc !important;
}

.custom-table .el-table--border td,
.custom-table .el-table--border th {
  border-right: 2px solid #c0c4cc !important;
}

.custom-table .el-table--border th {
  border-bottom: 2px solid #c0c4cc !important;
}

.custom-table .el-table--border td {
  border-bottom: 2px solid #c0c4cc !important;
}

/* 不同主任务的背景颜色 - 使用多重选择器确保生效 */
:deep(.el-table .bg-color-1),
:deep(.el-table tbody .bg-color-1),
:deep(.custom-table .bg-color-1),
.bg-color-1 {
  background-color: #f0f9ff !important;
}

:deep(.el-table .bg-color-2),
:deep(.el-table tbody .bg-color-2),
:deep(.custom-table .bg-color-2),
.bg-color-2 {
  background-color: #f0fdf4 !important;
}

:deep(.el-table .bg-color-3),
:deep(.el-table tbody .bg-color-3),
:deep(.custom-table .bg-color-3),
.bg-color-3 {
  background-color: #fefce8 !important;
}

:deep(.el-table .bg-color-4),
:deep(.el-table tbody .bg-color-4),
:deep(.custom-table .bg-color-4),
.bg-color-4 {
  background-color: #fef2f2 !important;
}

:deep(.el-table .bg-color-5),
:deep(.el-table tbody .bg-color-5),
:deep(.custom-table .bg-color-5),
.bg-color-5 {
  background-color: #faf5ff !important;
}

:deep(.el-table .bg-color-6),
:deep(.el-table tbody .bg-color-6),
:deep(.custom-table .bg-color-6),
.bg-color-6 {
  background-color: #f0fdfa !important;
}

:deep(.el-table .bg-color-1 td),
:deep(.el-table tbody .bg-color-1 td),
:deep(.custom-table .bg-color-1 td),
.bg-color-1 td {
  background-color: #f0f9ff !important;
}

:deep(.el-table .bg-color-2 td),
:deep(.el-table tbody .bg-color-2 td),
:deep(.custom-table .bg-color-2 td),
.bg-color-2 td {
  background-color: #f0fdf4 !important;
}

:deep(.el-table .bg-color-3 td),
:deep(.el-table tbody .bg-color-3 td),
:deep(.custom-table .bg-color-3 td),
.bg-color-3 td {
  background-color: #fefce8 !important;
}

:deep(.el-table .bg-color-4 td),
:deep(.el-table tbody .bg-color-4 td),
:deep(.custom-table .bg-color-4 td),
.bg-color-4 td {
  background-color: #fef2f2 !important;
}

:deep(.el-table .bg-color-5 td),
:deep(.el-table tbody .bg-color-5 td),
:deep(.custom-table .bg-color-5 td),
.bg-color-5 td {
  background-color: #faf5ff !important;
}

:deep(.el-table .bg-color-6 td),
:deep(.el-table tbody .bg-color-6 td),
:deep(.custom-table .bg-color-6 td),
.bg-color-6 td {
  background-color: #f0fdfa !important;
}

.custom-table :deep(.el-table tbody tr.bg-color-1:hover) {
  background-color: #e0f2fe !important;
}

.custom-table :deep(.el-table tbody tr.bg-color-2:hover) {
  background-color: #dcfce7 !important;
}

.custom-table :deep(.el-table tbody tr.bg-color-3:hover) {
  background-color: #fef9c3 !important;
}

.custom-table :deep(.el-table tbody tr.bg-color-4:hover) {
  background-color: #fee2e2 !important;
}

.custom-table :deep(.el-table tbody tr.bg-color-5:hover) {
  background-color: #f3e8ff !important;
}

.custom-table :deep(.el-table tbody tr.bg-color-6:hover) {
  background-color: #ccfbf1 !important;
}

.custom-table :deep(.el-table tbody tr.bg-color-1:hover td) {
  background-color: #e0f2fe !important;
}

.custom-table :deep(.el-table tbody tr.bg-color-2:hover td) {
  background-color: #dcfce7 !important;
}

.custom-table :deep(.el-table tbody tr.bg-color-3:hover td) {
  background-color: #fef9c3 !important;
}

.custom-table :deep(.el-table tbody tr.bg-color-4:hover td) {
  background-color: #fee2e2 !important;
}

.custom-table :deep(.el-table tbody tr.bg-color-5:hover td) {
  background-color: #f3e8ff !important;
}

.custom-table :deep(.el-table tbody tr.bg-color-6:hover td) {
  background-color: #ccfbf1 !important;
}

.custom-table .el-table th {
  background-color: #409eff !important;
  color: white !important;
  font-size: 16px !important;
  font-weight: bold;
}

.custom-table .el-table th .cell {
  color: white !important;
}

.parent-task-content {
  color: #2c5aa0;
  font-weight: 600;
  background-color: #f0f4f8;
  border-radius: 4px;
  padding: 4px 8px;
}

.sub-task-content {
  font-size: 1em;
  font-style: normal;
  color: #2c3e50;
  font-weight: 500;
  line-height: 1.6;
  white-space: pre-wrap;
}
</style>