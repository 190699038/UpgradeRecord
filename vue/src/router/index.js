import { createRouter, createWebHistory,createWebHashHistory  } from 'vue-router'
import MainLayout from '@/components/MainLayout.vue'
import UpgradeRecord from '@/components/UpgradeRecord.vue'
import ReviewRecord from '@/components/ReviewRecord.vue'
import UserManagement from '@/components/UserManagement.vue'
import DailyReminder from '@/components/DailyReminder.vue'
import KeyTask from '@/components/KeyTask.vue'
import ProductRecord from '@/components/ProductRecord.vue'

export default createRouter({
  history: createWebHashHistory(),
  routes: [
    {
      path: '/',
      component: MainLayout,
      children: [
        { path: 'upgrade-record', component: UpgradeRecord },
        { path: 'product-record', component: ProductRecord },

        { path: 'review-record', component: ReviewRecord },
        { path: 'user-management', component: UserManagement },
        { path: 'daily-reminders', component: DailyReminder },
        { path: 'key-tasks', component: KeyTask },
        { path: '', redirect: 'key-tasks' }
      ]
    }
  ]
})