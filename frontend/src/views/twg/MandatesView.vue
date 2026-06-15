<template>

      <main class="flex-1 overflow-y-auto">
        <div class="max-w-7xl mx-auto">

          <div class="hero-section">
            <div class="hero-content">
              <div class="hero-text">
                <h1>Office of Student Services - GAD Mandates</h1>
                <p>Gender and Development mandates where the Office of Student Services (OSS) is the responsible unit, as outlined in the BSU GAD Plan and Budget (GPB) 2026.</p>
                <div class="hero-stats">
                  <div class="stat-badge">
                    <div class="number">{{ totalMandates }}</div>
                    <div class="label">Total Mandates</div>
                  </div>
                  <div class="stat-badge">
                    <div class="number">{{ activeMandates }}</div>
                    <div class="label">Active</div>
                  </div>
                  <div class="stat-badge">
                    <div class="number">0</div>
                    <div class="label">Total Budget</div>
                  </div>
                </div>
              </div>
              
              <router-link to="/college/gad-plan-budget" class="gad-plan-card">
                <div class="gad-plan-icon">📜</div>
                <h3>GAD Plan & Budget</h3>
                <p>View GPB 2026 document</p>
                <span class="gad-plan-arrow">→</span>
              </router-link>
            </div>
          </div>
 
          <div class="filter-bar">
            <div class="filter-group">
              <span class="filter-label">Filter:</span>
              <select v-model="filters.status" class="filter-select" @change="applyFilters">
                <option value="all">All Mandates</option>
                <option value="active">In Progress</option>
                <option value="completed">Completed</option>
                <option value="upcoming">Upcoming</option>
              </select>
            </div>
            <div class="filter-group">
              <div class="search-box">
                <span>🔍</span>
                <input 
                  type="text" 
                  v-model="filters.search" 
                  placeholder="Search mandates..." 
                  @keyup.enter="applyFilters"
                >
              </div>
              <button class="btn-reset btn-primary-custom" @click="applyFilters">Apply</button>
              <button class="btn-reset" @click="resetFilters">Reset</button>
            </div>
          </div>

          <div v-if="loading" class="loading-state">
            <div class="loading-spinner"></div>
            <p>Loading mandates...</p>
          </div>

          <div v-else class="table-wrapper">
            <div class="table-header">
              <div>#</div>
              <div>Gender Issue / GAD Mandate</div>
              <div>Responsible Unit</div>
            </div>

            <div v-if="paginatedMandates.length === 0" class="empty-state">
              <span class="empty-icon">📭</span>
              <p>No OSS mandates found matching your criteria</p>
              <button @click="resetFilters" class="btn-reset">Clear all filters</button>
            </div>

            <router-link 
              v-for="(item, idx) in paginatedMandates" 
              :key="item.id"
              :to="`/college/mandate-details/${item.id}`"
              class="mandate-row"
            >
              <div class="mandate-number">{{ String(startIndex + idx + 1).padStart(2, '01') }}</div>
              <div class="mandate-title">
                {{ item.title }}
                <div class="mandate-meta">
                  <span class="status-badge" :class="getStatusClass(item.status)">{{ getStatusText(item.status) }}</span>
                  <span class="budget-text">Budget: {{ item.budget }}</span>
                </div>
              </div>
              <div class="mandate-office">{{ item.responsible }}</div>
            </router-link>
          </div>

          <div class="pagination" v-if="!loading && totalPages > 1">
            <div class="pagination-info">
              Showing {{ startIndex + 1 }} - {{ Math.min(startIndex + itemsPerPage, filteredMandates.length) }} of {{ filteredMandates.length }} OSS mandates
            </div>
            <div class="pagination-buttons">
              <button class="page-btn" :class="{ disabled: currentPage === 1 }" @click="changePage(currentPage - 1)" :disabled="currentPage === 1">←</button>
              
              <button 
                v-for="page in visiblePages" 
                :key="page"
                class="page-btn" 
                :class="{ active: page === currentPage }"
                @click="changePage(page)"
              >
                {{ page }}
              </button>
              
              <button class="page-btn" :class="{ disabled: currentPage === totalPages }" @click="changePage(currentPage + 1)" :disabled="currentPage === totalPages">→</button>
            </div>
          </div>
          
          <div class="footer-note">
            <p>Showing OSS (Office of Student Services) mandates as outlined in the BSU GAD Plan and Budget (GPB) 2026 | Last updated: {{ lastUpdated }}</p>
          </div>
        </div>
      </main>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import api from '../../api';
