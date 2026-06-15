<template>
      <main class="twg-main-content">
      
        <div class="twg-content-wrapper">
          
          <div class="twg-header">
            <h1 class="twg-title">TWG Submission Tracker</h1>
            <p class="twg-subtitle">Monitor, review, and evaluate submitted Activity Designs and Accomplishment Reports per institutional unit.</p>
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
                  v-model="searchQuery"
                  type="text" 
                  placeholder="Search unit name or code..." 
                  class="search-input"
                />
              </div>

              <div class="select-wrapper">
                <select 
                  v-model="statusFilter"
                  class="filter-select"
                >
                  <option value="all">All Units</option>
                  <option value="active">With Submissions</option>
                  <option value="empty">No Submissions</option>
                </select>
                <span class="select-arrow">▼</span>
              </div>
            </div>

            <div class="per-page-controls">
              <span class="per-page-label">Show</span>
              <select 
                v-model="perPage"
                @change="handlePerPageChange"
                class="per-page-select"
              >
                <option :value="5">5</option>
                <option :value="10">10</option>
                <option :value="25">25</option>
                <option :value="50">50</option>
              </select>
              <span class="per-page-label">records</span>
            </div>
          </section>

          <div class="table-container">
            <div class="table-wrapper">
              <table class="data-table">
                <thead>
                  <tr class="table-header-row">
                    <th class="table-header-cell table-header-number">#</th>
                    <th class="table-header-cell">College / Office / Unit</th>
                    <th class="table-header-cell table-header-center">Activity Designs</th>
                    <th class="table-header-cell table-header-center">Accomplishment Reports</th>
                    <th class="table-header-cell table-header-center">Total Status</th>
                  </tr>
                </thead>
                <tbody class="table-body">
                  <tr v-if="filteredUnits.length === 0">
                    <td colspan="5" class="empty-state">
                      No matching Technical Working Group records or submissions discovered in the repository.
                    </td>
                  </tr>
                  
                  <tr 
                    v-else
                    v-for="(unit, index) in filteredUnits" 
                    :key="unit.id"
                    class="table-row clickable-row"
                    @click="openDetailsModal(unit)"
                  >
                    <td class="table-cell table-cell-number">
                      {{ (currentPage - 1) * perPage + index + 1 }}
                    </td>
                    <td class="table-cell">
                      <div class="unit-name">{{ unit.name }}</div>
                      <div class="unit-code">{{ unit.code }}</div>
                    </td>
                    <td class="table-cell table-cell-center table-cell-count">
                      {{ unit.activity_designs_count || 0 }}
                    </td>
                    <td class="table-cell table-cell-center table-cell-count">
                      {{ unit.accomplishment_reports_count || 0 }}
                    </td>
                    <td class="table-cell table-cell-center">
                      <span 
                        class="submission-badge"
                        :class="unit.total_submissions > 0 ? 'submission-badge-active' : 'submission-badge-empty'"
                      >
                        {{ unit.total_submissions || 0 }} Submissions
                      </span>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>

            <div class="pagination-container">
              <p class="pagination-info">
                Showing <span class="pagination-highlight">{{ paginationMeta.from || 0 }}</span> to <span class="pagination-highlight">{{ paginationMeta.to || 0 }}</span> of <span class="pagination-highlight">{{ paginationMeta.total || 0 }}</span> Technical Working Groups
              </p>
              
              <div class="pagination-controls">
                <button 
                  @click="changePage(currentPage - 1)"
                  :disabled="currentPage === 1"
                  class="pagination-btn"
                >
                  ←
                </button>
                <button 
                  v-for="page in paginationMeta.last_page" 
                  :key="page"
                  @click="changePage(page)"
                  :class="['pagination-page', currentPage === page && 'pagination-page-active']"
                >
                  {{ page }}
                </button>
                <button 
                  @click="changePage(currentPage + 1)"
                  :disabled="currentPage === paginationMeta.last_page"
                  class="pagination-btn"
                >
                  →
                </button>
              </div>
            </div>
          </div>

          <div class="footer-note">
            <p class="footer-text">
              📋 Tracking submission configurations for all university Technical Working Groups
            </p>
          </div>

        </div>
      </main>

    <div v-if="isModalOpen" class="modal-overlay" @click.self="closeModal">
      <div class="modal-window glass-card">
        <div class="modal-header">
          <div class="header-info">
            <h2 class="modal-title">{{ selectedUnit?.name }}</h2>
            <p class="modal-subtitle">Submissions History & Overview</p>
          </div>
          <button class="close-btn" @click="closeModal">
            <span class="material-symbols-outlined">close</span>
          </button>
        </div>

        <div class="modal-body custom-scrollbar">
          <div v-if="modalLoading" class="modal-loader">
            <div class="spinner"></div>
            <p>Loading unit records...</p>
          </div>

          <div v-else class="modal-sections">
            <div class="modal-section">
              <div class="section-banner design-banner">
                <span class="material-symbols-outlined">description</span>
                <h3>Activity Designs ({{ unitDesigns.length }})</h3>
              </div>
              <div class="item-list">
                <div v-for="design in unitDesigns" :key="design.act_design_id" class="item-entry">
                  <div class="item-info">
                    <div class="item-title-row">
                      <span class="item-title">{{ design.activity_title }}</span>
                      <span class="mini-status" :class="getStatusClass(design.status)">{{ design.status }}</span>
                    </div>
                    <span class="item-meta">{{ design.control || 'No Control #' }} • {{ formatDate(design.start_date) }}</span>
                  </div>
                  <button class="item-action-btn" @click.stop="router.push(`/staff/ad-view/${design.act_design_id}`)">View</button>
                </div>
                <p v-if="unitDesigns.length === 0" class="empty-note">No designs found.</p>
              </div>
            </div>

            <div class="modal-section">
              <div class="section-banner report-banner">
                <span class="material-symbols-outlined">analytics</span>
                <h3>Accomplishment Reports ({{ unitReports.length }})</h3>
              </div>
              <div class="item-list">
                <div v-for="report in unitReports" :key="report.id" class="item-entry">
                  <div class="item-info">
                    <div class="item-title-row">
                      <span class="item-title">{{ report.activity_title }}</span>
                      <span class="mini-status" :class="getStatusClass(report.status)">{{ report.status }}</span>
                    </div>
                    <span class="item-meta">{{ report.control_number || 'No Control #' }} • {{ formatDate(report.start_date) }}</span>
                  </div>
                  <button class="item-action-btn" @click.stop="router.push(`/staff/ar-view/${report.id}`)">View</button>
                </div>
                <p v-if="unitReports.length === 0" class="empty-note">No reports found.</p>
              </div>
            </div>
          </div>

        </div>
      </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import api from '../../api';

