<template>
      <main class="main-content">
        <div class="content-wrapper">
          
          <div class="page-header">
            <h1 class="page-title">Activity Designs Tracker</h1>
            <p class="page-subtitle">Review, monitor compliance status, and manage submitted institutional activity plan frameworks.</p>
          </div>

          <section class="stats-section">
            <div 
              v-for="stat in metricsStats" 
              :key="stat.label" 
              class="stat-card"
            >
              <div class="stat-card-inner">
                <div :class="['stat-icon', stat.bgClass]">
                  <span class="material-symbols-outlined stat-icon-symbol" :class="stat.iconColor">
                    {{ stat.icon }}
                  </span>
                </div>
                <div class="stat-info">
                  <h3 class="stat-value">
                    {{ stat.value }}
                  </h3>
                  <p class="stat-label">
                    {{ stat.label }}
                  </p>
                </div>
              </div>
            </div>
          </section>

          <section class="filter-section">
            <div class="filter-controls">
              <div class="search-wrapper">
                <span class="search-icon">🔍</span>
                <input 
                  v-model="filters.search"
                  type="text" 
                  placeholder="Search control identifier or title..." 
                  class="search-input"
                />
              </div>

              <div class="select-wrapper">
                <select 
                  v-model="filters.office"
                  class="filter-select"
                >
                  <option value="all">All Offices & Units</option>
                  <option v-for="off in officeOptions" :key="off" :value="off">{{ off }}</option>
                </select>
                <span class="select-arrow">▼</span>
              </div>

              <div class="select-wrapper">
                <select 
                  v-model="filters.status"
                  class="filter-select"
                >
                  <option value="all">All Statuses</option>
                  <option value="Pending">Pending Review</option>
                  <option value="Approved">Approved</option>
                  <option value="Revision">Revision</option>
                </select>
                <span class="select-arrow">▼</span>
              </div>
            </div>

            <div class="per-page-controls">
              <span class="per-page-label">Show</span>
              <select 
                v-model="perPage"
                class="per-page-select"
              >
                <option :value="5">5</option>
                <option :value="10">10</option>
                <option :value="25">25</option>
              </select>
              <span class="per-page-label">records</span>
            </div>
          </section>

          <div class="table-container">
            <div class="table-wrapper">
              <table class="data-table">
                <thead>
                  <tr class="table-header-row">
                    <th class="table-header-cell">Control No.</th>
                    <th class="table-header-cell">Activity Title</th>
                    <th class="table-header-cell">Office / Unit</th>
                    <th class="table-header-cell">Form Type</th>
                    <th class="table-header-cell">Date Submitted</th>
                    <th class="table-header-cell">Status</th>
                  </tr>
                </thead>
                <tbody class="table-body">
                  <tr v-if="filteredDesigns.length === 0">
                    <td colspan="6" class="empty-state">
                      No matching activity design submissions found in the repository index.
                    </td>
                  </tr>
                  
                  <tr 
                    v-else
                    v-for="item in filteredDesigns" 
                    :key="item.act_design_id"
                    @click="viewDetails(item)"
                    class="table-row"
                  >
                    <td class="table-cell control-cell">
                      {{ item.control }}
                    </td>
                    <td class="table-cell title-cell">
                      {{ item.title }}
                    </td>
                    <td class="table-cell office-cell">
                      {{ item.office }}
                    </td>
                    <td class="table-cell">
                      <span class="mandate-badge">
                        {{ item.formLabel }}
                      </span>
                    </td>
                    <td class="table-cell date-cell">
                      {{ item.date }}
                    </td>
                    <td class="table-cell">
                      <span 
                        class="status-badge"
                        :class="statusBadgeClass(item.status)"
                      >
                        {{ item.status }}
                      </span>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>

            <div class="pagination-container">
              <p class="pagination-info">
                Showing <span class="pagination-highlight">{{ paginationMeta.from || 0 }}</span> to <span class="pagination-highlight">{{ paginationMeta.to || 0 }}</span> of <span class="pagination-highlight">{{ paginationMeta.total || 0 }}</span> design records
              </p>
              
              <div class="pagination-controls">
                <button 
                  :disabled="currentPage === 1"
                  @click="currentPage--"
                  class="pagination-btn"
                >
                  ←
                </button>
                <button 
                  v-for="page in paginationMeta.last_page" 
                  :key="page"
                  @click="currentPage = page"
                  :class="['pagination-page', currentPage === page && 'pagination-page-active']"
                >
                  {{ page }}
                </button>
                <button 
                  :disabled="currentPage === paginationMeta.last_page"
                  @click="currentPage++"
                  class="pagination-btn"
                >
                  →
                </button>
              </div>
            </div>
          </div>

        </div>
      </main>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import api from '../../api';

