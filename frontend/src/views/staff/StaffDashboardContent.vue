<template>
  <div class="staff-dashboard-content">
  <div class="bg-white p-8 rounded-2xl border border-slate-100 shadow-sm">
      <h1 class="text-3xl font-bold text-slate-900">Welcome, {{ user.username || 'Staff' }} to your Dashboard!</h1>
      <p class="text-slate-500 mt-2">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
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
                    <th class="table-header-cell">Type</th>
                    <th class="table-header-cell">Activity Title</th>
                    <th class="table-header-cell">Date Submitted</th>
                    <th class="table-header-cell">Status</th>
                  </tr>
                </thead>
                <tbody class="table-body">
                  <tr v-if="pendingActivities.length === 0">
                    <td colspan="4" class="empty-state-cell">
                      No pending activities found matching evaluation workflows
                    </td>
                  </tr>
                  <tr v-else v-for="activity in pendingActivities" :key="activity.id" @click="navigateToView(activity)" class="table-row">
                    <td class="type-cell">
                      <span class="type-badge" :class="activity.type === 'design' ? 'type-badge-design' : 'type-badge-report'">
                        {{ activity.typeName }}
                      </span>
                    </td>
                    <td class="activity-title-cell">{{ activity.title }}</td>
                    <td class="date-cell">{{ activity.date }}</td>
                    <td class="status-cell">
                      <span class="status-badge" :class="statusBadgeClass(activity.status)">
                        {{ activity.status }}
                      </span>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>

            <div class="table-footer">
              <p class="footer-text">Showing {{ pendingActivities.length }} pending items</p>
              <router-link to="/staff/submitted-list?filter=pending" class="view-all-link">
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
          <div class="calendar-header-nav">
            <h4 class="schedule-title">{{ currentMonthName }} {{ currentYear }}</h4>
            <div class="calendar-controls">
              <button @click="changeMonth(-1)" class="nav-btn">◀</button>
              <button @click="changeMonth(1)" class="nav-btn">▶</button>
            </div>
          </div>
          
          <div class="calendar-container">
            <div class="calendar-weekdays">
              <span v-for="day in ['S', 'M', 'T', 'W', 'T', 'F', 'S']" :key="day">{{ day }}</span>
            </div>
            <div class="calendar-dates">
              <div 
                v-for="(day, index) in calendarDays" 
                :key="index" 
                class="date-cell"
                :class="{ 'date-active': day.current }"
              >
                <span class="date-number">{{ day.n }}</span>
              </div>
            </div>
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
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';

const router = useRouter();
const user = ref(JSON.parse(localStorage.getItem('user') || '{}'));
const showNotifications = ref(false);

const toggleNotifications = () => {
  showNotifications.value = !showNotifications.value;
};

const statusBadgeClass = (status) => {
  const s = status?.toLowerCase() || '';
  return s.includes('revision') ? 'status-badge-revision' : 'status-badge-pending';
};

const navigateToView = (item) => {
  const type = item.type;
  const id = item.id;
  const currentUserId = user.value.id || user.value.user_id;
  const status = item.status?.toLowerCase() || '';
  const isOwner = Number(item.user_id) === Number(currentUserId);

  if (type === 'design') {
    if (status.includes('revision') && isOwner) {
      router.push(`/staff/ad-revision/${id}`);
    } else {
      router.push(`/staff/ad-view/${id}`);
    }
  } else {
    if (status.includes('revision') && isOwner) {
      router.push(`/staff/ar-revision/${id}`);
    } else {
      router.push(`/staff/ar-view/${id}`);
    }
  }
};

// Calendar Logic (Synced with CollegeDashboard)
const currentMonthDate = ref(new Date());
const currentMonthName = computed(() => currentMonthDate.value.toLocaleString('default', { month: 'long' }));
const currentYear = computed(() => currentMonthDate.value.getFullYear());

const calendarDays = computed(() => {
  const year = currentMonthDate.value.getFullYear();
  const month = currentMonthDate.value.getMonth();
  const firstDayOfMonth = new Date(year, month, 1).getDay();
  const lastDateOfMonth = new Date(year, month + 1, 0).getDate();
  const days = [];

  for (let i = 0; i < firstDayOfMonth; i++) {
    days.push({ n: '', current: false });
  }

  const today = new Date();
  for (let i = 1; i <= lastDateOfMonth; i++) {
    const isToday = i === today.getDate() && 
                    month === today.getMonth() && 
                    year === today.getFullYear();
    days.push({ n: i, current: isToday });
  }
  return days;
});

