<template>
  <aside 
    :class="[
      'w-64 bg-[#1a1a2e] text-white fixed h-full flex flex-col p-6 shadow-xl z-50 transition-transform duration-300 top-0 left-0',
      isOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'
    ]"
  >
    <div class="sidebar-header">
      <div class="sidebar-logo">
        <img src="/images/bsulogo.png" alt="BSU Logo" />
        <div class="logo-text">
          <div class="logo-subtitle">Benguet State University</div>
          <div class="logo-title">GAD-AMS</div>
          <div class="logo-dept">Gender and Development Office</div>
        </div>
      </div>
      <button @click="$emit('close')" class="lg:hidden text-slate-400 hover:text-white p-1 flex-shrink-0 flex items-center justify-center ml-2">
        <span class="material-symbols-outlined text-lg">close</span>
      </button>
    </div>

    <nav class="flex-grow space-y-1 overflow-y-auto custom-scrollbar mt-4">
      <router-link 
        v-for="item in menuItems" 
        :key="item.label"
        :to="item.href"
        @click="$emit('close')"
        class="flex items-center gap-3 p-3 rounded-xl transition-all duration-200"
        :class="$route.path === item.href ? 'bg-primary/20 text-white font-bold' : 'text-slate-400 hover:bg-white/5 hover:text-white'"
      >
        <span class="material-symbols-outlined text-xl">{{ item.icon }}</span>
        <span class="text-sm">{{ item.label }}</span>
      </router-link>
    </nav>

    <div class="mt-auto pt-6 border-t border-white/10">
      <button @click="$emit('logout')" class="flex items-center gap-3 p-3 text-slate-400 hover:text-red-400 transition-colors w-full text-left">
        <span class="material-symbols-outlined text-xl">logout</span>
        <span class="text-sm font-bold">Sign Out</span>
      </button>
    </div>
  </aside>
</template>

<script setup>
defineProps({
  roleLabel: { type: String, default: 'User' },
  menuItems: { type: Array, required: true },
  isOpen: { type: Boolean, default: false }
});

defineEmits(['logout', 'close']);
</script>

<style scoped>
  /* Logo section */
  .sidebar-header {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    margin-bottom: 20px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.15);
    padding-bottom: 16px;
    flex-shrink: 0;
  }

  .sidebar-logo {
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .sidebar-logo img {
    height: 48px;
    width: auto;
    object-fit: contain;
  }

  .logo-text {
    text-align: left;
  }

  .logo-subtitle {
    font-size: 10px;
    font-weight: 700;
    color: #b979cc;
    letter-spacing: -0.025em;
    line-height: 1;
  }

  .logo-title {
    font-size: 20px;
    font-weight: 800;
    color: #ffffff;
    letter-spacing: -0.05em;
    line-height: 1;
  }

  .logo-dept {
    font-size: 7px;
    text-transform: uppercase;
    letter-spacing: 0.1em;
    color: #94a3b8;
    font-weight: 500;
    margin-top: 2px;
  }
  
.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: rgba(255,255,255,0.05);
  border-radius: 10px;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: #b979cc;
  border-radius: 10px;
}
</style>
