import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '../stores/userStore'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      name: 'home',
      component: () => import('../views/Home.vue')
    },
    {
      path: '/food/:id',
      name: 'foodDetail',
      component: () => import('../views/FoodDetail.vue')
    },
    {
      path: '/foods',
      name: 'foodList',
      component: () => import('../views/FoodList.vue')
    },
    {
      path: '/stores',
      name: 'storeList',
      component: () => import('../views/StoreList.vue')
    },
    {
      path: '/store/:id',
      name: 'storeDetail',
      component: () => import('../views/StoreDetail.vue')
    },
    {
      path: '/community',
      name: 'community',
      component: () => import('../views/Community.vue')
    },
    {
      path: '/map',
      name: 'map',
      component: () => import('../views/Map.vue')
    },
    {
      path: '/login',
      name: 'login',
      component: () => import('../views/Login.vue')
    },
    {
      path: '/user',
      name: 'user',
      component: () => import('../views/User.vue')
    },
    {
      path: '/user/profile',
      name: 'userProfile',
      component: () => import('../views/UserProfile.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/user/collections',
      name: 'userCollections',
      component: () => import('../views/UserCollections.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/user/comments',
      name: 'userComments',
      component: () => import('../views/UserComments.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/user/history',
      name: 'userHistory',
      component: () => import('../views/UserHistory.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/user/posts',
      name: 'userPosts',
      component: () => import('../views/UserPosts.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/user/settings',
      name: 'userSettings',
      component: () => import('../views/UserSettings.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/user/help',
      name: 'userHelp',
      component: () => import('../views/UserHelp.vue')
    },
    {
      path: '/user/about',
      name: 'userAbout',
      component: () => import('../views/UserAbout.vue')
    },
    {
      path: '/taste-test',
      name: 'tasteTest',
      component: () => import('../views/TasteTest.vue')
    },
    {
      path: '/time-timeline',
      name: 'timeTimeline',
      component: () => import('../views/TimeTimelineView.vue')
    },
    {
      path: '/shop',
      name: 'shop',
      component: () => import('../views/Shop.vue')
    },
    {
      path: '/product/:id',
      name: 'productDetail',
      component: () => import('../views/ProductDetail.vue')
    },
    {
      path: '/cart',
      name: 'cart',
      component: () => import('../views/Cart.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/order/create',
      name: 'orderCreate',
      component: () => import('../views/OrderCreate.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/order/payment',
      name: 'orderPayment',
      component: () => import('../views/OrderPayment.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/order/success',
      name: 'orderSuccess',
      component: () => import('../views/OrderSuccess.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/user/orders',
      name: 'userOrders',
      component: () => import('../views/UserOrders.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/merchant-test',
      name: 'merchantTest',
      component: () => import('../views/MerchantTest.vue')
    },
    {
      path: '/merchant-apply',
      name: 'merchantApply',
      component: () => import('../views/MerchantApplySimple.vue')
    },
    {
      path: '/merchant',
      name: 'merchant',
      component: () => import('../views/merchant/MerchantLayout.vue'),
      meta: { requiresAuth: true },
      redirect: '/merchant/dashboard',
      children: [
        {
          path: 'dashboard',
          name: 'merchantDashboard',
          component: () => import('../views/merchant/views/Dashboard.vue')
        },
        {
          path: 'products',
          name: 'merchantProducts',
          component: () => import('../views/merchant/views/Products.vue')
        },
        {
          path: 'content',
          name: 'merchantContent',
          component: () => import('../views/merchant/views/Content.vue')
        },
        {
          path: 'finance',
          name: 'merchantFinance',
          component: () => import('../views/merchant/views/Finance.vue')
        },
        {
          path: 'profile',
          name: 'merchantProfile',
          component: () => import('../views/merchant/views/Profile.vue')
        }
      ]
    },
    {
      path: '/admin',
      name: 'admin',
      component: () => import('../views/admin/AdminLayout.vue'),
      meta: { requiresAuth: true, requiresAdmin: true },
      redirect: '/admin/dashboard',
      children: [
        {
          path: 'dashboard',
          name: 'adminDashboard',
          component: () => import('../views/admin/views/Dashboard.vue')
        },
        {
          path: 'users',
          name: 'adminUsers',
          component: () => import('../views/admin/views/UserManagement.vue')
        },
        {
          path: 'roles',
          name: 'adminRoles',
          component: () => import('../views/admin/views/RoleManagement.vue')
        },
        {
          path: 'permissions',
          name: 'adminPermissions',
          component: () => import('../views/admin/views/PermissionManagement.vue')
        },
        {
          path: 'statistics',
          name: 'adminStatistics',
          component: () => import('../views/admin/views/Statistics.vue')
        },
        {
          path: 'settings',
          name: 'adminSettings',
          component: () => import('../views/admin/views/Settings.vue')
        },
        {
          path: 'merchants',
          name: 'adminMerchants',
          component: () => import('../views/admin/views/MerchantManagement.vue')
        },
        {
          path: 'content',
          name: 'adminContent',
          component: () => import('../views/admin/views/ContentManagement.vue')
        }
      ]
    }
  ]
})

router.beforeEach(async (to, from, next) => {
  const userStore = useUserStore()

  if (!userStore.isLoaded) {
    await userStore.loadUser()
  }

  if (to.meta.requiresAuth) {
    if (userStore.isLoggedIn) {
      if (to.meta.requiresAdmin) {
        if (userStore.user?.isAdmin === 1) {
          next()
        } else {
          next('/user')
        }
      } else {
        next()
      }
    } else {
      next('/login')
    }
  } else {
    next()
  }
})

export default router