const changeMonth = (offset) => {
  currentMonthDate.value = new Date(currentMonthDate.value.getFullYear(), currentMonthDate.value.getMonth() + offset, 1);
};

/* ==============================================================
  DYNAMIC MATRIX STATE (API READY)
  ==============================================================
*/
const metricsStats = ref([
  { label: 'Pending Reviews', value: '0', icon: 'schedule', iconColor: 'text-amber-400', bgClass: 'bg-amber-500/10' },
  { label: 'Total Act Designs', value: '0', icon: 'description', iconColor: 'text-purple-400', bgClass: 'bg-purple-500/10' },
  { label: 'Total Acc Reports', value: '0', icon: 'analytics', iconColor: 'text-blue-400', bgClass: 'bg-blue-500/10' },
  { label: 'Total GAD Budget', value: '₱0.0M', icon: 'payments', iconColor: 'text-emerald-400', bgClass: 'bg-emerald-500/10' },
  { label: '% GAD Allocation', value: '0.00%', icon: 'percent', iconColor: 'text-pink-400', bgClass: 'bg-[#990dd1]/10' }
]);

const pendingActivities = ref([]);
const upcomingDeadlines = ref([]);
const activityLogs = ref([]);
const notificationItems = ref([]);

const fetchDashboardData = async () => {
  try {
    const currentUserId = Number(user.value.id || user.value.user_id);
    
    // Fetch both types of submissions from the API
    const [designsRes, reportsRes] = await Promise.all([
      axios.get('http://localhost:8080/api/activity-designs'),
      axios.get('http://localhost:8080/api/activity-reports')
    ]);

    const allDesigns = designsRes.data.success ? designsRes.data.data : [];
    const allReports = reportsRes.data.success ? reportsRes.data.data : [];

    // Map Activity Designs to unified table format
    const formattedDesigns = allDesigns.map(d => ({
      id: d.act_design_id,
      title: d.activity_title || d.title,
      office: d.office,
      type: 'design',
      typeName: 'Activity Design',
      date: d.date || d.start_date,
      status: d.status,
      user_id: d.user_id
    }));

    // Map Accomplishment Reports to unified table format
    const formattedReports = allReports.map(r => ({
      id: r.id || r.act_report_id,
      title: r.activity_title || r.title,
      office: r.office,
      type: 'report',
      typeName: 'Accomplishment Report',
      date: r.date || r.start_date,
      status: r.status,
      user_id: r.user_id
    }));

    // Filter for current user's PENDING or REVISION items and sort by ID (recent first)
    const userPending = [...formattedDesigns, ...formattedReports]
      .filter(item => {
        const isOwner = Number(item.user_id) === currentUserId;
        const s = item.status?.toLowerCase() || '';
        // Include both 'pending' and 'revision' as they both require user attention
        return isOwner && (s === 'pending' || s.includes('revision'));
      })
      .sort((a, b) => b.id - a.id);

    pendingActivities.value = userPending.slice(0, 5);

    // Update Metric Stats cards with dynamic values
    metricsStats.value[0].value = userPending.length.toString();
    metricsStats.value[1].value = formattedDesigns.filter(d => Number(d.user_id) === currentUserId).length.toString();
    metricsStats.value[2].value = formattedReports.filter(r => Number(r.user_id) === currentUserId).length.toString();
  } catch (err) {
    console.error('Error fetching dashboard data:', err);
  }
};

onMounted(() => {
  fetchDashboardData();
});
</script>

<style scoped>
.staff-dashboard-content {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 2rem;
  padding-bottom: 2rem;
}

/* Stats Section */
.stats-section {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 1rem;
}

