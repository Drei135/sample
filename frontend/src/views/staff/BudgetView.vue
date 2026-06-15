<template>
      <main class="main-content">
        <div class="content-wrapper">
          
          <div class="page-header">
            <div class="header-main-flex">
              <div>
                <h1 class="page-title">Budget Utilization Monitoring</h1>
                <p class="page-subtitle">Track budget allocation, utilization, remaining balances, and percentage utilization across all GAD units and offices.</p>
              </div>
              <button @click="router.push('/staff/budget-allocation')" class="allocation-btn">
                <span class="material-symbols-outlined btn-icon">payments</span>
                Manage Budget Allocation
              </button>
            </div>
          </div>

          <div class="stats-grid">
            <div class="stat-card">
              <div class="stat-icon-wrapper blue">
                <span class="material-symbols-outlined">account_balance</span>
              </div>
              <div class="stat-content">
                <h3 class="stat-value">₱{{ formatNum(totalAllocatedBudget) }}</h3>
                <p class="stat-label">Total Allocated Budget</p>
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-icon-wrapper green">
                <span class="material-symbols-outlined">trending_up</span>
              </div>
              <div class="stat-content">
                <h3 class="stat-value">₱{{ formatNum(totalUtilizedAmount) }}</h3>
                <p class="stat-label">Total Utilized Amount</p>
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-icon-wrapper amber">
                <span class="material-symbols-outlined">account_balance_wallet</span>
              </div>
              <div class="stat-content">
                <h3 class="stat-value">₱{{ formatNum(totalRemainingBudget) }}</h3>
                <p class="stat-label">Total Remaining Budget</p>
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-icon-wrapper purple">
                <span class="material-symbols-outlined">pie_chart</span>
              </div>
              <div class="stat-content">
                <h3 class="stat-value">{{ overallUtilizationRate }}%</h3>
                <p class="stat-label">Overall Utilization Rate</p>
              </div>
            </div>
          </div>

          <div class="table-container">
            <div class="table-wrapper">
              <table class="data-table">
                <thead>
                  <tr class="table-header-row">
                    <th class="table-header-cell col-number">#</th>
                    <th class="table-header-cell col-unit text-left">Unit / Office</th>
                    <th class="table-header-cell col-allocated">Total Allocated Budget</th>
                    <th class="table-header-cell col-utilized">Utilized Amount</th>
                    <th class="table-header-cell col-remaining">Remaining Budget</th>
                    <th class="table-header-cell col-percent">% Utilization</th>
                  </tr>
                </thead>
                <tbody class="table-body">
                  <tr v-if="budgetRows.length === 0">
                    <td colspan="6" class="empty-state">
                      No budget records found in the database.
                    </td>
                  </tr>

                  <tr v-else v-for="(row, index) in budgetRows" :key="row.id" class="table-row">
                    <td class="table-cell cell-number">
                      {{ index + 1 }}
                    </td>
                    
                    <td class="table-cell cell-unit">
                      <div class="unit-name">{{ row.unit_name }}</div>
                      <div class="unit-code">{{ row.unit_code }}</div>
                    </td>

                    <td class="table-cell cell-allocated editable-cell" @click="startEditingCell(row.id, 'allocated', row.allocated)">
                      <div v-if="isEditing(row.id, 'allocated')" class="edit-input-wrapper">
                        <input 
                          :ref="el => setCellInputRef(el, row.id, 'allocated')" 
                          v-model.number="activeEditValue" 
                          type="number" 
                          step="1000" 
                          min="0"
                          @blur="saveCellAdjustment(row.id, 'allocated')" 
                          @keyup.enter="saveCellAdjustment(row.id, 'allocated')" 
                          @keyup.esc="cancelCellAdjustment" 
                          class="edit-input"
                        />
                      </div>
                      <div v-else class="cell-value">
                        ₱{{ formatNum(row.allocated) }}
                        <span class="edit-icon">✏️</span>
                      </div>
                    </td>

                    <td class="table-cell cell-utilized editable-cell" @click="startEditingCell(row.id, 'utilized', row.utilized)">
                      <div v-if="isEditing(row.id, 'utilized')" class="edit-input-wrapper">
                        <input 
                          :ref="el => setCellInputRef(el, row.id, 'utilized')" 
                          v-model.number="activeEditValue" 
                          type="number" 
                          step="1000" 
                          min="0"
                          @blur="saveCellAdjustment(row.id, 'utilized')" 
                          @keyup.enter="saveCellAdjustment(row.id, 'utilized')" 
                          @keyup.esc="cancelCellAdjustment" 
                          class="edit-input"
                        />
                      </div>
                      <div v-else class="cell-value">
                        ₱{{ formatNum(row.utilized) }}
                        <span class="edit-icon">✏️</span>
                      </div>
                    </td>

                    <td class="table-cell cell-remaining" :class="getRemainingClass(row.remaining)">
                      ₱{{ formatNum(row.remaining) }}
                    </td>

                    <td class="table-cell cell-percent">
                      <div class="progress-container">
                        <div class="progress-bar-wrapper">
                          <div 
                            class="progress-bar-fill"
                            :class="getUtilizationBarClass(row.utilizationRate)"
                            :style="{ width: `${Math.min(row.utilizationRate, 100)}%` }"
                          ></div>
                        </div>
                        <span class="percent-text" :class="getUtilizationTextClass(row.utilizationRate)">
                          {{ row.utilizationRate.toFixed(1) }}%
                        </span>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <div class="legend-container">
            <div class="legend-left">
              <span class="legend-icon">🎨</span>
              <span class="legend-item">
                <span class="legend-dot green"></span> Healthy (&lt;70%)
              </span>
              <span class="legend-item">
                <span class="legend-dot yellow"></span> Moderate (70-85%)
              </span>
              <span class="legend-item">
                <span class="legend-dot red"></span> Critical (&gt;85%)
              </span>
            </div>
            <div class="legend-right">
              <span class="edit-note">✏️ Click on allocated or utilized cells to edit</span>
            </div>
          </div>
        </div>
      </main>

    <div v-if="showConfirmModal" class="modal-overlay">
      <div class="modal-container">
        <h3 class="modal-title">Confirm Budget Adjustment</h3>
        <p class="modal-message">
          You are about to update <span class="modal-highlight">{{ getFieldLabel(pendingUpdate.field) }}</span> for 
          <span class="modal-unit">{{ getUnitName(pendingUpdate.rowId) }}</span> to 
          <span class="modal-amount">₱{{ formatNum(pendingUpdate.value) }}</span>.
          This will automatically recalculate remaining budget and utilization rate.
        </p>
        
        <div class="modal-actions">
          <button @click="cancelModalAction" class="modal-btn modal-btn-cancel">
            Cancel
          </button>
          <button @click="confirmModalAction" class="modal-btn modal-btn-confirm">
            Commit Update
          </button>
        </div>
      </div>
    </div>
