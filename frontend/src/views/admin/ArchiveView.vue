<template>

      <main class="flex-1 overflow-y-auto">
        <div class="max-w-7xl mx-auto">

          <div class="page-header">
            <h1 class="page-title">Archive Management</h1>
            <p class="page-subtitle">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
          </div>

          <div class="stats-container">
            <div class="stat-card-purple">
              <div class="stat-card-inner">
                <div class="stat-icon-wrapper purple">
                  <span class="material-symbols-outlined">inventory</span>
                </div>
                <div class="stat-content">
                  <h3 class="stat-number-purple">{{ totalArchived }}</h3>
                  <p class="stat-label-purple">TOTAL ARCHIVED</p>
                </div>
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-card-inner">
                <div class="stat-icon-wrapper green">
                  <span class="material-symbols-outlined">check_circle</span>
                </div>
                <div class="stat-content">
                  <h3 class="stat-number">{{ approvedDesigns }}</h3>
                  <p class="stat-label">Approved Designs</p>
                </div>
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-card-inner">
                <div class="stat-icon-wrapper blue">
                  <span class="material-symbols-outlined">celebration</span>
                </div>
                <div class="stat-content">
                  <h3 class="stat-number">{{ completedReports }}</h3>
                  <p class="stat-label">Completed Reports</p>
                </div>
              </div>
            </div>
          </div><br>

          <div class="tabs-container">
            <div class="tabs-header">
              <button 
                @click="activeTab = 'designs'" 
                class="tab-btn"
                :class="{ 'tab-active': activeTab === 'designs', 'tab-inactive': activeTab !== 'designs' }"
              >
                Activity Designs
                <span class="tab-badge">{{ totalDesigns }}</span>
              </button>
              <button 
                @click="activeTab = 'reports'" 
                class="tab-btn"
                :class="{ 'tab-active': activeTab === 'reports', 'tab-inactive': activeTab !== 'reports' }"
              >
                Accomplishment Reports
                <span class="tab-badge">{{ totalReports }}</span>
              </button>
            </div>
          </div>

          <div class="filter-card">
            <div class="filter-inline">
              <div class="filter-item">
                <label class="filter-label">STATUS</label>
                <select v-model="filters.status" class="filter-select-custom" @change="applyFilters">
                  <option value="all">All Status</option>
                  <option value="completed">Completed</option>
                  <option value="cancelled">Cancelled</option>
                </select>
              </div>

              <div class="filter-item">
                <label class="filter-label">SORT BY</label>
                <select v-model="filters.sort" class="filter-select-custom" @change="applyFilters">
                  <option value="date_desc">Newest First</option>
                  <option value="date_asc">Oldest First</option>
                  <option value="control_asc">Control A-Z</option>
                  <option value="control_desc">Control Z-A</option>
                </select>
              </div>

              <div class="filter-search">
                <label class="filter-label">SEARCH</label>
                <div class="search-box-wrapper">
                  <span class="search-icon">🔍</span>
                  <input 
                    type="text" 
                    v-model="filters.search" 
                    placeholder="Search by title or control number..." 
                    class="search-input"
                    @keyup.enter="applyFilters"
                  >
                </div>
              </div>

              <div class="filter-actions">
                <button class="btn-primary-custom" @click="applyFilters">Apply Filters</button>
                <button class="btn-secondary-custom" @click="resetFilters">Clear</button>
              </div>
            </div>

            <div class="filter-footer">
              <div class="record-count">
                <span class="count-number">{{ filteredItems.length }}</span> record(s) found
              </div>
            </div>
          </div>

          <div v-if="loading" class="loading-state">
            <div class="loading-spinner"></div>
            <p>Loading archive records...</p>
          </div>

          <div v-else class="data-table">
            <div class="overflow-x-auto">
              <table class="data-table-inner">
                <thead>
                  <tr class="table-header-row">
                    <th class="table-header-cell">TYPE</th>
                    <th class="table-header-cell">CONTROL NUMBER</th>
                    <th class="table-header-cell">ACTIVITY TITLE</th>
                    <th class="table-header-cell">DATE ARCHIVED</th>
                    <th class="table-header-cell">STATUS</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-if="paginatedItems.length === 0" class="empty-row">
                    <td colspan="5" class="empty-cell">
                      <div class="empty-content">
                        <span class="empty-emoji">📭</span>
                        <p>No archived records found</p>
                        <button class="btn-secondary-custom" @click="resetFilters">Clear Filters</button>
                      </div>
                    </td>
                  </tr>
                  <tr 
                    v-for="item in paginatedItems" 
                    :key="item.id"
                    class="clickable-row"
                    @click="viewItem(item)"
                  >
                    <td class="table-cell">
                      <span class="type-badge" :class="item.type === 'design' ? 'type-design' : 'type-report'">
                        {{ item.type === 'design' ? 'Activity Design' : 'Accomplishment Report' }}
                      </span>
                    </td>
                    <td class="table-cell">
                      <div class="control-number">{{ item.control }}</div>
                      <div class="item-date">{{ item.date }}</div>
                    </td>
                    <td class="table-cell">
                      <div class="item-title">{{ item.title }}</div>
                    </td>
                    <td class="table-cell">
                      <div class="control-number">{{ formatDate(item.archived_at) }}</div>
                    </td>
                    <td class="table-cell">
                      <span class="status-badge" :class="item.statusClass">
                        {{ item.statusText }}
                      </span>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>

            <div v-if="totalPages > 1" class="pagination-container">
              <div class="pagination-info">
                Showing <span class="info-highlight">{{ startIndex + 1 }}</span> - 
                <span class="info-highlight">{{ Math.min(startIndex + itemsPerPage, filteredItems.length) }}</span> 
                of <span class="info-total">{{ filteredItems.length }}</span> records
              </div>
              <div class="pagination-buttons">
                <button class="page-btn" :class="{ disabled: currentPage === 1 }" @click="changePage(currentPage - 1)" :disabled="currentPage === 1">← Prev</button>
                
                <button 
                  v-for="page in visiblePages" 
                  :key="page"
                  class="page-btn" 
                  :class="{ active: page === currentPage }"
                  @click="changePage(page)"
                >
                  {{ page }}
                </button>
                
                <button class="page-btn" :class="{ disabled: currentPage === totalPages }" @click="changePage(currentPage + 1)" :disabled="currentPage === totalPages">Next →</button>
              </div>
            </div>
          </div>
        </div>
      </main>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';

