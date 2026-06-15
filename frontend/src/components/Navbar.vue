<template>
  <nav class="navbar">
    <div class="navbar-inner">
      <div class="navbar-brand">
        <router-link to="/">BSU GAD Corner</router-link>
      </div>

      <div class="navbar-links">
        <router-link 
          v-for="item in navItems" 
          :key="item.label"
          :to="item.href"
          class="nav-link"
          :class="$route.path === item.href ? 'nav-link-active' : 'nav-link-inactive'"
        >
          {{ item.label }}
        </router-link>
      </div>

      <div class="navbar-actions">
        <div class="search-wrapper">
          <span class="material-symbols-outlined search-icon">search</span>
          <input class="search-input" placeholder="Search resources..." type="text"/>
        </div>

        <template v-if="$route.path === '/login'">
          <router-link to="/register" class="btn-signup">Sign Up</router-link>
        </template>
        <template v-else>
          <span class="already-text">Already have an account?</span>
          <router-link to="/login" class="btn-login">Portal Login</router-link>
        </template>
      </div>
    </div>
  </nav>
</template>

<script setup>
const navItems = [
  { href: '/', label: 'Home' },
  // { href: '/about', label: 'About Us' },
  { href: '/resources', label: 'Resources' },
  { href: '/gad-corner', label: 'GAD Corner' },
  { href: '/contact', label: 'Contact' }
];
</script>

<style scoped>
.navbar { position: fixed; top: 0; width: 100%; z-index: 50; background: #1a1a2e; backdrop-filter: blur(12px); box-shadow: 0 1px 3px rgba(0,0,0,0.08); border-bottom: 1px solid rgba(139, 92, 246, 0.08); }
.navbar-inner { display: flex; justify-content: space-between; align-items: center; width: 100%; padding: 16px 32px; max-width: 1400px; margin: 0 auto; gap: 32px; }
.navbar-brand { font-size: 20px; font-weight: 900; letter-spacing: -0.03em; color: #990dd1; text-transform: uppercase; white-space: nowrap; }
.navbar-brand a { color: inherit; text-decoration: none; }
.navbar-links { display: flex; align-items: center; gap: 32px; font-weight: 600; letter-spacing: -0.01em; }
.nav-link { text-decoration: none; transition: color 0.2s; font-size: 16px; }
.nav-link-active { color: #fff; font-weight: 700; border-bottom: 2px solid #9333ea; padding-bottom: 4px; }
.nav-link-inactive { color: #475569; }
.nav-link-inactive:hover { color: #fff; }
.navbar-actions { display: flex; align-items: center; gap: 16px; }
.search-wrapper { position: relative; display: block; }
.search-icon { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); font-size: 16px; color: #94a3b8; }
.search-input { background: #f1f5f9; border: 1px solid #e2e8f0; border-radius: 6px; padding: 8px 16px 8px 40px; font-size: 13px; width: 240px; color: #1e293b; transition: all 0.2s; outline: none; }
.search-input::placeholder { color: #94a3b8; }
.search-input:focus { border-color: #9333ea; box-shadow: 0 0 0 2px rgba(147, 51, 234, 0.15); background: #fff; }
.already-text { font-size: 10px; text-transform: uppercase; letter-spacing: 0.15em; color: #94a3b8; white-space: nowrap; }
.btn-signup { background: #422b68; color: white; padding: 8px 20px; border-radius: 9999px; font-size: 13px; font-weight: 600; letter-spacing: 0.05em; text-decoration: none; display: inline-block; text-align: center; transition: all 0.2s; }
.btn-signup:hover { opacity: 0.9; }
.btn-signup:active { transform: scale(0.95); }
.btn-login { background: linear-gradient(135deg, #7e22ce 0%, #a855f7 100%); color: white; padding: 8px 24px; border-radius: 9999px; font-size: 13px; font-weight: 600; letter-spacing: 0.08em; text-transform: uppercase; text-decoration: none; display: inline-block; text-align: center; transition: all 0.2s; }
.btn-login:hover { transform: scale(0.97); box-shadow: 0 4px 12px rgba(126, 34, 206, 0.3); }
@media (max-width: 1024px) { .search-wrapper { display: none; } .already-text { display: none; } }
@media (max-width: 768px) { .navbar-links { display: none; } .navbar-inner { padding: 12px 20px; } }
</style>