import DashboardSidebar from '../../components/DashboardSidebar.vue';
import DashboardHeader from '../../components/DashboardHeader.vue';

const router = useRouter();
const user = ref(JSON.parse(localStorage.getItem('user') || '{}'));

const mandates = ref([]);
const loading = ref(false);

const filters = ref({
  status: 'all',
  search: ''
});

const currentPage = ref(1);
const itemsPerPage = 10;

const totalMandates = computed(() => mandates.value.length);
const activeMandates = computed(() => mandates.value.filter(m => m.status === 'active').length);

const filteredMandates = computed(() => {
  let result = [...mandates.value];
  
  if (filters.value.status !== 'all') {
    result = result.filter(m => m.status === filters.value.status);
  }
  
  if (filters.value.search.trim()) {
    const searchTerm = filters.value.search.toLowerCase();
    result = result.filter(m => m.title.toLowerCase().includes(searchTerm));
  }
  
  return result;
});

const totalPages = computed(() => Math.ceil(filteredMandates.value.length / itemsPerPage));
const startIndex = computed(() => (currentPage.value - 1) * itemsPerPage);
const paginatedMandates = computed(() => {
  return filteredMandates.value.slice(startIndex.value, startIndex.value + itemsPerPage);
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

const fetchMandates = async () => {
  loading.value = true;
  try {
    // TODO: Replace with your actual API endpoint
    // const response = await api.get('mandates');
    // mandates.value = response.data;
    
    // Temporary empty array - remove this once database is connected
    mandates.value = [];
    
  } catch (error) {
    console.error('Error fetching mandates:', error);
  } finally {
    loading.value = false;
  }
};

const applyFilters = () => {
  currentPage.value = 1;
};

const resetFilters = () => {
  filters.value = {
    status: 'all',
    search: ''
  };
  currentPage.value = 1;
};

const changePage = (page) => {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page;
  }
};

const getStatusClass = (status) => {
  const classes = {
    active: 'status-active',
    completed: 'status-completed',
    upcoming: 'status-upcoming'
  };
  return classes[status] || 'status-active';
};

const getStatusText = (status) => {
  const texts = {
    active: 'In Progress',
    completed: 'Completed',
    upcoming: 'Upcoming'
  };
  return texts[status] || 'In Progress';
};

const lastUpdated = computed(() => {
  const date = new Date();
  return date.toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' });
});

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
  if (!user.value.id || user.value.role !== 'college') {
    router.push('/login');
  }
  fetchMandates();
});
</script>

<style scoped>
.max-w-7xl {
  max-width: 80rem;
  margin: 0 auto;
}

.hero-section {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  border-radius: 1.75rem;
  padding: 2rem 2.5rem;
  margin-bottom: 2rem;
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(185, 121, 204, 0.3);
}

.hero-section::before {
  content: '';
  position: absolute;
  top: -50%;
  right: -20%;
  width: 400px;
  height: 400px;
  background: radial-gradient(circle, rgba(185, 121, 204, 0.15) 0%, rgba(185, 121, 204, 0) 70%);
  border-radius: 50%;
  pointer-events: none;
}

.hero-content {
  position: relative;
  z-index: 10;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1.5rem;
}

.hero-text {
  flex: 1;
}

.hero-text h1 {
  font-size: 2rem;
  font-weight: 800;
  color: #ffffff;
  margin-bottom: 0.5rem;
  letter-spacing: -0.02em;
}

.hero-text p {
  font-size: 0.95rem;
  color: #cbd5e1;
  max-width: 550px;
  line-height: 1.5;
}

.hero-stats {
  display: flex;
  gap: 1rem;
  margin-top: 1rem;
}

.stat-badge {
  background: rgba(255, 255, 255, 0.08);
  backdrop-filter: blur(10px);
  border-radius: 1rem;
  padding: 0.75rem 1.5rem;
  text-align: center;
  border: 1px solid rgba(185, 121, 204, 0.3);
}

.stat-badge .number {
  font-size: 1.75rem;
  font-weight: 800;
  color: #b979cc;
}

