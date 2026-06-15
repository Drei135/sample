import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import LoginView from '../views/LoginView.vue'
import RegisterView from '../views/RegisterView.vue'
import AboutView from '../views/AboutView.vue'
import ResourcesView from '../views/ResourcesView.vue'
import GADCornerView from '../views/GADCornerView.vue'
import ContactView from '../views/ContactView.vue'
import AdminDashboard from '../views/AdminDashboard.vue'
import AdminAnnualReport from '../views/AdminAnnualReport.vue'
import CollegeDashboard from '../views/CollegeDashboard.vue'
import StaffDashboard from '../views/StaffDashboard.vue'
const routes = [
  { path: '/', name: 'home', component: HomeView },
  { path: '/login', name: 'login', component: LoginView },
  { path: '/register', name: 'register', component: RegisterView },
  { path: '/about', name: 'about', component: AboutView },
  { path: '/resources', name: 'resources', component: ResourcesView },
  { path: '/gad-corner', name: 'gad-corner', component: GADCornerView },
  { path: '/contact', name: 'contact', component: ContactView },

  // Legacy bookmarks → nested routes
  { path: '/college/submit-accomplishment', redirect: '/college/submit-report' },
  { path: '/staff/reviews', redirect: '/staff/submitted-list' },

  // Admin (nested layout + full workflows)
  {
    path: '/admin',
    component: AdminDashboard,
    children: [
      { path: '', redirect: '/admin/dashboard' },
      { path: 'dashboard', name: 'admin-dashboard', component: () => import('../views/admin/AdminDashboardContent.vue') },
      { path: 'annual-report', name: 'admin-annual-report', component: AdminAnnualReport },
      { path: 'submitted-list', name: 'admin-submitted', component: () => import('../views/admin/SubmittedListView.vue') },
      { path: 'ad-list', name: 'admin-activity-designs', component: () => import('../views/admin/AdListView.vue') },
      { path: 'ar-list', name: 'admin-accomplishment-reports', component: () => import('../views/admin/ARListView.vue') },
      { path: 'ad-view/:id', name: 'admin-ad-view', component: () => import('../views/admin/ADView.vue') },
      { path: 'ar-view/:id', name: 'admin-ar-view', component: () => import('../views/admin/ARView.vue') },
      { path: 'ar-review/:id', name: 'admin-ar-review', component: () => import('../views/admin/ARReview.vue') },
      { path: 'ad-review/:id', name: 'admin-ad-review', component: () => import('../views/admin/ADReview.vue') },
      { path: 'archive', name: 'admin-archive', component: () => import('../views/admin/ArchiveView.vue') },
      { path: 'mandates', name: 'admin-mandates', component: () => import('../views/admin/MandatesView.vue') },
      { path: 'reports', name: 'admin-reports', component: () => import('../views/admin/ReportsView.vue') },
      { path: 'user-manual', name: 'admin-user-manual', component: () => import('../views/admin/UserManualView.vue') },
      { path: 'budget', name: 'admin-budget', component: () => import('../views/admin/BudgetView.vue') },
      { path: 'design-review', name: 'admin-design-review', component: () => import('../views/admin/DesignReview.vue') },
      { path: 'design-view', name: 'admin-design-view', component: () => import('../views/admin/DesignView.vue') },
      { path: 'assign-mandates', name: 'admin-assign-mandates', component: () => import('../views/admin/AssignMandates.vue') },
      { path: 'gad-plan-budget', name: 'admin-gad-plan-budget', component: () => import('../views/admin/GadPlanBudgetView.vue') },
      { path: 'data-privacy-policy', name: 'admin-privacy-policy', component: () => import('../views/admin/PrivacyPolicyView.vue') },
    ]
  },

  // College / TWG
  {
    path: '/college',
    component: CollegeDashboard,
    children: [
      { path: '', redirect: '/college/dashboard' },
      { path: 'submit', name: 'college-submit-hub', component: () => import('../views/twg/SubmittView.vue') },
      { path: 'submit-design', name: 'college-submit-ad', component: () => import('../views/twg/SubmitADView.vue') },
      { path: 'submit-report', name: 'college-submit-ar', component: () => import('../views/twg/SubmitARView.vue') },
      { path: 'dashboard', name: 'college-dashboard', component: () => import('../views/twg/CollegeDashboardContent.vue') },
      { path: 'submitted-list', name: 'college-submitted-list', component: () => import('../views/twg/SubmittedListView.vue') },
      { path: 'ad-view/:id', name: 'college-ad-view', component: () => import('../views/twg/ADView.vue') },
      { path: 'ar-view/:id', name: 'college-ar-view', component: () => import('../views/twg/ARView.vue') },
      { path: 'ar-revision/:id', name: 'college-ar-revision', component: () => import('../views/twg/ARRevision.vue') },
      { path: 'ad-revision/:id', name: 'college-ad-revision', component: () => import('../views/twg/ADRevision.vue') },
      { path: 'archive', name: 'college-archive', component: () => import('../views/twg/ArchiveView.vue') },
      { path: 'mandates', name: 'college-mandates', component: () => import('../views/twg/MandatesView.vue') },
      { path: 'gad-plan-budget', name: 'college-gad-plan-budget', component: () => import('../views/twg/GadPlanBudgetView.vue') },
      { path: 'user-manual', name: 'college-user-manual', component: () => import('../views/twg/UserManualView.vue') },
      { path: 'data-privacy-policy', name: 'college-privacy-policy', component: () => import('../views/twg/PrivacyPolicyView.vue') },
      { path: 'tech-assist', name: 'college-tech-assist', component: () => import('../views/PlaceholderContent.vue') },
    ]
  },

  // Staff
  {
    path: '/staff',
    component: StaffDashboard,
    children: [
      { path: '', redirect: '/staff/dashboard' },
      { path: 'submit', name: 'staff-submit-hub', component: () => import('../views/staff/SubmitView.vue') },
      { path: 'submit-design', name: 'staff-submit-ad', component: () => import('../views/staff/SubmitADView.vue') },
      { path: 'submit-report', name: 'staff-submit-ar', component: () => import('../views/staff/SubmitARView.vue') },
      { path: 'dashboard', name: 'staff-dashboard', component: () => import('../views/staff/StaffDashboardContent.vue') },
      { path: 'submitted-list', name: 'staff-submitted-list', component: () => import('../views/staff/SubmittedListView.vue') },
      { path: 'ad-list', name: 'staff-ad-list', component: () => import('../views/staff/AdListView.vue') },
      { path: 'ar-list', name: 'staff-ar-list', component: () => import('../views/staff/ARListView.vue') },
      { path: 'ad-view/:id', name: 'staff-ad-view', component: () => import('../views/staff/ADView.vue') },
      { path: 'ar-view/:id', name: 'staff-ar-view', component: () => import('../views/staff/ARView.vue') },
      { path: 'ad-revision/:id', name: 'staff-ad-revision', component: () => import('../views/staff/ADRevision.vue') },
      { path: 'ar-revision/:id', name: 'staff-ar-revision', component: () => import('../views/staff/ARRevision.vue') },
      { path: 'archive', name: 'staff-archive', component: () => import('../views/staff/ArchiveView.vue') },
      { path: 'mandates', name: 'staff-mandates', component: () => import('../views/staff/MandatesView.vue') },
      { path: 'gad-plan-budget', name: 'staff-gad-plan-budget', component: () => import('../views/staff/GadPlanBudgetView.vue') },
      { path: 'reports', name: 'staff-reports', component: () => import('../views/staff/ReportsView.vue') },
      { path: 'budget', name: 'staff-budget', component: () => import('../views/staff/BudgetView.vue') },
      { path: 'budget-allocation', name: 'staff-budget-allocation', component: () => import('../views/staff/BudgetAllocationView.vue') },
      { path: 'user-manual', name: 'staff-user-manual', component: () => import('../views/staff/UserManualView.vue') },
      { path: 'data-privacy-policy', name: 'staff-privacy-policy', component: () => import('../views/staff/PrivacyPolicyView.vue') },
    ]
  },
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

export default router