</template>

<script setup>
import { ref, computed, nextTick, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import api from '../../api';

const router = useRouter();
const user = ref(JSON.parse(localStorage.getItem('user') || '{}'));

const budgetRows = ref([]);
const editingRowId = ref(null);
const editingFieldName = ref(null);
const activeEditValue = ref(0);
const showConfirmModal = ref(false);
const pendingUpdate = ref({ rowId: null, field: null, value: 0 });
const inputRefs = {};

const totalAllocatedBudget = computed(() => {
  return budgetRows.value.reduce((sum, row) => sum + (row.allocated || 0), 0);
});

const totalUtilizedAmount = computed(() => {
  return budgetRows.value.reduce((sum, row) => sum + (row.utilized || 0), 0);
});

const totalRemainingBudget = computed(() => {
  return budgetRows.value.reduce((sum, row) => sum + (row.remaining || 0), 0);
});

const overallUtilizationRate = computed(() => {
  if (totalAllocatedBudget.value === 0) return 0;
  return ((totalUtilizedAmount.value / totalAllocatedBudget.value) * 100).toFixed(1);
});

const formatNum = (val) => {
  if (val === undefined || val === null) return '0.00';
  return Number(val).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
};

const calculateRemaining = (allocated, utilized) => {
  return Math.max(0, (allocated || 0) - (utilized || 0));
};

const calculateUtilizationRate = (allocated, utilized) => {
  if (!allocated || allocated === 0) return 0;
  return Math.min(100, (utilized / allocated) * 100);
};

const updateRowCalculations = (row) => {
  row.remaining = calculateRemaining(row.allocated, row.utilized);
  row.utilizationRate = calculateUtilizationRate(row.allocated, row.utilized);
};

const getRemainingClass = (remaining) => {
  if (remaining <= 0) return 'remaining-critical';
  if (remaining < 10000) return 'remaining-warning';
  return 'remaining-healthy';
};

const getUtilizationBarClass = (rate) => {
  if (rate >= 85) return 'bar-critical';
  if (rate >= 70) return 'bar-warning';
  return 'bar-healthy';
};

const getUtilizationTextClass = (rate) => {
  if (rate >= 85) return 'text-critical';
  if (rate >= 70) return 'text-warning';
  return 'text-healthy';
};

const getFieldLabel = (field) => {
  return field === 'allocated' ? 'Total Allocated Budget' : 'Utilized Amount';
};

const getUnitName = (rowId) => {
  const row = budgetRows.value.find(r => r.id === rowId);
  return row ? row.unit_name : 'Unknown Unit';
};

const setCellInputRef = (el, id, field) => {
  if (el) inputRefs[`${id}_${field}`] = el;
};

const isEditing = (id, field) => editingRowId.value === id && editingFieldName.value === field;

const startEditingCell = (id, field, currentVal) => {
  editingRowId.value = id;
  editingFieldName.value = field;
  activeEditValue.value = currentVal || 0;
  nextTick(() => {
    const el = inputRefs[`${id}_${field}`];
    if (el) el.focus();
  });
};

const saveCellAdjustment = (id, field) => {
  if (activeEditValue.value < 0) activeEditValue.value = 0;
  
  pendingUpdate.value = { rowId: id, field, value: activeEditValue.value };
  showConfirmModal.value = true;
  editingRowId.value = null;
  editingFieldName.value = null;
};

const cancelCellAdjustment = () => {
  editingRowId.value = null;
  editingFieldName.value = null;
};

const confirmModalAction = async () => {
  showConfirmModal.value = false;
  const target = budgetRows.value.find(r => r.id === pendingUpdate.value.rowId);
  
  if (target) {
    const oldValue = target[pendingUpdate.value.field];
    target[pendingUpdate.value.field] = pendingUpdate.value.value;
    
    updateRowCalculations(target);
    
    try {
      // TODO: Connect to actual API endpoint
      // await api.post('staff/budget-monitoring/update', {
      //   id: pendingUpdate.value.rowId,
      //   field: pendingUpdate.value.field,
      //   old_value: oldValue,
      //   new_value: pendingUpdate.value.value
      // });
      console.log('Budget update prepared:', {
        id: pendingUpdate.value.rowId,
        field: pendingUpdate.value.field,
        old_value: oldValue,
        new_value: pendingUpdate.value.value
      });
    } catch (err) { 
      console.error('Error saving budget update:', err); 
    }
  }
};

const cancelModalAction = () => { 
  showConfirmModal.value = false; 
};

const fetchBudgetData = async () => {
  try {
    // TODO: Connect to actual API endpoint
    // const response = await api.get('staff/budget-monitoring');
    // budgetRows.value = response.data;
    // 
    // Ensure calculations are correct for each row
    // budgetRows.value.forEach(row => {
    //   updateRowCalculations(row);
    // });
    
    // Keep empty for now - will be populated when database is connected
    budgetRows.value = [];
    
  } catch (err) { 
    console.error('Error fetching budget data:', err); 
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
    fetchBudgetData(); 
  }
});
</script>

