<template>
  <div class="container">

    <!-- 查询区域 -->
    <div class="search-area">
      <el-button type="primary" @click="openDialog('create')">新增记录</el-button>
      <el-date-picker
        v-model="searchParams.start_time"
        type="datetime"
        placeholder="选择开始时间"
        value-format="YYYY-MM-DD HH:mm:ss"
      />
      <el-date-picker
        v-model="searchParams.end_time"
        type="datetime"
        placeholder="选择结束时间"
        value-format="YYYY-MM-DD HH:mm:ss"
      />
      <el-select v-model="searchParams.country" style="width: 120px;" placeholder="选择国家">
        <el-option
          v-for="country in countryOptions"
          :key="country.value"
          :label="country.label"
          :value="country.value"
        />
      </el-select>
      <el-button type="primary" @click="fetchRecords">查询</el-button>
      <el-button @click="copyYesterdayContent">复制昨日上线内容</el-button>
    </div>

    <!-- 数据表格 -->
    <el-table :data="tableData" border>
      <el-table-column prop="country" label="国家" header-align="center" align="center" width="100" :formatter="formatCountry"/>
      <el-table-column prop="content" label="升级内容" header-align="center">
        <template #default="scope">
          <div style="white-space: pre-line">{{ scope.row.content }}</div>
        </template>
      </el-table-column>
      <el-table-column prop="type" label="类型" header-align="center" align="center" width="90"/>
      <el-table-column prop="platform" label="平台" header-align="center" align="center" width="60"/>
      <el-table-column prop="updater" label="研发" header-align="center" align="center" width="100" show-overflow-tooltip/>
      <el-table-column prop="tester" label="测试" header-align="center" align="center" width="100" show-overflow-tooltip/>
      <el-table-column prop="is_review" label="复盘" header-align="center" align="center" width="100" show-overflow-tooltip :formatter="formatReview"/>

      <el-table-column prop="remark" label="备注" header-align="center" align="center" width="100" show-overflow-tooltip/>

      <el-table-column prop="update_time" label="更新时间" header-align="center" align="center" width="150"/>
      <el-table-column label="操作" width="150" header-align="center" align="center">
        <template #default="scope">
          <el-button size="small" @click="openDialog('edit', scope.row)">编辑</el-button>
          <el-button size="small" type="danger" @click="handleDelete(scope.row)">删除</el-button>
          <el-button size="small" style="margin-top: 3px;" v-if="scope.row.is_review == 1" @click="review(scope.row)">查看复盘</el-button>

        </template>
      </el-table-column>
    </el-table>

    <!-- 弹窗表单 -->
    <el-dialog :title="dialogTitle" v-model="dialogVisible">
      <el-form :model="formData" :rules="formRules" ref="formRef" label-width="80px">
        <el-form-item label="国家" prop="country" l>
          <el-select v-model="formData.country">
            <el-option
              v-for="country in countryOptions"
              :key="country.value"
              :label="country.label"
              :value="country.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="类型" prop="type">
          <el-select v-model="formData.type">
            <el-option
              v-for="type in typeOptions"
              :key="type.value"
              :label="type.label"
              :value="type.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="平台" prop="platform">
          <el-select v-model="formData.platform">
            <el-option
              v-for="platform in platformOptions"
              :key="platform.value"
              :label="platform.label"
              :value="platform.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="升级内容" prop="content">
          <el-input
            v-model="formData.content"
            type="textarea"
            :rows="4"
            placeholder="请输入升级内容"
          />
        </el-form-item>
        <el-form-item label="复盘" prop="platform">
          <el-select v-model="formData.is_review">
            <el-option
              v-for="platform in is_review_options"
              :key="platform.value"
              :label="platform.label"
              :value="platform.value"
            />
          </el-select>
        </el-form-item>

        <el-form-item label="测试人员" prop="tester">
          <el-select 
            v-model="formData.tester"
            multiple
            filterable
            placeholder="请选择测试人员">
            <el-option
              v-for="tester in testers"
              :key="tester.id"
              :label="tester.username"
              :value="tester.username"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="更新人" prop="updater">
          <el-select
            v-model="formData.updater"
            multiple
            filterable
            placeholder="请选择更新人">
            <el-option
              v-for="dev in develops"
              :key="dev.id"
              :label="dev.username"
              :value="dev.username"
            />
          </el-select>
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
    <el-dialog
      v-model="reviewDialogVisible"
      title="升级内容复盘"
      :width="`${windowWidth * 0.8}px`"
      :height="`${windowHeight * 0.8}px`"
      top="5vh"
    >
      <div class="editor-container">
        <div class="content-container">{{ currentRow.content }}</div>

        <QuillEditor
          v-model:content="editorContent"
          :options="editorOptions"
          contentType="html"
          ref="myQuillEditor"
        />
      </div>
      <template #footer>
        <el-button @click="reviewDialogVisible = false">关闭</el-button>
      </template>
    </el-dialog>

  </div>