const router = useRouter();
const user = ref(JSON.parse(localStorage.getItem('user') || '{}'));

const archivedDesigns = ref([]);
const archivedReports = ref([]);
const loading = ref(false);
const activeTab = ref('designs');

const filters = ref({ 
  status: 'all',
  sort: 'date_desc',
  search: '' 
});

const currentPage = ref(1);
const itemsPerPage = 10;

const totalArchived = computed(() => {
  return archivedDesigns.value.length + archivedReports.value.length;
});

const approvedDesigns = computed(() => {
  return archivedDesigns.value.length;
});

const completedReports = computed(() => {
  return archivedReports.value.length;
});

const totalDesigns = computed(() => {
  return archivedDesigns.value.length;
});

const totalReports = computed(() => {
  return archivedReports.value.length;
});

const currentSourceData = computed(() => {
  return activeTab.value === 'designs' ? archivedDesigns.value : archivedReports.value;
});

const filteredItems = computed(() => {
  let items = [...currentSourceData.value];
  
  if (filters.value.status === 'completed') {
    items = items.filter(item => item.status.toLowerCase() === 'approved' || item.status.toLowerCase() === 'verified' || item.status.toLowerCase() === 'completed');
  } else if (filters.value.status === 'cancelled') {
    items = items.filter(item => item.status.toLowerCase() === 'cancelled');
  }
  
  if (filters.value.search.trim()) {
    const searchTerm = filters.value.search.toLowerCase();
    items = items.filter(item => 
      item.title.toLowerCase().includes(searchTerm) || 
      item.control.toLowerCase().includes(searchTerm)
    );
  }
  
  const sorted = [...items];
  switch (filters.value.sort) {
    case 'control_asc':
      sorted.sort((a, b) => a.control.localeCompare(b.control));
      break;
    case 'control_desc':
      sorted.sort((a, b) => b.control.localeCompare(a.control));
      break;
    case 'date_asc':
      sorted.sort((a, b) => new Date(a.dateRaw) - new Date(b.dateRaw));
      break;
    default: 
      sorted.sort((a, b) => new Date(b.dateRaw) - new Date(a.dateRaw));
  }
  
  return sorted;
});