<style scoped>
.budget-utilization {
  min-height: 100vh;
  display: flex;
  color: #cbd5e1;
  font-family: system-ui, -apple-system, sans-serif;
}

.budget-utilization ::selection {
  background: rgba(153, 13, 209, 0.3);
  color: white;
}

.main-container {
  flex-grow: 1;
  margin-left: 256px;
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.main-content {
  padding-left: 0;
  flex-grow: 1;
}

.content-wrapper {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.page-header {
  padding: 0 0.25rem;
  margin-bottom: 0;
}

.header-main-flex {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.allocation-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.625rem 1.25rem;
  border-radius: 0.75rem;
  background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%);
  color: white;
  font-size: 1rem;
  font-weight: 700;
  border: none;
  cursor: pointer;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.15);
  transition: all 0.2s ease;
}

.allocation-btn:hover {
  opacity: 0.9;
  transform: translateY(-1px);
}

.btn-icon {
  font-size: 1.125rem !important;
}

.page-title {
  font-size: 1.5rem;
  font-weight: 900;
  letter-spacing: -0.025em;
  color: #16213e;
  margin: 0 0 0.5rem 0;
}

.page-subtitle {
  font-size: 1rem;
  color: #475569;
  margin: 0;
  line-height: 1.4;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1rem;
}

