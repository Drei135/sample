<template>
      <main class="flex-1 overflow-y-autobg-transparent">
        <div class="max-w-7xl mx-auto">

          <div class="page-header">
            <h1 class="page-title">Activity Designs and Accomplishment Reports Tracker</h1>
            <p class="page-subtitle">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
          </div>

            <div class="stats-container">

            <div class="stat-card-purple">
                <div class="stat-card-inner">
                <div class="stat-icon-wrapper purple">
                    <span class="material-symbols-outlined">description</span>
                </div>
                <div class="stat-content">
                    <h3 class="stat-number-purple">{{ totalSubmitted }}</h3>
                    <p class="stat-label-purple">TOTAL SUBMITTED</p>
                </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-card-inner">
                <div class="stat-icon-wrapper blue">
                    <span class="material-symbols-outlined">schedule</span>
                </div>
                <div class="stat-content">
                    <h3 class="stat-number">{{ pendingCount }}</h3>
                    <p class="stat-label">PENDING</p>
                </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-card-inner">
                <div class="stat-icon-wrapper amber">
                    <span class="material-symbols-outlined">edit_document</span>
                </div>
                <div class="stat-content">
                    <h3 class="stat-number">{{ revisionCount }}</h3>
                    <p class="stat-label">REVISIONS</p>
                </div>
                </div>
            </div>
            </div><br>

          <div class="tabs-container">
            <div class="tabs-header">
              <button 
                @click="activeTab = 'design'" 
                class="tab-btn"
                :class="{ 'tab-active': activeTab === 'design', 'tab-inactive': activeTab !== 'design' }"
              >
                Activity Designs
                <span class="tab-badge">{{ totalDesigns }}</span>
              </button>
              <button 
                @click="activeTab = 'report'" 
                class="tab-btn"
                :class="{ 'tab-active': activeTab === 'report', 'tab-inactive': activeTab !== 'report' }"
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
                  <option value="pending">Pending Review</option>
                  <option value="revision">For Revision</option>
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
            <p>Loading submissions...</p>
          </div>

          <div v-else class="data-table">
            <div class="overflow-x-auto">
              <table class="data-table-inner">
                <thead>
                  <tr class="table-header-row">
                    <th class="table-header-cell">TYPE</th>
                    <th class="table-header-cell">CONTROL NUMBER</th>
                    <th class="table-header-cell">ACTIVITY TITLE</th>
                    <th class="table-header-cell">FORMAT TYPE</th>
                    <th class="table-header-cell">STATUS</th>
                   </tr>
                </thead>
                <tbody>
                  <tr v-if="paginatedItems.length === 0" class="empty-row">
                    <td colspan="5" class="empty-cell">
                      <div class="empty-content">
                        <span class="empty-emoji">📭</span>
                        <p>No records found matching your criteria</p>
                        <button class="btn-secondary-custom" @click="resetFilters">Clear Filters</button>
                      </div>
                    </td>
                   </tr>
                  <tr 
                    v-for="item in paginatedItems" 
                    :key="item.id"
                    class="clickable-row"
                    @click="viewDetails(item)"
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
                      <span class="form-badge" :class="item.formClass">
                        {{ item.formLabel }}
                      </span>
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

const submissions = ref([]);
const loading = ref(false);
const activeTab = ref('design');

const filters = ref({
  status: 'all',
  sort: 'date_desc',
  search: ''
});

const currentPage = ref(1);
const itemsPerPage = 10;