const router = useRouter();

const user = ref(JSON.parse(localStorage.getItem('user') || '{}'));

const searchQuery = ref('');
const statusFilter = ref('all');
const twgUnits = ref([]);
const currentPage = ref(1);
const perPage = ref(10);

 const isModalOpen = ref(false);
const selectedUnit = ref(null);
const unitDesigns = ref([]);
const unitReports = ref([]);
const modalLoading = ref(false);

const openDetailsModal = async (unit) => {
  selectedUnit.value = unit;
  isModalOpen.value = true;
  modalLoading.value = true;
  
  try {
    const [designsRes, reportsRes] = await Promise.all([
      api.get(`activity-design/user/${unit.id}`),
      api.get(`accomplishment-report/user/${unit.id}`)
    ]);
    
    unitDesigns.value = designsRes.data.data || [];
    unitReports.value = reportsRes.data.data || [];
  } catch (err) {
    console.error('Error fetching unit submissions:', err);
  } finally {
    modalLoading.value = false;
  }
};

const closeModal = () => {
  isModalOpen.value = false;
  selectedUnit.value = null;
  unitDesigns.value = [];
  unitReports.value = [];
};

const formatDate = (date) => {
  if (!date) return '---';
  return new Date(date).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
};

const getStatusClass = (status) => {
  if (!status) return '';
  const s = status.toLowerCase();
  if (s === 'approved' || s === 'completed' || s === 'verified') return 'mini-status-success';
  if (s === 'pending') return 'mini-status-pending';
  if (s.includes('revision') || s === 'cancelled') return 'mini-status-danger';
  return '';
};

const paginationMeta = ref({
  total: 0,
  from: 0,
  to: 0,
  last_page: 1
});

const metricsStats = ref([
  { label: 'Total TWGs', value: '0', icon: 'groups', iconColor: 'text-green-400', bgClass: 'bg-green-500/10' },
  { label: 'Total Non-TWG', value: '0', icon: 'person_search', iconColor: 'text-amber-400', bgClass: 'bg-amber-500/10' },
  { label: 'Total Act Designs', value: '0', icon: 'description', iconColor: 'text-purple-400', bgClass: 'bg-purple-500/10' },
  { label: 'Total Acc Reports', value: '0', icon: 'analytics', iconColor: 'text-blue-400', bgClass: 'bg-blue-500/10' }
]);

