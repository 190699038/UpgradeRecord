<template>
    <div class="crud-container">

        <div class="column-control">
            <el-button @click="dialogVisible = true">列筛选</el-button>
            <el-dialog title="显示列设置" v-model="dialogVisible" width="60%">
                <el-checkbox-group v-model="selectedColumns">
                    <el-checkbox v-for="(value, key) in columnsVisibility" :key="key" :label="key"
                        @change="handleColumnChange">
                        {{ getColumnLabel(key) }}
                    </el-checkbox>
                </el-checkbox-group>
            </el-dialog>
        </div>


        <el-table :data="tableData" style="width: 100%" :fit="true" :row-style="{ height: 'auto' }"
            :cell-style="{ padding: '0px 0' }" :header-cell-style="getHeaderClassName">
            <el-table-column v-if="columnsVisibility.id" label="ID" align="center" width="48" prop="id"
                header-align="center" />

            <!-- 新增合并表头 -->
            <el-table-column label="需求概述（产品组填写）" header-align="center"
                v-if="columnsVisibility.goal || columnsVisibility.requirement_name || columnsVisibility.content">
                <el-table-column v-if="columnsVisibility.requirement_name" prop="requirement_name" label="需求名称"
                    width="250" header-align="center">
                    <template #default="scope">
                        <div style="white-space: normal;">{{ scope.row.requirement_name }}</div>
                    </template>
                </el-table-column>
                <el-table-column prop="goal" label="目标" width="250" header-align="center" v-if="columnsVisibility.goal">
                    <template #default="scope">
                        <div v-html="scope.row.goal" style="white-space: normal;"></div>
                    </template>
                </el-table-column>
                <el-table-column prop="content" label="内容" width="250" header-align="center"
                    v-if="columnsVisibility.content">
                    <template #default="scope">
                        <div v-html="scope.row.content" style="white-space: normal;"></div>
                    </template>
                </el-table-column>
            </el-table-column>

            <!-- 分组2 -->
            <el-table-column label="相关信息（产品组填写）" header-align="center" v-if="columnsVisibility.planned_launch || columnsVisibility.requirement_meeting_time || columnsVisibility.requirement_document || columnsVisibility.review_form || columnsVisibility.project || columnsVisibility.priority || columnsVisibility.source|| columnsVisibility.owner || columnsVisibility.progress">
                <el-table-column prop="project" label="项目" width="81" align="center" v-if="columnsVisibility.project"/>
                <el-table-column prop="priority" label="优先级" width="61" align="center"  v-if="columnsVisibility.priority"/>
                <el-table-column prop="source" label="来源" width="75" align="center"  v-if="columnsVisibility.source"/>
                <el-table-column prop="owner" label="负责人" width="61" align="center"  v-if="columnsVisibility.owner"/>
                <el-table-column prop="progress" label="进度" width="85" align="center"  v-if="columnsVisibility.progress"/>
                <el-table-column prop="review_form" label="评审表" width="100" align="center"  v-if="columnsVisibility.review_form">
                    <template #default="scope">
                        <a v-if="scope.row.review_form" :href="scope.row.review_form" target="_blank" rel="noopener"
                            :title="scope.row.review_form">{{ scope.row.review_form }}</a>
                        <span v-else>-</span>
                    </template>
                </el-table-column>

                <el-table-column prop="requirement_document" label="需求文档" width="100" header-align="center"  v-if="columnsVisibility.requirement_document">
                    <template #default="scope">
                        <a v-if="scope.row.requirement_document" :href="scope.row.requirement_document" target="_blank"
                            rel="noopener" :title="scope.row.requirement_document">{{ scope.row.requirement_document
                            }}</a>
                        <span v-else>-</span>
                    </template>
                </el-table-column>


                <el-table-column prop="requirement_meeting_time" label="会议时间" width="83" align="center"  v-if="columnsVisibility.requirement_meeting_time"/>
                <el-table-column prop="attendees" label="参会人员" width="75"  v-if="columnsVisibility.attendees"/>
                <el-table-column prop="planned_launch" label="计划上线" width="81" align="center" header-align="center"  v-if="columnsVisibility.planned_launch"/>
            </el-table-column>

            <!-- 分组4 -->
            <el-table-column label="时间（叶积建填写）" header-align="center" v-if="columnsVisibility.development_time || columnsVisibility.test_time || columnsVisibility.launch_time">
                <el-table-column prop="development_time" label="开发时间" width="83" align="center" header-align="center" v-if="columnsVisibility.development_time"/>
                <el-table-column prop="test_time" label="提测时间" width="83" align="center" header-align="center" v-if="columnsVisibility.test_time"/>
                <el-table-column prop="launch_time" label="上线时间" width="83" align="center" header-align="center" v-if="columnsVisibility.launch_time"/>
            </el-table-column>

            <!-- 分组5 -->
            <el-table-column v-if="columnsVisibility.retrospective" label="姜宇晨" prop="retrospective_document"
                width="120" header-align="center" >
                <el-table-column label="复盘文档" header-align="center">
                    <template #default="scope">
                        <a v-if="scope.row.retrospective_document" :href="scope.row.retrospective_document"
                            target="_blank" rel="noopener" :title="scope.row.retrospective_document">{{
                                scope.row.retrospective_document }}</a>
                        <span v-else>-</span>
                    </template>
                </el-table-column>
            </el-table-column>

            <!-- 分组6 -->
            <el-table-column label="考核相关（用人组填写）" header-align="center"  v-if="columnsVisibility.post_launch_evaluation || columnsVisibility.meeting_score">
                <el-table-column prop="post_launch_evaluation" label="上线效果/环评结果" width="250" header-align="center" v-if="columnsVisibility.post_launch_evaluation">
                    <template #default="scope">
                        <div v-html="scope.row.post_launch_evaluation" />
                    </template>
                </el-table-column>
                <el-table-column prop="meeting_score" label="需求会评分" width="90" align="center" header-align="center" v-if="columnsVisibility.meeting_score"/>
            </el-table-column>
            <el-table-column label="操作" width="75" header-align="center">
                <template #default="scope">
                    <div>
                        <el-button size="small" @click="openDialog('edit', scope.row)">编辑</el-button>
                    </div>
                    <div style="margin-top: 4px;"><el-button size="small" type="danger"
                            @click="handleDelete(scope.row)">删除</el-button> </div>

                </template>
            </el-table-column>
        </el-table>



    </div>