.stat-badge .label {
  font-size: 0.95rem;
  color: #a0aec0;
  text-transform: uppercase;
  letter-spacing: 0.03em;
  margin-top: 0.25rem;
}

/* GAD Plan Card */
.gad-plan-card {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  border-radius: 1.25rem;
  padding: 1.25rem 1.5rem;
  text-align: center;
  border: 1px solid rgba(185, 121, 204, 0.3);
  transition: all 0.3s ease;
  cursor: pointer;
  text-decoration: none;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  min-width: 180px;
}

.gad-plan-card:hover {
  background: rgba(185, 121, 204, 0.15);
  transform: translateY(-2px);
  border-color: #b979cc;
}

.gad-plan-icon {
  width: 48px;
  height: 48px;
  background: rgba(185, 121, 204, 0.2);
  border-radius: 1rem;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
}

.gad-plan-card h3 {
  font-size: 1rem;
  font-weight: 700;
  color: #ffffff;
  margin: 0;
}

.gad-plan-card p {
  font-size: 1rem;
  color: #a0aec0;
  margin: 0;
}

.gad-plan-arrow {
  font-size: 1.25rem;
  color: #b979cc;
}

/* Filter Bar */
.filter-bar {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  border-radius: 1rem;
  padding: 1rem 1.5rem;
  margin-bottom: 1.75rem;
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  border: 1px solid rgba(185, 121, 204, 0.15);
}

.filter-group {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  flex-wrap: wrap;
}

.filter-label {
  font-size: 1rem;
  font-weight: 700;
  text-transform: uppercase;
  color: #b979cc;
  letter-spacing: 0.03em;
}

.filter-select {
  padding: 0.5rem 1rem;
  border-radius: 0.6rem;
  border: 1px solid rgba(255, 255, 255, 0.15);
  font-size: 0.8rem;
  font-family: inherit;
  cursor: pointer;
  color: #ffffff;
}

.filter-select option {
  background: #1a1a2e;
  color: #e2e8f0;
}

.filter-select:focus {
  outline: none;
  border-color: #b979cc;
  box-shadow: 0 0 0 2px rgba(185, 121, 204, 0.2);
}

.search-box {
  position: relative;
}

.search-box input {
  padding: 0.5rem 1rem 0.5rem 2.25rem;
  width: 260px;
  border-radius: 0.6rem;
  border: 1px solid rgba(255, 255, 255, 0.15);
  font-size: 0.8rem;
  font-family: inherit;
  color: #ffffff;
}

.search-box input::placeholder {
  color: #ffffff;
}

.search-box input:focus {
  outline: none;
  border-color: #b979cc;
  box-shadow: 0 0 0 2px rgba(185, 121, 204, 0.2);
}

.search-box span {
  position: absolute;
  left: 0.75rem;
  top: 50%;
  transform: translateY(-50%);
  font-size: 0.85rem;
  opacity: 0.6;
  color: #ffffff;
}

.btn-reset {
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

.btn-reset:hover {
  background: rgba(185, 121, 204, 0.15);
  border-color: #b979cc;
  color: #b979cc;
}

.btn-primary-custom {
  background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%);
  color: white;
  border: none;
}

.btn-primary-custom:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(153, 13, 209, 0.4);
  color: white;
}

/* Loading State */
.loading-state {
  background: rgba(255, 255, 255, 0.04);
  border-radius: 1.25rem;
  padding: 4rem;
  text-align: center;
  border: 1px solid rgba(185, 121, 204, 0.15);
}

.loading-state p {
  color: #cbd5e1;
  margin-top: 1rem;
  font-size: 0.9rem;
}

