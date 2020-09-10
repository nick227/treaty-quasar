const routes = [
  {
    path: '/',
    component: () => import('layouts/MainLayout.vue'),
    children: [
      { path: '', component: () => import('pages/Index.vue') },
      { path: '/profile', component: () => import('pages/Profile.vue') },
      { path: '/treaties', component: () => import('pages/TreatyList.vue') },
      { path: '/treaty/create', component: () => import('pages/CreateTreaty.vue') },
      { path: '/treaty/:id', component: () => import('pages/Treaty.vue') },
      { path: '/login', component: () => import('pages/Login.vue') },
      { path: '/organizations', component: () => import('pages/OrganizationList.vue') },
      { path: '/organization/:id', component: () => import('pages/Organization.vue') }
    ]
  }
]

// Always leave this as last one
if (process.env.MODE !== 'ssr') {
  routes.push({
    path: '*',
    component: () => import('pages/Error404.vue')
  })
}

export default routes
