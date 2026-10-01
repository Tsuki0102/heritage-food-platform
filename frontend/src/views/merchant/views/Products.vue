<template>
  <div class="merchant-products">
    <div class="toolbar">
      <el-input v-model="keyword" placeholder="搜索商品名称、分类或非遗标签" clearable style="width: 280px" />
      <div class="toolbar-actions">
        <el-button :loading="merchantStore.loading" @click="refreshData">刷新</el-button>
        <el-button type="primary" @click="openDialog()">新增商品</el-button>
      </div>
    </div>

    <div class="table-card">
      <el-table :data="filteredProducts" v-loading="merchantStore.loading">
        <el-table-column prop="productName" label="商品名称" min-width="180" />
        <el-table-column prop="category" label="分类" min-width="120" />
        <el-table-column label="价格" min-width="110">
          <template #default="{ row }">¥{{ formatMoney(row.price) }}</template>
        </el-table-column>
        <el-table-column prop="heritageTag" label="非遗标签" min-width="160" />
        <el-table-column prop="submittedAt" label="最近提审时间" min-width="170" />
        <el-table-column label="状态" width="110">
          <template #default="{ row }">
            <el-tag :type="tagType(row.status)">{{ statusText(row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="250" fixed="right">
          <template #default="{ row }">
            <el-button size="small" @click="openDialog(row)">编辑</el-button>
            <el-button
              v-if="row.status === 'approved'"
              size="small"
              type="warning"
              plain
              @click="setOffline(row.id)"
            >
              申请下架
            </el-button>
            <el-button v-else size="small" type="primary" plain @click="resubmit(row.id)">
              重新提审
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <el-dialog v-model="dialogVisible" :title="dialogMode === 'create' ? '新增商品' : '编辑商品'" width="620px">
      <el-form label-width="100px">
        <el-form-item label="商品名称">
          <el-input v-model.trim="form.productName" />
        </el-form-item>
        <el-form-item label="商品分类">
          <el-input v-model.trim="form.category" />
        </el-form-item>
        <el-form-item label="商品价格">
          <el-input-number v-model="form.price" :min="0" :precision="2" :step="1" controls-position="right" />
        </el-form-item>
        <el-form-item label="非遗标签">
          <el-input v-model.trim="form.heritageTag" />
        </el-form-item>
        <el-form-item label="商品描述">
          <el-input v-model.trim="form.description" type="textarea" :rows="5" />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="saveProduct">提交审核</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import type { MerchantWorkbenchProduct } from '../../../stores/merchantWorkbenchStore'
import { useMerchantWorkbenchStore } from '../../../stores/merchantWorkbenchStore'

const merchantStore = useMerchantWorkbenchStore()

const keyword = ref('')
const dialogVisible = ref(false)
const dialogMode = ref<'create' | 'edit'>('create')
const submitting = ref(false)

const form = reactive({
  id: 0,
  productName: '',
  category: '',
  price: 0,
  heritageTag: '',
  description: ''
})

const filteredProducts = computed(() => {
  const text = keyword.value.trim().toLowerCase()
  if (!text) {
    return merchantStore.products
  }

  return merchantStore.products.filter(item =>
    [item.productName, item.heritageTag, item.category].some(value => String(value).toLowerCase().includes(text))
  )
})

const formatMoney = (value: number) => Number(value || 0).toFixed(2)

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
    return '已上架'
  }
  if (status === 'offline') {
    return '已下架'
  }
  if (status === 'rejected') {
    return '已驳回'
  }
  return '待审核'
}

const resetForm = () => {
  form.id = 0
  form.productName = ''
  form.category = ''
  form.price = 0
  form.heritageTag = ''
  form.description = ''
}

const openDialog = (product?: MerchantWorkbenchProduct) => {
  dialogMode.value = product ? 'edit' : 'create'
  resetForm()

  if (product) {
    form.id = product.id
    form.productName = product.productName
    form.category = product.category
    form.price = product.price
    form.heritageTag = product.heritageTag
    form.description = product.description
  }

  dialogVisible.value = true
}

const refreshData = async () => {
  try {
    await merchantStore.refresh()
  } catch (error) {
    ElMessage.error('刷新商品数据失败')
  }
}

const saveProduct = async () => {
  if (!form.productName || !form.category || !form.heritageTag) {
    ElMessage.warning('请完整填写商品名称、分类和非遗标签')
    return
  }

  submitting.value = true

  try {
    await merchantStore.saveProduct({
      id: dialogMode.value === 'edit' ? form.id : undefined,
      productName: form.productName,
      category: form.category,
      price: form.price,
      heritageTag: form.heritageTag,
      description: form.description
    })
    dialogVisible.value = false
    ElMessage.success(dialogMode.value === 'edit' ? '商品已更新并重新提交审核' : '商品已提交审核')
  } catch (error) {
    ElMessage.error('商品提交失败')
  } finally {
    submitting.value = false
  }
}

const resubmit = async (id: number) => {
  try {
    await merchantStore.setProductStatus(id, 'pending')
    ElMessage.success('商品已重新提交审核')
  } catch (error) {
    ElMessage.error('重新提审失败')
  }
}

const setOffline = async (id: number) => {
  try {
    await merchantStore.setProductStatus(id, 'offline')
    ElMessage.success('下架申请已提交')
  } catch (error) {
    ElMessage.error('下架申请提交失败')
  }
}

onMounted(async () => {
  await merchantStore.initialize()
})
</script>

<style scoped>
.merchant-products {
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
