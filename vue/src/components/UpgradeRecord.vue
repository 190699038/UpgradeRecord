<template>
  <div class="container">

    <!-- 查询区域 -->
    <div class="search-area">
      <el-button type="primary" @click="openDialog('create')">新增记录</el-button>
      <el-date-picker v-model="searchParams.start_time" type="datetime" placeholder="选择开始时间"
        value-format="YYYY-MM-DD HH:mm:ss" />
      <el-date-picker v-model="searchParams.end_time" type="datetime" placeholder="选择结束时间"
        value-format="YYYY-MM-DD HH:mm:ss" />
      <el-select v-model="searchParams.country" style="width: 120px;" placeholder="选择国家">
        <el-option v-for="country in countryOptions" :key="country.value" :label="country.label"
          :value="country.value" />
      </el-select>
      <el-button type="primary" @click="fetchRecords">查询</el-button>
      <el-button @click="copyYesterdayContent">复制昨日上线内容</el-button>
    </div>

    <!-- 数据表格 -->
    <el-table :data="tableData" border>
      <el-table-column prop="id" label="序号" header-align="center" align="center" width="90" />
      <el-table-column prop="country" label="国家" header-align="center" align="center" width="100"
        :formatter="formatCountry" />
      <el-table-column prop="content" label="升级内容" header-align="center">
        <template #default="scope">
          <div style="white-space: pre-line">{{ scope.row.content }}</div>
        </template>
      </el-table-column>
      <el-table-column prop="type" label="类型" header-align="center" align="center" width="90" />
      <el-table-column prop="platform" label="平台" header-align="center" align="center" width="60" />
      <el-table-column prop="updater" label="研发" header-align="center" align="center" width="100"
        show-overflow-tooltip />
      <el-table-column prop="tester" label="测试" header-align="center" align="center" width="100"
        show-overflow-tooltip />
      <el-table-column prop="is_review" label="复盘" header-align="center" align="center" width="100"
        show-overflow-tooltip :formatter="formatReview" />

      <el-table-column prop="remark" label="备注" header-align="center" align="center" width="100"
        show-overflow-tooltip />

      <el-table-column prop="update_time" label="更新时间" header-align="center" align="center" width="150" />
      <el-table-column label="操作" width="150" header-align="center" align="center">
        <template #default="scope">
          <el-button size="small" @click="openDialog('edit', scope.row)">编辑</el-button>
          <el-button size="small" type="danger" @click="handleDelete(scope.row)">删除</el-button>
          <el-button size="small" style="margin-top: 3px;" v-if="scope.row.is_review == 1"
            @click="review(scope.row)">查看复盘</el-button>

        </template>
      </el-table-column>
    </el-table>

    <!-- 弹窗表单 -->
    <el-dialog :title="dialogTitle" v-model="dialogVisible">
      <template #header>
        <div class="dialog-header">
          <span>{{ dialogTitle }}</span>
          <el-button type="primary" size="small" @click="openTextParser">解析文本内容</el-button>
        </div>
      </template>
      <el-form :model="formData" :rules="formRules" ref="formRef" label-width="80px">
        <el-form-item label="国家" prop="country" l>
          <el-select v-model="formData.country">
            <el-option v-for="country in countryOptions" :key="country.value" :label="country.label"
              :value="country.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="类型" prop="type">
          <el-select v-model="formData.type">
            <el-option v-for="type in typeOptions" :key="type.value" :label="type.label" :value="type.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="平台" prop="platform">
          <el-select v-model="formData.platform">
            <el-option v-for="platform in platformOptions" :key="platform.value" :label="platform.label"
              :value="platform.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="升级内容" prop="content">
          <el-input v-model="formData.content" type="textarea" :rows="4" placeholder="请输入升级内容" />
        </el-form-item>
        <el-form-item label="复盘" prop="platform">
          <el-select v-model="formData.is_review">
            <el-option v-for="platform in is_review_options" :key="platform.value" :label="platform.label"
              :value="platform.value" />
          </el-select>
        </el-form-item>

        <el-form-item label="测试人员" prop="tester">
          <el-select v-model="formData.tester" multiple filterable placeholder="请选择测试人员">
            <el-option v-for="tester in testers" :key="tester.id" :label="tester.username" :value="tester.username" />
          </el-select>
        </el-form-item>
        <el-form-item label="更新人" prop="updater">
          <el-select v-model="formData.updater" multiple filterable placeholder="请选择更新人">
            <el-option v-for="dev in develops" :key="dev.id" :label="dev.username" :value="dev.username" />
          </el-select>
        </el-form-item>
        <el-form-item label="更新时间" prop="update_time">
          <el-date-picker
            v-model="formData.update_time"
            type="datetime"
            placeholder="选择更新时间"
            value-format="YYYY-MM-DD HH:mm:ss"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="formData.remark" type="textarea" />
        </el-form-item>

      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确认</el-button>
      </template>
    </el-dialog>
    <!-- 复盘弹窗 -->
    <el-dialog v-model="reviewDialogVisible" title="升级内容复盘" :width="`${windowWidth * 0.8}px`"
      :height="`${windowHeight * 0.8}px`" top="5vh">
      <div class="editor-container">
        <div class="content-container">{{ reviewInfo.review_content == null ? '' : reviewInfo.review_content }}</div>

        <el-select v-model="reviewInfo.product_manager_id" placeholder="复盘人员" style="margin-bottom: 16px">
          <el-option v-for="pm in ProductManagers" :key="pm.id" :label="pm.username" :value="pm.id" />
        </el-select>
        <QuillEditor v-model:content="conclusion" :options="editorOptions" contentType="html" ref="myQuillEditor"
          style="height: 80%;" @ready="handleEditorReady" />
      </div>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitFormReview">提交</el-button>

      </template>
    </el-dialog>

  </div>
