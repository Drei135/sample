<template>
  <div class="staff-dashboard-content">
    
    <div class="bg-white p-8 rounded-2xl border border-slate-100 shadow-sm">
      <h1 class="text-3xl font-bold text-slate-900">Welcome, (Director) to your Dashboard!</h1>
      <p class="text-slate-500 mt-2">Manage your GAD programs, monitor activity designs, and oversee budget utilization from here.</p>
    </div>

    <section class="stats-section">
      <div v-for="stat in metricsStats" :key="stat.label" class="stat-card">
        <div class="stat-card-inner">
          <div :class="['stat-icon', stat.bgClass]">
            <span class="material-symbols-outlined stat-icon-symbol" :class="stat.iconColor">{{ stat.icon }}</span>
          </div>
          <div class="stat-info">
            <h3 class="stat-value">{{ stat.value }}</h3>
            <p class="stat-label">{{ stat.label }}</p>
          </div>
        </div>
      </div>
    </section>

    <section class="dashboard-grid">
      
      <div class="grid-main">
        
        <div class="pending-activities-section">
          <div class="section-header">
            <span class="title-indicator"></span>
            <h4 class="section-title">Recent Pending Activities</h4>
          </div>

          <div class="table-container">
            <div class="table-wrapper">
              <table class="data-table">
                <thead>
                  <tr class="table-header-row">
                    <th class="table-header-cell">Activity Title</th>
                    <th class="table-header-cell">Office / Unit</th>
                    <th class="table-header-cell">Type</th>
                    <th class="table-header-cell">Date Submitted</th>
                  </tr>
                </thead>
                <tbody class="table-body">
                  <tr v-if="pendingActivities.length === 0">
                    <td colspan="4" class="empty-state-cell">
                      No pending activities found matching evaluation workflows
                    </td>
                  </tr>
                  <tr v-else v-for="activity in pendingActivities" :key="activity.id" @click="navigateToView(activity.type, activity.id)" class="table-row">
                    <td class="activity-title-cell">{{ activity.title }}</td>
                    <td class="office-cell">{{ activity.office }}</td>
                    <td class="type-cell">
                      <span class="type-badge" :class="activity.type === 'design' ? 'type-badge-design' : 'type-badge-report'">
                        {{ activity.typeName }}
                      </span>
                    </td>
                    <td class="date-cell">{{ activity.date }}</td>
                  </tr>
                </tbody>
              </table>
            </div>

            <div class="table-footer">
              <p class="footer-text">Showing {{ pendingActivities.length }} pending items</p>
              <router-link to="/admin/submitted-list?filter=pending" class="view-all-link">
                View All Activity Hub →
              </router-link>
            </div>
          </div>
        </div>

        <div class="analytics-section">
          <div class="section-header">
            <span class="title-indicator"></span>
            <h4 class="section-title">Data Visualization & Analytics</h4>
          </div>
          
          <div class="analytics-placeholder">
            <div class="placeholder-icon">📊</div>
            <h5 class="placeholder-title">Analytics Workspace Staged</h5>
            <p class="placeholder-text">
              Database connections ready. Visualization dashboards and metric trends will load here automatically once live transaction reporting engines are instantiated.
            </p>
          </div>
        </div>
      </div>

      <div class="grid-sidebar">
        
        <div class="schedule-card">
          <div class="schedule-header">
            <h4 class="schedule-title">Schedule & Deadlines</h4>
            <div class="calendar-nav">
              <span class="calendar-nav-btn">◀</span>
              <span class="calendar-label">CALENDAR</span>
              <span class="calendar-nav-btn">▶</span>
            </div>
          </div>
          
          <div class="calendar-weekdays">
            <span v-for="day in ['S', 'M', 'T', 'W', 'T', 'F', 'S']" :key="day">{{ day }}</span>
          </div>
          <div class="calendar-dates">
            <span class="date-cell date-cell-past">1</span>
            <span v-for="date in 23" :key="date" class="date-cell">
              <span class="date-number">{{ date + 1 }}</span>
            </span>
            <span v-for="blankDay in 7" :key="'b-' + blankDay" class="date-cell date-cell-future">{{ 24 + blankDay }}</span>
          </div>

          <div class="deadlines-section">
            <h5 class="deadlines-title">Upcoming Deadlines</h5>
            <div class="deadlines-list">
              <div v-if="upcomingDeadlines.length === 0" class="deadlines-empty">
                No impending target deadlines
              </div>
              <div v-else v-for="deadline in upcomingDeadlines" :key="deadline.id" class="deadline-item">
                <div class="deadline-info">
                  <div class="deadline-dot"></div>
                  <p class="deadline-title">{{ deadline.title }}</p>
                </div>
                <span class="deadline-badge">{{ deadline.badgeText }}</span>
              </div>
            </div>
          </div>
        </div>

        <div class="activity-logs-card">
          <h5 class="logs-title">System Activity Logs</h5>
          <div class="logs-list">
            <div v-if="activityLogs.length === 0" class="logs-empty">
              No recent transaction events
            </div>
            <div v-else v-for="log in activityLogs" :key="log.id" class="log-item">
              <div class="log-icon">{{ log.icon }}</div>
              <div class="log-content">
                <p class="log-action">{{ log.action }}</p>
                <p class="log-time">{{ log.time }}</p>
              </div>
            </div>
          </div>
        </div>

      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import api from '../../api';

