<template>
      <main class="main-content">
        <div class="content-wrapper">
          <div class="two-column-grid">
            <div class="left-column">

              <div class="page-header">
                <h1 class="page-title">Execute Budget Allocation Adjustment</h1>
                <p class="page-subtitle">Reallocate pending program capitals, record transaction logs, and manage structural operational realignments.</p>
              </div>

              <div class="form-card">
                
                <div class="form-group">
                  <label class="form-label">Target Mandate / Program Framework</label>
                  <div class="select-wrapper">
                    <select 
                      v-model="realignmentForm.mandate_id" 
                      @change="handleMandateSelection"
                      class="form-select"
                    >
                      <option value="" disabled selected>Select an institutional target mandate code...</option>
                      <option v-for="m in mandateOptions" :key="m.id" :value="m.id">
                        [{{ m.control_no }}] {{ m.title }} — (Remaining: ₱{{ formatCurrency(m.current_balance) }})
                      </option>
                    </select>
                    <span class="select-arrow">▼</span>
                  </div>
                </div>

                <div class="two-col-form">
                  <div class="form-group">
                    <label class="form-label">Adjustment Classification Type</label>
                    <div class="select-wrapper">
                      <select 
                        v-model="realignmentForm.type" 
                        class="form-select"
                      >
                        <option value="augmentation">Augmentation (Increase Budget)</option>
                        <option value="realignment">Realignment (Transfer / Deduct Capital)</option>
                      </select>
                      <span class="select-arrow">▼</span>
                    </div>
                  </div>

                  <div class="form-group">
                    <label class="form-label">Adjustment Capital Amount (₱)</label>
                    <div class="input-with-prefix">
                      <span class="input-prefix">₱</span>
                      <input 
                        v-model.number="realignmentForm.amount"
                        type="number" 
                        step="0.01" 
                        placeholder="0.00"
                        class="form-input"
                      />
                    </div>
                  </div>
                </div>

                <div class="form-group">
                  <label class="form-label">Justification Log Narrative / Scope Remarks</label>
                  <textarea 
                    v-model="realignmentForm.justification"
                    rows="4" 
                    placeholder="Enter full legal routing description, board resolution index codes, or core justification rationale frameworks for this financial adjustment..."
                    class="form-textarea"
                  ></textarea>
                </div>

                <div class="form-actions">
                  <button 
                    type="button"
                    @click="resetFormStructure"
                    class="btn-clear"
                  >
                    Clear Form
                  </button>
                  <button 
                    type="button"
                    @click="submitRealignmentPipeline"
                    class="btn-submit"
                  >
                    Commit Adjustment Pipeline
                  </button>
                </div>

              </div>
            </div>

            <aside class="right-column">
              <div class="summary-card">
                <h3 class="summary-title">
                  <span>📊</span> Financial Summary Index
                </h3>
                
                <div class="summary-stats">
                  <div class="summary-stat">
                    <p class="summary-stat-label">Total Combined GAD Allocation</p>
                    <p class="summary-stat-value">₱{{ formatCurrency(financialMeta.totalBudget) }}</p>
                  </div>
                  <div class="summary-stat">
                    <p class="summary-stat-label">Total Utilized Outlays</p>
                    <p class="summary-stat-value purple">₱{{ formatCurrency(financialMeta.totalUtilized) }}</p>
                  </div>
                </div>

                <div class="summary-footer">
                  <span>Global Liquidity Util:</span>
                  <span class="summary-footer-value">{{ financialMeta.utilizationRate }}%</span>
                </div>
              </div>

              <div class="reserves-card">
                <div class="reserves-header">
                  <span class="reserves-label">Available GAD Reserves</span>
                </div>
                <p class="reserves-value">₱{{ formatCurrency(financialMeta.totalBudget - financialMeta.totalUtilized) }}</p>
                <p class="reserves-note">Net pool values remaining inside active institutional tracking records accounts registers ready for deployment pipeline tasks.</p>
              </div>
            </aside>

          </div>

          <section class="logs-section">
            <div class="logs-header">
              <h3 class="logs-title">
                <span>⏱️</span> Recent Modification Action Logs Registry
              </h3>
            </div>

            <div class="logs-table-container">
              <div class="table-wrapper">
                <table class="logs-table">
                  <thead>
                    <tr class="logs-table-header">
                      <th class="logs-th">Log ID / Ref</th>
                      <th class="logs-th">Target Mandate Framework</th>
                      <th class="logs-th">Action Class</th>
                      <th class="logs-th text-right">Adjustment Amount</th>
                      <th class="logs-th">Justification Summary Description</th>
                      <th class="logs-th text-right">Timestamp Entry</th>
                    </tr>
                  </thead>
                  <tbody class="logs-table-body">
                    <tr v-if="historyLogs.length === 0">
                      <td colspan="6" class="logs-empty">
                        No financial modification or allocation realignment history logs recorded inside current database indexes.
                       </td>
                    </tr>
                    <tr v-else v-for="log in historyLogs" :key="log.id" class="logs-table-row">
                      <td class="logs-cell logs-ref">#{{ log.reference_no }}</td>
                      <td class="logs-cell logs-mandate">{{ log.mandate_title }}</td>
                      <td class="logs-cell">
                        <span 
                          class="logs-badge"
                          :class="log.type === 'augmentation' ? 'logs-badge-green' : 'logs-badge-red'"
                        >
                          {{ log.type }}
                        </span>
                      </td>
                      <td class="logs-cell logs-amount text-right" :class="log.type === 'augmentation' ? 'text-green' : 'text-red'">
                        {{ log.type === 'augmentation' ? '+' : '-' }}₱{{ formatCurrency(log.amount) }}
                      </td>
                      <td class="logs-cell logs-justification">{{ log.justification }}</td>
                      <td class="logs-cell logs-date text-right">{{ log.created_at }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </section>

        </div>
      </main>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import api from '../../api';

const router = useRouter();
const user = ref(JSON.parse(localStorage.getItem('user') || '{}'));

const realignmentForm = ref({
  mandate_id: '',
  type: 'augmentation',
  amount: null,
  justification: ''
});

const mandateOptions = ref([]);
const historyLogs = ref([]);
const financialMeta = ref({
  totalBudget: 0,
  totalUtilized: 0,
  utilizationRate: 0
});

const formatCurrency = (val) => {
  return Number(val).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
};

const handleMandateSelection = () => {
  console.log(`Evaluating current available pipeline metrics against mandate context entity ID: ${realignmentForm.value.mandate_id}`);
};

const resetFormStructure = () => {
  realignmentForm.value = {
    mandate_id: '',
    type: 'augmentation',
    amount: null,
    justification: ''
  };
};

const submitRealignmentPipeline = async () => {
  if (!realignmentForm.value.mandate_id || !realignmentForm.value.amount || !realignmentForm.value.justification) {
    alert("Please completely satisfy all data parameter form input elements before processing transaction vectors.");
    return;
  }
  
  try {
    // API endpoint database commit routing pipeline placeholder:
    // await api.post('staff/budget/realign', realignmentForm.value);
    alert("Financial reallocation command committed successfully inside registry buffers.");
    resetFormStructure();
    fetchInitialBudgetDataPipeline();
  } catch (err) {
    console.error(err);
  }
};

const fetchInitialBudgetDataPipeline = async () => {
  try {
    // Pipeline connection route mappings placeholders layouts triggers:
    // const mandatesRes = await api.get('staff/budget/available-mandates');
    // mandateOptions.value = mandatesRes.data;
    // const logsRes = await api.get('staff/budget/realignment-logs');
    // historyLogs.value = logsRes.data;
    // const metaRes = await api.get('staff/budget/financial-meta');
    // financialMeta.value = metaRes.data;
  } catch (err) {
    console.error(err);
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
    fetchInitialBudgetDataPipeline();
  }
});
</script>

