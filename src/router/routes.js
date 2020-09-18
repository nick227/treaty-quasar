const routes = [
  {
    path: '/',
    component: () => import('layouts/MainLayout.vue'),
    children: [
      { path: '', component: () => import('pages/Index.vue') },
      { path: '/profile/:id', component: () => import('pages/member/ProfilePage.vue') },
      { path: '/conflicts', component: () => import('pages/conflict/ConflictListPage.vue') },
      { path: '/treaties', component: () => import('pages/treaty/ListTreatyPage.vue') },
      { path: '/members', component: () => import('pages/member/MemberListPage.vue') },
      { path: '/conflict/:id', component: () => import('pages/conflict/ConflictPage.vue') },
      { path: '/login', component: () => import('pages/LoginPage.vue') },
      { path: '/messages', component: () => import('pages/member/MessagesPage.vue') },
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