const filteredUnits = computed(() => {
  let records = twgUnits.value;

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    records = records.filter(unit => 
      unit.name.toLowerCase().includes(query) ||
      unit.code.toLowerCase().includes(query)
    );
  }

  if (statusFilter.value === 'active') {
    records = records.filter(unit => (unit.total_submissions || 0) > 0);
  } else if (statusFilter.value === 'empty') {
    records = records.filter(unit => (unit.total_submissions || 0) === 0);
  }

  return records;
});

const fetchTWGSubmissions = async (page = 1) => {
  try {
    const response = await api.get(`twg/twg-submissions?page=${page}&per_page=${perPage.value}`);
    twgUnits.value = response.data.data.map(unit => ({
      ...unit,
      name: unit.username, 
      code: `UNIT-${unit.id}` 
    }));
    paginationMeta.value = response.data.meta;
    currentPage.value = page;

    metricsStats.value[0].value = response.data.meta.total || 0;
    metricsStats.value[2].value = response.data.meta.total_designs || 0;
    metricsStats.value[3].value = response.data.meta.total_reports || 0;
  } catch (err) {
    console.error('Error parsing operational submissions context registry:', err);
  }
};

const handlePerPageChange = () => {
  currentPage.value = 1;
  fetchTWGSubmissions(1);
};

const changePage = (page) => {
  if (page >= 1 && page <= paginationMeta.value.last_page) {
    fetchTWGSubmissions(page);
  }
};

const viewDetails = (unitId) => {
  router.push(`/staff/twg-details/${unitId}`);
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
    fetchTWGSubmissions();
  }
});
</script>

