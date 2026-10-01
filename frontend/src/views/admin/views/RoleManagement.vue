<template>
  <div class="role-management heritage-pattern">
    <div class="admin-page-header">
      <h2 class="admin-page-title">角色管理</h2>
      <div class="header-actions">
        <el-button type="primary" @click="addRole">
          <span>➕</span>
          添加角色
        </el-button>
      </div>
    </div>

    <div class="admin-table-wrapper role-table">
      <el-table :data="roleAdminStore.roles" style="width: 100%" v-loading="roleAdminStore.loading">
        <el-table-column prop="id" label="ID" width="80"></el-table-column>
        <el-table-column prop="roleName" label="角色名称"></el-table-column>
        <el-table-column prop="roleKey" label="角色标识"></el-table-column>
        <el-table-column prop="description" label="描述"></el-table-column>
        <el-table-column prop="status" label="状态" width="80">
          <template #default="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'">
              {{ scope.row.status === 1 ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间"></el-table-column>
        <el-table-column label="操作" width="250">
          <template #default="scope">
            <el-button size="small" @click="editRole(scope.row)">编辑</el-button>
            <el-button size="small" @click="openPermissionDialog(scope.row)">分配权限</el-button>
            <el-button size="small" type="danger" @click="deleteRole(scope.row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
    
    <div class="admin-pagination-wrapper pagination">
      <el-pagination
        v-model:current-page="roleAdminStore.currentPage"
        v-model:page-size="roleAdminStore.pageSize"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        :total="roleAdminStore.total"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      ></el-pagination>
    </div>

    <!-- 添加/编辑角色对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '添加角色' : '编辑角色'"
      width="520px"
      class="admin-dialog-wrapper"
    >
      <el-form :model="form" label-width="100px" :rules="rules" ref="formRef" class="admin-form-wrapper">
        <el-form-item label="角色名称" prop="roleName">
          <el-input v-model="form.roleName"></el-input>
        </el-form-item>
        <el-form-item label="角色标识" prop="roleKey">
          <el-input v-model="form.roleKey"></el-input>
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
          <el-button type="primary" @click="saveRole">保存</el-button>
        </span>
      </template>
    </el-dialog>
    
    <!-- 分配权限对话框 -->
    <el-dialog
      v-model="permissionDialogVisible"
      :title="`分配权限 - ${currentRole?.roleName || ''}`"
      width="600px"
    >
      <el-tree
        ref="permissionTreeRef"
        :data="permissionAdminStore.permissionTree"
        :props="{ children: 'children', label: 'permissionName' }"
        show-checkbox
        node-key="id"
        default-expand-all
      ></el-tree>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="permissionDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="savePermissions">保存</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoleAdminStore } from '../../../stores/admin/roleAdminStore'
import { usePermissionAdminStore } from '../../../stores/admin/permissionAdminStore'
import type { Role, Permission } from '../../../types'
import { ElMessage, ElTree } from 'element-plus'

const roleAdminStore = useRoleAdminStore()
const permissionAdminStore = usePermissionAdminStore()
const dialogVisible = ref(false)
const permissionDialogVisible = ref(false)
const dialogType = ref<'add' | 'edit'>('add')
const currentRole = ref<Role | null>(null)
const formRef = ref()
const permissionTreeRef = ref<InstanceType<typeof ElTree>>()

const form = ref<Role>({
  id: 0,
  roleName: '',
  roleKey: '',
  description: '',
  status: 1,
  createTime: '',
  updateTime: ''
})

const rules = {
  roleName: [
    { required: true, message: '请输入角色名称', trigger: 'blur' },
    { min: 2, max: 20, message: '角色名称长度在 2 到 20 个字符', trigger: 'blur' }
  ],
  roleKey: [
    { required: true, message: '请输入角色标识', trigger: 'blur' },
    { pattern: /^[a-z_]+$/, message: '角色标识只能包含小写字母和下划线', trigger: 'blur' }
  ]
}

const addRole = () => {
  dialogType.value = 'add'
  form.value = {
    id: 0,
    roleName: '',
    roleKey: '',
    description: '',
    status: 1,
    createTime: '',
    updateTime: ''
  }
  dialogVisible.value = true
}

const editRole = (role: Role) => {
  dialogType.value = 'edit'
  form.value = { ...role }
  dialogVisible.value = true
}

const saveRole = async () => {
  if (!formRef.value) return
  
  try {
    await formRef.value.validate()
    
    let success = false
    if (dialogType.value === 'add') {
      success = await roleAdminStore.addRole(form.value)
    } else {
      success = await roleAdminStore.updateRole(form.value)
    }
    
    if (success) {
      dialogVisible.value = false
      ElMessage.success(dialogType.value === 'add' ? '添加角色成功' : '更新角色成功')
    } else {
      ElMessage.error(dialogType.value === 'add' ? '添加角色失败' : '更新角色失败')
    }
  } catch (error) {
    console.error('表单验证失败:', error)
  }
}

const deleteRole = async (id: number) => {
  try {
    const success = await roleAdminStore.deleteRole(id)
    if (success) {
      ElMessage.success('删除角色成功')
    } else {
      ElMessage.error('删除角色失败')
    }
  } catch (error) {
    ElMessage.error('删除角色失败')
  }
}

const openPermissionDialog = async (role: Role) => {
  currentRole.value = role
  permissionDialogVisible.value = true
  
  await permissionAdminStore.fetchPermissionTree()
  
  const response = await fetch(`/api/admin/permissions/role/${role.id}`)
  const permissions = await response.json()
  
  const checkedKeys = permissions.map((p: Permission) => p.id)
  permissionTreeRef.value?.setCheckedKeys(checkedKeys)
}

const savePermissions = async () => {
  if (!currentRole.value || !permissionTreeRef.value) return
  
  const checkedKeys = permissionTreeRef.value.getCheckedKeys() as number[]
  const halfCheckedKeys = permissionTreeRef.value.getHalfCheckedKeys() as number[]
  const allKeys = [...checkedKeys, ...halfCheckedKeys]
  
  const success = await roleAdminStore.assignPermissionsToRole(currentRole.value.id, allKeys)
  
  if (success) {
    permissionDialogVisible.value = false
    ElMessage.success('分配权限成功')
  } else {
    ElMessage.error('分配权限失败')
  }
}

const handleSizeChange = (size: number) => {
  roleAdminStore.setPageSize(size)
}

const handleCurrentChange = (current: number) => {
  roleAdminStore.setCurrentPage(current)
}

onMounted(() => {
  roleAdminStore.fetchRoles()
  permissionAdminStore.fetchPermissionTree()
})
</script>

<style scoped>
.role-management {
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

  .admin-pagination-wrapper {
    justify-content: center;
  }
}
</style>