const router = useRouter();

const navigateToView = (type, id) => {
  if (type === 'design') {
    router.push(`/admin/ad-review/${id}`);
  } else {
    router.push(`/admin/ar-review/${id}`);
  }
};

const metricsStats = ref([
  { label: 'Pending Act Designs', value: '0', icon: 'description', iconColor: 'text-purple-400', bgClass: 'bg-purple-500/10' },
  { label: 'Pending Acc Reports', value: '0', icon: 'analytics', iconColor: 'text-blue-400', bgClass: 'bg-blue-500/10' },
  { label: 'Total GAD Budget', value: '₱0', icon: 'payments', iconColor: 'text-emerald-400', bgClass: 'bg-emerald-500/10' },
  { label: 'Remaining Balance', value: '₱0', icon: 'account_balance_wallet', iconColor: 'text-pink-400', bgClass: 'bg-pink-500/10' }
]);

const pendingActivities = ref([]);
const upcomingDeadlines = ref([]);
const activityLogs = ref([]);

const fetchStats = async () => {
  try {
    const [designsRes, reportsRes] = await Promise.all([
      api.get('activity-designs'),
      api.get('activity-reports')
    ]);
    
    if (designsRes.data.success) {
      const pendingDesigns = designsRes.data.data.filter(d => d.status === 'Pending').length;
      metricsStats.value[0].value = pendingDesigns.toString();
      
      // Also update pending activities list
      const pDesigns = designsRes.data.data
        .filter(d => d.status === 'Pending')
        .slice(0, 3)
        .map(d => ({
          id: d.act_design_id,
          type: 'design',
          title: d.title,
          typeName: 'Activity Design',
          office: d.office || d.submitter_name || 'N/A',
          date: d.date || 'Pending Review'
        }));
      pendingActivities.value = pDesigns;
    }
    
    if (reportsRes.data.success) {
      const pendingReports = reportsRes.data.data.filter(r => r.status === 'Pending').length;
      metricsStats.value[1].value = pendingReports.toString();
      
      const pReports = reportsRes.data.data
        .filter(r => r.status === 'Pending')
        .slice(0, 3)
        .map(r => ({
          id: r.id || r.acc_report_id,
          type: 'report',
          title: r.title,
          typeName: 'Accomplishment Report',
          office: r.office || r.submitter_name || 'N/A',
          date: r.date || 'Pending Verification'
        }));
      
      pendingActivities.value = [...pendingActivities.value, ...pReports].slice(0, 4);
    }
  } catch (err) {
    console.error('Error fetching dashboard stats:', err);
  }
};

onMounted(() => {
  fetchStats();
});
</script>

