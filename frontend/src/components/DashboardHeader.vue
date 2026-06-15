<template>
  <header class="dashboard-header">
    <div class="header-container">
      <div class="header-left">
        <div class="header-text">
          <span class="header-title">{{ title }}</span>
          <span class="header-context">{{ context }}</span>
        </div>
      </div>
      <div class="header-right">
        <div v-if="showSearch" class="search-container">
          <span class="search-icon">
            <span class="material-symbols-outlined">search</span>
          </span>
          <input
            class="search-input"
            :placeholder="searchPlaceholder"
            type="search"
          />
        </div>
        <div class="action-buttons">
          <button type="button" class="action-btn">
            <span class="material-symbols-outlined">notifications</span>
          </button>
          <button type="button" class="action-btn">
            <span class="material-symbols-outlined">settings</span>
          </button>
          <div class="user-avatar" :title="username">
            <span class="user-initial">{{ userInitial }}</span>
          </div>
        </div>
      </div>
    </div>
  </header>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
  title: { type: String, default: 'Dashboard' },
  context: { type: String, default: '' },
  showSearch: { type: Boolean, default: true },
  searchPlaceholder: { type: String, default: 'Search...' },
  username: { type: String, default: 'User' }
});

const userInitial = computed(() => props.username.charAt(0).toUpperCase());
</script>

<style scoped>
.dashboard-header {
  width: 100%;
  position: sticky;
  top: 0;
  z-index: 40;
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  backdrop-filter: blur(12px);
  border-bottom: 1px solid rgba(185, 121, 204, 0.15);
  font-family: system-ui, -apple-system, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
}

.header-container {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  padding: 0.75rem 2.5rem 0.75rem 1rem;
  width: 100%;
  max-width: 1600px;
  margin: 0 auto;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 1rem;
  min-width: 0;
}

.header-text {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

@media (min-width: 640px) {
  .header-text {
    flex-direction: row;
    align-items: baseline;
    gap: 1rem;
  }
}

.header-title {
  font-size: 1.25rem;
  font-weight: bold;
  letter-spacing: -0.025em;
  background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

@media (min-width: 640px) {
  .header-title {
    font-size: 1.5rem;
  }
}

.header-context {
  font-size: 0.875rem;
  font-weight: 500;
  color: #cbd5e1;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  opacity: 0.8;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 1rem;
  flex-shrink: 0;
}

@media (min-width: 640px) {
  .header-right {
    gap: 1.5rem;
  }
}

.search-container {
  position: relative;
  display: none;
}

@media (min-width: 768px) {
  .search-container {
    display: block;
  }
}

.search-icon {
  position: absolute;
  inset-y: 0;
  left: 0;
  display: flex;
  align-items: center;
  padding-left: 0.75rem;
  color: #cbd5e1;
}

.search-icon .material-symbols-outlined {
  font-size: 1rem;
}

.search-input {
  padding: 0.5rem 0.75rem 0.5rem 2.25rem;
  background: rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(5px);
  border: 1px solid rgba(185, 121, 204, 0.15);
  border-radius: 0.75rem;
  font-size: 0.875rem;
  color: #cbd5e1;
  width: 14rem;
  transition: all 0.2s ease;
}

@media (min-width: 1024px) {
  .search-input {
    width: 16rem;
  }
}

.search-input::placeholder {
  color: rgba(203, 213, 225, 0.5);
}

.search-input:focus {
  outline: none;
  border-color: rgba(185, 121, 204, 0.4);
  background: rgba(0, 0, 0, 0.4);
  box-shadow: 0 0 0 2px rgba(153, 13, 209, 0.2);
}

.action-buttons {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

@media (min-width: 640px) {
  .action-buttons {
    gap: 0.75rem;
  }
}

.action-btn {
  padding: 0.5rem;
  background: rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(185, 121, 204, 0.15);
  border-radius: 9999px;
  cursor: pointer;
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.action-btn:hover {
  background: rgba(0, 0, 0, 0.5);
  border-color: rgba(185, 121, 204, 0.3);
  transform: scale(0.95);
}

.action-btn .material-symbols-outlined {
  font-size: 1.25rem;
  color: #cbd5e1;
}

.user-avatar {
  width: 2rem;
  height: 2rem;
  border-radius: 9999px;
  background: linear-gradient(135deg, #990dd1 0%, #b979cc 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  border: 1px solid rgba(185, 121, 204, 0.5);
  cursor: pointer;
  transition: transform 0.2s ease;
}

.user-avatar:hover {
  transform: scale(1.05);
}

.user-initial {
  font-size: 0.75rem;
  font-weight: bold;
  color: white;
  user-select: none;
}

@media (max-width: 768px) {
  .header-container {
    padding: 0.75rem 1rem;
  }

  .header-title {
    font-size: 1rem;
  }

  .header-context {
    font-size: 0.75rem;
  }

  .action-btn .material-symbols-outlined {
    font-size: 1rem;
  }

  .user-avatar {
    width: 1.75rem;
    height: 1.75rem;
  }

  .user-initial {
    font-size: 0.625rem;
  }
}

@media (max-width: 640px) {
  .header-left {
    gap: 0.5rem;
  }

  .header-text {
    gap: 0.25rem;
  }
}

@media (max-width: 480px) {
  .header-container {
    gap: 0.5rem;
    padding: 0.5rem 1rem;
  }

  .action-buttons {
    gap: 0.25rem;
  }

  .search-input {
    width: 10rem;
    padding: 0.375rem 0.5rem 0.375rem 2rem;
  }
}
</style>