</template>

<script setup>
import { ref, onMounted, computed, onBeforeUnmount } from 'vue';
import api from '@/utils/api.js';
import { QuillEditor } from '@vueup/vue-quill'
import 'quill/dist/quill.core.css'
import 'quill/dist/quill.snow.css'

const tableData =  ref([])
const develops=  ref([])
const testers=  ref([])
const currentRow = ref({});
const reviewDialogVisible = ref(false);
const editorRef = ref(null);
const editorContent = ref('');
const windowWidth = ref(window.innerWidth);
const windowHeight = ref(window.innerHeight);
const dialogVisible = ref(false)
const dialogType = ref('create')
const dialogTitle = computed(() => {
  return dialogType.value === 'create' ? '新增记录' : '编辑记录'
})
const searchParams = ref({
        start_time: '',
        end_time: '',
        country: ''
      })
const formData =ref ({
        country: '',
        content: '',
        type: '',
        platform: '',
        tester: [],
        updater: [],
        update_time: '',
        remark: ''
      })
const formRules = ref ({
        country: [{ required: true, message: '请选择国家', trigger: 'change' }],
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
const  countryOptions = ref( [
        { value: 'US', label: '美国' },
        { value: 'BR', label: '巴西' },
        { value: 'MX', label: '墨西哥' },
        { value: 'PE', label: '秘鲁' },
        { value: 'CL', label: '智利' },
        { value: 'AU', label: '澳大利亚' }
      ])
const  typeOptions = ref( [
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
const is_review_options = ref ([
        { value: 1, label: '是' },
        { value: 0, label: '否' }
      ])

onMounted(() => {
  fetchUserList()
  fetchRecords()
})


const fetchRecords = async () => {
  try {
    const response = await api.post('/api.php?table=upgrade_record&action=list', searchParams.value);
    tableData.value = response.data.data ; 
  }catch (error) {
    console.error('获取记录列表失败:', error); 
    tableData.value  = [];
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
  }else{
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
            update_time: new Date().toISOString().slice(0, 19).replace('T', ' ')}
    try {
      api[method](url, submitData)
      dialogVisible.value = false
      fetchRecords()
    }catch (error) {
      console.error('提交表单失败:', error); 
    }
}

const handleDelete = async (row) => {
  try {
    await api.delete(`/api.php?table=upgrade_record&action=delete&id=${row.id}`);
    fetchRecords()    ; 
  } catch(error) {
    console.error('删除记录失败:', error);
  }
}

const copyYesterdayContent = async () => {

}

const review = (row) => {
  currentRow.value = row;
  editorContent.value = row.content;
  reviewDialogVisible.value = true;
};

const handleEditorCreated = (editor) => {
  const toolbar = editor.getModule('toolbar');
  toolbar.addHandler('image', () => {
    const input = document.createElement('input');
    input.type = 'file';
    input.accept = 'image/*';
    input.onchange = async () => {
      const file = input.files[0];
      const formData = new FormData();
      formData.append('file', file);
      try {
        const res = await api.post(`http://localhost/Record/server/upload.php?record_id=${currentRow.value.id}`, formData);
        const range = editor.getSelection();
        editor.insertEmbed(range.index, 'image', res.data.url);
      } catch (error) {
        console.error('图片上传失败:', error);
      }
    };
    input.click();
  });
};

const editorOptions = {
  modules: {
    toolbar: [
      ['bold', 'italic', 'underline', 'strike'],
      ['blockquote', 'code-block'],
      [{ 'header': 1 }, { 'header': 2 }],
      [{ 'list': 'ordered'}, { 'list': 'bullet' }],
      [{ 'script': 'sub'}, { 'script': 'super' }],
      ['link', 'image'],
      ['clean']
    ]
  }
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
          }else{
            develops.value.push(element);
          }
        }
      }catch (error) {
        console.error('获取用户列表失败:', error);
      }
    }

const formatCountry = (row) => {
      const found = countryOptions.value.find(opt => opt.value === row.country);
      return found ? found.label : row.country;
    }

const formatReview = (row) => {
      const found = is_review_options.value.find(opt => opt.value === row.is_review);
      return found? found.label : row.is_review;
    }

</script>

<style scoped>
.editor-container {
  height: calc(80vh - 100px);
}

:deep(.w-e-text-container) {
  height: 600px !important;
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