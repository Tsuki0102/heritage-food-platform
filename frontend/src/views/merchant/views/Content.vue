<template>
  <div class="merchant-content-page">
    <div class="toolbar">
      <el-input v-model="keyword" placeholder="搜索内容标题、类型或风险点" clearable style="width: 280px" />
      <div class="toolbar-actions">
        <el-button :loading="merchantStore.loading" @click="refreshData">刷新</el-button>
        <el-button type="primary" @click="openDialog()">新增内容</el-button>
      </div>
    </div>

    <div class="table-card">
      <el-table :data="filteredContents" v-loading="merchantStore.loading">
        <el-table-column prop="title" label="内容标题" min-width="220" />
        <el-table-column prop="contentType" label="内容类型" min-width="120" />
        <el-table-column prop="riskPoint" label="审核关注点" min-width="160" />
        <el-table-column prop="submittedAt" label="最近提审时间" min-width="170" />
        <el-table-column label="状态" width="110">
          <template #default="{ row }">
            <el-tag :type="tagType(row.status)">{{ statusText(row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button size="small" @click="openDialog(row)">编辑</el-button>
            <el-button size="small" type="primary" plain @click="resubmit(row.id)">重新提审</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <el-dialog v-model="dialogVisible" :title="dialogMode === 'create' ? '新增内容' : '编辑内容'" width="680px">
      <el-form label-width="110px">
        <el-form-item label="内容标题">
          <el-input v-model.trim="form.title" />
        </el-form-item>
        <el-form-item label="内容类型">
          <el-select v-model="form.contentType" style="width: 100%">
            <el-option label="图文故事" value="图文故事" />
            <el-option label="短视频脚本" value="短视频脚本" />
            <el-option label="匠人专题" value="匠人专题" />
            <el-option label="品牌专栏" value="品牌专栏" />
          </el-select>
        </el-form-item>
        <el-form-item label="审核关注点">
          <el-input v-model.trim="form.riskPoint" />
        </el-form-item>
        <el-form-item label="内容正文">
          <el-input v-model.trim="form.content" type="textarea" :rows="7" />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="saveContent">提交审核</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import type { MerchantWorkbenchContent } from '../../../stores/merchantWorkbenchStore'
import { useMerchantWorkbenchStore } from '../../../stores/merchantWorkbenchStore'

const merchantStore = useMerchantWorkbenchStore()

const keyword = ref('')
const dialogVisible = ref(false)
const dialogMode = ref<'create' | 'edit'>('create')
const submitting = ref(false)

const form = reactive({
  id: 0,
  title: '',
  contentType: '图文故事',
  riskPoint: '',
  content: ''
})

const filteredContents = computed(() => {
  const text = keyword.value.trim().toLowerCase()
  if (!text) {
    return merchantStore.contents
  }

  return merchantStore.contents.filter(item =>
    [item.title, item.contentType, item.riskPoint].some(value => String(value).toLowerCase().includes(text))
  )
})

const tagType = (status: string) => {
  if (status === 'approved') {
    return 'success'
  }
  if (status === 'pending') {
    return 'warning'
  }
  return 'danger'
}

const statusText = (status: string) => {
  if (status === 'approved') {
    return '已发布'
  }
  if (status === 'rejected') {
    return '已驳回'
  }
  return '待审核'
}

const resetForm = () => {
  form.id = 0
  form.title = ''
  form.contentType = '图文故事'
  form.riskPoint = ''
  form.content = ''
}

const openDialog = (content?: MerchantWorkbenchContent) => {
  dialogMode.value = content ? 'edit' : 'create'
  resetForm()

  if (content) {
    form.id = content.id
    form.title = content.title
    form.contentType = content.contentType
    form.riskPoint = content.riskPoint
    form.content = content.content
  }

  dialogVisible.value = true
}

const refreshData = async () => {
  try {
    await merchantStore.refresh()
  } catch (error) {
    ElMessage.error('刷新内容数据失败')
  }
}

const saveContent = async () => {
  if (!form.title || !form.contentType || !form.content) {
    ElMessage.warning('请完整填写内容标题、类型和正文')
    return
  }

  submitting.value = true

  try {
    await merchantStore.saveContent({
      id: dialogMode.value === 'edit' ? form.id : undefined,
      title: form.title,
      contentType: form.contentType,
      riskPoint: form.riskPoint || '需人工复核',
      content: form.content
    })
    dialogVisible.value = false
    ElMessage.success(dialogMode.value === 'edit' ? '内容已更新并重新提交审核' : '内容已提交审核')
  } catch (error) {
    ElMessage.error('内容提交失败')
  } finally {
    submitting.value = false
  }
}

const resubmit = async (id: number) => {
  const target = merchantStore.contents.find(item => item.id === id)
  if (!target) {
    return
  }

  try {
    await merchantStore.saveContent({
      id: target.id,
      title: target.title,
      contentType: target.contentType,
      riskPoint: target.riskPoint,
      content: target.content
    })
    ElMessage.success('内容已重新提交审核')
  } catch (error) {
    ElMessage.error('重新提审失败')
  }
}

onMounted(async () => {
  await merchantStore.initialize()
})
</script>

<style scoped>
.merchant-content-page {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.toolbar {
  display: flex;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
}

.toolbar-actions {
  display: flex;
  gap: 12px;
}

.table-card {
  background: rgba(255, 255, 255, 0.92);
  border: 1px solid rgba(199, 155, 74, 0.18);
  border-radius: 20px;
  box-shadow: 0 18px 40px rgba(92, 55, 20, 0.06);
  padding: 18px;
}

@media (max-width: 720px) {
  .toolbar,
  .toolbar-actions {
    flex-direction: column;
  }
}
</style>
