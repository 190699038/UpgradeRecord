<template>
  <div class="follow-up-task">
    <el-tabs v-model="activeTab" @tab-change="handleTabChange">
      <el-tab-pane label="日常跟进信息" name="sub">
        <FollowUpSubTask ref="subTaskRef" />
      </el-tab-pane>
      <el-tab-pane label="主任务信息" name="main">
        <FollowUpMainTask ref="mainTaskRef" />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import FollowUpMainTask from '../view/FollowUpMainTask.vue'
import FollowUpSubTask from '../view/FollowUpSubTask.vue'

const activeTab = ref('sub')
const subTaskRef = ref(null)
const mainTaskRef = ref(null)

// 监听标签页变化
const handleTabChange = (tabName) => {
  refreshCurrentTab(tabName)
}

// 监听activeTab变化
watch(activeTab, (newTab) => {
  refreshCurrentTab(newTab)
})

// 刷新当前标签页数据
const refreshCurrentTab = (tabName) => {
  if (tabName === 'main' && mainTaskRef.value) {
    mainTaskRef.value.fetchRecords()
  } else if (tabName === 'sub' && subTaskRef.value) {
    subTaskRef.value.fetchRecords()
  }
}
</script>

<style scoped>
.follow-up-task {
  padding: 20px;
}
</style>