<template>
  <div class="review-record">
    <div class="filter-container">
      <el-button type="primary" @click="openDialog('create')">新增记录</el-button>

      <el-date-picker
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
      />
      <el-button type="primary" @click="fetchRecords">查询</el-button>

    </div>
    <el-table :data="tableData" border>
      <el-table-column prop="date" label="日期" header-align="center" align="center" width="150" />
      <el-table-column prop="initiator" label="发起人" header-align="center" align="center" width="120" show-overflow-tooltip />
      <el-table-column prop="participants" label="参与人" header-align="center" align="center" width="120" show-overflow-tooltip />
      <el-table-column prop="purpose" label="目的" header-align="center" show-overflow-tooltip width="300"/>
      <el-table-column prop="content" label="结论" header-align="center" show-overflow-tooltip>
        <template #default="scope">
          <div style="white-space: pre-line">{{ scope.row.content }}</div>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="150" header-align="center" align="center">
        <template #default="scope">
          <el-button size="small" @click="handleEdit(scope.row)">编辑</el-button>
          <el-button size="small" type="danger" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="dialogVisible" :title="dialogType === 'edit' ? '编辑记录' : '新增记录'" style="width: 80%;height: 75%;">
      <el-form ref="formRef" :model="formData" :rules="formRules" label-width="80px" style="width: 90%; height: 100%;">
        <el-form-item label="日期">
          <el-date-picker
            v-model="formData.date"
            type="date"
            value-format="YYYYMMDD"
          />
        </el-form-item>
        <!-- <el-form-item label="目的">
          <el-input v-model="formData.purpose"/>
        </el-form-item>
        <el-form-item label="参会人">
          <el-select v-model="formData.initiator" multiple filterable placeholder="请选择参会人">
          <el-option v-for="user in users" :key="user.id" :label="user.username" :value="user.username" />
        </el-select>
        </el-form-item>
        <el-form-item label="参与人">
          <el-select v-model="formData.participants" multiple filterable placeholder="请选择参与人">
          <el-option v-for="user in users" :key="user.id" :label="user.username" :value="user.username" />
        </el-select> -->
        <!-- </el-form-item> -->
        <!-- <el-form-item label="结论">
          <el-input v-model="formData.conclusion" type="textarea" rows="8"/>
        </el-form-item> -->
        <el-form-item label="结论">
          <div style="width: 100%; height: 100%; display: flex; flex-direction: column; flex: 1;">
            <QuillEditor 
              v-model:content="conclusion"
              :options="editorOptions"
              contentType="html"
              style="height: 55vh;width: 110%;"
              ref="myQuillEditor"
              @ready="handleEditorReady"
            />
          </div>
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
import { ref, onMounted  } from 'vue'
import { ElMessageBox,ElMessage } from 'element-plus';
import { QuillEditor ,Quill} from '@vueup/vue-quill'
import Delta from 'quill-delta';

import api from '../utils/api'
import { id } from 'element-plus/es/locales.mjs';
const editorInstance = ref(null)

const tableData = ref([])
const conclusion = ref('<p><strong style="color: #ff0000;">目的：xxx</strong></p><p><br></p><p>发起人：xxx</p><p><br></p><p>参会人：xxx</p><p><br></p><p><strong>结论：</strong></p><p>1. </p><p>2. </p><p>3. </p><p>4. </p><p><br></p>')
const searchParams = ref({
  start_date: '',
  end_date: ''

})
const customColors = ref(['#000000', '#ff0000', '#ffffff'])

const myQuillEditor = ref(null)


const fetchRecords = async () => {
  try {
    const response = await api.post('/api.php?table=chen_yaopu_review&action=list', searchParams.value)
    tableData.value = response.data.data
  } catch (error) {
    console.error('获取记录失败:', error)
    tableData.value = []
  }
}

const dialogVisible = ref(false)
const dialogType = ref('create')

const formRules = ref({
  date: [{ required: true, message: '请选择日期', trigger: 'change' }],
  // purpose: [{ required: true, message: '请输入会议目的', trigger: 'blur' }],
  // initiator: [{ required: true, message: '请选择参会人', trigger: 'change' }],
  // participants: [{ required: true, message: '请选择参与人', trigger: 'change' }],
  // conclusion: [{ required: true, message: '请输入会议结论', trigger: 'blur' }]
})

const users = ref([])

const formData = ref({
  id: 0,
  date: '',
  purpose: '',
  initiator: [],
  participants: [],
  conclusion: ''
})

const getUsers = async () => {
  try {
    const response = await api.post('/api.php?table=user&action=list')
    users.value = response.data.data
  } catch (error) {
    console.error('获取用户列表失败:', error)
  }
}

  const handleEdit = (row) => {
    dialogType.value = 'edit'
    formData.value = { 
      ...row,
      date: String(row.date).replace(/[^0-9]/g, '') // 添加String类型转换
    }
    dialogVisible.value = true

    conclusion.value =  row.conclusion



  }

  const formRef = ref(null)