<style scoped>
.staff-dashboard-content { width: 100%; display: flex; flex-direction: column; gap: 32px; padding-bottom: 32px; background: transparent; }
.stat-card, .pending-activities-section, .analytics-section, .schedule-card, .activity-logs-card { border-radius: 16px; border: 1px solid rgba(185, 121, 204, 0.15); background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15); }
.stats-section { display: grid; grid-template-columns: repeat(4, 1fr); gap: 24px; }
.stat-card { padding: 20px 16px; border-radius: 12px; transition: transform 0.2s ease, box-shadow 0.2s ease; }
.stat-card:hover { transform: translateY(-4px); box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.3); }
.stat-card-inner { display: flex; align-items: center; gap: 12px; }
.stat-icon { width: 40px; height: 40px; border-radius: 8px; display: flex; align-items: center; justify-content: center; }
.stat-icon-symbol { font-size: 18px; }
.text-purple-400 { color: #c084fc; }
.text-blue-400 { color: #60a5fa; }
.text-emerald-400 { color: #34d399; }
.text-pink-400 { color: #f472b6; }
.bg-purple-500\/10 { background: rgba(168, 85, 247, 0.1); }
.bg-blue-500\/10 { background: rgba(59, 130, 246, 0.1); }
.bg-emerald-500\/10 { background: rgba(16, 185, 129, 0.1); }
.bg-pink-500\/10 { background: rgba(244, 114, 182, 0.1); }
.stat-info { min-width: 0; }
.stat-value { font-size: 20px; font-weight: 900; color: white; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.stat-label { font-size: 13px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; color: #94a3b8; margin-top: 2px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.dashboard-grid { display: grid; grid-template-columns: 7fr 3fr; gap: 32px; align-items: start; }
.grid-main, .grid-sidebar { display: flex; flex-direction: column; gap: 24px; }
.section-header, .schedule-header { display: flex; align-items: center; gap: 8px; margin-bottom: 20px; }
.title-indicator { width: 6px; height: 16px; background: linear-gradient(to bottom, #9333ea, #c084fc); border-radius: 9999px; }
.section-title, .schedule-title { font-weight: 700; color: #ffffff; font-size: 18px; margin: 0; }
.pending-activities-section, .analytics-section { padding: 24px; }
.schedule-card, .activity-logs-card { padding: 20px; }
.table-container { border: 1px solid rgba(185, 121, 204, 0.1); border-radius: 12px; overflow: hidden; background: transparent; }
.table-wrapper { overflow-x: auto; }
.data-table { width: 100%; text-align: left; border-collapse: collapse; }
.table-header-row { background: rgba(255, 255, 255, 0.02); border-bottom: 1px solid rgba(255, 255, 255, 0.05); }
.table-header-cell { padding: 16px; font-size: 13px; font-weight: 700; color: #b979cc; text-transform: uppercase; letter-spacing: 0.05em; }
.empty-state-cell { padding: 40px; text-align: center; font-size: 13px; color: #94a3b8; font-weight: 500; }
.table-row { border-bottom: 1px solid rgba(255, 255, 255, 0.05); cursor: pointer; transition: all 0.2s ease; }
.table-row:hover { background: rgba(255, 255, 255, 0.03); }
.activity-title-cell { padding: 16px; font-size: 13px; font-weight: 600; color: #f1f5f9; transition: color 0.2s ease; }
.table-row:hover .activity-title-cell { color: #c084fc; }
.office-cell { padding: 16px; font-size: 13px; color: #cbd5e1; }
.type-cell { padding: 16px; }
.type-badge { font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; padding: 4px 8px; border-radius: 6px; display: inline-block; }
.type-badge-design { background: rgba(153, 13, 209, 0.2); color: #d8b4fe; border: 1px solid rgba(153, 13, 209, 0.3); }
.type-badge-report { background: rgba(6, 182, 212, 0.15); color: #7dd3fc; border: 1px solid rgba(6, 182, 212, 0.2); }
.date-cell { padding: 16px; font-size: 13px; font-family: monospace; color: #94a3b8; }
.table-footer { padding: 16px; background: rgba(0, 0, 0, 0.1); border-top: 1px solid rgba(255, 255, 255, 0.05); display: flex; justify-content: space-between; align-items: center; font-size: 13px; }
.footer-text { color: #94a3b8; font-weight: 500; }
.view-all-link { background: rgba(0, 0, 0, 0.3); border: 1px solid rgba(185, 121, 204, 0.2); color: #b979cc; padding: 6px 12px; border-radius: 8px; font-size: 13px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; text-decoration: none; transition: all 0.2s ease; display: inline-flex; align-items: center; gap: 4px; }
.view-all-link:hover { color: #c084fc; border-color: rgba(185, 121, 204, 0.4); }
.analytics-placeholder { border: 1px solid rgba(147, 51, 234, 0.15); background: transparent; padding: 32px; border-radius: 12px; min-height: 260px; display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; margin-top: 8px; }
.placeholder-icon { width: 48px; height: 48px; background: rgba(0, 0, 0, 0.2); border: 1px solid rgba(147, 51, 234, 0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 18px; margin-bottom: 12px; }
.placeholder-title { font-size: 13px; font-weight: 700; color: #c084fc; }
.placeholder-text { font-size: 13px; color: #94a3b8; max-width: 448px; margin-top: 4px; line-height: 1.5; }
.schedule-header { justify-content: space-between; margin-bottom: 16px; }
.calendar-nav { display: flex; align-items: center; gap: 8px; font-family: monospace; font-size: 13px; color: #cbd5e1; }
.calendar-nav-btn { padding: 4px; border-radius: 4px; cursor: pointer; transition: background 0.2s ease; }
.calendar-nav-btn:hover { background: rgba(255, 255, 255, 0.1); }
.calendar-label { font-weight: 700; color: white; }
.calendar-weekdays { display: grid; grid-template-columns: repeat(7, 1fr); gap: 4px; text-align: center; font-size: 13px; font-weight: 700; color: #c084fc; letter-spacing: 0.05em; margin-bottom: 8px; }
.calendar-dates { display: grid; grid-template-columns: repeat(7, 1fr); gap: 4px; text-align: center; font-family: monospace; font-size: 13px; color: #cbd5e1; }
.date-cell { padding: 8px; border-radius: 8px; cursor: pointer; transition: all 0.2s ease; }
.date-cell:hover { background: rgba(185, 121, 204, 0.2); }
.date-cell:hover .date-number { color: white; }
.date-cell-past, .date-cell-future { color: #cbd5e1; }
.date-number { transition: color 0.2s ease; }
.deadlines-section { border-top: 1px solid rgba(255, 255, 255, 0.05); padding-top: 16px; margin-top: 16px; }
.deadlines-title, .logs-title { font-size: 13px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; color: #c084fc; margin-bottom: 12px; }
.deadlines-list, .logs-list { display: flex; flex-direction: column; gap: 8px; }
.deadlines-empty, .logs-empty { text-align: center; padding: 12px; font-size: 13px; color: #94a3b8; font-weight: 500; }
.deadline-item { display: flex; align-items: center; justify-content: space-between; padding: 8px; border-radius: 8px; background: rgba(0, 0, 0, 0.2); border: 1px solid rgba(255, 255, 255, 0.05); transition: all 0.2s ease; }
.deadline-item:hover { border-color: rgba(185, 121, 204, 0.3); background: rgba(185, 121, 204, 0.05); }
.deadline-info { display: flex; align-items: center; gap: 8px; min-width: 0; }
.deadline-dot { width: 6px; height: 6px; border-radius: 9999px; background: #fbbf24; flex-shrink: 0; }
.deadline-title { font-size: 13px; color: #e2e8f0; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; padding-right: 8px; }
.deadline-badge { font-size: 12px; font-weight: 700; padding: 2px 6px; border-radius: 4px; background: rgba(0, 0, 0, 0.25); color: #cbd5e1; text-transform: uppercase; letter-spacing: 0.05em; flex-shrink: 0; }
.logs-title { margin-bottom: 16px; }
.logs-list { gap: 16px; }
.log-item { display: flex; gap: 12px; align-items: flex-start; }
.log-icon { width: 24px; height: 24px; border-radius: 6px; background: rgba(0, 0, 0, 0.3); border: 1px solid rgba(147, 51, 234, 0.2); display: flex; align-items: center; justify-content: center; font-size: 13px; flex-shrink: 0; }
.log-content { min-width: 0; }
.log-action { font-size: 13px; color: #e2e8f0; line-height: 1.4; font-weight: 500; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
.log-time { font-size: 13px; font-family: monospace; color: #94a3b8; margin-top: 2px; }
::-webkit-scrollbar { width: 6px; height: 6px; }
::-webkit-scrollbar-track { background: transparent; }
::-webkit-scrollbar-thumb { background: rgba(255, 255, 255, 0.1); border-radius: 4px; }
@media (max-width: 1024px) { .stats-section { grid-template-columns: repeat(2, 1fr); } .dashboard-grid { grid-template-columns: 1fr; } }
@media (max-width: 768px) { .stats-section { grid-template-columns: 1fr; } }
</style>