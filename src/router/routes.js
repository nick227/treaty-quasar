const routes = [
  {
    path: '/',
    component: () => import('layouts/MainLayout.vue'),
    children: [
      { path: '', component: () => import('pages/Index.vue') },
      { path: '/conflicts', component: () => import('pages/conflict/ConflictListPage.vue') },
      { path: '/conflict/:id', component: () => import('pages/conflict/ConflictPage.vue') },
      { path: '/organizations', component: () => import('pages/organization/OrganizationListPage.vue') },
      { path: '/organization/:id', component: () => import('pages/organization/OrganizationPage.vue') },
      { path: '/treaties', component: () => import('pages/treaty/ListTreatyPage.vue') },
      { path: '/treaty/:id', component: () => import('pages/treaty/TreatyPage.vue') },
      { path: '/members', component: () => import('pages/member/MemberListPage.vue') },
      { path: '/admin/', component: () => import('pages/admin/AdminPage.vue') },
      { path: '/profile/:id', component: () => import('pages/member/ProfilePage.vue') },
      { path: '/login', component: () => import('pages/LoginPage.vue') },
      { path: '/get-started', component: () => import('pages/welcome/WelcomePage.vue') },
      { path: '/activity', component: () => import('pages/activity/ActivityListPage.vue') },
      { path: '/messages', component: () => import('pages/member/MessagesPage.vue') }
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