<style scoped>
.budget-realignment {
  min-height: 100vh;
  display: flex;
  color: #cbd5e1;
  font-family: system-ui, -apple-system, sans-serif;
}

.budget-realignment ::selection {
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

.app-header {
  position: fixed;
  top: 0;
  left: 256px;
  right: 0;
  height: 80px;
  background: rgba(26, 26, 46, 0.4);
  backdrop-filter: blur(24px);
  z-index: 40;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 40px;
  border-bottom: 1px solid rgba(185, 121, 204, 0.1);
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
}

.header-title {
  font-size: 1.5rem;
  font-weight: 900;
  letter-spacing: -0.025em;
  background: linear-gradient(135deg, white, #cbd5e1, #b979cc);
  background-clip: text;
  -webkit-background-clip: text;
  color: transparent;
}

.header-subtitle-wrapper {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-top: 0.125rem;
}

.header-subtitle {
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: #b979cc;
  font-weight: 800;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.icon-btn-wrapper {
  position: relative;
}

.icon-btn {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 0.75rem;
  background: rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(185, 121, 204, 0.2);
  font-size: 1.125rem;
  cursor: pointer;
  transition: all 0.3s;
}

.icon-btn:hover {
  border-color: rgba(185, 121, 204, 0.5);
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

.two-column-grid {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 1.5rem;
  align-items: start;
}

.left-column {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.right-column {
  margin-top: 0;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.page-header {
  padding: 0 0.25rem;
}

.page-title {
  font-size: 1.5rem;
  font-weight: 900;
  letter-spacing: -0.025em;
  color: #16213e;
}

.page-subtitle {
  font-size: 1rem;
  color: #475569;
  margin-top: 0.25rem;
}

.form-card {
  border-radius: 1rem;
  border: 1px solid rgba(185, 121, 204, 0.15);
  padding: 1.5rem;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.25);
  backdrop-filter: blur(8px);
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);

}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-label {
  display: block;
  font-size: 0.9rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  font-weight: 800;
  color: rgba(203, 213, 225, 0.9);
}

.select-wrapper {
  position: relative;
}

.form-select {
  width: 100%;
  padding: 0.75rem 1rem;
  border-radius: 0.75rem;
  background: rgba(0, 0, 0, 0.4);
  border: 1px solid rgba(185, 121, 204, 0.2);
  font-size: 1rem;
  font-weight: 600;
  color: white;
  appearance: none;
  cursor: pointer;
  transition: all 0.3s;
}

.form-select:focus {
  outline: none;
  border-color: rgba(185, 121, 204, 0.5);
}

.select-arrow {
  position: absolute;
  right: 1rem;
  top: 50%;
  transform: translateY(-50%);
  color: #94a3b8;
  font-size: 1rem;
  pointer-events: none;
}

.two-col-form {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.input-with-prefix {
  position: relative;
}

.input-prefix {
  position: absolute;
  left: 1rem;
  top: 50%;
  transform: translateY(-50%);
  font-family: monospace;
  font-size: 1rem;
  color: #b979cc;
  font-weight: 900;
}

.form-input {
  width: 100%;
  padding: 0.75rem 1rem 0.75rem 2rem;
  border-radius: 0.75rem;
  background: rgba(0, 0, 0, 0.4);
  border: 1px solid rgba(185, 121, 204, 0.2);
  font-size: 1rem;
  font-family: monospace;
  color: white;
  transition: all 0.3s;
}

.form-input:focus {
  outline: none;
  border-color: rgba(185, 121, 204, 0.5);
}

.form-input::placeholder {
  color: #cbd5e1;
}

.form-textarea {
  width: 100%;
  padding: 0.75rem 1rem;
  border-radius: 0.75rem;
  background: rgba(0, 0, 0, 0.4);
  border: 1px solid rgba(185, 121, 204, 0.2);
  font-size: 1rem;
  font-weight: 600;
  color: white;
  resize: none;
  transition: all 0.3s;
}

.form-textarea:focus {
  outline: none;
  border-color: rgba(185, 121, 204, 0.5);
}

.form-textarea::placeholder {
  color: #cbd5e1;
}

.form-actions {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 0.75rem;
  padding-top: 0.5rem;
}

.btn-clear {
  padding: 0.625rem 1.25rem;
  border-radius: 0.75rem;
  font-size: 1rem;
  font-weight: 700;
  color: #94a3b8;
  background: transparent;
  border: none;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-clear:hover {
  color: white;
}

.btn-submit {
  padding: 0.625rem 1.5rem;
  border-radius: 0.75rem;
  font-size: 1rem;
  font-weight: 900;
  background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%);
  color: white;
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
  border: none;
  cursor: pointer;
  transition: opacity 0.2s;
}

.btn-submit:hover {
  opacity: 0.9;
}

.summary-card {
  padding: 1.25rem;
  border-radius: 1rem;
  border: 1px solid rgba(185, 121, 204, 0.15);
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
  backdrop-filter: blur(8px);
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
}

.summary-title {
  font-size: 1rem;
  font-weight: 900;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #94a3b8;
  margin-bottom: 1rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.summary-stats {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.summary-stat {
  padding: 0.875rem;
  border-radius: 0.75rem;
  background: rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.05);
}

.summary-stat-label {
  font-size: 0.85rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #94a3b8;
}

.summary-stat-value {
  font-size: 1.25rem;
  font-weight: 900;
  color: white;
  margin-top: 0.125rem;
}

.summary-stat-value.purple {
  color: #b979cc;
}

.summary-footer {
  margin-top: 1rem;
  padding-top: 0.875rem;
  border-top: 1px solid rgba(185, 121, 204, 0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.85rem;
  color: #94a3b8;
  font-family: monospace;
}

.summary-footer-value {
  color: white;
  font-weight: 700;
}

.reserves-card {
  border-radius: 1rem;
  padding: 1.25rem;
  border: 1px solid rgba(255, 255, 255, 0.1);
  position: relative;
  overflow: hidden;
  backdrop-filter: blur(8px);
  background: #cbd5e1;
}

.reserves-header {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.5rem;
}

.reserves-icon {
  font-size: 1.25rem;
}

.reserves-label {
  font-size: 1rem;
  font-weight: 900;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #16213e;
}

.reserves-value {
  font-size: 1.5rem;
  font-weight: 900;
  color: #16213e;
  letter-spacing: -0.025em;
}

.reserves-note {
  font-size: 0.9rem;
  color: #990dd1;
  font-weight: 500;
  margin-top: 0.25rem;
}

.logs-section {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.logs-header {
  padding: 0 0.25rem;
}

.logs-title {
  font-size: 1rem;
  font-weight: 900;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #16213e;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.logs-table-container {
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

.logs-table {
  width: 100%;
  text-align: left;
  border-collapse: collapse;
  font-size: 1rem;
}

.logs-table-header {
  border-bottom: 1px solid rgba(185, 121, 204, 0.1);
  background: rgba(0, 0, 0, 0.4);
}

.logs-th {
  padding: 0.875rem 1.25rem;
  font-size: 0.85rem;
  font-weight: 900;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #b979cc;
}

.text-right {
  text-align: right;
}

.logs-table-body {
  display: table-row-group;
}

.logs-empty {
  background: #cbd5e1;
  padding: 2rem 1.25rem;
  text-align: center;
  font-size: 1rem;
  color: #16213e;
  font-weight: 500;
}

.logs-table-row {
  transition: all 0.3s;
  border-bottom: 1px solid rgba(185, 121, 204, 0.05);
}

.logs-table-row:hover {
  background: rgba(255, 255, 255, 0.05);
}

.logs-cell {
  padding: 0.875rem 1.25rem;
  font-weight: 500;
  color: #cbd5e1;
}

.logs-ref {
  font-family: monospace;
  font-weight: 700;
  color: #b979cc;
}

.logs-mandate {
  font-weight: 600;
  color: #e2e8f0;
  max-width: 200px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.logs-amount {
  font-family: monospace;
  font-weight: 700;
}

.logs-justification {
  color: #94a3b8;
  font-size: 0.9rem;
  font-weight: 600;
  max-width: 250px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.logs-date {
  color: #94a3b8;
  font-family: monospace;
  font-size: 0.85rem;
}

.text-green {
  color: #4ade80;
}

.text-red {
  color: #f87171;
}

.logs-badge {
  padding: 0.125rem 0.5rem;
  border-radius: 0.375rem;
  font-size: 0.8rem;
  font-weight: 900;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.logs-badge-green {
  background: rgba(74, 222, 128, 0.2);
  color: #4ade80;
  border: 1px solid rgba(74, 222, 128, 0.3);
}

.logs-badge-red {
  background: rgba(248, 113, 113, 0.2);
  color: #f87171;
  border: 1px solid rgba(248, 113, 113, 0.3);
}

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

input[type="number"]::-webkit-inner-spin-button,
input[type="number"]::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

input[type="number"] {
  -moz-appearance: textfield;
}

@media (max-width: 1024px) {
  .main-container {
    margin-left: 0;
  }
  
  .app-header {
    left: 0;
  }
  
  .two-column-grid {
    grid-template-columns: 1fr;
  }
  
  .right-column {
    margin-top: 0;
  }
}

@media (max-width: 768px) {
  .content-wrapper {
    padding: 20px;
  }
  
  .two-col-form {
    grid-template-columns: 1fr;
  }
  
  .logs-table {
    min-width: 800px;
  }
}
</style>