const router = useRouter();
const user = ref(JSON.parse(localStorage.getItem('user') || '{}'));

const filters = ref({
  search: '',
  office: 'all',
  status: 'all'
});

const officeOptions = ref([]);

// Database repositories
const activityDesigns = ref([]);
const currentPage = ref(1);
const perPage = ref(10);
const paginationMeta = ref({ total: 0, from: 0, to: 0, last_page: 1 });

const metricsStats = ref([
  { label: 'Total Designs', value: '0', icon: 'description', iconColor: 'text-purple-400', bgClass: 'bg-purple-500/10' },
  { label: 'Pending Reviews', value: '0', icon: 'schedule', iconColor: 'text-amber-400', bgClass: 'bg-amber-500/10' },
  { label: 'Approved Plans', value: '0', icon: 'verified', iconColor: 'text-green-400', bgClass: 'bg-green-500/10' },
  { label: 'Revision', value: '0', icon: 'assignment_return', iconColor: 'text-red-400', bgClass: 'bg-red-500/10' }
]);

const filteredDesigns = computed(() => {
  let records = activityDesigns.value;
  if (filters.value.search) {
    const q = filters.value.search.toLowerCase();
    records = records.filter(i => i.control.toLowerCase().includes(q) || i.title.toLowerCase().includes(q));
  }
  if (filters.value.office !== 'all') {
    records = records.filter(i => i.office === filters.value.office);
  }
  if (filters.value.status !== 'all') {
    records = records.filter(i => i.status === filters.value.status);
  }
  return records;
});

const statusBadgeClass = (status) => {
  if (status === 'Approved') return 'status-badge-approved';
  if (status === 'Revision') return 'status-badge-revision';
  return 'status-badge-pending';
};

const viewDetails = (item) => {
  // Only navigate to the revision/edit view if the status is 'Revision' AND the current user is the owner
  if (item.status === 'Revision' && item.user_id == user.value.id) {
    router.push(`/staff/ad-revision/${item.act_design_id}`);
  } else {
    router.push(`/staff/ad-view/${item.act_design_id}`);
  }
};

const fetchDesigns = async () => {
  try {
    const response = await api.get('activity-designs');
    if (response.data.success) {
      activityDesigns.value = response.data.data;
      officeOptions.value = [...new Set(response.data.data.map(d => d.office).filter(Boolean))];

      // Update stat cards
      const total = activityDesigns.value.length;
      const pending = activityDesigns.value.filter(d => d.status === 'Pending').length;
      const approved = activityDesigns.value.filter(d => d.status === 'Approved').length;
      const revision = activityDesigns.value.filter(d => d.status === 'Revision').length;
      metricsStats.value[0].value = String(total);
      metricsStats.value[1].value = String(pending);
      metricsStats.value[2].value = String(approved);
      metricsStats.value[3].value = String(revision);

      paginationMeta.value.total = total;
      paginationMeta.value.from = total > 0 ? 1 : 0;
      paginationMeta.value.to = total;
    }
  } catch (err) {
    console.error('Failed to fetch activity designs:', err);
  }
};

const handleLogout = async () => {
  try {
    await api.get('logout');
    localStorage.removeItem('user');
    router.push('/login');
  } catch (err) {
    localStorage.removeItem('user');
    router.push('/login');
  }
};

onMounted(() => {
  if (!user.value.id || user.value.role !== 'gad_staff') {
    router.push('/login');
  } else {
    fetchDesigns();
  }
});
</script>