.stat-card {
  padding: 1rem;
  border-radius: 0.75rem;
  border: 1px solid rgba(147, 51, 234, 0.15);
  background: linear-gradient(135deg, #0f172a, #020617);
  transition: transform 0.2s ease;
}

.stat-card:hover {
  transform: translateY(-4px);
}

.stat-card-inner {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.stat-icon {
  width: 40px;
  height: 40px;
  border-radius: 0.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
}

.stat-icon-symbol {
  font-size: 1.125rem;
}

/* Icon Colors */
.text-amber-400 { color: #fbbf24; }
.text-purple-400 { color: #c084fc; }
.text-blue-400 { color: #60a5fa; }
.text-emerald-400 { color: #34d399; }
.text-pink-400 { color: #f472b6; }

/* Background Classes */
.bg-amber-500\/10 { background: rgba(245, 158, 11, 0.1); }
.bg-purple-500\/10 { background: rgba(168, 85, 247, 0.1); }
.bg-blue-500\/10 { background: rgba(59, 130, 246, 0.1); }
.bg-emerald-500\/10 { background: rgba(16, 185, 129, 0.1); }
.bg-\[\#990dd1\]\/10 { background: rgba(153, 13, 209, 0.1); }

.stat-info {
  min-width: 0;
}

.stat-value {
  font-size: 1.25rem;
  font-weight: 900;
  color: white;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.stat-label {
  font-size: 0.625rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #94a3b8;
  margin-top: 0.125rem;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* Dashboard Grid */
.dashboard-grid {
  display: grid;
  grid-template-columns: 7fr 3fr;
  gap: 2rem;
  align-items: start;
}

.grid-main {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.grid-sidebar {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

/* Section Header */
.section-header {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.title-indicator {
  width: 0.375rem;
  height: 1rem;
  background: linear-gradient(to bottom, #9333ea, #c084fc);
  border-radius: 9999px;
}

.section-title {
  font-weight: 700;
  color: #16213e;
  font-size: 1.25rem;
}

/* Table Container */
.table-container {
  border: 1px solid rgba(147, 51, 234, 0.15);
  border-radius: 0.75rem;
  overflow: hidden;
  background: linear-gradient(135deg, #0f172a, #020617);
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
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
  background: rgba(0, 0, 0, 0.2);
  border-bottom: 1px solid rgba(147, 51, 234, 0.1);
}

.table-header-cell {
  padding: 1rem;
  font-size: 0.625rem;
  font-weight: 700;
  color: #c084fc;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.table-body {
  display: table-row-group;
}

.empty-state-cell {
  padding: 2.5rem;
  text-align: center;
  font-size: 0.75rem;
  color: #64748b;
  font-weight: 500;
}

.table-row {
  border-bottom: 1px solid rgba(147, 51, 234, 0.05);
  cursor: pointer;
  transition: all 0.2s ease;
}

.table-row:hover {
  background: rgba(255, 255, 255, 0.05);
}

.activity-title-cell {
  padding: 1rem;
  font-size: 0.875rem;
  font-weight: 600;
  color: #e2e8f0;
  transition: color 0.2s ease;
}

.table-row:hover .activity-title-cell {
  color: #c084fc;
}

.status-cell {
  padding: 1rem;
}

.status-badge {
  display: inline-block;
  padding: 0.25rem 0.625rem;
  border-radius: 0.5rem;
  font-size: 0.5625rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.status-badge-pending {
  background: rgba(245, 158, 11, 0.2);
  color: #fbbf24;
  border: 1px solid rgba(245, 158, 11, 0.3);
}

.status-badge-revision {
  background: rgba(239, 68, 68, 0.15);
  color: #ef4444;
  border: 1px solid rgba(239, 68, 68, 0.25);
}

.type-cell {
  padding: 1rem;
}

.type-badge {
  font-size: 0.5625rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  padding: 0.25rem 0.5rem;
  border-radius: 0.375rem;
  display: inline-block;
}

.type-badge-design {
  background: rgba(153, 13, 209, 0.2);
  color: #b979cc;
  border: 1px solid rgba(153, 13, 209, 0.3);
}

.type-badge-report {
  background: rgba(6, 182, 212, 0.1);
  color: #22d3ee;
  border: 1px solid rgba(6, 182, 212, 0.2);
}

.date-cell {
  padding: 1rem;
  font-size: 0.75rem;
  font-family: monospace;
  color: #64748b;
}

.table-footer {
  padding: 1rem;
  background: rgba(0, 0, 0, 0.1);
  border-top: 1px solid rgba(147, 51, 234, 0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.75rem;
}

.footer-text {
  color: #64748b;
  font-weight: 500;
}

.view-all-link {
  background: rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(147, 51, 234, 0.15);
  color: white;
  padding: 0.375rem 0.75rem;
  border-radius: 0.5rem;
  font-size: 0.625rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  text-decoration: none;
  transition: all 0.2s ease;
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
}

.view-all-link:hover {
  color: #c084fc;
}

/* Analytics Placeholder */
.analytics-section {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.analytics-placeholder {
  border: 1px solid rgba(147, 51, 234, 0.15);
  background: rgba(15, 23, 42, 0.6);
  padding: 2rem;
  border-radius: 0.75rem;
  min-height: 260px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  box-shadow: inset 0 2px 4px 0 rgba(0, 0, 0, 0.05);
}

.placeholder-icon {
  width: 48px;
  height: 48px;
  background: rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(147, 51, 234, 0.1);
  border-radius: 0.75rem;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.125rem;
  margin-bottom: 0.75rem;
  opacity: 0.6;
}

.placeholder-title {
  font-size: 0.875rem;
  font-weight: 700;
  color: #e2e8f0;
}

.placeholder-text {
  font-size: 0.75rem;
  color: #64748b;
  max-width: 448px;
  margin-top: 0.25rem;
  line-height: 1.5;
}

/* Schedule Card */
.schedule-card {
  padding: 1.25rem;
  border: 1px solid rgba(147, 51, 234, 0.15);
  border-radius: 0.75rem;
  background: linear-gradient(135deg, #0f172a, #020617);
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
}

.calendar-header-nav {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.calendar-controls {
  display: flex;
  gap: 0.5rem;
}

.nav-btn {
  background: rgba(147, 51, 234, 0.1);
  border: none;
  color: #c084fc;
  padding: 4px 8px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 0.75rem;
}

.schedule-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 1rem;
}

.schedule-title {
  font-size: 0.875rem;
  font-weight: 700;
  color: #c084fc;
  letter-spacing: 0.025em;
}

.calendar-nav {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-family: monospace;
  font-size: 0.75rem;
  color: #cbd5e1;
}

.calendar-nav-btn {
  padding: 0.25rem;
  border-radius: 0.25rem;
  cursor: pointer;
  transition: background 0.2s ease;
}

.calendar-nav-btn:hover {
  background: rgba(255, 255, 255, 0.1);
}

.calendar-label {
  font-weight: 700;
  color: white;
}

.calendar-weekdays {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 0.25rem;
  text-align: center;
  font-size: 0.625rem;
  font-weight: 700;
  color: #c084fc;
  letter-spacing: 0.05em;
  margin-bottom: 0.5rem;
}

.calendar-dates {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 0.25rem;
  text-align: center;
  font-family: monospace;
  font-size: 0.75rem;
  color: #cbd5e1;
}

.date-active {
  background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%);
  color: #ffffff;
  font-weight: 800;
  box-shadow: 0 4px 12px rgba(153, 13, 209, 0.4);
  border-radius: 0.5rem;
}
/* Deadlines Section */
.deadlines-section {
  border-top: 1px solid rgba(147, 51, 234, 0.1);
  padding-top: 1rem;
  margin-top: 1rem;
}

.deadlines-title {
  font-size: 0.5625rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #94a3b8;
  margin-bottom: 0.75rem;
}

.deadlines-list {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.deadlines-empty {
  text-align: center;
  padding: 0.75rem;
  font-size: 0.75rem;
  color: #64748b;
  font-weight: 500;
}

.deadline-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0.5rem;
  border-radius: 0.5rem;
  background: rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.05);
  transition: all 0.2s ease;
}

.deadline-item:hover {
  border-color: rgba(147, 51, 234, 0.2);
}

.deadline-info {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  min-width: 0;
}

.deadline-dot {
  width: 0.375rem;
  height: 0.375rem;
  border-radius: 9999px;
  background: #fbbf24;
  flex-shrink: 0;
}

.deadline-title {
  font-size: 0.75rem;
  color: #e2e8f0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  padding-right: 0.5rem;
}

.deadline-badge {
  font-size: 0.5625rem;
  font-weight: 700;
  padding: 0.125rem 0.375rem;
  border-radius: 0.25rem;
  background: rgba(245, 158, 11, 0.1);
  color: #fbbf24;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  flex-shrink: 0;
}

/* Activity Logs Card */
.activity-logs-card {
  padding: 1.25rem;
  border: 1px solid rgba(147, 51, 234, 0.15);
  border-radius: 0.75rem;
  background: linear-gradient(135deg, #0f172a, #020617);
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
}

.logs-title {
  font-size: 0.625rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: #c084fc;
  margin-bottom: 1rem;
}

.logs-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.logs-empty {
  text-align: center;
  padding: 0.75rem;
  font-size: 0.75rem;
  color: #64748b;
  font-weight: 500;
}

.log-item {
  display: flex;
  gap: 0.75rem;
  align-items: flex-start;
}

.log-icon {
  width: 24px;
  height: 24px;
  border-radius: 0.375rem;
  background: rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(147, 51, 234, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.75rem;
  flex-shrink: 0;
}

.log-content {
  min-width: 0;
}

.log-action {
  font-size: 0.75rem;
  color: #e2e8f0;
  line-height: 1.4;
  font-weight: 500;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.log-time {
  font-size: 0.625rem;
  font-family: monospace;
  color: #64748b;
  margin-top: 0.125rem;
}

/* Responsive */
@media (max-width: 1024px) {
  .stats-section {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .dashboard-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .stats-section {
    grid-template-columns: 1fr;
  }
  
  .content-wrapper {
    padding: 20px;
  }
}
</style>