<style scoped>
.twg-submissions { min-height: 100vh; display: flex; color: #cbd5e1; font-family: system-ui, -apple-system, sans-serif; }
.twg-submissions ::selection { background: rgba(153, 13, 209, 0.3); color: white; }
.twg-main-container { flex-grow: 1; margin-left: 256px; display: flex; flex-direction: column; min-height: 100vh; }
.twg-main-content { padding-left: 0; flex-grow: 1; }
.twg-content-wrapper { display: flex; flex-direction: column; gap: 24px; }
.twg-header { padding: 0 4px; }
.twg-title { font-size: 24px; font-weight: 900; letter-spacing: -0.025em; color: #1a1a2e; }
.twg-subtitle { font-size: 14px; color: #475569; margin-top: 4px; }
.stats-section { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; }
.stat-card { padding: 16px; border-radius: 16px; border: 1px solid rgba(185, 121, 204, 0.15); box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1); backdrop-filter: blur(8px); transition: all 0.3s; background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); }
.stat-card:hover { transform: translateY(-4px); }
.stat-card-inner { display: flex; align-items: center; gap: 12px; }
.stat-icon { width: 40px; height: 40px; border-radius: 12px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.stat-icon-symbol { font-weight: 500; font-size: 18px; }
.text-green-400 { color: #4ade80; }
.text-amber-400 { color: #fbbf24; }
.text-purple-400 { color: #c084fc; }
.text-blue-400 { color: #60a5fa; }
.bg-green-500\/10 { background: rgba(34, 197, 94, 0.1); }
.bg-amber-500\/10 { background: rgba(245, 158, 11, 0.1); }
.bg-purple-500\/10 { background: rgba(168, 85, 247, 0.1); }
.bg-blue-500\/10 { background: rgba(59, 130, 246, 0.1); }
.stat-info { min-width: 0; }
.stat-value { font-size: 20px; font-weight: 900; letter-spacing: -0.025em; color: white; line-height: 1.25; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.stat-label { font-size: 14px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.05em; color: rgba(203, 213, 225, 0.7); margin-top: 2px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.filter-section { padding: 16px; border-radius: 16px; border: 1px solid rgba(185, 121, 204, 0.15); box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.25); backdrop-filter: blur(8px); display: flex; flex-direction: row; align-items: center; justify-content: space-between; gap: 16px; background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); }
.filter-controls { display: flex; flex-direction: row; align-items: center; gap: 12px; width: auto; }
.search-wrapper { position: relative; width: 288px; }
.search-icon { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 14px; }
.search-input { width: 100%; padding: 8px 16px 8px 36px; border-radius: 12px; background: rgba(0, 0, 0, 0.4); border: 1px solid rgba(185, 121, 204, 0.2); font-size: 14px; font-weight: 600; color: white; transition: all 0.3s; }
.search-input:focus { outline: none; border-color: rgba(185, 121, 204, 0.5); }
.search-input::placeholder { color: #94a3b8; }
.select-wrapper { position: relative; width: 176px; }
.filter-select { width: 100%; padding: 8px 12px; border-radius: 12px; background: rgba(0, 0, 0, 0.4); border: 1px solid rgba(185, 121, 204, 0.2); font-size: 14px; font-weight: 600; color: white; appearance: none; cursor: pointer; transition: all 0.3s; }
.filter-select:focus { outline: none; border-color: rgba(185, 121, 204, 0.5); }
.select-arrow { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 14px; pointer-events: none; }
.per-page-controls { display: flex; align-items: center; gap: 8px; }
.per-page-label { font-size: 14px; color: #94a3b8; font-weight: 500; }
.per-page-select { padding: 6px 10px; border-radius: 8px; background: rgba(0, 0, 0, 0.4); border: 1px solid rgba(185, 121, 204, 0.2); font-size: 14px; font-weight: 700; color: white; cursor: pointer; transition: all 0.3s; }
.per-page-select:focus { outline: none; border-color: rgba(185, 121, 204, 0.5); }
.table-container { border-radius: 16px; border: 1px solid rgba(185, 121, 204, 0.15); box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.25); overflow: hidden; backdrop-filter: blur(8px); background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); }
.table-wrapper { overflow-x: auto; }
.data-table { width: 100%; text-align: left; border-collapse: collapse; }
.table-header-row { border-bottom: 1px solid rgba(185, 121, 204, 0.1); background: rgba(0, 0, 0, 0.3); }
.table-header-cell { padding: 16px 24px; font-size: 13px; font-weight: 900; text-transform: uppercase; letter-spacing: 0.1em; color: #b979cc; }
.table-header-number { width: 48px; text-align: center; }
.table-header-center { text-align: center; }
.table-header-right { text-align: right; }
.table-body { display: table-row-group; }
.empty-state { padding: 48px 24px; text-align: center; font-size: 14px; color: #94a3b8; font-weight: 500; }
.table-row { transition: all 0.3s; border-bottom: 1px solid rgba(185, 121, 204, 0.05); }
.clickable-row { cursor: pointer; }
.table-row:hover { background: rgba(255, 255, 255, 0.05); }
.table-cell { padding: 16px 24px; font-size: 14px; }
.table-cell-number { font-size: 14px; font-family: monospace; font-weight: 700; color: #94a3b8; text-align: center; }
.table-cell-center { text-align: center; }
.table-cell-right { text-align: right; }
.table-cell-count { font-family: monospace; font-size: 14px; font-weight: 700; color: #cbd5e1; }
.unit-name { font-weight: 700; color: #e2e8f0; font-size: 14px; }
.unit-code { font-size: 14px; color: #b979cc; font-weight: 500; letter-spacing: 0.025em; text-transform: uppercase; margin-top: 2px; }
.submission-badge { display: inline-block; padding: 4px 12px; border-radius: 8px; font-size: 14px; font-weight: 900; text-transform: uppercase; letter-spacing: 0.05em; }
.submission-badge-active { background: rgba(153, 13, 209, 0.2); color: #b979cc; border: 1px solid rgba(153, 13, 209, 0.3); }
.submission-badge-empty { background: rgba(0, 0, 0, 0.3); color: #94a3b8; border: 1px solid rgba(255, 255, 255, 0.05); }
.view-details-btn { padding: 8px 16px; border-radius: 12px; font-size: 14px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; color: white; transition: all 0.3s; display: inline-flex; align-items: center; gap: 6px; cursor: pointer; background: rgba(0, 0, 0, 0.3); border: 1px solid rgba(185, 121, 204, 0.15); }
.view-details-btn:hover { color: #b979cc; }
.pagination-container { padding: 16px 24px; border-top: 1px solid rgba(185, 121, 204, 0.1); background: rgba(0, 0, 0, 0.1); display: flex; flex-direction: row; justify-content: space-between; align-items: center; gap: 16px; }
.pagination-info { font-size: 14px; color: #94a3b8; font-weight: 500; }
.pagination-highlight { font-weight: 700; color: white; }
.pagination-controls { display: flex; align-items: center; gap: 6px; }
.pagination-btn { width: 32px; height: 32px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 14px; font-weight: 700; color: white; border: 1px solid rgba(185, 121, 204, 0.1); background: rgba(0, 0, 0, 0.3); cursor: pointer; transition: all 0.2s; }
.pagination-btn:hover:not(:disabled) { border-color: rgba(185, 121, 204, 0.4); }
.pagination-btn:disabled { opacity: 0.3; cursor: not-allowed; }
.pagination-page { width: 32px; height: 32px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 14px; font-weight: 700; transition: all 0.2s; cursor: pointer; color: #94a3b8; border: 1px solid rgba(185, 121, 204, 0.1); background: rgba(0, 0, 0, 0.2); }
.pagination-page:hover { border-color: rgba(185, 121, 204, 0.3); }
.pagination-page-active { color: white; background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%); box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); border: none; }
.footer-note { text-align: center; padding-top: 8px; }
.footer-text { font-size: 14px; font-weight: 500; letter-spacing: 0.05em; color: #94a3b8; text-transform: uppercase; }
.modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.7); backdrop-filter: blur(4px); display: flex; align-items: center; justify-content: center; z-index: 9999; padding: 20px; }
.modal-window { width: 100%; max-width: 700px; max-height: 85vh; display: flex; flex-direction: column; overflow: hidden; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5); }
.glass-card { background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border-radius: 24px; border: 1px solid rgba(185, 121, 204, 0.2); }
.modal-header { padding: 24px; border-bottom: 1px solid rgba(185, 121, 204, 0.15); display: flex; justify-content: space-between; align-items: center; }
.modal-title { font-size: 20px; font-weight: 800; color: white; }
.modal-subtitle { font-size: 14px; color: #b979cc; font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; }
.close-btn { background: none; border: none; color: #94a3b8; cursor: pointer; transition: color 0.2s; }
.close-btn:hover { color: white; }
.modal-body { padding: 24px; overflow-y: auto; }
.modal-loader { text-align: center; padding: 40px; color: #94a3b8; }
.section-banner { display: flex; align-items: center; gap: 10px; padding: 10px 15px; border-radius: 8px; margin-bottom: 15px; background: rgba(0, 0, 0, 0.3); }
.section-banner h3 { font-size: 14px; font-weight: 800; text-transform: uppercase; margin: 0; }
.design-banner { color: #c084fc; border-left: 4px solid #c084fc; }
.report-banner { color: #60a5fa; border-left: 4px solid #60a5fa; margin-top: 30px; }
.item-entry { display: flex; justify-content: space-between; align-items: center; padding: 12px; border-bottom: 1px solid rgba(255, 255, 255, 0.05); }
.item-title { display: block; color: white; font-weight: 600; font-size: 14px; }
.item-meta { display: block; font-size: 14px; color: #94a3b8; margin-top: 2px; }
.item-title-row { display: flex; align-items: center; gap: 8px; margin-bottom: 2px; }
.mini-status { font-size: 14px; padding: 1px 6px; border-radius: 4px; font-weight: 700; text-transform: uppercase; background: rgba(255, 255, 255, 0.1); color: #94a3b8; }
.mini-status-success { background: rgba(34, 197, 94, 0.2); color: #4ade80; }
.mini-status-pending { background: rgba(245, 158, 11, 0.2); color: #fbbf24; }
.mini-status-danger { background: rgba(239, 68, 68, 0.2); color: #f87171; }
.item-action-btn { background: rgba(185, 121, 204, 0.1); border: 1px solid rgba(185, 121, 204, 0.2); color: #b979cc; padding: 4px 12px; border-radius: 6px; font-size: 14px; font-weight: 700; cursor: pointer; }
.item-action-btn:hover { background: #b979cc; color: white; }
.empty-note { color: #64748b; font-size: 14px; font-style: italic; padding: 10px; }
::-webkit-scrollbar { width: 6px; height: 6px; }
::-webkit-scrollbar-track { background: rgba(0, 0, 0, 0.1); }
::-webkit-scrollbar-thumb { background: rgba(185, 121, 204, 0.3); border-radius: 99px; }
::-webkit-scrollbar-thumb:hover { background: rgba(153, 13, 209, 0.5); }
@media (max-width: 1024px) { .twg-main-container { margin-left: 0; } .stats-section { grid-template-columns: repeat(2, 1fr); } .filter-section { flex-direction: column; align-items: stretch; } .filter-controls { width: 100%; flex-direction: column; } .search-wrapper, .select-wrapper { width: 100%; } .pagination-container { flex-direction: column; } }
@media (max-width: 768px) { .twg-content-wrapper { padding: 20px; } .stats-section { grid-template-columns: 1fr; } }
</style>