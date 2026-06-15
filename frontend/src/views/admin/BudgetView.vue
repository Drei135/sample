<template>
  <div class="budget-view-container">
    
    <div class="welcome-card">
      <h1 class="welcome-title">Budget Utilization Monitoring</h1>
      <p class="welcome-subtitle">
        Track budget allocation, utilization, remaining balances, and percentage execution across all GAD units and tracked office mandates.
      </p>
    </div>

    <section class="stats-section">
      <div class="stat-card">
        <div class="stat-card-inner">
          <div class="stat-icon bg-purple">
            <span class="material-symbols-outlined text-purple">account_balance</span>
          </div>
          <div class="stat-info">
            <h3 class="stat-value">{{ totalBudget }}</h3>
            <p class="stat-label">Total GAD Budget</p>
          </div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-card-inner">
          <div class="stat-icon bg-emerald">
            <span class="material-symbols-outlined text-emerald">trending_up</span>
          </div>
          <div class="stat-info">
            <h3 class="stat-value">{{ totalUtilized }}</h3>
            <p class="stat-label">Total Utilized Amount</p>
          </div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-card-inner">
          <div class="stat-icon bg-pink">
            <span class="material-symbols-outlined text-pink">account_balance_wallet</span>
          </div>
          <div class="stat-info">
            <h3 class="stat-value">{{ remainingBalance }}</h3>
            <p class="stat-label">Remaining Balance</p>
          </div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-card-inner">
          <div class="stat-icon bg-blue">
            <span class="material-symbols-outlined text-blue">percent</span>
          </div>
          <div class="stat-info">
            <h3 class="stat-value">{{ utilizationRate }}</h3>
            <p class="stat-label">Utilization Rate</p>
          </div>
        </div>
      </div>
    </section>

    <section class="dashboard-grid">
      
      <div class="grid-main">
        <div class="mandates-section">
          <div class="section-header">
            <span class="title-indicator"></span>
            <h4 class="section-title">GAD Core Office Mandate Allocation</h4>
          </div>

          <div class="table-container">
            <div class="table-wrapper">
              <table class="data-table">
                <thead>
                  <tr class="table-header-row">
                    <th class="table-header-cell">Mandate Program Title</th>
                    <th class="table-header-cell">Utilized</th>
                    <th class="table-header-cell">Total Allocated</th>
                    <th class="table-header-cell text-right">Execution Rate</th>
                  </tr>
                </thead>
                <tbody class="table-body">
                  <tr v-if="mandates.length === 0">
                    <td colspan="4" class="empty-state-cell">
                      No active core office mandate allocations found.
                    </td>
                  </tr>
                  <tr v-else v-for="item in mandates" :key="item.id" class="table-row">
                    <td class="mandate-title-cell">
                      <div class="title-wrapper">
                        <span class="title-main">{{ item.title }}</span>
                        <span class="title-desc">{{ item.desc }}</span>
                      </div>
                    </td>
                    <td class="numeric-cell text-emerald">{{ item.utilized }}</td>
                    <td class="numeric-cell text-slate">{{ item.total }}</td>
                    <td class="badge-cell text-right">
                      <span class="rate-badge">{{ item.percent }}</span>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            
            <div class="table-footer">
              <p class="footer-text">Tracking {{ mandates.length }} active internal GAD tracking units</p>
            </div>
          </div>
        </div>
      </div>

      <div class="grid-sidebar">
        <div class="summary-card">
          <div class="sidebar-header">
            <h4 class="sidebar-title">Budget Framework Logs</h4>
          </div>
          
          <div class="budget-status-box">
            <p class="status-box-title">Budget Status Context</p>
            <h3 class="status-box-value">{{ currentFrameworkStatus }}</h3>
            <p class="status-box-text">{{ statusDescription }}</p>
          </div>

          <div class="info-alert-box">
            <div class="alert-dot"></div>
            <p class="alert-text">{{ systemNoticeText }}</p>
          </div>
        </div>
      </div>

    </section>
  </div>
</template>

<script setup>
import { ref } from 'vue';

// Metric Aggregates (Staged to bind directly to database totals later)
const totalBudget = ref('₱0');
const totalUtilized = ref('₱0');
const remainingBalance = ref('₱0');
const utilizationRate = ref('0.00%');

// Primary Data Matrix Table Array
const mandates = ref([]);

// Sidebar Dynamic Context Parameters
const currentFrameworkStatus = ref('');
const statusDescription = ref('');
const systemNoticeText = ref('');
</script>

<style scoped>
/* Main Parent Container */
.budget-view-container {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 2rem;
  background: transparent;
  box-sizing: border-box;
}

/* Welcome Header Card Component (Static White Theme) */
.welcome-card {
  background: #ffffff;
  padding: 2rem;
  border-radius: 1rem;
  border: 1px solid #f1f5f9;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.welcome-title {
  font-size: 1.875rem;
  font-weight: 800;
  color: #0f172a;
  margin: 0;
}

.welcome-subtitle {
  font-size: 1.1rem;
  color: #475569;
  margin-top: 0.5rem;
  line-height: 1.5;
}

/* Master Stats Grid Setup */
.stats-section {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1.5rem;
}

/* Dark Slate Container Standards used by metrics and content panels */
.stat-card,
.mandates-section,
.summary-card {
  border-radius: 1rem;
  border: 1px solid rgba(185, 121, 204, 0.15);
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
}

.stat-card {
  padding: 1.25rem 1rem;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.stat-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.3);
}

