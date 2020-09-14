const routes = [
  {
    path: '/',
    component: () => import('layouts/MainLayout.vue'),
    children: [
      { path: '', component: () => import('pages/Index.vue') },
      { path: '/profile/:id', component: () => import('pages/member/ProfilePage.vue') },
      { path: '/treaties', component: () => import('pages/treaty/TreatyListPage.vue') },
      { path: '/members', component: () => import('pages/member/MemberListPage.vue') },
      { path: '/treaty/:id', component: () => import('pages/treaty/TreatyPage.vue') },
      { path: '/login', component: () => import('pages/LoginPage.vue') },
      { path: '/organizations', component: () => import('pages/organization/OrganizationListPage.vue') },
      { path: '/organization/:id', component: () => import('pages/organization/OrganizationPage.vue') }
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