.loading-spinner {
  width: 50px;
  height: 50px;
  border: 3px solid rgba(185, 121, 204, 0.2);
  border-top-color: #b979cc;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

/* Table */
.table-wrapper {
  background: rgba(255, 255, 255, 0.04);
  border-radius: 1.25rem;
  overflow: hidden;
  border: 1px solid rgba(185, 121, 204, 0.15);
}

.table-header {
  display: grid;
  grid-template-columns: 60px 1fr 180px;
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  padding: 1rem 1.5rem;
  border-bottom: 1px solid rgba(185, 121, 204, 0.15);
  font-size: 1rem;
  font-weight: 800;
  text-transform: uppercase;
  color: #cbd5e1;
  letter-spacing: 0.03em;
}

.mandate-row {
  display: grid;
  grid-template-columns: 60px 1fr 180px;
  padding: 1.25rem 1.5rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
  transition: all 0.2s;
  cursor: pointer;
  text-decoration: none;
}

.mandate-row:hover {
  background: rgba(185, 121, 204, 0.08);
}

.mandate-number {
  font-weight: 700;
  color: #b979cc;
  font-size: 0.9rem;
}

.mandate-title {
  font-weight: 500;
  color: #f1f5f9;
  font-size: 0.9rem;
  line-height: 1.4;
}

.mandate-meta {
  margin-top: 0.5rem;
  display: flex;
  align-items: center;
  gap: 0.75rem;
  flex-wrap: wrap;
}

.status-badge {
  display: inline-block;
  padding: 0.25rem 0.75rem;
  border-radius: 30px;
  font-size: 0.95rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.02em;
}

.status-active {
  background: rgba(245, 124, 0, 0.2);
  color: #ff9800;
  border: 1px solid rgba(245, 124, 0, 0.3);
}

.status-completed {
  background: rgba(46, 125, 50, 0.2);
  color: #66bb6a;
  border: 1px solid rgba(46, 125, 50, 0.3);
}

.status-upcoming {
  background: rgba(21, 101, 192, 0.2);
  color: #64b5f6;
  border: 1px solid rgba(21, 101, 192, 0.3);
}

.budget-text {
  font-size: 1rem;
  color: #cbd5e1;
}

.mandate-office {
  font-size: 0.85rem;
  color: #cbd5e1;
  font-weight: 500;
}

/* Empty State */
.empty-state {
  background: #cbd5e1;
  padding: 3rem;
  text-align: center;
  color: #16213e;
}

.empty-icon {
  font-size: 3rem;
  display: block;
  margin-bottom: 1rem;
}

.empty-reset {
  color: #b979cc;
  margin-top: 0.75rem;
  display: inline-block;
  text-decoration: none;
  background: none;
  border: none;
  cursor: pointer;
  font-size: 0.9rem;
}

.empty-reset:hover {
  color: #990dd1;
}

/* Pagination */
.pagination {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1rem 1.5rem;
  background: rgba(255, 255, 255, 0.04);
  border-top: 1px solid rgba(185, 121, 204, 0.15);
  border-radius: 0 0 1.25rem 1.25rem;
}

.pagination-info {
  font-size: 0.8rem;
  color: #16213e;
}

.pagination-buttons {
  display: flex;
  gap: 0.5rem;
}

.page-btn {
  width: 2rem;
  height: 2rem;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 0.5rem;
  border: 1px solid rgba(255, 255, 255, 0.15);
  background: rgba(0, 0, 0, 0.3);
  font-size: 0.8rem;
  cursor: pointer;
  transition: all 0.2s;
  text-decoration: none;
  color: #16213e;
}

.page-btn:hover {
  background: rgba(185, 121, 204, 0.15);
  border-color: #b979cc;
  color: #b979cc;
}

.page-btn.active {
  background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%);
  border-color: #990dd1;
  color: white;
}

.page-btn.disabled {
  opacity: 0.4;
  cursor: not-allowed;
  pointer-events: none;
}

/* Footer */
.footer-note {
  text-align: center;
  margin-top: 1.5rem;
  font-size: 1rem;
  color: #16213e;
}

/* Responsive */
@media (max-width: 1024px) {
  .hero-content {
    flex-direction: column;
    text-align: center;
  }
  .hero-text p {
    max-width: 100%;
  }
  .gad-plan-card {
    width: 100%;
    max-width: 250px;
    margin: 0 auto;
  }
}

@media (max-width: 768px) {
  .hero-section {
    padding: 1.5rem;
  }
  .hero-text h1 {
    font-size: 1.5rem;
  }
  .table-header, .mandate-row {
    grid-template-columns: 50px 1fr 120px;
    padding: 1rem;
  }
  .filter-bar {
    flex-direction: column;
    align-items: stretch;
  }
  .search-box input {
    width: 100%;
  }
  .pagination {
    flex-direction: column;
    gap: 1rem;
  }
  .hero-stats {
    flex-wrap: wrap;
    justify-content: center;
  }
}
</style>