.stat-card-inner {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

/* Metric Icon Circle System */
.stat-icon {
  width: 40px;
  height: 40px;
  border-radius: 0.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

/* Dynamic Status Token Palette */
.text-purple { color: #c084fc; }
.text-blue { color: #60a5fa; }
.text-emerald { color: #34d399; }
.text-pink { color: #f472b6; }

.bg-purple { background: rgba(168, 85, 247, 0.1); }
.bg-blue { background: rgba(59, 130, 246, 0.1); }
.bg-emerald { background: rgba(16, 185, 129, 0.1); }
.bg-pink { background: rgba(244, 114, 182, 0.1); }

.stat-info {
  min-width: 0;
}

.stat-value {
  font-size: 1.25rem;
  font-weight: 900;
  color: #ffffff;
  margin: 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.stat-label {
  font-size: 0.85rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #94a3b8;
  margin-top: 0.125rem;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* Main Panel Display Structural Grid */
.dashboard-grid {
  display: grid;
  grid-template-columns: 7fr 3fr;
  gap: 2rem;
  align-items: start;
}

.grid-main,
.grid-sidebar {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

/* Headers Inside Panels */
.section-header,
.sidebar-header {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 1.25rem;
}

.title-indicator {
  width: 0.375rem;
  height: 1rem;
  background: linear-gradient(to bottom, #9333ea, #c084fc);
  border-radius: 9999px;
}

.section-title,
.sidebar-title {
  font-weight: 700;
  color: #ffffff;
  font-size: 1.125rem;
  margin: 0;
}

/* Container Padding Configuration overrides */
.mandates-section {
  padding: 1.5rem;
}

.summary-card {
  padding: 1.25rem;
}

/* Embedded Table Component Structure */
.table-container {
  border: 1px solid rgba(185, 121, 204, 0.1);
  border-radius: 0.75rem;
  overflow: hidden;
  background: transparent;
}

.table-wrapper {
  overflow-x: auto;
}

.data-table {
  width: 100%;
  text-align: left;
  border-collapse: collapse;
}

.table-header-row {
  background: rgba(255, 255, 255, 0.02);
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}

.table-header-cell {
  padding: 1rem;
  font-size: 0.85rem;
  font-weight: 700;
  color: #b979cc;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.empty-state-cell {
  padding: 3rem;
  text-align: center;
  font-size: 0.8125rem;
  color: #94a3b8;
  font-weight: 500;
}

.table-row {
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
  transition: all 0.2s ease;
}

.table-row:hover {
  background: rgba(255, 255, 255, 0.03);
}

.mandate-title-cell {
  padding: 1rem;
}

.title-wrapper {
  display: flex;
  flex-direction: column;
  gap: 0.125rem;
}

.title-main {
  font-size: 1.1rem;
  font-weight: 700;
  color: #f1f5f9;
}

.title-desc {
  font-size: 1rem;
  color: #94a3b8;
  line-height: 1.3;
}

.numeric-cell {
  padding: 1rem;
  font-size: 1.1rem;
  font-weight: 600;
  font-family: monospace;
}

.text-emerald { color: #34d399; }
.text-slate { color: #94a3b8; }

.badge-cell {
  padding: 1rem;
  vertical-align: middle;
}

/* Translucent Highlighting Tags */
.rate-badge {
  font-size: 0.9rem;
  font-weight: 700;
  font-family: monospace;
  padding: 0.25rem 0.5rem;
  border-radius: 0.375rem;
  background: rgba(153, 13, 209, 0.2);
  color: #d8b4fe;
  border: 1px solid rgba(153, 13, 209, 0.3);
  display: inline-block;
}

.table-footer {
  padding: 1rem;
  background: rgba(0, 0, 0, 0.1);
  border-top: 1px solid rgba(255, 255, 255, 0.05);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.footer-text {
  font-size: 1rem;
  color: #94a3b8;
  font-weight: 500;
  margin: 0;
}

/* Sidebar Information Blocks */
.budget-status-box {
  padding: 1rem;
  border-radius: 0.75rem;
  background: rgba(0, 0, 0, 0.15);
  border: 1px solid rgba(255, 255, 255, 0.05);
  margin-bottom: 1rem;
}

.status-box-title {
  font-size: 0.8rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #94a3b8;
  margin: 0;
}

.status-box-value {
  font-size: 1.125rem;
  font-weight: 800;
  color: #c084fc;
  margin: 0.25rem 0 0 0;
}

.status-box-text {
  font-size: 1rem;
  color: #cbd5e1;
  margin: 0.5rem 0 0 0;
  line-height: 1.4;
}

.info-alert-box {
  display: flex;
  gap: 0.5rem;
  padding: 0.75rem 1rem;
  border-radius: 0.75rem;
  background: rgba(251, 191, 36, 0.05);
  border: 1px solid rgba(251, 191, 36, 0.15);
}

.alert-dot {
  width: 6px;
  height: 6px;
  background: #fbbf24;
  border-radius: 50%;
  margin-top: 4px;
  flex-shrink: 0;
}

.alert-text {
  font-size: 0.7125rem;
  color: #fbbf24;
  line-height: 1.4;
  margin: 0;
}

.text-right { text-align: right; }

@media (max-width: 1024px) {
  .stats-section {
    grid-template-columns: repeat(2, 1fr);
  }
  .dashboard-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 640px) {
  .stats-section {
    grid-template-columns: 1fr;
  }
}
</style>