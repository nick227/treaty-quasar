const routes = [
  {
    path: '/',
    component: () => import('layouts/MainLayout.vue'),
    children: [
      { path: '', component: () => import('pages/Index.vue') },
      { path: '/profile/:id', component: () => import('pages/ProfilePage.vue') },
      { path: '/treaties', component: () => import('pages/TreatyListPage.vue') },
      { path: '/members', component: () => import('pages/MemberListPage.vue') },
      { path: '/treaty/:id', component: () => import('pages/TreatyPage.vue') },
      { path: '/login', component: () => import('pages/LoginPage.vue') },
      { path: '/organizations', component: () => import('pages/OrganizationListPage.vue') },
      { path: '/organization/:id', component: () => import('pages/OrganizationPage.vue') }
    ]
  }
]

// Always leave this as last one
if (process.env.MODE !== 'ssr') {
  routes.push({
    path: '*',
    component: () => import('pages/Error404Page.vue')
  })
}

export default routes