.stat-card {
  padding: 1.25rem;
  border-radius: 1rem;
  border: 1px solid rgba(185, 121, 204, 0.15);
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
  backdrop-filter: blur(8px);
  transition: all 0.3s;
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);

}

.stat-card:hover {
  transform: translateY(-2px);
  border-color: rgba(185, 121, 204, 0.3);
}

.stat-icon-wrapper {
  width: 40px;
  height: 40px;
  border-radius: 0.75rem;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  margin-bottom: 0.75rem;
}

.stat-icon-wrapper.blue {
  background: rgba(59, 130, 246, 0.1);
}

.stat-icon-wrapper.blue .material-symbols-outlined {
  color: #60a5fa;
}

.stat-icon-wrapper.green {
  background: rgba(34, 197, 94, 0.1);
}

.stat-icon-wrapper.green .material-symbols-outlined {
  color: #4ade80;
}

.stat-icon-wrapper.amber {
  background: rgba(245, 158, 11, 0.1);
}

.stat-icon-wrapper.amber .material-symbols-outlined {
  color: #fbbf24;
}

.stat-icon-wrapper.purple {
  background: rgba(153, 13, 209, 0.1);
}

.stat-icon-wrapper.purple .material-symbols-outlined {
  color: #b979cc;
}

.material-symbols-outlined {
  font-size: 1.5rem;
}

.stat-content {
  min-width: 0;
}

.stat-value {
  font-size: 1.25rem;
  font-weight: 900;
  letter-spacing: -0.025em;
  color: white;
  line-height: 1.25;
  margin: 0;
}

.stat-label {
  font-size: 0.85rem;
  font-weight: 800;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: rgba(203, 213, 225, 0.7);
  margin-top: 0.25rem;
}

.table-container {
  border-radius: 1rem;
  border: 1px solid rgba(185, 121, 204, 0.15);
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.25);
  overflow: hidden;
  backdrop-filter: blur(8px);
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
}

.table-wrapper {
  overflow-x: auto;
}

.data-table {
  width: 100%;
  text-align: left;
  border-collapse: collapse;
  min-width: 900px;
}

.col-number { width: 60px; text-align: center; }
.col-unit { width: 250px; }
.col-allocated { width: 160px; text-align: center; }
.col-utilized { width: 160px; text-align: center; }
.col-remaining { width: 160px; text-align: center; }
.col-percent { width: 180px; text-align: center; }

.table-header-row {
  border-bottom: 1px solid rgba(185, 121, 204, 0.1);
  background: rgba(0, 0, 0, 0.4);
}

.table-header-cell {
  padding: 1rem 1rem;
  font-size: 0.85rem;
  font-weight: 900;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: #b979cc;
  text-align: center;
}

.text-left {
  text-align: left;
}

.table-body {
  display: table-row-group;
  background: #cbd5e1;
}

.empty-state {
  padding: 3rem 1.5rem;
  text-align: center;
  font-size: 1rem;
  color: #94a3b8;
  font-weight: 500;
}

.table-row {
  transition: all 0.3s;
  border-bottom: 1px solid rgba(185, 121, 204, 0.05);
}

.table-row:hover {
  background: rgba(255, 255, 255, 0.05);
}

.table-cell {
  padding: 0.875rem 1rem;
  vertical-align: middle;
}

.cell-number {
  text-align: center;
  font-weight: 700;
  color: #cbd5e1;
}

.cell-unit {
  text-align: left;
}

.unit-name {
  font-weight: 700;
  color: #e2e8f0;
}

.unit-code {
  font-size: 0.85rem;
  color: #b979cc;
  letter-spacing: 0.025em;
  text-transform: uppercase;
  margin-top: 0.125rem;
  font-family: monospace;
}

.editable-cell {
  cursor: pointer;
  position: relative;
  transition: all 0.2s;
  text-align: center;
}

.editable-cell:hover {
  background: rgba(0, 0, 0, 0.4);
}

.cell-value {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  color: #cbd5e1;
  position: relative;
}

.edit-icon {
  position: absolute;
  right: 4px;
  font-size: 0.8rem;
  color: rgba(185, 121, 204, 0.4);
  opacity: 0;
  transition: opacity 0.2s;
}

.editable-cell:hover .edit-icon {
  opacity: 1;
}

.edit-input-wrapper {
  position: absolute;
  inset: 4px;
  z-index: 10;
}

