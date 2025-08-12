<template>
  <div class="container">
     <UpdateList />
    <!-- <el-tabs v-model="activeTab" class="demo-tabs">
      <el-tab-pane label="更新记录" name="updateList">
        <UpdateList />
      </el-tab-pane>
      
      <el-tab-pane label="更新记录数据统计" name="updateStatic">
        <UpdateStatic />
      </el-tab-pane>
    </el-tabs> -->
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import UpdateList from '@/view/UpdateList.vue'
import UpdateStatic from '@/view/UpdateStatic.vue'

const activeTab = ref('updateList')


onMounted(() => {

})




</script>

<style scoped>
.container {
  padding: 20px;
  overflow-x: auto;
}

.demo-tabs {
  margin-bottom: 20px;
}

.tab-content {
  min-height: 400px;
}

.search-area {
  margin-bottom: 20px;
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  align-items: center;
}

:deep(.custom-table) {
  margin-top: 20px;
  min-width: 1600px;
  overflow-x: visible;
}

:deep(.el-table) {
  border: 1px solid #d0d7e5;
  font-family: '微软雅黑';
}

:deep(.el-table th) {
  background: #004bff;
  font-weight: bold;
}

:deep(.el-table__cell) {
  border-right: 1px solid #d0d7e5 !important;
  border-bottom: 1px solid #d0d7e5 !important;
}
</style>