<style scoped>
.main-container { flex-grow: 1; display: flex; flex-direction: column; min-height: 100vh; }
.main-content { padding-left: 0; flex-grow: 1; }
.content-wrapper { display: flex; flex-direction: column; gap: 24px; }
.page-header { padding: 0 4px; }
.page-title { font-size: 24px; font-weight: 900; letter-spacing: -0.025em; color: #16213e; }
.page-subtitle { font-size: 14px; color: #475569; margin-top: 4px; }
.stats-section { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; }
.stat-card { padding: 16px; border-radius: 16px; border: 1px solid rgba(185, 121, 204, 0.15); box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1); backdrop-filter: blur(8px); transition: all 0.3s; background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); }
.stat-card:hover { transform: translateY(-4px); }
.stat-card-inner { display: flex; align-items: center; gap: 12px; }
.stat-icon { width: 40px; height: 40px; border-radius: 12px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.stat-icon-symbol { font-weight: 500; font-size: 18px; }
.text-blue-400 { color: #60a5fa; }
.text-amber-400 { color: #fbbf24; }
.text-cyan-400 { color: #22d3ee; }
.text-red-400 { color: #f87171; }
.text-purple-400 { color: #c084fc; }
.text-green-400 { color: #4ade80; }
.bg-blue-500\/10 { background: rgba(59, 130, 246, 0.1); }
.bg-amber-500\/10 { background: rgba(245, 158, 11, 0.1); }
.bg-cyan-500\/10 { background: rgba(6, 182, 212, 0.1); }
.bg-red-500\/10 { background: rgba(239, 68, 68, 0.1); }
.bg-purple-500\/10 { background: rgba(168, 85, 247, 0.1); }
.bg-green-500\/10 { background: rgba(34, 197, 94, 0.1); }
.mandate-badge { padding: 4px 10px; border-radius: 8px; font-size: 13px; font-weight: 900; text-transform: uppercase; letter-spacing: 0.05em; background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255, 255, 255, 0.1); color: #cbd5e1; }
.status-badge-approved { background: rgba(34, 197, 94, 0.2); color: #4ade80; border: 1px solid rgba(34, 197, 94, 0.3); }
.stat-info { min-width: 0; }
.stat-value { font-size: 20px; font-weight: 900; letter-spacing: -0.025em; color: white; line-height: 1.25; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.stat-label { font-size: 13px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.05em; color: rgba(203, 213, 225, 0.7); margin-top: 2px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.filter-section { padding: 16px; border-radius: 16px; border: 1px solid rgba(185, 121, 204, 0.15); box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.25); backdrop-filter: blur(8px); display: flex; flex-direction: row; align-items: center; justify-content: space-between; gap: 16px; background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); }
.filter-controls { display: flex; flex-direction: row; align-items: center; gap: 12px; width: auto; }
.search-wrapper { position: relative; width: 288px; }
.search-icon { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 13px; }
.search-input { width: 100%; padding: 8px 16px 8px 36px; border-radius: 12px; background: rgba(0, 0, 0, 0.4); border: 1px solid rgba(185, 121, 204, 0.2); font-size: 13px; font-weight: 600; color: white; transition: all 0.3s; }
.search-input:focus { outline: none; border-color: rgba(185, 121, 204, 0.5); }
.search-input::placeholder { color: #94a3b8; }
.select-wrapper { position: relative; width: 176px; }
.filter-select { width: 100%; padding: 8px 12px; border-radius: 12px; background: rgba(0, 0, 0, 0.4); border: 1px solid rgba(185, 121, 204, 0.2); font-size: 13px; font-weight: 600; color: white; appearance: none; cursor: pointer; transition: all 0.3s; }
.filter-select:focus { outline: none; border-color: rgba(185, 121, 204, 0.5); }
.select-arrow { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 13px; pointer-events: none; }
.per-page-controls { display: flex; align-items: center; gap: 8px; }
.per-page-label { font-size: 13px; color: #94a3b8; font-weight: 500; }
.per-page-select { padding: 6px 10px; border-radius: 8px; background: rgba(0, 0, 0, 0.4); border: 1px solid rgba(185, 121, 204, 0.2); font-size: 13px; font-weight: 700; color: white; cursor: pointer; transition: all 0.3s; }
.per-page-select:focus { outline: none; border-color: rgba(185, 121, 204, 0.5); }
.table-container { border-radius: 16px; border: 1px solid rgba(185, 121, 204, 0.15); box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.25); overflow: hidden; backdrop-filter: blur(8px); background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); }
.table-wrapper { overflow-x: auto; }
.data-table { width: 100%; text-align: left; border-collapse: collapse; }
.table-header-row { border-bottom: 1px solid rgba(185, 121, 204, 0.1); background: rgba(0, 0, 0, 0.3); }
.table-header-cell { padding: 16px 24px; font-size: 13px; font-weight: 900; text-transform: uppercase; letter-spacing: 0.1em; color: #b979cc; }
.table-body { display: table-row-group; }
.empty-state { padding: 48px 24px; text-align: center; font-size: 13px; color: #94a3b8; font-weight: 500; }
.table-row { transition: all 0.3s; border-bottom: 1px solid rgba(185, 121, 204, 0.05); cursor: pointer; font-size: 13px; }
.table-row:hover { background: rgba(255, 255, 255, 0.05); }
.table-cell { padding: 16px 24px; }
.control-cell { font-family: monospace; font-size: 13px; font-weight: 700; color: #b979cc; }
.title-cell { font-weight: 600; color: #e2e8f0; transition: color 0.3s; font-size: 13px; }
.table-row:hover .title-cell { color: #b979cc; }
.office-cell { color: rgba(203, 213, 225, 0.8); font-size: 13px; }
.date-cell { color: #94a3b8; font-family: monospace; font-size: 13px; }
.category-badge { padding: 4px 10px; border-radius: 8px; font-size: 13px; font-weight: 900; text-transform: uppercase; letter-spacing: 0.05em; background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255, 255, 255, 0.1); color: #cbd5e1; }
.status-badge { display: inline-block; padding: 4px 12px; border-radius: 8px; font-size: 13px; font-weight: 900; text-transform: uppercase; letter-spacing: 0.05em; }
.status-badge-pending { background: rgba(245, 158, 11, 0.2); color: #fbbf24; border: 1px solid rgba(245, 158, 11, 0.3); }
.status-badge-verified { background: rgba(6, 182, 212, 0.2); color: #22d3ee; border: 1px solid rgba(6, 182, 212, 0.3); }
.status-badge-revision { background: rgba(239, 68, 68, 0.2); color: #f87171; border: 1px solid rgba(239, 68, 68, 0.3); }
.pagination-container { padding: 16px 24px; border-top: 1px solid rgba(185, 121, 204, 0.1); background: rgba(0, 0, 0, 0.1); display: flex; flex-direction: row; justify-content: space-between; align-items: center; gap: 16px; }
.pagination-info { font-size: 13px; color: #94a3b8; font-weight: 500; }
.pagination-highlight { font-weight: 700; color: white; }
.pagination-controls { display: flex; align-items: center; gap: 6px; }
.pagination-btn { width: 32px; height: 32px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 700; color: white; border: 1px solid rgba(185, 121, 204, 0.1); background: rgba(0, 0, 0, 0.3); cursor: pointer; transition: all 0.2s; }
.pagination-btn:hover:not(:disabled) { border-color: rgba(185, 121, 204, 0.4); }
.pagination-btn:disabled { opacity: 0.3; cursor: not-allowed; }
.pagination-page { width: 32px; height: 32px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 700; transition: all 0.2s; cursor: pointer; color: #94a3b8; border: 1px solid rgba(185, 121, 204, 0.1); background: rgba(0, 0, 0, 0.2); }
.pagination-page:hover { border-color: rgba(185, 121, 204, 0.3); }
.pagination-page-active { color: white; background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%); box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); border: none; }
::-webkit-scrollbar { width: 6px; height: 6px; }
::-webkit-scrollbar-track { background: rgba(0, 0, 0, 0.1); }
::-webkit-scrollbar-thumb { background: rgba(185, 121, 204, 0.3); border-radius: 99px; }
::-webkit-scrollbar-thumb:hover { background: rgba(153, 13, 209, 0.5); }
@media (max-width: 1024px) { .main-container { margin-left: 0; } .app-header { left: 0; } .stats-section { grid-template-columns: repeat(2, 1fr); } .filter-section { flex-direction: column; align-items: stretch; } .filter-controls { width: 100%; flex-direction: column; } .search-wrapper, .select-wrapper { width: 100%; } .pagination-container { flex-direction: column; } }
@media (max-width: 768px) { .content-wrapper { padding: 20px; } .stats-section { grid-template-columns: 1fr; } }
</style>