.edit-input {
  width: 100%;
  height: 100%;
  text-align: center;
  background: #1a1a2e;
  border-radius: 0.5rem;
  border: 1px solid #b979cc;
  color: white;
  font-size: 1rem;
  font-family: monospace;
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.3);
  padding: 0.25rem;
}

.edit-input:focus {
  outline: none;
  ring: 1px solid #b979cc;
}

/* Remaining Budget Colors */
.remaining-healthy {
  color: #4ade80;
  font-weight: 700;
  text-align: center;
}

.remaining-warning {
  color: #fbbf24;
  font-weight: 700;
  text-align: center;
}

.remaining-critical {
  color: #f87171;
  font-weight: 700;
  text-align: center;
}

/* Progress Bar */
.progress-container {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.progress-bar-wrapper {
  flex: 1;
  height: 0.375rem;
  background: #334155;
  border-radius: 9999px;
  overflow: hidden;
}

.progress-bar-fill {
  height: 100%;
  border-radius: 9999px;
  transition: width 0.3s;
}

.bar-healthy {
  background: #4ade80;
}

.bar-warning {
  background: #fbbf24;
}

.bar-critical {
  background: #f87171;
}

.percent-text {
  font-weight: 700;
  font-size: 1rem;
  min-width: 45px;
  text-align: right;
}

.text-healthy {
  color: #4ade80;
}

.text-warning {
  color: #fbbf24;
}

.text-critical {
  color: #f87171;
}

/* Legend */
.legend-container {
  font-size: 0.85rem;
  color: #94a3b8;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 0.5rem;
}

.legend-left {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.legend-icon {
  margin-right: 0.25rem;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 0.25rem;
}

.legend-dot {
  display: inline-block;
  width: 0.75rem;
  height: 0.75rem;
  border-radius: 9999px;
}

.legend-dot.green {
  background: rgba(74, 222, 128, 0.4);
}

.legend-dot.yellow {
  background: rgba(251, 191, 36, 0.4);
}

.legend-dot.red {
  background: rgba(248, 113, 113, 0.4);
}

.legend-right {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.edit-note {
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
}

/* Modal */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.7);
  backdrop-filter: blur(8px);
  z-index: 50;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1rem;
}

.modal-container {
  border-radius: 1rem;
  border: 1px solid rgba(185, 121, 204, 0.2);
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.25);
  padding: 1.5rem;
  width: 100%;
  max-width: 28rem;
  backdrop-filter: blur(24px);
  background: rgba(26, 26, 46, 0.95);
  animation: fadeIn 0.2s ease-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: scale(0.95);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

.modal-title {
  font-size: 1rem;
  font-weight: 900;
  letter-spacing: -0.025em;
  color: white;
  margin-bottom: 0.5rem;
}

.modal-message {
  font-size: 1rem;
  color: #94a3b8;
  line-height: 1.5;
  margin-bottom: 1.25rem;
}

.modal-highlight {
  font-weight: 700;
  color: white;
}

.modal-unit {
  font-weight: 700;
  color: #b979cc;
}

.modal-amount {
  font-family: monospace;
  font-weight: 700;
  color: white;
  background: rgba(255, 255, 255, 0.1);
  padding: 0.125rem 0.375rem;
  border-radius: 0.25rem;
}

.modal-actions {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 0.625rem;
}

.modal-btn {
  padding: 0.5rem 1rem;
  border-radius: 0.75rem;
  font-size: 1rem;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s;
  border: none;
}

.modal-btn-cancel {
  color: #94a3b8;
  background: transparent;
}

.modal-btn-cancel:hover {
  color: white;
  background: rgba(255, 255, 255, 0.05);
}

.modal-btn-confirm {
  background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%);
  color: white;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.modal-btn-confirm:hover {
  opacity: 0.9;
}

/* Scrollbar */
::-webkit-scrollbar {
  width: 6px;
  height: 6px;
}

::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.1);
}

::-webkit-scrollbar-thumb {
  background: rgba(185, 121, 204, 0.3);
  border-radius: 99px;
}

::-webkit-scrollbar-thumb:hover {
  background: rgba(153, 13, 209, 0.5);
}

/* Responsive */
@media (max-width: 1024px) {
  .main-container {
    margin-left: 0;
  }
  
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .legend-container {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.5rem;
  }
}

@media (max-width: 768px) {
  .content-wrapper {
    padding: 20px;
  }
  
  .stats-grid {
    grid-template-columns: 1fr;
  }
  
  .header-main-flex {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }
  
  .allocation-btn {
    width: 100%;
    justify-content: center;
  }
}
</style>