</template>

<script setup>
import { ref, onMounted, computed, onBeforeUnmount } from 'vue';
import { ElMessageBox } from 'element-plus';
import api from '@/utils/api.js';
import { QuillEditor ,Quill} from '@vueup/vue-quill'
import 'quill/dist/quill.snow.css'
import DOMPurify from 'dompurify'
// import ImageDropAndPaste from 'quill-image-drop-and-paste'
// QuillEditor.Quill.register('modules/imageDropAndPaste', ImageDropAndPaste)
import { ElMessage } from 'element-plus'

const myQuillEditor = ref(null)

const tableData = ref([])
const develops = ref([])
const testers = ref([])
const ProductManagers = ref([])

const currentRow = ref({});
const reviewDialogVisible = ref(false);
const editorRef = ref(null);
const editorContent = ref('');
const windowWidth = ref(window.innerWidth);
const windowHeight = ref(window.innerHeight);
const dialogVisible = ref(false)
const dialogType = ref('create')

const reviewInfo = ref({ 'review_content': '', 'conclusion': '' })
const dialogTitle = computed(() => {
  return dialogType.value === 'create' ? '新增记录' : '编辑记录'
})

const conclusion = ref('')
const searchParams = ref({
  start_time: '',
  end_time: '',
  country: ''
})
const formData = ref({
  country: '',
  content: '',
  type: '',
  platform: '',
  tester: [],
  updater: [],
  update_time: '',
  remark: ''
})
const formRules = ref({
  country: [{ required: true, message: '请选择国家', trigger: 'change' }],
  update_time: [{ required: true, message: '请选择更新时间', trigger: 'change' }],
  content: [{
    required: true,
    message: '请输入升级内容',
    trigger: 'change',
    type: 'string',
    min: 1
  }],
  type: [{ required: true, message: '请选择类型', trigger: 'change' }],
  platform: [{ required: true, message: '请选择平台', trigger: 'change' }],
  tester: [{
    required: true,
    message: '请输入测试人员',
    trigger: 'change',
    type: 'array',
    min: 1
  }],
  updater: [{
    required: true,
    message: '请输入更新人',
    trigger: 'change',
    type: 'array',
    min: 1
  }]
})
const countryOptions = ref([
  { value: 'US', label: '美国' },
  { value: 'BR', label: '巴西' },
  { value: 'MX', label: '墨西哥' },
  { value: 'PE', label: '秘鲁' },
  { value: 'CL', label: '智利' },
  { value: 'AU', label: '澳大利亚' }
])
const typeOptions = ref([
  { value: '新功能', label: '新功能' },
  { value: '新游戏', label: '新游戏' },
  { value: 'bug修复', label: 'bug修复' },
  { value: '功能优化', label: '功能优化' }
])
const platformOptions = ref([
  { value: '前端', label: '前端' },
  { value: '后端', label: '后端' },
  { value: '前后端', label: '前后端' },
  { value: '数据库', label: '数据库' }
])
const is_review_options = ref([
  { value: 1, label: '是' },
  { value: 0, label: '否' }
])