const totalPages = computed(() => Math.ceil(filteredItems.value.length / itemsPerPage));
const startIndex = computed(() => (currentPage.value - 1) * itemsPerPage);
const paginatedItems = computed(() => {
  return filteredItems.value.slice(startIndex.value, startIndex.value + itemsPerPage);
});

const visiblePages = computed(() => {
  const maxVisible = 5;
  let startPage = Math.max(1, currentPage.value - Math.floor(maxVisible / 2));
  let endPage = Math.min(totalPages.value, startPage + maxVisible - 1);
  
  if (endPage - startPage + 1 < maxVisible) {
    startPage = Math.max(1, endPage - maxVisible + 1);
  }
  
  const pages = [];
  for (let i = startPage; i <= endPage; i++) {
    pages.push(i);
  }
  return pages;
});

const fetchArchives = async () => {
  loading.value = true;
  try {
    const response = await axios.get('http://localhost:8080/api/archives');
    
    if (response.data.success) {
      const allData = response.data.data;

      archivedDesigns.value = allData.filter(i => i.type === 'design').map(d => ({
        id: d.original_id,
        ...d,
        statusClass: getStatusClass(d.status),
        statusText: d.status,
        formClass: getFormClass(d.form_label)
      }));

      archivedReports.value = allData.filter(i => i.type === 'report').map(r => ({
        id: r.original_id,
        ...r,
        statusClass: getStatusClass(r.status),
        statusText: r.status,
        formClass: getFormClass(r.form_label)
      }));
    }
  } catch (error) {
    console.error('Error fetching archive records:', error);
  } finally {
    loading.value = false;
  }
};

const formatDate = (date) => {
  if (!date) return '---';
  return new Date(date).toLocaleDateString('en-US', { 
    month: 'short', 
    day: 'numeric', 
    year: 'numeric' 
  });
};

const formatFormType = (type) => {
  const types = { 'inset': 'INSET', 'extension': 'Extension Program', 'employee': 'Employee Training' };
  return types[type] || type;
};

const getFormClass = (type) => {
  return `form-badge-${type}`;
};

const getStatusClass = (status) => {
  if (!status) return '';
  const s = status.toLowerCase();
  if (s === 'approved') return 'status-approved';
  if (s === 'verified' || s === 'completed') return 'status-completed';
  if (s === 'cancelled') return 'status-revision';
  return 'status-pending';
};

const applyFilters = () => {
  currentPage.value = 1;
};

const resetFilters = () => {
  filters.value = {
    status: 'all',
    sort: 'date_desc',
    search: ''
  };
  currentPage.value = 1;
};

const changePage = (page) => {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page;
  }
};

const viewItem = (item) => {
  if (item.type === 'design') {
    router.push(`/admin/ad-view/${item.id}`);
  } else {
    router.push(`/admin/ar-view/${item.id}`);
  }
};

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
  if (!user.value.id || user.value.role !== 'admin') {
    router.push('/login');
  }
  fetchArchives();
});
</script>

<style scoped>
.page-header { padding: 0 4px 24px 0; }
.page-title { font-size: 24px; font-weight: 900; letter-spacing: -0.025em; color: #16213e; }
.page-subtitle { font-size: 12px; color: #94a3b8; margin-top: 4px; }
.stats-container { display: grid; grid-template-columns: 1fr; gap: 24px; }
.stat-card-purple { background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); padding: 16px; border-radius: 16px; box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05); border: 1px solid rgba(0, 0, 0, 0.15); }
.stat-card { padding: 16px; border-radius: 16px; border: 1px solid rgba(185, 121, 204, 0.15); box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1); backdrop-filter: blur(8px); transition: all 0.3s; background-color: #cbd5e1; }

