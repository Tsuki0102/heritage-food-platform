<template>
  <div class="permission-management heritage-pattern">
    <div class="admin-page-header">
      <h2 class="admin-page-title">权限管理</h2>
      <div class="header-actions">
        <el-button type="primary" @click="addPermission">
          <span>➕</span>
          添加权限
        </el-button>
      </div>
    </div>

    <div class="admin-chart-container permission-tree">
      <el-tree
        :data="permissionAdminStore.permissionTree"
        :props="{ children: 'children', label: 'permissionName' }"
        node-key="id"
        default-expand-all
        v-loading="permissionAdminStore.loading"
      >
        <template #default="{ node, data }">
          <span class="custom-tree-node">
            <span>
              <el-tag size="small" :type="getTagType(data.resourceType)" style="margin-right: 8px;">
                {{ getResourceTypeText(data.resourceType) }}
              </el-tag>
              {{ node.label }} ({{ data.permissionKey }})
            </span>
            <span class="tree-actions">
              <el-button size="small" @click="editPermission(data)">编辑</el-button>
              <el-button size="small" type="danger" @click="deletePermission(data.id)">删除</el-button>
            </span>
          </span>
        </template>
      </el-tree>
    </div>
    
    <!-- 添加/编辑权限对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '添加权限' : '编辑权限'"
      width="520px"
      class="admin-dialog-wrapper"
    >
      <el-form :model="form" label-width="100px" :rules="rules" ref="formRef" class="admin-form-wrapper">
        <el-form-item label="权限名称" prop="permissionName">
          <el-input v-model="form.permissionName"></el-input>
        </el-form-item>
        <el-form-item label="权限标识" prop="permissionKey">
          <el-input v-model="form.permissionKey"></el-input>
        </el-form-item>
        <el-form-item label="资源类型" prop="resourceType">
          <el-select v-model="form.resourceType" style="width: 100%;">
            <el-option label="菜单" value="menu"></el-option>
            <el-option label="按钮" value="button"></el-option>
            <el-option label="接口" value="api"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="资源路径" prop="resourceUrl">
          <el-input v-model="form.resourceUrl" placeholder="例如：/admin/users"></el-input>
        </el-form-item>
        <el-form-item label="父权限" prop="parentId">
          <el-tree-select
            v-model="form.parentId"
            :data="permissionAdminStore.permissionTree"
            :props="{ children: 'children', label: 'permissionName', value: 'id' }"
            check-strictly
            placeholder="选择父权限，顶级权限请留空"
            clearable
            style="width: 100%;"
          ></el-tree-select>
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input v-model="form.description" type="textarea"></el-input>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-switch v-model="form.status" active-value="1" inactive-value="0"></el-switch>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="savePermission">保存</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { usePermissionAdminStore } from '../../../stores/admin/permissionAdminStore'
import type { Permission } from '../../../types'
import { ElMessage } from 'element-plus'

const permissionAdminStore = usePermissionAdminStore()
const dialogVisible = ref(false)
const dialogType = ref<'add' | 'edit'>('add')
const formRef = ref()

const form = ref<Permission>({
  id: 0,
  permissionName: '',
  permissionKey: '',
  resourceType: 'menu',
  resourceUrl: '',
  parentId: 0,
  description: '',
  status: 1,
  createTime: '',
  updateTime: ''
})

const rules = {
  permissionName: [
    { required: true, message: '请输入权限名称', trigger: 'blur' },
    { min: 2, max: 20, message: '权限名称长度在 2 到 20 个字符', trigger: 'blur' }
  ],
  permissionKey: [
    { required: true, message: '请输入权限标识', trigger: 'blur' },
    { pattern: /^[a-z_:]+$/, message: '权限标识只能包含小写字母、下划线和冒号', trigger: 'blur' }
  ],
  resourceType: [
    { required: true, message: '请选择资源类型', trigger: 'change' }
  ]
}

const getTagType = (resourceType: string) => {
  const typeMap: Record<string, 'primary' | 'success' | 'warning'> = {
    menu: 'primary',
    button: 'success',
    api: 'warning'
  }
  return typeMap[resourceType] || 'primary'
}

const getResourceTypeText = (resourceType: string) => {
  const textMap: Record<string, string> = {
    menu: '菜单',
    button: '按钮',
    api: '接口'
  }
  return textMap[resourceType] || resourceType
}

const addPermission = () => {
  dialogType.value = 'add'
  form.value = {
    id: 0,
    permissionName: '',
    permissionKey: '',
    resourceType: 'menu',
    resourceUrl: '',
    parentId: 0,
    description: '',
    status: 1,
    createTime: '',
    updateTime: ''
  }
  dialogVisible.value = true
}

const editPermission = (permission: Permission) => {
  dialogType.value = 'edit'
  form.value = { ...permission }
  dialogVisible.value = true
}

const savePermission = async () => {
  if (!formRef.value) return
  
  try {
    await formRef.value.validate()
    
    let success = false
    if (dialogType.value === 'add') {
      success = await permissionAdminStore.addPermission(form.value)
    } else {
      success = await permissionAdminStore.updatePermission(form.value)
    }
    
    if (success) {
      dialogVisible.value = false
      ElMessage.success(dialogType.value === 'add' ? '添加权限成功' : '更新权限成功')
    } else {
      ElMessage.error(dialogType.value === 'add' ? '添加权限失败' : '更新权限失败')
    }
  } catch (error) {
    console.error('表单验证失败:', error)
  }
}

const deletePermission = async (id: number) => {
  try {
    const success = await permissionAdminStore.deletePermission(id)
    if (success) {
      ElMessage.success('删除权限成功')
    } else {
      ElMessage.error('删除权限失败')
    }
  } catch (error) {
    ElMessage.error('删除权限失败')
  }
}

onMounted(() => {
  permissionAdminStore.fetchPermissionTree()
})
</script>

<style scoped>
.permission-management {
  padding: 4px 0;
}

.header-actions :deep(.el-button) {
  border-radius: 24px;
  padding: 10px 20px;
  font-weight: 600;
  letter-spacing: 1px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.header-actions :deep(.el-button:hover) {
  transform: translateY(-2px);
  box-shadow: var(--shadow-primary);
}

.permission-tree {
  padding: var(--spacing-xl);
}

.custom-tree-node {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 14px;
  gap: 10px;
}

.tree-actions {
  display: flex;
  gap: 5px;
}

@media (max-width: 768px) {
  .admin-page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: var(--spacing-md);
    padding: var(--spacing-md);
  }

  .header-actions :deep(.el-button) {
    width: 100%;
  }

  .permission-tree {
    padding: var(--spacing-lg) var(--spacing-md);
  }
}
</style>