const filteredItems = computed(() => {
  let items = submissions.value.filter(item => item.type === activeTab.value);
  
  if (filters.value.status !== 'all') {
    items = items.filter(item => item.status === filters.value.status);
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

const totalSubmitted = computed(() => {
  return submissions.value.length;
});

const totalDesigns = computed(() => {
  return submissions.value.filter(item => item.type === 'design').length;
});

const totalReports = computed(() => {
  return submissions.value.filter(item => item.type === 'report').length;
});

const pendingCount = computed(() => {
  return submissions.value.filter(item => item.status === 'pending').length;
});

const revisionCount = computed(() => {
  return submissions.value.filter(item => item.status.includes('revision')).length;
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

const fetchSubmissions = async () => {
  loading.value = true;
  try {
    const userId = user.value.id || user.value.user_id;
    
    const [designsRes, reportsRes] = await Promise.all([
      axios.get(`http://localhost:8080/api/activity-designs/${userId}`),
      axios.get(`http://localhost:8080/api/activity-reports/${userId}`)
    ]);

    const designs = (designsRes.data.data || []).map(d => ({
      id: d.act_design_id,
      type: 'design',
      control: d.control,
      title: d.activity_title,
      formLabel: formatFormType(d.formLabel),
      formClass: getFormClass(d.formLabel),
      status: d.status.toLowerCase(),
      statusText: d.status,
      statusClass: getStatusClass(d.status),
      date: d.date,
      dateRaw: d.created_at || d.date
    }));

    const reports = (reportsRes.data.data || []).map(r => ({
      id: r.id,
      type: 'report',
      control: r.control,
      title: r.activity_title,
      formLabel: formatFormType(r.form_type),
      formClass: getFormClass(r.form_type),
      status: r.status.toLowerCase(),
      statusText: r.status,
      statusClass: getStatusClass(r.status),
      date: r.date,
      dateRaw: r.created_at || r.date
    }));

    submissions.value = [...designs, ...reports];
    
  } catch (error) {
    console.error('Error fetching submissions:', error);
  } finally {
    loading.value = false;
  }
};

const formatFormType = (type) => {
  const types = { 'inset': 'INSET Training', 'extension': 'Extension Program', 'employee': 'Employee Training' };
  return types[type] || type;
};

const getFormClass = (type) => {
  return `form-badge-${type}`;
};

const getStatusClass = (status) => {
  const s = status?.toLowerCase() || '';
  if (s === 'approved' || s === 'verified') return 'status-verified';
  if (s.includes('revision')) return 'status-revision';
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

// const viewItem = (item) => {
//   if (item.type === 'design') {
//     router.push(`/college/ad-view/${item.id}`);
//   } else {
//     router.push(`/college/ar-view/${item.id}`);
//   }
// };

const viewDetails = (item) => {
  if (item.type === 'design' || !item.type) { 
    if (item.status && item.status.toLowerCase().includes('revision')) {
      router.push(`/college/ad-revision/${item.id}`);
    } else {
      router.push(`/college/ad-view/${item.id}`);
    }
  } else {
    if (item.status && item.status.toLowerCase().includes('revision')) {
      router.push(`/college/ar-revision/${item.id}`);
    } else {
      router.push(`/college/ar-view/${item.id}`);
    }
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
  if (!user.value.id || !['gad_staff', 'college', 'admin'].includes(user.value.role)) {
    router.push('/login');
  }
  fetchSubmissions();
});
</script>

<style scoped>
.page-header {
  padding: 0 0.25rem 1.5rem 0;
}

.page-title {
  font-size: 1.5rem;
  font-weight: 900;
  letter-spacing: -0.025em;
  color: #16213e;
}

.page-subtitle {
  font-size: 0.75rem;
  color: #94a3b8;
  margin-top: 0.25rem;
}

.stats-container {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
}

@media (min-width: 768px) {
  .stats-container {
    grid-template-columns: repeat(4, 1fr);
  }
}

.stat-card-purple {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  padding: 1.5rem;
  border-radius: 1rem;
  box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05);
  border: 1px solid rgba(0, 0, 0, 0.15);
}

.stat-card {
  background-color: #cbd5e1;
  padding: 1.5rem;
  border-radius: 1rem;
  box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05);
  border: 1px solid rgba(0, 0, 0, 0.15);
}

.stat-card-inner {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.stat-icon-wrapper {
  padding: 0.75rem;
  border-radius: 0.75rem;
}

.stat-icon-wrapper.purple {
  background-color: #f3e8ff;
}

.stat-icon-wrapper.purple .material-symbols-outlined {
  color: #9333ea;
}

.stat-icon-wrapper.blue {
  background-color: #eff6ff;
}

.stat-icon-wrapper.blue .material-symbols-outlined {
  color: #2563eb;
}

.stat-icon-wrapper.green {
  background-color: #ecfdf5;
}

.stat-icon-wrapper.green .material-symbols-outlined {
  color: #059669;
}

.stat-icon-wrapper.amber {
  background-color: #fffbeb;
}

.stat-icon-wrapper.amber .material-symbols-outlined {
  color: #d97706;
}

.material-symbols-outlined {
  font-size: 1.5rem;
}

.stat-content {
  flex: 1;
}

.stat-number {
  font-size: 1.5rem;
  font-weight: 800;
  color: #1e293b;
  margin: 0;
  line-height: 1.2;
}

.stat-label {
  font-size: 10px;
  font-weight: 700;
  color: #1a1a2e;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin: 0.25rem 0 0 0;
}

.stat-number-purple {
  font-size: 1.5rem;
  font-weight: 800;
  color: #ffffff;
  margin: 0;
  line-height: 1.2;
}

.stat-label-purple {
  font-size: 10px;
  font-weight: 700;
  color: #d4a3e3;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin: 0.25rem 0 0 0;
}

.stat-sub {
  font-size: 0.75rem;
  color: #64748b;
  opacity: 0.7;
  margin: 0.25rem 0 0 0;
}

.stat-sub-purple {
  font-size: 0.75rem;
  color: #b979cc;
  opacity: 0.7;
  margin: 0.25rem 0 0 0;
}

.tabs-container {
  margin-bottom: 1.5rem;
  border-bottom: 1px solid #e2e8f0;
}

.tabs-header {
  display: flex;
  gap: 0.5rem;
}

.tab-btn {
  transition: all 0.25s ease;
  border-radius: 12px 12px 0 0;
  padding: 0.75rem 1.5rem;
  font-weight: 600;
  font-size: 0.85rem;
  background: none;
  border: none;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
}

.tab-active {
  border-bottom: 3px solid #990dd1;
  color: #71009e;
  background: rgba(153, 13, 209, 0.04);
}

.tab-inactive {
  border-bottom: 3px solid transparent;
  color: #64748b;
}

.tab-inactive:hover {
  border-bottom: 3px solid #b979cc;
  color: #990dd1;
  background: rgba(153, 13, 209, 0.02);
}

.tab-badge {
  background: #f1f5f9;
  color: #64748b;
  padding: 0.125rem 0.5rem;
  border-radius: 30px;
  font-size: 0.7rem;
  font-weight: 600;
}

.tab-active .tab-badge {
  background: rgba(153, 13, 209, 0.1);
  color: #990dd1;
}

.filter-card {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  border-radius: 1.25rem;
  padding: 1rem 1.5rem;
  margin-bottom: 1.5rem;
  border: 1px solid #cbd5e1;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
}

.filter-inline {
  display: flex;
  flex-wrap: wrap;
  align-items: flex-end;
  gap: 1rem;
}

.filter-item {
  flex: 1;
  min-width: 140px;
}

.filter-search {
  flex: 2;
  min-width: 200px;
}

.filter-label {
  display: block;
  font-size: 0.65rem;
  font-weight: 700;
  color: #b979cc;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: 0.375rem;
}

.filter-select-custom {
  width: 100%;
  padding: 0.5rem 0.75rem;
  border-radius: 0.75rem;
  border: 1px solid rgba(185, 121, 204, 0.15);
  background:  #16213e;
  font-size: 0.8rem;
  color: #ffffff;
  cursor: pointer;
}

.filter-select-custom:focus {
  outline: none;
  border-color: #990dd1;
  box-shadow: 0 0 0 2px rgba(153, 13, 209, 0.1);
}

.search-box-wrapper {
  position: relative;
}

.search-icon {
  position: absolute;
  left: 0.75rem;
  top: 50%;
  transform: translateY(-50%);
  font-size: 0.85rem;
  opacity: 0.6;
  color: #ffffff;
}

.search-input {
  width: 100%;
  padding: 0.5rem 0.75rem 0.5rem 2rem;
  border-radius: 0.75rem;
  border: 1px solid rgba(185, 121, 204, 0.15);
  background:  #16213e;
  font-size: 0.8rem;
  color: #ffffff;
}

.search-input::placeholder {
  color: #ffffff;
}

.search-input:focus {
  outline: none;
  border-color: #990dd1;
  box-shadow: 0 0 0 2px rgba(153, 13, 209, 0.1);
}

.filter-actions {
  display: flex;
  gap: 0.5rem;
}

.btn-primary-custom {
  background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%);
  color: white;
  padding: 0.5rem 1.25rem;
  border-radius: 0.75rem;
  font-size: 0.75rem;
  font-weight: 600;
  border: none;
  cursor: pointer;
  transition: all 0.2s ease;
}

.btn-primary-custom:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(153, 13, 209, 0.3);
}

.btn-secondary-custom {
  padding: 0.5rem 1.25rem;
  border-radius: 0.6rem;
  border: 1px solid rgba(255, 255, 255, 0.15);
  background: rgba(0, 0, 0, 0.3);
  font-size: 0.8rem;
  font-weight: 600;
  color: #cbd5e1;
  cursor: pointer;
  transition: all 0.2s;
  text-decoration: none;
  display: inline-block;
}

.btn-secondary-custom:hover {
  background: rgba(185, 121, 204, 0.15);
  border-color: #b979cc;
  color: #b979cc;
}

.filter-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 1rem;
  padding-top: 0.75rem;
  border-top: 1px dashed #e2e8f0;
}

.record-count {
  font-size: 0.7rem;
  color: #64748b;
}

.count-number {
  font-weight: 700;
  color: #990dd1;
  font-size: 0.8rem;
}

.loading-state {
  background: #ffffff;
  border-radius: 1.25rem;
  padding: 3rem;
  text-align: center;
  border: 1px solid #e2e8f0;
}

.loading-state p {
  color: #475569;
  margin-top: 1rem;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 3px solid #e2e8f0;
  border-top-color: #990dd1;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.data-table {
  background: #cbd5e1;
  border-radius: 1.25rem;
  overflow: hidden;
  border: 1px solid #e2e8f0;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
}

.overflow-x-auto {
  overflow-x: auto;
}

.data-table-inner {
  width: 100%;
  border-collapse: collapse;
}

.table-header-row {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  border-bottom: 1px solid #e2e8f0;
}

.table-header-cell {
  padding: 1rem 1.5rem;
  text-align: left;
  font-size: 0.7rem;
  font-weight: 800;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #ffffff;
}

.clickable-row {
  cursor: pointer;
  transition: all 0.2s ease;
  border-bottom: 1px solid #f1f5f9;
}

.clickable-row:hover {
  background: #faf5ff;
}

.table-cell {
  padding: 1rem 1.5rem;
}

.type-badge {
  display: inline-flex;
  align-items: center;
  padding: 0.25rem 0.8rem;
  border-radius: 30px;
  font-size: 0.7rem;
  font-weight: 700;
}

.type-design {
  background: #f3e8ff;
  color: #7e22ce;
}

.type-report {
  background: #e0f2fe;
  color: #0369a1;
}

.form-badge {
  display: inline-flex;
  align-items: center;
  padding: 0.2rem 0.6rem;
  border-radius: 30px;
  font-size: 0.65rem;
  font-weight: 600;
  background: #f1f5f9;
  color: #475569;
}

.status-badge {
  display: inline-flex;
  align-items: center;
  padding: 0.3rem 0.8rem;
  border-radius: 30px;
  font-size: 0.7rem;
  font-weight: 700;
}

.status-badge.status-pending {
  background: #fef3c7;
  color: #d97706;
  border: 1px solid #fde68a;
}

.status-badge.status-revision {
  background: #fee2e2;
  color: #dc2626;
  border: 1px solid #fecaca;
}

.status-badge.status-verified,
.status-badge.status-approved {
  background: #d1fae5;
  color: #059669;
  border: 1px solid #6ee7b7;
}

.form-badge-inset { background: #fef3c7; color: #b45309; }
.form-badge-extension { background: #d1fae5; color: #065f46; }
.form-badge-employee { background: #e0e7ff; color: #3730a3; }

.control-number {
  font-family: monospace;
  font-size: 0.8rem;
  font-weight: 700;
  color: #7e22ce;
  letter-spacing: 0.03em;
}

.item-date {
  font-size: 0.65rem;
  color: #94a3b8;
  margin-top: 0.25rem;
}

.item-title {
  font-weight: 600;
  color: #1e293b;
  font-size: 0.85rem;
  line-height: 1.4;
}

.empty-row {
  border-bottom: none;
}

.empty-cell {
  padding: 3rem 1.5rem;
  text-align: center;
}

.empty-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
}

.empty-emoji {
  font-size: 3rem;
}

.empty-content p {
  color: #1a1a2e;
  font-size: 0.85rem;
}

.pagination-container {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1rem 1.5rem;
  border-top: 1px solid #e2e8f0;
  flex-wrap: wrap;
  gap: 1rem;
}

.pagination-info {
  font-size: 0.75rem;
  color: #64748b;
}

.info-highlight {
  font-weight: 700;
  color: #7e22ce;
}

.info-total {
  font-weight: 700;
  color: #1e293b;
}

.pagination-buttons {
  display: flex;
  gap: 0.5rem;
  flex-wrap: wrap;
}

.page-btn {
  padding: 0.4rem 0.9rem;
  border: 1px solid #e2e8f0;
  border-radius: 0.6rem;
  background: #ffffff;
  font-size: 0.75rem;
  font-weight: 500;
  cursor: pointer;
  color: #475569;
  transition: all 0.2s ease;
}

.page-btn:hover:not(:disabled) {
  background: #faf5ff;
  border-color: #990dd1;
  color: #990dd1;
}

.page-btn.active {
  background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%);
  color: white;
  border-color: #990dd1;
}

.page-btn.disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

@media (max-width: 1024px) {
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .stats-grid {
    grid-template-columns: 1fr;
  }
  
  .filter-inline {
    flex-direction: column;
    align-items: stretch;
  }
  
  .filter-actions {
    justify-content: flex-end;
  }
  
  .pagination-container {
    flex-direction: column;
  }
  
  .table-header-cell,
  .table-cell {
    padding: 0.75rem 1rem;
  }
}
</style>