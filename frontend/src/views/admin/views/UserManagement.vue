<template>
  <div class="user-management">
    <div class="admin-page-header">
      <h2 class="admin-page-title">用户管理</h2>
      <div class="header-actions">
        <el-input v-model="searchQuery" placeholder="搜索用户名、手机号..." style="width: 320px;" @keyup.enter="handleSearch" clearable></el-input>
        <el-button type="primary" @click="addUser">
          <span>➕</span>
          添加用户
        </el-button>
      </div>
    </div>

    <div class="admin-table-wrapper user-table">
      <el-table :data="userAdminStore.users" style="width: 100%" v-loading="userAdminStore.loading" :height="520" :max-height="520" :virtual-scroll="true" stripe>
        <el-table-column prop="id" label="ID" width="80"></el-table-column>
        <el-table-column prop="nickname" label="昵称"></el-table-column>
        <el-table-column prop="phone" label="手机号"></el-table-column>
        <el-table-column prop="gender" label="性别" width="80">
          <template #default="scope">
            {{ scope.row.gender === 1 ? '男' : '女' }}
          </template>
        </el-table-column>
        <el-table-column prop="region" label="地区"></el-table-column>
        <el-table-column prop="registerTime" label="注册时间"></el-table-column>
        <el-table-column prop="status" label="状态" width="80">
          <template #default="scope">
            <el-switch v-model="scope.row.status" active-value="1" inactive-value="0" @change="updateUserStatus(scope.row)"></el-switch>
          </template>
        </el-table-column>
        <el-table-column prop="isAdmin" label="管理员" width="80">
          <template #default="scope">
            <el-switch v-model="scope.row.isAdmin" active-value="1" inactive-value="0" @change="updateUserAdmin(scope.row)"></el-switch>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150">
          <template #default="scope">
            <el-button size="small" @click="editUser(scope.row)">编辑</el-button>
            <el-button size="small" type="danger" @click="deleteUser(scope.row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
    
    <div class="admin-pagination-wrapper pagination">
      <el-pagination
        v-model:current-page="userAdminStore.currentPage"
        v-model:page-size="userAdminStore.pageSize"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        :total="userAdminStore.total"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      ></el-pagination>
    </div>

    <!-- 添加/编辑用户对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '添加用户' : '编辑用户'"
      width="540px"
      class="admin-dialog-wrapper"
    >
      <el-form :model="form" label-width="100px" :rules="rules" ref="formRef" class="admin-form-wrapper">
        <el-form-item label="昵称" prop="nickname">
          <el-input v-model="form.nickname"></el-input>
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="form.phone"></el-input>
        </el-form-item>
        <el-form-item label="密码" prop="password" v-if="dialogType === 'add'">
          <el-input v-model="form.password" type="password"></el-input>
        </el-form-item>
        <el-form-item label="性别" prop="gender">
          <el-radio-group v-model="form.gender">
            <el-radio label="1">男</el-radio>
            <el-radio label="0">女</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="地区" prop="region">
          <el-input v-model="form.region"></el-input>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-switch v-model="form.status" active-value="1" inactive-value="0"></el-switch>
        </el-form-item>
        <el-form-item label="管理员" prop="isAdmin">
          <el-switch v-model="form.isAdmin" active-value="1" inactive-value="0"></el-switch>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="saveUser">保存</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useUserAdminStore } from '../../../stores/admin/userAdminStore'
import type { User } from '../../../types'
import { ElMessage } from 'element-plus'

const userAdminStore = useUserAdminStore()
const dialogVisible = ref(false)
const dialogType = ref<'add' | 'edit'>('add')
const form = ref<User>({
  id: 0,
  nickname: '',
  phone: '',
  password: '',
  gender: 1,
  region: '',
  registerTime: '',
  status: 1,
  isAdmin: 0,
  avatar: ''
})
const searchQuery = ref('')
const formRef = ref()

const rules = {
  nickname: [
    { required: true, message: '请输入昵称', trigger: 'blur' },
    { min: 2, max: 20, message: '昵称长度在 2 到 20 个字符', trigger: 'blur' }
  ],
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少 6 个字符', trigger: 'blur' }
  ],
  region: [
    { required: true, message: '请输入地区', trigger: 'blur' }
  ]
}

const addUser = () => {
  dialogType.value = 'add'
  form.value = {
    id: 0,
    nickname: '',
    phone: '',
    password: '',
    gender: 1,
    region: '',
    registerTime: new Date().toISOString(),
    status: 1,
    isAdmin: 0,
    avatar: ''
  }
  dialogVisible.value = true
}

const editUser = (user: User) => {
  dialogType.value = 'edit'
  form.value = { ...user }
  dialogVisible.value = true
}

const saveUser = async () => {
  if (!formRef.value) return
  
  try {
    await formRef.value.validate()
    
    if (dialogType.value === 'add') {
      const success = await userAdminStore.addUser(form.value)
      if (success) {
        dialogVisible.value = false
        ElMessage.success('添加用户成功')
      } else {
        ElMessage.error('添加用户失败')
      }
    } else {
      const success = await userAdminStore.updateUser(form.value)
      if (success) {
        dialogVisible.value = false
        ElMessage.success('更新用户成功')
      } else {
        ElMessage.error('更新用户失败')
      }
    }
  } catch (error) {
    console.error('表单验证失败:', error)
  }
}

const deleteUser = async (id: number) => {
  try {
    const success = await userAdminStore.deleteUser(id)
    if (success) {
      ElMessage.success('删除用户成功')
    } else {
      ElMessage.error('删除用户失败')
    }
  } catch (error) {
    ElMessage.error('删除用户失败')
  }
}

const updateUserStatus = async (user: User) => {
  try {
    const success = await userAdminStore.updateUser(user)
    if (success) {
      // 不显示提示，避免过多弹窗
    }
  } catch (error) {
    ElMessage.error('更新用户状态失败')
  }
}

const updateUserAdmin = async (user: User) => {
  try {
    const success = await userAdminStore.updateUser(user)
    if (success) {
      // 不显示提示，避免过多弹窗
    }
  } catch (error) {
    ElMessage.error('更新管理员状态失败')
  }
}

const handleSizeChange = (size: number) => {
  userAdminStore.setPageSize(size)
}

const handleCurrentChange = (current: number) => {
  userAdminStore.setCurrentPage(current)
}

const handleSearch = () => {
  userAdminStore.setSearchQuery(searchQuery.value)
}

onMounted(() => {
  userAdminStore.fetchUsers()
})
</script>

<style scoped>
.user-management {
  padding: 4px 0;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: var(--spacing-md);
}

.header-actions :deep(.el-input__wrapper) {
  border-radius: 24px;
  border: 2px solid var(--admin-border);
  transition: all 0.3s ease;
}

.header-actions :deep(.el-input__wrapper:focus-within) {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 4px rgba(200, 22, 29, 0.08);
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

  .header-actions {
    width: 100%;
    flex-direction: column;
    align-items: stretch;
    gap: var(--spacing-sm);
  }

  .header-actions :deep(.el-input) {
    width: 100% !important;
  }

  .header-actions :deep(.el-button) {
    width: 100%;
  }

  .admin-pagination-wrapper {
    justify-content: center;
  }

  .user-table :deep(.el-table) {
    font-size: 13px;
  }
}

@media (max-width: 480px) {
  .admin-page-header {
    padding: var(--spacing-sm) var(--spacing-md);
  }
}
</style>