const submitForm = async () => {
  try {
    // await formRef.value.validate()
    const quill = myQuillEditor.value.getQuill(); // 获取 Quill 实例
    const content = quill.root.innerHTML; // 获取 Quill 编辑器的内容
    console.log(content)
    const value = conclusion.value;

    console.log(value)
    //截取文案中相关内容，赋值给formData
    //字符串内容如:<p><strong style="color: #ff0000;">目的：xxx</strong></p><p><br></p><p>发起人：xxx</p><p><br></p><p>参会人：xxx</p><p><br></p><p><strong>结论：</strong></p><p>1. </p><p>2. </p><p>3. </p><p>4. </p><p><br></p>
    //截取目的
    const purpose = value.match(/目的：(.*?)<\/strong>/)[1]
    formData.value.purpose = purpose
    //截取发起人
    const initiator = value.match(/发起人：(.*?)<\/p>/)[1]
    formData.value.initiator = initiator
    //截取参会人
    const participants = value.match(/参会人：(.*?)<\/p>/)[1]
    formData.value.participants = participants
    //截取结论
    const ctent = value.match(/<strong>结论：<\/strong>(.*)/s)[1]
    .replace(/<\/p\s*\/?>/gi, '\n')
    .replace(/<[^>]*>/g, '')

    formData.value.content = ctent
    formData.value.conclusion = content

    const payload = {
      ...formData.value,
      screenshot_url	: '',
    }

    console.log(payload)

    const url = dialogType.value === 'edit' 
      ? `/api.php?table=chen_yaopu_review&action=update&id=${formData.value.id}`
      : '/api.php?table=chen_yaopu_review&action=create'

    await api[dialogType.value === 'edit' ? 'put' : 'post'](url, payload)
    ElMessage.success(dialogType.value === 'edit' ? '修改成功' : '创建成功')
    dialogVisible.value = false
    fetchRecords()
  } catch (error) {
    if (!error.response) {
      ElMessage.warning('请完善必填项')
    } else {
      console.error('操作失败:', error)
      ElMessage.error(error.response.data.message || '操作失败')
    }
  }
}

const handleDelete = async (row) => {
  try {
    await api.delete(`/api.php?table=chen_yaopu_review&action=delete&id=${row.id}`)
    fetchRecords()
  } catch (error) {
    console.error('删除失败:', error)
  }
}

const openDialog = (type, row = {}, event) => {
  // 参数默认值处理
  const safeRow = row?.row || row || {}
  dialogType.value = type
  formData.value = {
    id: safeRow?.id || 0,
    date: safeRow.date || new Date().toISOString().slice(0,10).replace(/-/g,''),
    purpose: '',
    initiator: [],
    participants: [],
    conclusion: '<p><strong style="color: #ff0000;">目的：xxx</strong></p><p><br></p><p>发起人：xxx</p><p><br></p><p>参会人：xxx</p><p><br></p><p><strong>结论：</strong></p><p>1. </p><p>2. </p><p>3. </p><p>4. </p><p><br></p>'
  }
  conclusion.value = formData.value.conclusion
  dialogVisible.value = true
}

onMounted(() => {
  getUsers()
  const end = new Date()
  const start = new Date()
  start.setDate(start.getDate() - 7)
  formData.value.date = end.toISOString().slice(0,10).replace(/-/g,'')
  
  searchParams.value.start_date = start.toISOString().slice(0,10).replace(/-/g,'')
  searchParams.value.end_date = end.toISOString().slice(0,10).replace(/-/g,'')
  fetchRecords()
})
const editorOptions = ref({
  theme: 'snow',
  placeholder: '请输入详细会议结论...',
  modules: {
    toolbar: [
      ['bold', 'italic', 'underline', 'strike'],
      ['blockquote', 'code-block'],
      [{ 'color': customColors.value }, { 'background': [] }],
      ['clean']
    ]
  }
})

const handleEditorReady = (quill) => {
  const Clipboard = Quill.import('modules/clipboard');
  class PlainClipboard extends Clipboard {
    static blotName = 'custom-text';
    static tagName = 'span';
    static className = 'custom-text';
  }
  Quill.register(CustomTextBlot);
  
  editorInstance.value = quill
  
  // 配置图片粘贴处理器
  quill.clipboard.addMatcher('img', async (node, delta) => {
    console.log('图片粘贴处理器被调用');
    const src = node.getAttribute('src')
    if (src.startsWith('data:')) {
      try {
        const res = await api.post(`/UploadImage.php`, {
          image: src,
          type: 'review',
          record_id: formData.value?.id ? formData.value.id : 0
        }, {
          headers: { 'Content-Type': 'application/json' }
        });
        insertImageToEditor(res.data.url);
      } catch (error) {
        console.error('图片上传失败:', error);
      }
    }
    return delta;
  });

  // 配置富文本粘贴处理器
  quill.clipboard.addMatcher(Node.ELEMENT_NODE, async (node, delta) => {
    console.log('配置富文本粘贴处理器');
    const opsList = [];
    delta.ops.forEach(op => {
      if (op.insert) {
        opsList.push({
          insert: op.insert,
        });
      }
    });
    delta.ops = opsList;
    return delta;

  });
  // 初始化空Delta对象
  quill.setContents(new Delta());
  }

const insertImageToEditor = (url) => {
  const quill = myQuillEditor.value.getQuill(); // 获取 Quill 实例
  const range = quill.getSelection(true); // 当前光标位置[2](@ref)
  quill.insertEmbed(range.index, 'image', url); // 插入图片[2,7](@ref)
};

</script>

<style scoped>
.filter-container {
  margin-bottom: 20px;
  display: flex;
  gap: 10px;
}

.el-date-editor {
  width: 200px;
}
</style>

<style scoped>
.review-record {
  padding: 20px;
}
</style>