onMounted(() => {
  // 初始化默认时间
  const todayStart = new Date();
  todayStart.setDate(todayStart.getDate() - 7);
  todayStart.setHours(0, 0, 0, 0);
  
  searchParams.value.start_time = new Date(todayStart.getTime() - todayStart.getTimezoneOffset() * 60000)
  .toISOString()
  .slice(0, 19)
  .replace('T', ' ');//todayStart.toISOString().slice(0, 19).replace('T', ' ');
  const todayEnd = new Date();
  todayEnd.setHours(23, 59, 59, 0);
  searchParams.value.end_time = new Date(todayEnd.getTime() - todayEnd.getTimezoneOffset() * 60000)
  .toISOString()
  .slice(0, 19)
  .replace('T', ' ');
  searchParams.value.country = 'US'
  fetchUserList()
  fetchRecords()
})

const editorInstance = ref(null)

const handleEditorReady = (quill) => {
  class CustomTextBlot extends Quill.import('blots/text') {
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
          type: 'update',
          record_id: currentRow.value?.id ? currentRow.value.id : 0
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
}

const editorOptions = {
  modules: {
    toolbar: [
      ['bold', 'italic', 'underline', 'strike'],
      [{ 'color': [] }, { 'background': [] }],
      ['blockquote', 'code-block'],
      [{ 'header': 1 }, { 'header': 2 }],
      [{ 'list': 'ordered' }, { 'list': 'bullet' }],
      [{ 'script': 'sub' }, { 'script': 'super' }],
      ['link'],
      ['clean']
    ],
    // Removed clipboard configuration from here
  }
};




const submitFormReview = async () => {
  if (reviewInfo.value.product_manager_id == null || reviewInfo.value.product_manager_id == '') {
    ElMessage.error('请选择复盘人员')
    return
  }
  const quill = myQuillEditor.value.getQuill(); // 获取 Quill 实例
  // const range = quill.getSelection(true); // 当前光标位置[2](@ref)
  // const deltaString = JSON.stringify(quill.getContents());

  console.log('更新复盘结论 ----' + quill.root.innerHTML);

  // const cleanHTML = DOMPurify.sanitize(quill.root.innerHTML, {
  //   ALLOWED_TAGS: ['p', 'strong', 'em', 'img', 'a'], // 自定义允许标签
  //   ALLOWED_ATTR: ['href', 'src', 'alt']
  // })
  const submitData = {
    country: currentRow.value.country,
    record_id: currentRow.value.id,
    review_content: reviewInfo.value.review_content,
    review_time: new Date().toISOString().slice(0, 19).replace('T', ' '),
    reviewer: reviewInfo.value.product_manager_id,
    conclusion: encodeURIComponent(quill.root.innerHTML),
    screenshot_url: '',
  }
  try {
    if (reviewInfo.value.id == null || reviewInfo.value.id == '') {
      await api.post('/api.php?table=review_record&action=create', submitData);
    } else {
      submitData.id = reviewInfo.value.id
      // await api.post('/api.php?table=review_record&action=update', submitData);
      await api.put(`/api.php?table=review_record&action=update&id=${reviewInfo.value.id}`, submitData);
    }
    reviewDialogVisible.value = false;
    fetchRecords()
    // fetchReviewInfo()
  } catch (error) {
    console.error('获取记录列表失败:', error);
    tableData.value = [];
  }

  dialogVisible.value = false;
}

const fetchRecords = async () => {
  try {
    const response = await api.post('/api.php?table=upgrade_record&action=list', searchParams.value);
    tableData.value = response.data.data;
  } catch (error) {
    console.error('获取记录列表失败:', error);
    tableData.value = [];
  }
}

const fetchReviewInfo = async () => {
  try {
    const response = await api.get('/api.php?table=review_record&action=get&id=' + currentRow.value.id);

    if (response.data.data.id > 0) {
      reviewInfo.value = response.data.data;
      conclusion.value = decodeURIComponent(reviewInfo.value.conclusion);

      console.log('上次复盘结论 ----' + conclusion.value);

    } else {
      reviewInfo.value.review_content = currentRow.value.content
      reviewInfo.value.conclusion = currentRow.value.content

    }


  } catch (error) {
    console.error('获取记录列表失败:', error);
    tableData.value = [];
  }
}

const openDialog = (type, row) => {
  dialogType.value = type;
  dialogType.value === 'create' ? '新增记录' : '编辑记录'

  if (type === 'edit') {
    formData.value = {
      ...row,
      tester: row.tester ? row.tester.split('、') : [],
      updater: row.updater ? row.updater.split('、') : []
    }
  } else {
    formData.value = {
      country: '',
      content: '',
      type: '',
      platform: '',
      tester: '',
      remark: ''
    }
  }
  dialogVisible.value = true;
}


const submitForm = async () => {
  const method = dialogType.value === 'create' ? 'post' : 'put'
  const url = dialogType.value === 'create'
    ? '/api.php?table=upgrade_record&action=create'
    : `/api.php?table=upgrade_record&action=update&id=${formData.value.id}`
  const submitData = {
    ...formData.value,
    tester: formData.value.tester.join('、'),
    updater: formData.value.updater.join('、'),
    update_time: formData.value.update_time
  }
  try {
    api[method](url, submitData)
    dialogVisible.value = false
    setTimeout(() => {
      fetchRecords()
    }, 1000)
  } catch (error) {
    console.error('提交表单失败:', error);
  }
}

const handleDelete = async (row) => {
  try {
    await api.delete(`/api.php?table=upgrade_record&action=delete&id=${row.id}`);
    fetchRecords();
  } catch (error) {
    console.error('删除记录失败:', error);
  }
}

const copyYesterdayContent = async () => {
  try {
    const endDate = new Date();
    const startDate = new Date();
    startDate.setDate(endDate.getDate() - 2);

    const filteredData = tableData.value.filter(record => {
      const recordTime = new Date(record.update_time);
      return recordTime >= startDate && recordTime <= endDate;
    });

    if (filteredData.length === 0) {
      ElMessage.warning('最近两天没有可复制的升级内容');
      return;
    }

    let textContent = '';
    filteredData.forEach(record => {
      const countryLabel = countryOptions.value.find(c => c.value === record.country)?.label || record.country;
      const timeString = record.update_time.replace(/-/g, '/');
      
      textContent += `${countryLabel}${record.platform}上线 (${timeString}) 更新内容：\n${record.content}\n\n`;
    });

    // 浏览器能力检测
    if (navigator.clipboard) {
      await navigator.clipboard.writeText(textContent);
    } else {
      // 降级方案：使用textarea执行复制
      const textarea = document.createElement('textarea');
      textarea.value = textContent;
      textarea.style.position = 'fixed';
      textarea.style.opacity = '0';
      document.body.appendChild(textarea);
      textarea.select();
      
      try {
        const successful = document.execCommand('copy');
        if (!successful) throw new Error('复制失败');
      } finally {
        document.body.removeChild(textarea);
      }
    }
    
    ElMessage.success('内容已复制到剪贴板');
  } catch (error) {
    console.error('复制失败:', error);
    ElMessage.error({
      message: '复制失败: ' + (error.message || '请手动复制内容'),
      duration: 5000
    });
  }
};

const review = (row) => {
  currentRow.value = row;
  // editorContent.value = row.content;
  reviewDialogVisible.value = true;
  fetchReviewInfo();
};


const insertImageToEditor = (url) => {
  const quill = myQuillEditor.value.getQuill(); // 获取 Quill 实例
  const range = quill.getSelection(true); // 当前光标位置[2](@ref)
  quill.insertEmbed(range.index, 'image', url); // 插入图片[2,7](@ref)
};


// 窗口尺寸监听
const handleResize = () => {
  windowWidth.value = window.innerWidth;
  windowHeight.value = window.innerHeight;
};

onMounted(() => {
  window.addEventListener('resize', handleResize);
});

onBeforeUnmount(() => {
  window.removeEventListener('resize', handleResize);
});

const fetchUserList = async () => {
  try {
    const response = await api.get('/api.php?table=user');
    const users = response.data.data;
    for (let index = 0; index < users.length; index++) {
      const element = users[index];
      if (element.position === '测试') {
        testers.value.push(element);
      } else if (element.position === '产品') {
        ProductManagers.value.push(element);
      }
      else {
        develops.value.push(element);
      }
    }
  } catch (error) {
    console.error('获取用户列表失败:', error);
  }
}

const formatCountry = (row) => {
  const found = countryOptions.value.find(opt => opt.value === row.country);
  return found ? found.label : row.country;
}

const formatReview = (row) => {
  const found = is_review_options.value.find(opt => opt.value === row.is_review);
  return found ? found.label : row.is_review;
}

const openTextParser = () => {
  ElMessageBox.prompt('请输入要解析的文本内容', '内容解析', {
    inputType: 'textarea',
    draggable: true,
    closeOnClickModal: false,
    beforeClose: (action, instance, done) => {
      if (action === 'confirm') {
        if (!instance.inputValue.trim()) {
          ElMessage.error('请输入要解析的内容')
          return
        }
        parseContent(instance.inputValue)
      }
      done()
    }
  }).catch(() => {})
}

const parseContent = (text) => {
  const patterns = {
    content: /【更新内容】：([\s\S]*?)(?=ꔷ|\n【|$)/,
    country: /【地区】：\s*([^\n]+)/,
    updateTime: /【上线时间（国内）[^】]*】：\s*(\d{4})(\d{2})(\d{2})\s*(\d{2}:\d{2})/,
    updater: /【开发人员[^】]*】：\s*([^\n]+)/,
    tester: /【测试人员[^】]*】：\s*([^\n]+)/,
    remark: /【文档地址[^】]*】:?\s*([^\n]+)/
    }

  const extractField = (regex, text) => {
    const match = text.match(regex)
    return match ? match[1].trim() : ''
  }

  // 国家匹配
  formData.value.country = countryOptions.value.find(
    opt => opt.label === extractField(patterns.country, text)
  )?.value || ''

  // 时间格式转换
  const timeMatch = text.match(patterns.updateTime)
  if (timeMatch) {
    const [_, year, month, day, time] = timeMatch
    formData.value.update_time = `${year}-${month}-${day} ${time}:00`
  }

  // 开发人员模糊匹配
  const devNames = extractField(patterns.updater, text).split(/[、,]/)
  if (devNames.length) {
    formData.value.updater = devNames
      .flatMap(name => 
        develops.value
          .filter(dev => dev.username.toLowerCase().includes(name.trim().toLowerCase()))
          .map(dev => dev.username)
      )
      .filter((v,i,a) => a.indexOf(v) === i) // 去重
  }

  // 测试人员模糊匹配
  const testerNames = extractField(patterns.tester, text).split(/[、,]/)
  if (testerNames.length) {
    formData.value.tester = testerNames
      .flatMap(name =>
        testers.value
          .filter(t => t.username.toLowerCase().includes(name.trim().toLowerCase()))
          .map(t => t.username)
      )
      .filter((v,i,a) => a.indexOf(v) === i) // 去重
  }

  // 备注信息
  formData.value.remark = extractField(patterns.remark, text)
  formData.value.content = extractField(patterns.content, text)

}


</script>

<style scoped>
.editor-container {
  height: calc((90vh - 200px));
}

:deep(.w-e-text-container) {
  height: 100% !important;
}

.upgrade-record {
  padding: 20px;
}

.content-container {
  white-space: pre-wrap;
  margin-bottom: 16px;
  padding: 8px;
  border: 1px solid #ebeef5;
  border-radius: 4px;
}

:deep(.el-table .cell) {
  white-space: pre-wrap;
}
</style>

