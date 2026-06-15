<template>
  <div class="college-dashboard">
    <DashboardSidebar 
      roleLabel="Technical Working Group (TWG)" 
      :menuItems="collegeMenu" 
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
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';
import DashboardSidebar from '../components/DashboardSidebar.vue';

const router = useRouter();
const user = ref(JSON.parse(localStorage.getItem('user') || '{}'));

const collegeMenu = [
  { label: 'New Submission', icon: 'add', href: '/college/submit' },
  { label: 'Dashboard', icon: 'dashboard', href: '/college/dashboard' },
  { label: 'Submitted List', icon: 'list', href: '/college/submitted-list' },
  { label: 'Archives', icon: 'archive', href: '/college/archive' },
  { label: 'Mandates', icon: 'gavel', href: '/college/mandates' },
  { label: 'User Manual', icon: 'menu_book', href: '/college/user-manual' },
  { label: 'Data Privacy Policy', icon: 'privacy_tip', href: '/college/data-privacy-policy' }
];

const handleLogout = async () => {
  try {
    await axios.get('http://localhost:8080/api/logout');
    localStorage.removeItem('user');
    router.push('/login');
  } catch (err) {
    localStorage.removeItem('user');
    router.push('/login');
  }
};

onMounted(() => {
  if (!user.value.id || user.value.role !== 'college') {
    router.push('/login');
  }
});
</script>

<style scoped>
.college-dashboard { min-height: 100vh; display: flex; background-color: #f8fafc; }
.dashboard-main { flex-grow: 1; margin-left: 256px; display: flex; flex-direction: column; min-height: 100vh; }
.dashboard-header { position: fixed; top: 0; left: 256px; right: 0; height: 80px; z-index: 10; display: flex; align-items: center; padding: 0 40px; background: #1a1a2e; border-bottom: 1px solid rgba(185, 121, 204, 0.3); }
.header-title { font-size: 1.5rem; font-weight: 900; color: white; margin: 0; }
.header-subtitle { font-size: 0.65rem; font-weight: 700; color: #b979cc; text-transform: uppercase; letter-spacing: 0.05em; }

.dashboard-main-content { padding-top: 80px; flex-grow: 1; display: block; width: 100%; }
.content-wrapper { padding: 40px; width: 100%; }
</style>