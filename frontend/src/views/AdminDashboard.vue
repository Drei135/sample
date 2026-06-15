<template>
  <div class="admin-dashboard bg-slate-50">
    <DashboardSidebar 
      roleLabel="Administrator" 
      :menuItems="adminMenu" 
      @logout="handleLogout" 
    />

    <div class="dashboard-main bg-slate-50">
      <header class="dashboard-header bg-[#1a1a2e] border-b border-purple-900/30">
        </header>

      <main class="dashboard-main-content">
        <div class="content-wrapper">
          <router-view /> 
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router';
import DashboardSidebar from '../components/DashboardSidebar.vue';

const router = useRouter();

const adminMenu = [
  { label: 'Dashboard', icon: 'dashboard', href: '/admin/dashboard' },
  { label: 'Submitted List', icon: 'folder', href: '/admin/submitted-list' },
  { label: 'Activity Design List', icon: 'description', href: '/admin/ad-list' },
  { label: 'Accomplishment Report List', icon: 'description', href: '/admin/ar-list' },
  { label: 'Archive', icon: 'archive', href: '/admin/archive' },
  { label: 'Mandates Management', icon: 'account_balance', href: '/admin/mandates' },
  { label: 'Report Monitoring', icon: 'bar_chart', href: '/admin/reports' },
  { label: 'Budget Monitoring', icon: 'account_balance_wallet', href: '/admin/budget' },
  { label: 'User Manual', icon: 'help', href: '/admin/user-manual' },
  { label: 'Data Privacy Policy', icon: 'privacy_tip', href: '/admin/data-privacy-policy' }
];

const handleLogout = () => {
  localStorage.removeItem("user");
  router.push("/login");
};
</script>

<style scoped>
.admin-dashboard { min-height: 100vh; display: flex; background-color: #f8fafc; }
.dashboard-main { flex-grow: 1; margin-left: 256px; display: flex; flex-direction: column; min-height: 100vh; }
.dashboard-header { position: fixed; top: 0; left: 256px; right: 0; height: 80px; z-index: 10; display: flex; align-items: center; padding: 0 40px; background: #1a1a2e; border-bottom: 1px solid rgba(185, 121, 204, 0.3); }
.header-title { font-size: 1.5rem; font-weight: 900; color: white; margin: 0; }
.header-subtitle { font-size: 0.65rem; font-weight: 700; color: #b979cc; text-transform: uppercase; letter-spacing: 0.05em; }

.dashboard-main-content { padding-top: 80px; flex-grow: 1; display: block; width: 100%; }
.content-wrapper { padding: 40px; width: 100%; }
</style>