</template>

<script setup>
import { ref, onMounted, computed, nextTick } from 'vue';
import { ElMessage, ElMessageBox, ElNotification } from 'element-plus'
import api from '@/utils/api.js';
import { exportTaskToExcel } from '@/utils/excelExporter';
import html2canvas from 'html2canvas';
import docClient from '@/utils/DingTalkDocClient'


onMounted(() => {
    fetchDingTalkDoc('jb9Y4gmKWr71ez3MUaQZZGzxVGXn6lpz')



    let columnSettings = localStorage.getItem('columnSettings')
    if (columnSettings == null || columnSettings.length <= 0) {
        columnsVisibility.value = {
            id: true,
            requirement_name: true,
            goal: true,
            content: true,
            project: true,
            priority: true,
            source: true,
            owner: true,
            progress: true,
            review_form: true,
            requirement_document: true,
            requirement_meeting_time: true,
            attendees: true,
            planned_launch: true,
            development_time: true,
            test_time: true,
            launch_time: true,
            retrospective_document: true,
            post_launch_evaluation: true,
            meeting_score: true
        }
    }else{
        columnsVisibility.value = JSON.parse(columnSettings)
    }
})

const defaultColumns = {
    id: true,
    requirement_name: true,
    goal: true,
    content: true,
    project: true,
    priority: true,
    source: true,
    owner: true,
    progress: true,
    review_form: true,
    requirement_document: true,
    requirement_meeting_time: true,
    attendees: true,
    planned_launch: true,
    development_time: true,
    test_time: true,
    launch_time: true,
    retrospective_document: true,
    post_launch_evaluation: true,
    meeting_score: true
};

const columnsVisibility = ref({});


const selectedColumns = computed({
    get: () => Object.keys(columnsVisibility.value).filter(key => columnsVisibility.value[key]),
    set: (newVal) => {
        Object.keys(columnsVisibility.value).forEach(key => {
            columnsVisibility.value[key] = newVal.includes(key);
        });
    }
});

const tableRef = ref(null);
const dialogVisible = ref(false);

const getColumnLabel = (key) => {
    const labels = {
        'id': 'ID',
        'requirement_name': '需求名称',
        'goal': '目标',
        'content': '内容',
        'project': '项目',
        'priority': '优先级',
        'source': '来源',
        'owner': '负责人',
        'progress': '进度',
        'review_form': '评审表',
        'requirement_document': '需求文档',
        'requirement_meeting_time': '会议时间',
        'attendees': '参会人员',
        'planned_launch': '计划上线',
        'development_time': '开发时间',
        'test_time': '提测时间',
        'launch_time': '上线时间',
        'retrospective_document': '复盘文档',
        'post_launch_evaluation': '上线效果',
        'meeting_score': '会议评分'
    };
    return labels[key] || key;
};