.stat-card-inner { display: flex; align-items: center; gap: 16px; }
.stat-icon-wrapper { width: 40px; height: 40px; padding: 12px; border-radius: 12px; }
.stat-icon-wrapper.purple { background-color: #f3e8ff;  }
.stat-icon-wrapper.purple .material-symbols-outlined {  color: #9333ea; }
.stat-icon-wrapper.blue { background-color: #eff6ff; }
.stat-icon-wrapper.blue .material-symbols-outlined { color: #2563eb; }
.stat-icon-wrapper.green { background-color: #ecfdf5; }
.stat-icon-wrapper.green .material-symbols-outlined { color: #059669; }
.stat-icon-wrapper.amber { background-color: #fffbeb; }
.stat-icon-wrapper.amber .material-symbols-outlined { color: #d97706; }
.material-symbols-outlined { font-size: 20px; }
.stat-content { flex: 1; }
.stat-number { font-size: 20px; font-weight: 800; color: #1e293b; margin: 0; line-height: 1.2; }
.stat-label { font-size: 12px; font-weight: 700; color: #1a1a2e; text-transform: uppercase; letter-spacing: 0.05em; margin: 4px 0 0 0; }
.stat-number-purple { font-size: 20px; font-weight: 800; color: #ffffff; margin: 0; line-height: 1.2; }
.stat-label-purple { font-size: 12px; font-weight: 700; color: #d4a3e3; text-transform: uppercase; letter-spacing: 0.05em; margin: 4px 0 0 0; }
.stat-sub { font-size: 12px; color: #64748b; opacity: 0.7; margin: 4px 0 0 0; }
.stat-sub-purple { font-size: 12px; color: #b979cc; opacity: 0.7; margin: 4px 0 0 0; }
.tabs-container { margin-bottom: 24px; border-bottom: 1px solid #e2e8f0; }
.tabs-header { display: flex; gap: 8px; }
.tab-btn { transition: all 0.25s ease; border-radius: 12px 12px 0 0; padding: 12px 24px; font-weight: 600; font-size: 13px; background: none; border: none; cursor: pointer; display: inline-flex; align-items: center; gap: 8px; }
.tab-active { border-bottom: 3px solid #990dd1; color: #71009e; background: rgba(153, 13, 209, 0.04); }
.tab-inactive { border-bottom: 3px solid transparent; color: #64748b; }
.tab-inactive:hover { border-bottom: 3px solid #b979cc; color: #990dd1; background: rgba(153, 13, 209, 0.02); }
.tab-badge { background: #f1f5f9; color: #64748b; padding: 2px 8px; border-radius: 30px; font-size: 12px; font-weight: 600; }
.tab-active .tab-badge { background: rgba(153, 13, 209, 0.1); color: #990dd1; }
.filter-card { background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border-radius: 20px; padding: 16px 24px; margin-bottom: 24px; border: 1px solid #cbd5e1; box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05); }
.filter-inline { display: flex; flex-wrap: wrap; align-items: flex-end; gap: 16px; }
.filter-item { flex: 1; min-width: 140px; }
.filter-search { flex: 2; min-width: 200px; }
.filter-label { display: block; font-size: 12px; font-weight: 700; color: #b979cc; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 6px; }
.filter-select-custom { width: 100%; padding: 8px 12px; border-radius: 12px; border: 1px solid rgba(185, 121, 204, 0.15); background: #16213e; font-size: 13px; color: #ffffff; cursor: pointer; }
.filter-select-custom:focus { outline: none; border-color: #990dd1; box-shadow: 0 0 0 2px rgba(153, 13, 209, 0.1); }
.search-box-wrapper { position: relative; }
.search-icon { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); font-size: 13px; opacity: 0.6; color: #ffffff; }
.search-input { width: 100%; padding: 8px 12px 8px 32px; border-radius: 12px; border: 1px solid rgba(185, 121, 204, 0.15); background: #16213e; font-size: 13px; color: #ffffff; }
.search-input::placeholder { color: #94a3b8; }
.search-input:focus { outline: none; border-color: #990dd1; box-shadow: 0 0 0 2px rgba(153, 13, 209, 0.1); }
.filter-actions { display: flex; gap: 8px; }
.btn-primary-custom { background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%); color: white; padding: 8px 20px; border-radius: 12px; font-size: 12px; font-weight: 600; border: none; cursor: pointer; transition: all 0.2s ease; }
.btn-primary-custom:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(153, 13, 209, 0.3); }
.btn-secondary-custom { padding: 8px 20px; border-radius: 10px; border: 1px solid rgba(255, 255, 255, 0.15); background: rgba(0, 0, 0, 0.3); font-size: 13px; font-weight: 600; color: #cbd5e1; cursor: pointer; transition: all 0.2s; text-decoration: none; display: inline-block; }
.btn-secondary-custom:hover { background: rgba(185, 121, 204, 0.15); border-color: #b979cc; color: #b979cc; }
.filter-footer { display: flex; justify-content: space-between; align-items: center; margin-top: 16px; padding-top: 12px; border-top: 1px dashed #e2e8f0; }
.record-count { font-size: 12px; color: #94a3b8; }
.count-number { font-weight: 700; color: #b979cc; font-size: 13px; }
.loading-state { background: #cbd5e1; border-radius: 20px; padding: 48px; text-align: center; border: 1px solid #e2e8f0; }
.loading-state p { color: #475569; margin-top: 16px; }
.loading-spinner { width: 40px; height: 40px; border: 3px solid #e2e8f0; border-top-color: #990dd1; border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto; }
@keyframes spin { to { transform: rotate(360deg); } }
.data-table { background: #cbd5e1; border-radius: 20px; overflow: hidden; border: 1px solid #e2e8f0; box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05); }
.overflow-x-auto { overflow-x: auto; }
.data-table-inner { width: 100%; border-collapse: collapse; }
.table-header-row { background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); border-bottom: 1px solid #e2e8f0; }
.table-header-cell { padding: 16px 24px; text-align: left; font-size: 12px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.05em; color: #ffffff; }
.clickable-row { cursor: pointer; transition: all 0.2s ease; border-bottom: 1px solid #f1f5f9; }
.clickable-row:hover { background: #faf5ff; }
.table-cell { padding: 16px 24px; }
.type-badge { display: inline-flex; align-items: center; padding: 4px 13px; border-radius: 30px; font-size: 12px; font-weight: 700; }
.type-design { background: #f3e8ff; color: #7e22ce; }
.type-report { background: #e0f2fe; color: #0369a1; }
.form-badge { display: inline-flex; align-items: center; padding: 3px 10px; border-radius: 30px; font-size: 12px; font-weight: 600; background: #f1f5f9; color: #475569; }
.status-badge { display: inline-flex; align-items: center; padding: 5px 13px; border-radius: 30px; font-size: 12px; font-weight: 700; }
.status-badge.status-approved { background: #d1fae5; color: #059669; border: 1px solid #a7f3d0; }
.status-badge.status-completed { background: #e0f2fe; color: #0284c7; border: 1px solid #bae6fd; }
.status-badge.status-revision { background: #fee2e2; color: #dc2626; border: 1px solid #fecaca; }
.status-badge.status-pending { background: #fef3c7; color: #d97706; border: 1px solid #fde68a; }
.control-number { font-family: monospace; font-size: 13px; font-weight: 700; color: #7e22ce; letter-spacing: 0.03em; }
.item-date { font-size: 12px; color: #94a3b8; margin-top: 4px; }
.item-title { font-weight: 600; color: #1e293b; font-size: 13px; line-height: 1.4; }
.empty-row { border-bottom: none; }
.empty-cell { padding: 48px 24px; text-align: center; }
.empty-content { display: flex; flex-direction: column; align-items: center; gap: 8px; }
.empty-emoji { font-size: 48px; }
.empty-content p { color: #475569; font-size: 13px; }
.pagination-container { display: flex; align-items: center; justify-content: space-between; padding: 16px 24px; border-top: 1px solid #e2e8f0; flex-wrap: wrap; gap: 16px; }
.pagination-info { font-size: 12px; color: #64748b; }
.info-highlight { font-weight: 700; color: #7e22ce; }
.info-total { font-weight: 700; color: #1e293b; }
.pagination-buttons { display: flex; gap: 8px; flex-wrap: wrap; }
.page-btn { padding: 6px 14px; border: 1px solid #e2e8f0; border-radius: 10px; background: #ffffff; font-size: 12px; font-weight: 500; cursor: pointer; color: #475569; transition: all 0.2s ease; }
.page-btn:hover:not(:disabled) { background: #faf5ff; border-color: #990dd1; color: #990dd1; }
.page-btn.active { background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%); color: white; border-color: #990dd1; }
.page-btn.disabled { opacity: 0.4; cursor: not-allowed; }
@media (min-width: 768px) { .stats-container { grid-template-columns: repeat(4, 1fr); } }
@media (max-width: 1024px) { .stats-container { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 768px) { .stats-container { grid-template-columns: 1fr; } .filter-inline { flex-direction: column; align-items: stretch; } .filter-actions { justify-content: flex-end; } .pagination-container { flex-direction: column; } .table-header-cell, .table-cell { padding: 12px 16px; } }
</style>