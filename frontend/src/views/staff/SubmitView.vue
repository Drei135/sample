<template>
    <main class="p-8">
      <div id="twgSelectionModal" class="twg-view-wrapper">
        <div class="modal-container">
          <div class="modal-header">
            <h3 class="modal-title">New Submission</h3>
            <span class="title-badge">GAD-AMS Portal</span>
          </div>
          <p class="modal-text">Select the type of document you want to compile and submit for administrative review.</p>
          
          <div class="options-grid">
            <router-link to="/staff/submit-design" class="modal-option">
                <div class="modal-option-content">
                    <p class="modal-option-title">Activity Design</p>
                    <p class="modal-option-desc">Submit a new activity design proposal for approval</p>
                </div>
                <div class="modal-option-arrow">→</div>
                </router-link>

                <router-link to="/staff/submit-report" class="modal-option">
                <div class="modal-option-content">
                    <p class="modal-option-title">Accomplishment Report</p>
                    <p class="modal-option-desc">Submit accomplishment report for completed activities</p>
                </div>
                <div class="modal-option-arrow">→</div>
            </router-link>
          </div>
        </div>
      </div>
    </main>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import api from '../../api';

const router = useRouter();
const route = useRoute();
const user = ref(JSON.parse(localStorage.getItem('user') || '{}'));

const menuItems = computed(() => {
  if (route.path.includes('/staff')) return staffMenu;
  return [];
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
  if (!user.value.id) {
    router.push('/login');
  }
});
</script>

<style scoped>
.twg-view-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-grow: 1;
  background: transparent;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
}

.modal-container {
  background: linear-gradient(145deg, #1a1a2e 0%, #16213e 100%);
  border: 1px solid rgba(185, 121, 204, 0.2); 
  border-radius: 24px;
  padding: 40px;
  max-width: 520px;
  width: 100%;
  box-shadow: 0 20px 40px rgba(10, 10, 20, 0.5), 
              0 0 30px rgba(153, 13, 209, 0.05);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.modal-title {
  font-size: 24px;
  font-weight: 800;
  color: #ffffff; 
  letter-spacing: -0.03em;
}

.title-badge {
  font-size: 14px;
  font-weight: 700;
  color: #ffffff;
  background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%); /* Matching brand gradient */
  padding: 4px 12px;
  border-radius: 99px;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  box-shadow: 0 2px 8px rgba(153, 13, 209, 0.3);
}

.modal-text {
  color: #94a3b8; /* Muted slate text matching subnav links */
  margin-bottom: 32px;
  font-size: 16px;
  line-height: 1.6;
  text-align: left;
}

.options-grid {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.modal-option {
  display: flex;
  align-items: center;
  gap: 20px;
  padding: 20px;
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 16px;
  text-decoration: none;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Hover effect mirrors the glowing sidebar buttons */
.modal-option:hover {
  background-color: rgba(185, 121, 204, 0.12);
  border-color: #b979cc;
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(153, 13, 209, 0.15);
}

.modal-option-icon {
  width: 52px;
  height: 52px;
  background: rgba(185, 121, 204, 0.15);
  border: 1px solid rgba(185, 121, 204, 0.25);
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  flex-shrink: 0;
  transition: all 0.25s ease;
}

.modal-option:hover .modal-option-icon {
  background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%);
  transform: scale(1.05);
}

.modal-option-content {
  flex: 1;
  text-align: left;
}

.modal-option-title {
  font-weight: 700;
  color: #ffffff;
  font-size: 16px;
  margin: 0 0 4px 0;
}

.modal-option-desc {
  font-size: 12px;
  color: #cbd5e1; /* Clear readability text over dark elements */
  line-height: 1.4;
  margin: 0;
}

.modal-option-arrow {
  color: #94a3b8;
  font-size: 20px;
  font-weight: bold;
  transition: all 0.25s ease;
}

.modal-option:hover .modal-option-arrow {
  color: #ffffff;
  transform: translateX(4px);
}
</style>