const handleColumnChange = () => {
    saveColumnSettings();
};

const saveColumnSettings = () => {
    localStorage.setItem('columnSettings', JSON.stringify(columnsVisibility.value));
    nextTick(() => tableRef.value?.doLayout());
    ElNotification({
        title: '设置已保存',
        message: '列显示已更新',
        type: 'success',
        duration: 2000
    });
};

// const handleToggleChange = (val) => {
//   clearTimeout(toggleDebounce.value);
//   toggleDebounce.value = setTimeout(() => {
//     columnsVisibility.value.retrospective = val;
//   }, 300);
// };

const tableData = ref([
    {
        id: 999,
        requirement_name: '用户中心改版',
        goal: '<span style="color:#67C23A">▲20%</span> 用户活跃度提升',
        content: '<ul><li>重构用户信息模块</li><li>新增成就系统</li></ul>',
        project: '加拿大 H5',
        priority: '高',
        source: '锴张锴楠',
        owner: '张产品',
        progress: '上线待复盘',
        review_form: 'https://alidocs.dingtalk.com/i/nodes/14lgGw3P8vv1wb3XsdQP2v4985daZ90D?utm_scene=team_space',
        requirement_document: 'https://alidocs.dingtalk.com/i/nodes/14lgGw3P8vv1wb3XsdQP2v4985daZ90D?utm_scene=team_space',
        requirement_meeting_time: '20240320',
        attendees: '张产品、李四、王五',
        planned_launch: '20240601',
        development_time: '20240325',
        test_time: '20240420',
        launch_time: '20240501',
        retrospective_document: 'https://example.com/review',
        post_launch_evaluation: '<span style="background:#f0f9eb">DAU提升18%</span>',
        meeting_score: '4.8'
    },
    // 更多测试数据...
]);


const getHeaderClassName = (obj) => {
    let rowIndex = obj.rowIndex
    let columnIndex = obj.columnIndex
    let item = obj.row[columnIndex]
    console.log(item.label)
    let label = item.label

    if (label == '需求概述（产品组填写）' || label == '需求名称' || label == '目标' || label == '内容') {
        return { padding: '0 0', background: '#BF900A', color: 'white', height: '36px' }
    } else if (label == '相关信息（产品组填写）' || label == '项目' || label == '优先级' || label == '来源' || label == '负责人' || label == '进度' || label == '评审表' || label == '需求文档' || label == '会议时间' || label == '参会人员' || label == '计划上线') {
        return { padding: '0 0', background: '#409EFF', color: 'white', height: '36px' }
    } else if (label == '时间（叶积建填写）' || label == '开发时间' || label == '提测时间' || label == '上线时间') {
        return { padding: '0 0', background: '#558036', color: 'white', height: '36px' }
    } else if (label == '姜宇晨' || label == '复盘文档') {
        return { padding: '0 0', background: '#C65A14', color: 'white', height: '36px' }
    } else if (label == '考核相关（用人组填写）' || label == '上线效果/环评结果' || label == '需求会评分') {
        return { padding: '0 0', background: '#3F3F3F', color: 'white', height: '36px' }
    }
    return { padding: '0 0', background: '#B0C4DE' }
}


async function fetchDingTalkDoc(docId) {
  try {
    const content = await docClient.getDocContent(docId);
    console.log('文档内容:', content);
    return content;
  } catch (error) {
    console.error('获取文档失败:', error.message);
    throw error;
  }
}

</script>

<style scoped>
.dialog-content {
    max-height: 60vh;
    overflow-y: auto;
    padding: 10px 20px;
}

.column-checkbox {
    margin: 8px 0;
    width: 200px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.el-checkbox-group {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
}

.toggle-container {
    margin: 12px 0;
    padding: 8px;
    background: #f5f7fa;
    border-radius: 4px;
}

.crud-container {
    height: 100vh;
    overflow-y: auto;
}

.el-table {
    width: 100% !important;
    max-height: calc(100vh - 20px);
}

@media screen and (max-width: 1800px) {
    .el-table {
        font-size: 12px;
    }

    .el-table__body .cell {
        line-height: 1.4;
    }
}



::v-deep .el-table .cell {
    white-space: nowrap !important;
    overflow: hidden;
    text-overflow: ellipsis;
    font-size: 12px;
}



/* 保持所有表头文本白色 */
.el-table .table-header {
    color: white;
    font-weight: bold;
}


/* 新增表头居中样式 */
.el-table__header .cell {
    display: flex;
    justify-content: center;
    align-items: center;
    text-align: center;
    ;
}
</style>
