<template>
  <div class="content-management">
    <div class="page-header">
      <div>
        <h2>内容管理</h2>
        <p>统一管理商品、店铺和社区内容。</p>
      </div>
    </div>

    <div class="content-card">
      <el-tabs v-model="activeTab" @tab-change="handleTabChange">
        <el-tab-pane label="非遗美食" name="foods">
          <div class="toolbar">
            <el-input
              v-model="foodFilters.keyword"
              placeholder="搜索美食名称"
              clearable
              style="width: 260px"
              @keyup.enter="handleFoodSearch"
            />
            <el-select
              v-model="foodFilters.region"
              clearable
              placeholder="全部地区"
              style="width: 160px"
              @change="handleFoodSearch"
            >
              <el-option label="北京" value="北京" />
              <el-option label="上海" value="上海" />
              <el-option label="广东" value="广东" />
              <el-option label="河南" value="河南" />
              <el-option label="四川" value="四川" />
              <el-option label="陕西" value="陕西" />
              <el-option label="浙江" value="浙江" />
              <el-option label="江苏" value="江苏" />
              <el-option label="重庆" value="重庆" />
            </el-select>
            <el-select
              v-model="foodFilters.taste"
              clearable
              placeholder="全部口味"
              style="width: 160px"
              @change="handleFoodSearch"
            >
              <el-option label="咸香" value="咸香" />
              <el-option label="鲜美" value="鲜美" />
              <el-option label="清淡" value="清淡" />
              <el-option label="酸辣" value="酸辣" />
              <el-option label="鲜香" value="鲜香" />
              <el-option label="麻辣" value="麻辣" />
              <el-option label="酸甜" value="酸甜" />
              <el-option label="甜香" value="甜香" />
              <el-option label="双味" value="双味" />
            </el-select>
            <el-select
              v-model="foodFilters.heritageLevel"
              clearable
              placeholder="全部级别"
              style="width: 160px"
              @change="handleFoodSearch"
            >
              <el-option label="国家级" value="国家级" />
              <el-option label="省级" value="省级" />
              <el-option label="市级" value="市级" />
            </el-select>
            <el-button type="primary" plain @click="handleFoodSearch">搜索</el-button>
            <div class="toolbar-spacer"></div>
            <el-button @click="resetFoodFilters">重置</el-button>
          </div>

          <el-table :data="foods" v-loading="foodLoading" style="width: 100%">
            <el-table-column prop="id" label="ID" width="80" />
            <el-table-column prop="name" label="美食名称" min-width="180" show-overflow-tooltip />
            <el-table-column prop="region" label="地区" width="120" />
            <el-table-column prop="taste" label="口味" width="100" />
            <el-table-column prop="heritageLevel" label="非遗级别" width="120" />
            <el-table-column prop="heritageTag" label="非遗标签" min-width="160" show-overflow-tooltip />
            <el-table-column prop="price" label="价格" width="100">
              <template #default="scope">
                {{ scope.row.price ? '¥' + formatMoney(scope.row.price) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="viewCount" label="浏览" width="90" />
            <el-table-column prop="likeCount" label="点赞" width="90" />
            <el-table-column prop="createdAt" label="创建时间" min-width="180">
              <template #default="scope">
                {{ formatDateTime(scope.row.createdAt) }}
              </template>
            </el-table-column>
            <el-table-column label="操作" width="120" fixed="right">
              <template #default="scope">
                <el-button size="small" type="danger" @click="handleDeleteFood(scope.row)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>

          <div class="pagination">
            <el-pagination
              v-model:current-page="foodPager.page"
              v-model:page-size="foodPager.pageSize"
              :page-sizes="[10, 20, 50]"
              layout="total, sizes, prev, pager, next, jumper"
              :total="foodPager.total"
              @size-change="handleFoodPageSizeChange"
              @current-change="fetchFoods"
            />
          </div>
        </el-tab-pane>

        <el-tab-pane label="店铺" name="stores">
          <div class="toolbar">
            <el-input
              v-model="storeFilters.keyword"
              placeholder="搜索店铺名、地址或联系方式"
              clearable
              style="width: 280px"
              @keyup.enter="handleStoreSearch"
            />
            <el-input-number
              v-model="storeFilters.minScore"
              :min="0"
              :max="5"
              :step="0.1"
              :precision="1"
              placeholder="最低评分"
              controls-position="right"
              @change="handleStoreSearch"
            />
            <el-button type="primary" plain @click="handleStoreSearch">搜索</el-button>
            <div class="toolbar-spacer"></div>
            <el-button @click="resetStoreFilters">重置</el-button>
            <el-button type="primary" @click="openStoreDialog()">新增店铺</el-button>
          </div>

          <el-table :data="stores" v-loading="storeLoading" style="width: 100%">
            <el-table-column prop="id" label="ID" width="80" />
            <el-table-column prop="name" label="店铺名" min-width="180" show-overflow-tooltip />
            <el-table-column prop="address" label="地址" min-width="220" show-overflow-tooltip />
            <el-table-column prop="contact" label="联系方式" min-width="160" show-overflow-tooltip />
            <el-table-column prop="score" label="评分" width="100" />
            <el-table-column prop="openingHours" label="营业时间" min-width="180" show-overflow-tooltip />
            <el-table-column prop="updateTime" label="更新时间" min-width="180">
              <template #default="scope">
                {{ formatDateTime(scope.row.updateTime || scope.row.createTime) }}
              </template>
            </el-table-column>
            <el-table-column label="操作" width="170" fixed="right">
              <template #default="scope">
                <el-button size="small" @click="openStoreDialog(scope.row)">编辑</el-button>
                <el-button size="small" type="danger" @click="handleDeleteStore(scope.row)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>

          <div class="pagination">
            <el-pagination
              v-model:current-page="storePager.page"
              v-model:page-size="storePager.pageSize"
              :page-sizes="[10, 20, 50]"
              layout="total, sizes, prev, pager, next, jumper"
              :total="storePager.total"
              @size-change="handleStorePageSizeChange"
              @current-change="fetchStores"
            />
          </div>
        </el-tab-pane>

        <el-tab-pane label="社区" name="community">
          <div class="toolbar">
            <el-input
              v-model="communityFilters.keyword"
              placeholder="搜索帖子标题或内容"
              clearable
              style="width: 280px"
              @keyup.enter="handleCommunitySearch"
            />
            <el-select
              v-model="communityFilters.type"
              clearable
              placeholder="全部类型"
              style="width: 160px"
              @change="handleCommunitySearch"
            >
              <el-option label="复刻分享" :value="0" />
              <el-option label="探店体验" :value="1" />
              <el-option label="门店推荐" :value="2" />
            </el-select>
            <el-button type="primary" plain @click="handleCommunitySearch">搜索</el-button>
            <div class="toolbar-spacer"></div>
            <el-button @click="resetCommunityFilters">重置</el-button>
          </div>

          <el-table :data="communityPosts" v-loading="communityLoading" style="width: 100%">
            <el-table-column prop="id" label="ID" width="80" />
            <el-table-column prop="title" label="标题" min-width="220" show-overflow-tooltip />
            <el-table-column prop="nickname" label="作者" width="140" show-overflow-tooltip />
            <el-table-column prop="type" label="类型" width="120">
              <template #default="scope">
                <el-tag size="small">{{ getCommunityTypeLabel(scope.row.type) }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="likeCount" label="点赞" width="90" />
            <el-table-column prop="commentCount" label="评论" width="90" />
            <el-table-column prop="createTime" label="发布时间" min-width="180">
              <template #default="scope">
                {{ formatDateTime(scope.row.createTime) }}
              </template>
            </el-table-column>
            <el-table-column label="操作" width="170" fixed="right">
              <template #default="scope">
                <el-button size="small" @click="openCommunityDialog(scope.row.id)">查看</el-button>
                <el-button size="small" type="danger" @click="handleDeleteCommunity(scope.row)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>

          <div class="pagination">
            <el-pagination
              v-model:current-page="communityPager.page"
              v-model:page-size="communityPager.pageSize"
              :page-sizes="[10, 20, 50]"
              layout="total, sizes, prev, pager, next, jumper"
              :total="communityPager.total"
              @size-change="handleCommunityPageSizeChange"
              @current-change="fetchCommunityPosts"
            />
          </div>
        </el-tab-pane>
      </el-tabs>
    </div>

    <el-dialog v-model="productDialog.visible" :title="productDialog.mode === 'create' ? '新增商品' : '编辑商品'" width="720px">
      <el-form :model="productForm" label-width="100px">
        <div class="form-grid">
          <el-form-item label="商品名">
            <el-input v-model="productForm.name" />
          </el-form-item>
          <el-form-item label="分类">
            <el-input v-model="productForm.category" />
          </el-form-item>
          <el-form-item label="价格">
            <el-input-number v-model="productForm.price" :min="0" :precision="2" :step="1" controls-position="right" />
          </el-form-item>
          <el-form-item label="原价">
            <el-input-number v-model="productForm.originalPrice" :min="0" :precision="2" :step="1" controls-position="right" />
          </el-form-item>
          <el-form-item label="库存">
            <el-input-number v-model="productForm.stock" :min="0" controls-position="right" />
          </el-form-item>
          <el-form-item label="状态">
            <el-select v-model="productForm.status">
              <el-option label="上架" :value="1" />
              <el-option label="下架" :value="0" />
            </el-select>
          </el-form-item>
          <el-form-item label="评分">
            <el-input-number v-model="productForm.rating" :min="0" :max="5" :step="0.1" :precision="1" controls-position="right" />
          </el-form-item>
          <el-form-item label="销量">
            <el-input-number v-model="productForm.salesCount" :min="0" controls-position="right" />
          </el-form-item>
        </div>
        <el-form-item label="封面图">
          <el-input v-model="productForm.coverImage" />
        </el-form-item>
        <el-form-item label="轮播图">
          <el-input v-model="productForm.imagesText" type="textarea" :rows="2" placeholder="多个地址用英文逗号分隔" />
        </el-form-item>
        <el-form-item label="商品描述">
          <el-input v-model="productForm.description" type="textarea" :rows="5" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="productDialog.visible = false">取消</el-button>
        <el-button type="primary" @click="saveProductForm">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="storeDialog.visible" :title="storeDialog.mode === 'create' ? '新增店铺' : '编辑店铺'" width="760px">
      <el-form :model="storeForm" label-width="100px">
        <div class="form-grid">
          <el-form-item label="店铺名">
            <el-input v-model="storeForm.name" />
          </el-form-item>
          <el-form-item label="联系方式">
            <el-input v-model="storeForm.contact" />
          </el-form-item>
          <el-form-item label="评分">
            <el-input-number v-model="storeForm.score" :min="0" :max="5" :step="0.1" :precision="1" controls-position="right" />
          </el-form-item>
          <el-form-item label="营业时间">
            <el-input v-model="storeForm.openingHours" />
          </el-form-item>
          <el-form-item label="经度">
            <el-input-number v-model="storeForm.longitude" :precision="6" :step="0.000001" controls-position="right" />
          </el-form-item>
          <el-form-item label="纬度">
            <el-input-number v-model="storeForm.latitude" :precision="6" :step="0.000001" controls-position="right" />
          </el-form-item>
        </div>
        <el-form-item label="地址">
          <el-input v-model="storeForm.address" />
        </el-form-item>
        <el-form-item label="店铺介绍">
          <el-input v-model="storeForm.introduction" type="textarea" :rows="5" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="storeDialog.visible = false">取消</el-button>
        <el-button type="primary" @click="saveStoreForm">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="communityDialog.visible" title="帖子详情" width="760px">
      <el-form :model="communityForm" label-width="100px">
        <div class="form-grid">
          <el-form-item label="帖子ID">
            <el-input :model-value="communityForm.id" disabled />
          </el-form-item>
          <el-form-item label="作者">
            <el-input :model-value="communityForm.nickname || `用户${communityForm.userId || ''}`" disabled />
          </el-form-item>
          <el-form-item label="类型">
            <el-select v-model="communityForm.type">
              <el-option label="复刻分享" :value="0" />
              <el-option label="探店体验" :value="1" />
              <el-option label="门店推荐" :value="2" />
            </el-select>
          </el-form-item>
          <el-form-item label="发布时间">
            <el-input :model-value="formatDateTime(communityForm.createTime)" disabled />
          </el-form-item>
        </div>
        <el-form-item label="标题">
          <el-input v-model="communityForm.title" />
        </el-form-item>
        <el-form-item label="媒体地址">
          <el-input v-model="communityForm.mediaPath" />
        </el-form-item>
        <el-form-item label="帖子内容">
          <el-input v-model="communityForm.content" type="textarea" :rows="7" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="communityDialog.visible = false">关闭</el-button>
        <el-button type="primary" @click="saveCommunityForm">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { createStore, deleteStore, getStoreList, updateStore } from '../../../api/storeApi'
import { deletePost, getPostById, getPostList, updatePost } from '../../../api/communityApi'
import { deleteFood, getFoodList, updateFood } from '../../../api/foodApi'
import type { Store } from '../../../types/store'

type ContentTab = 'foods' | 'stores' | 'community'

interface PageResult<T> {
  records: T[]
  total: number
}

interface StoreRecord extends Store {
  createTime?: string
  updateTime?: string
}

interface CommunityPostRecord {
  id: number
  userId: number
  title: string
  content: string
  type: number
  mediaPath?: string
  likeCount?: number
  commentCount?: number
  nickname?: string
  createTime?: string
  updateTime?: string
}

interface FoodRecord {
  id: number
  name: string
  coverImage?: string
  images?: string[]
  price?: number
  originalPrice?: number
  description?: string
  region?: string
  taste?: string
  heritageLevel?: string
  heritageTag?: string
  status?: number
  viewCount?: number
  likeCount?: number
  rating?: number
  createdAt?: string
  updatedAt?: string
}

interface ProductFormModel {
  id?: number
  name: string
  description: string
  price: number
  originalPrice: number
  coverImage: string
  imagesText: string
  category: string
  stock: number
  salesCount: number
  rating: number
  status: number
}

interface StoreFormModel {
  id?: number
  name: string
  address: string
  contact: string
  openingHours: string
  introduction: string
  score: number
  longitude: number
  latitude: number
}

interface CommunityFormModel {
  id?: number
  userId?: number
  nickname?: string
  title: string
  content: string
  type: number
  mediaPath: string
  createTime?: string
}

const activeTab = ref<ContentTab>('products')

const productLoading = ref(false)
const storeLoading = ref(false)
const communityLoading = ref(false)
const foodLoading = ref(false)

const products = ref<ProductRecord[]>([])
const stores = ref<StoreRecord[]>([])
const communityPosts = ref<CommunityPostRecord[]>([])
const foods = ref<FoodRecord[]>([])
const productCategories = ref<string[]>([])

const productPager = reactive({ page: 1, pageSize: 10, total: 0 })
const storePager = reactive({ page: 1, pageSize: 10, total: 0 })
const communityPager = reactive({ page: 1, pageSize: 10, total: 0 })
const foodPager = reactive({ page: 1, pageSize: 10, total: 0 })

const productFilters = reactive({
  keyword: '',
  category: '',
  status: undefined as number | undefined,
  sortBy: 'updatedAt' as 'price' | 'sales' | 'rating' | 'createdAt' | 'updatedAt',
  sortOrder: 'desc' as 'asc' | 'desc'
})

const storeFilters = reactive({
  keyword: '',
  minScore: undefined as number | undefined
})

const communityFilters = reactive({
  keyword: '',
  type: undefined as number | undefined
})

const foodFilters = reactive({
  keyword: '',
  region: '',
  taste: '',
  heritageLevel: ''
})

const productDialog = reactive({
  visible: false,
  mode: 'create' as 'create' | 'edit'
})

const storeDialog = reactive({
  visible: false,
  mode: 'create' as 'create' | 'edit'
})

const communityDialog = reactive({
  visible: false
})

const productForm = reactive<ProductFormModel>(getEmptyProductForm())
const storeForm = reactive<StoreFormModel>(getEmptyStoreForm())
const communityForm = reactive<CommunityFormModel>(getEmptyCommunityForm())

function getEmptyProductForm(): ProductFormModel {
  return {
    name: '',
    description: '',
    price: 0,
    originalPrice: 0,
    coverImage: '',
    imagesText: '',
    category: '',
    stock: 0,
    salesCount: 0,
    rating: 0,
    status: 1
  }
}

function getEmptyStoreForm(): StoreFormModel {
  return {
    name: '',
    address: '',
    contact: '',
    openingHours: '',
    introduction: '',
    score: 0,
    longitude: 0,
    latitude: 0
  }
}

function getEmptyCommunityForm(): CommunityFormModel {
  return {
    title: '',
    content: '',
    type: 0,
    mediaPath: ''
  }
}

function assignProductForm(record?: ProductRecord) {
  Object.assign(productForm, getEmptyProductForm())
  if (!record) {
    return
  }

  const rawImages = (record as unknown as { images?: string[] | string }).images
  Object.assign(productForm, {
    id: record.id,
    name: record.name,
    description: record.description || '',
    price: Number(record.price || 0),
    originalPrice: Number(record.originalPrice || 0),
    coverImage: record.coverImage || '',
    imagesText: Array.isArray(rawImages) ? rawImages.join(', ') : (rawImages || ''),
    category: record.category || '',
    stock: Number(record.stock || 0),
    salesCount: Number(record.salesCount || 0),
    rating: Number(record.rating || 0),
    status: Number(record.status || 0)
  })
}

function assignStoreForm(record?: StoreRecord) {
  Object.assign(storeForm, getEmptyStoreForm())
  if (!record) {
    return
  }

  Object.assign(storeForm, {
    id: record.id,
    name: record.name,
    address: record.address || '',
    contact: record.contact || '',
    openingHours: record.openingHours || '',
    introduction: record.introduction || '',
    score: Number(record.score || 0),
    longitude: Number(record.longitude || 0),
    latitude: Number(record.latitude || 0)
  })
}

function assignCommunityForm(record?: CommunityPostRecord) {
  Object.assign(communityForm, getEmptyCommunityForm())
  if (!record) {
    return
  }

  Object.assign(communityForm, {
    id: record.id,
    userId: record.userId,
    nickname: record.nickname,
    title: record.title || '',
    content: record.content || '',
    type: Number(record.type || 0),
    mediaPath: record.mediaPath || '',
    createTime: record.createTime
  })
}

async function loadProductCategories() {
  try {
    productCategories.value = await getProductCategories()
  } catch (error) {
    ElMessage.error('加载商品分类失败')
  }
}

async function fetchProducts() {
  productLoading.value = true
  try {
    const response = await getProductList({
      page: productPager.page,
      pageSize: productPager.pageSize,
      keyword: productFilters.keyword || undefined,
      category: productFilters.category || undefined,
      status: productFilters.status,
      sortBy: productFilters.sortBy,
      sortOrder: productFilters.sortOrder
    })
    products.value = response.records || []
    productPager.total = response.total || 0
  } catch (error) {
    ElMessage.error('加载商品列表失败')
  } finally {
    productLoading.value = false
  }
}

async function fetchStores() {
  storeLoading.value = true
  try {
    const response = await getStoreList(storePager.page, storePager.pageSize, {
      keyword: storeFilters.keyword || undefined,
      minScore: storeFilters.minScore
    }) as PageResult<StoreRecord>
    stores.value = response.records || []
    storePager.total = response.total || 0
  } catch (error) {
    ElMessage.error('加载店铺列表失败')
  } finally {
    storeLoading.value = false
  }
}

async function fetchCommunityPosts() {
  communityLoading.value = true
  try {
    const response = await getPostList(communityPager.page, communityPager.pageSize) as PageResult<CommunityPostRecord>
    communityPosts.value = response.records || []
    communityPager.total = response.total || 0
  } catch (error) {
    ElMessage.error('加载社区帖子失败')
  } finally {
    communityLoading.value = false
  }
}

async function fetchFoods() {
  foodLoading.value = true
  try {
    const response = await getFoodList(foodPager.page, foodPager.pageSize, {
      keyword: foodFilters.keyword || undefined,
      region: foodFilters.region || undefined,
      taste: foodFilters.taste || undefined,
      heritage_level: foodFilters.heritageLevel || undefined
    }) as PageResult<FoodRecord>
    foods.value = response.records || []
    foodPager.total = response.total || 0
  } catch (error) {
    ElMessage.error('加载美食列表失败')
  } finally {
    foodLoading.value = false
  }
}

function handleProductSearch() {
  productPager.page = 1
  fetchProducts()
}

function handleStoreSearch() {
  storePager.page = 1
  fetchStores()
}

function handleCommunitySearch() {
  communityPager.page = 1
  fetchCommunityPosts()
}

function handleFoodSearch() {
  foodPager.page = 1
  fetchFoods()
}

function resetProductFilters() {
  productFilters.keyword = ''
  productFilters.category = ''
  productFilters.status = undefined
  productFilters.sortBy = 'updatedAt'
  productFilters.sortOrder = 'desc'
  handleProductSearch()
}

function resetStoreFilters() {
  storeFilters.keyword = ''
  storeFilters.minScore = undefined
  handleStoreSearch()
}

function resetCommunityFilters() {
  communityFilters.keyword = ''
  communityFilters.type = undefined
  handleCommunitySearch()
}

function resetFoodFilters() {
  foodFilters.keyword = ''
  foodFilters.region = ''
  foodFilters.taste = ''
  foodFilters.heritageLevel = ''
  handleFoodSearch()
}

function handleProductPageSizeChange() {
  productPager.page = 1
  fetchProducts()
}

function handleStorePageSizeChange() {
  storePager.page = 1
  fetchStores()
}

function handleCommunityPageSizeChange() {
  communityPager.page = 1
  fetchCommunityPosts()
}

function handleFoodPageSizeChange() {
  foodPager.page = 1
  fetchFoods()
}

function openProductDialog(record?: ProductRecord) {
  productDialog.mode = record ? 'edit' : 'create'
  assignProductForm(record)
  productDialog.visible = true
}

function openStoreDialog(record?: StoreRecord) {
  storeDialog.mode = record ? 'edit' : 'create'
  assignStoreForm(record)
  storeDialog.visible = true
}

async function openCommunityDialog(id: number) {
  try {
    const detail = await getPostById(id) as CommunityPostRecord
    assignCommunityForm(detail)
    communityDialog.visible = true
  } catch (error) {
    ElMessage.error('加载帖子详情失败')
  }
}

async function saveProductForm() {
  if (!productForm.name.trim()) {
    ElMessage.warning('请输入商品名')
    return
  }

  const payload = {
    ...(productDialog.mode === 'edit' && productForm.id ? { id: productForm.id } : {}),
    name: productForm.name.trim(),
    description: productForm.description.trim(),
    price: productForm.price,
    originalPrice: productForm.originalPrice,
    coverImage: productForm.coverImage.trim(),
    images: productForm.imagesText.trim(),
    category: productForm.category.trim(),
    stock: productForm.stock,
    salesCount: productForm.salesCount,
    rating: productForm.rating,
    status: productForm.status
  }

  try {
    if (productDialog.mode === 'create') {
      await createProduct(payload)
      ElMessage.success('新增商品成功')
    } else {
      await updateProduct(payload)
      ElMessage.success('更新商品成功')
    }
    productDialog.visible = false
    await Promise.all([loadProductCategories(), fetchProducts()])
  } catch (error) {
    ElMessage.error(productDialog.mode === 'create' ? '新增商品失败' : '更新商品失败')
  }
}

async function saveStoreForm() {
  if (!storeForm.name.trim()) {
    ElMessage.warning('请输入店铺名')
    return
  }

  const payload = {
    ...(storeDialog.mode === 'edit' && storeForm.id ? { id: storeForm.id } : {}),
    name: storeForm.name.trim(),
    address: storeForm.address.trim(),
    contact: storeForm.contact.trim(),
    openingHours: storeForm.openingHours.trim(),
    introduction: storeForm.introduction.trim(),
    score: storeForm.score,
    longitude: storeForm.longitude,
    latitude: storeForm.latitude
  }

  try {
    if (storeDialog.mode === 'create') {
      await createStore(payload)
      ElMessage.success('新增店铺成功')
    } else {
      await updateStore(payload)
      ElMessage.success('更新店铺成功')
    }
    storeDialog.visible = false
    await fetchStores()
  } catch (error) {
    ElMessage.error(storeDialog.mode === 'create' ? '新增店铺失败' : '更新店铺失败')
  }
}

async function saveCommunityForm() {
  if (!communityForm.id) {
    return
  }
  if (!communityForm.title.trim()) {
    ElMessage.warning('请输入帖子标题')
    return
  }

  try {
    await updatePost({
      id: communityForm.id,
      title: communityForm.title.trim(),
      content: communityForm.content.trim(),
      type: communityForm.type,
      mediaPath: communityForm.mediaPath.trim()
    })
    communityDialog.visible = false
    ElMessage.success('更新帖子成功')
    await fetchCommunityPosts()
  } catch (error) {
    ElMessage.error('更新帖子失败')
  }
}

async function handleDeleteProduct(record: ProductRecord) {
  try {
    await ElMessageBox.confirm(`确认删除商品"${record.name}"吗？`, '删除商品', {
      type: 'warning'
    })
    await deleteProduct(record.id)
    ElMessage.success('删除商品成功')
    if (products.value.length === 1 && productPager.page > 1) {
      productPager.page -= 1
    }
    await Promise.all([loadProductCategories(), fetchProducts()])
  } catch (error) {
    if (!isDialogCancel(error)) {
      ElMessage.error('删除商品失败')
    }
  }
}

async function handleDeleteStore(record: StoreRecord) {
  try {
    await ElMessageBox.confirm(`确认删除店铺"${record.name}"吗？`, '删除店铺', {
      type: 'warning'
    })
    await deleteStore(record.id)
    ElMessage.success('删除店铺成功')
    if (stores.value.length === 1 && storePager.page > 1) {
      storePager.page -= 1
    }
    await fetchStores()
  } catch (error) {
    if (!isDialogCancel(error)) {
      ElMessage.error('删除店铺失败')
    }
  }
}

async function handleDeleteCommunity(record: CommunityPostRecord) {
  try {
    await ElMessageBox.confirm(`确认删除帖子"${record.title}"吗？`, '删除帖子', {
      type: 'warning'
    })
    await deletePost(record.id)
    ElMessage.success('删除帖子成功')
    if (communityPosts.value.length === 1 && communityPager.page > 1) {
      communityPager.page -= 1
    }
    await fetchCommunityPosts()
  } catch (error) {
    if (!isDialogCancel(error)) {
      ElMessage.error('删除帖子失败')
    }
  }
}

async function handleDeleteFood(record: FoodRecord) {
  try {
    await ElMessageBox.confirm(`确认删除美食"${record.name}"吗？`, '删除美食', {
      type: 'warning'
    })
    await deleteFood(record.id)
    ElMessage.success('删除美食成功')
    if (foods.value.length === 1 && foodPager.page > 1) {
      foodPager.page -= 1
    }
    await fetchFoods()
  } catch (error) {
    if (!isDialogCancel(error)) {
      ElMessage.error('删除美食失败')
    }
  }
}

async function toggleProductStatus(record: ProductRecord, enabled: string | number | boolean) {
  const nextStatus = enabled ? 1 : 0
  try {
    await updateProduct({
      id: record.id,
      name: record.name,
      description: record.description,
      price: record.price,
      originalPrice: record.originalPrice,
      coverImage: record.coverImage,
      images: Array.isArray(record.images) ? record.images.join(',') : record.images,
      category: record.category,
      stock: record.stock,
      salesCount: record.salesCount,
      rating: record.rating,
      status: nextStatus
    })
    record.status = nextStatus
    ElMessage.success(nextStatus === 1 ? '商品已上架' : '商品已下架')
  } catch (error) {
    ElMessage.error('更新商品状态失败')
    await fetchProducts()
  }
}

function handleTabChange(name: string | number) {
  activeTab.value = name as ContentTab
  if (activeTab.value === 'products') {
    fetchProducts()
    return
  }
  if (activeTab.value === 'foods') {
    fetchFoods()
    return
  }
  if (activeTab.value === 'stores') {
    fetchStores()
    return
  }
  fetchCommunityPosts()
}

function getCommunityTypeLabel(type?: number) {
  if (type === 1) {
    return '探店体验'
  }
  if (type === 2) {
    return '门店推荐'
  }
  return '复刻分享'
}

function formatMoney(value?: number) {
  const amount = Number(value || 0)
  return amount.toFixed(2)
}

function formatDateTime(value?: string) {
  if (!value) {
    return '--'
  }
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) {
    return value
  }
  return date.toLocaleString('zh-CN', {
    hour12: false
  })
}

function isDialogCancel(error: unknown) {
  return error === 'cancel' || error === 'close'
}

onMounted(async () => {
  await Promise.all([
    fetchFoods(),
    fetchStores(),
    fetchCommunityPosts()
  ])
})
</script>

<style scoped>
.content-management {
  padding: 20px 0;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 20px;
}

.page-header h2 {
  margin: 0 0 6px;
  font-size: 20px;
  color: var(--text-color);
}

.page-header p {
  margin: 0;
  color: #7a8699;
  font-size: 14px;
}

.content-card {
  background: var(--bg-white);
  border-radius: 12px;
  box-shadow: var(--shadow);
  padding: 20px;
}

.toolbar {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-bottom: 16px;
  align-items: center;
}

.toolbar-spacer {
  flex: 1 1 auto;
}

.pagination {
  display: flex;
  justify-content: flex-end;
  margin-top: 20px;
}

.form-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 0 16px;
}
</style>
