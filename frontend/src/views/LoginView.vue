<template>
  <div class="login-page bg-background text-on-surface font-body flex flex-col items-center justify-center px-6 relative overflow-hidden pt-32 pb-16">
    <!-- Background Decorative Elements -->
    <div class="absolute inset-0 bg-login-texture -z-10"></div>
    <div class="absolute -top-24 -right-24 w-96 h-96 bg-primary/5 rounded-full blur-3xl"></div>
    <div class="absolute -bottom-24 -left-24 w-96 h-96 bg-secondary/5 rounded-full blur-3xl"></div>
    
    <div class="w-full max-w-md relative z-10">
      <!-- Brand Anchor -->
        <div class="text-center mb-10">
          <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-surface-container mb-6">
            <span class="material-symbols-outlined text-primary text-3xl">account_balance</span>
          </div>
          <h1 class="font-headline text-3xl font-extrabold text-on-surface tracking-tight mb-2">Welcome Back</h1>
          <p class="text-on-surface-variant text-sm max-w-xs mx-auto">Log in to the Benguet State University Gender and Development Office Portal</p>
        </div>

        <!-- Login Card -->
        <div class="bg-surface-container-lowest rounded-xl shadow-[0_8px_32px_rgba(26,28,29,0.04)] p-8 md:p-10 border border-outline-variant/15 relative overflow-hidden">
          <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-primary to-secondary/40"></div>
          
          <form @submit.prevent="handleLogin" class="space-y-6">
            <div v-if="error" class="rounded-md bg-red-100 border border-red-200 text-red-700 px-3 py-2 text-sm mb-3">
              {{ error }}
            </div>

            <!-- Identity Input -->
            <div class="space-y-2">
              <label class="block font-label text-xs font-bold uppercase tracking-widest text-on-surface-variant px-1" for="identity">Username or Email</label>
              <div class="relative group">
                <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-outline transition-colors group-focus-within:text-primary">person</span>
                <input 
                  v-model="identity"
                  class="w-full pl-12 pr-4 py-4 bg-surface-container-low border-none rounded-lg focus:ring-0 focus:bg-surface-bright focus:border-b-2 focus:border-primary transition-all duration-200 text-on-surface placeholder:text-outline/50" 
                  id="identity" 
                  placeholder="e.g. gad.office@bsu.edu.ph" 
                  required 
                  type="text" 
                />
              </div>
            </div>

            <!-- Password Input -->
            <div class="space-y-2">
              <div class="flex justify-between items-end px-1">
                <label class="block font-label text-xs font-bold uppercase tracking-widest text-on-surface-variant" for="password">Password</label>
                <a class="text-primary text-[10px] font-bold uppercase tracking-wider hover:underline underline-offset-4 decoration-2" href="#">Forgot Password?</a>
              </div>
              <div class="relative group">
                <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-outline transition-colors group-focus-within:text-primary">lock</span>
                <input 
                  v-model="password"
                  :type="showPassword ? 'text' : 'password'"
                  class="w-full pl-12 pr-12 py-4 bg-surface-container-low border-none rounded-lg focus:ring-0 focus:bg-surface-bright focus:border-b-2 focus:border-primary transition-all duration-200 text-on-surface placeholder:text-outline/50" 
                  id="password" 
                  placeholder="••••••••" 
                  required 
                />
                <button 
                  @click="showPassword = !showPassword"
                  class="absolute right-4 top-1/2 -translate-y-1/2 text-outline hover:text-on-surface-variant transition-colors" 
                  type="button"
                >
                  <span class="material-symbols-outlined text-sm">{{ showPassword ? 'visibility_off' : 'visibility' }}</span>
                </button>
              </div>
            </div>

            <div class="flex items-center gap-3 px-1">
              <input class="w-4 h-4 rounded border-outline text-primary focus:ring-primary" id="remember" type="checkbox" />
              <label class="text-sm text-on-surface-variant select-none" for="remember">Remember this device</label>
            </div>

            <!-- CTA -->
            <button 
              :disabled="loading"
              class="w-full py-4 px-6 bg-gradient-to-br from-primary to-primary-container text-white font-headline font-bold rounded-full shadow-lg shadow-primary/20 hover:opacity-90 active:scale-[0.98] transition-all duration-200 flex items-center justify-center gap-2" 
              type="submit"
            >
              {{ loading ? 'Signing In...' : 'Sign In to Dashboard' }}
              <span class="material-symbols-outlined text-sm">arrow_forward</span>
            </button>
          </form>

          <div class="mt-8 pt-8 border-t border-outline-variant/15 text-center">
            <p class="text-sm text-on-surface-variant font-body">
              Are you a visitor?
              <router-link class="text-secondary font-bold hover:underline underline-offset-4 decoration-2 ml-1" to="/gad-corner">Explore Public Records</router-link>
            </p>
          </div>
        </div>

        <!-- Supporting Information -->
        <div class="mt-12 grid grid-cols-2 gap-4">
          <div class="bg-surface-container rounded-xl p-4 flex items-start gap-3">
            <span class="material-symbols-outlined text-secondary text-xl">verified_user</span>
            <div>
              <h4 class="font-headline font-bold text-xs text-on-surface">Secure Access</h4>
              <p class="text-[10px] text-on-surface-variant leading-relaxed">Encrypted authentication for BSU personnel and students.</p>
            </div>
          </div>
          <div class="bg-surface-container rounded-xl p-4 flex items-start gap-3">
            <span class="material-symbols-outlined text-secondary text-xl">help_center</span>
            <div>
              <h4 class="font-headline font-bold text-xs text-on-surface">Need Help?</h4>
              <p class="text-[10px] text-on-surface-variant leading-relaxed">Contact the ICT Support Desk for login issues.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>

<script setup>
import { ref } from 'vue';
import { useRouter, useRoute } from 'vue-router';
// Use the relative path to step up out of the 'views' folder and find api.js
import api from '../api'; 

const router = useRouter();
const route = useRoute();
const identity = ref('');
const password = ref('');
const loading = ref(false);
const error = ref('');
const showPassword = ref(false);

const handleLogin = async () => {
  loading.value = true;
  error.value = '';
  
  try {
    const response = await api.post('login', {
      identity: identity.value,
      password: password.value
    });
    
    // Store user info in localStorage or a store
    const userData = response.data.user;
    localStorage.setItem('user', JSON.stringify(userData));
    
    const role = userData.role;
    const redirectTo = typeof route.query.redirect === 'string' ? route.query.redirect : null;
    
    console.log("Login successful. Detected role:", role, "redirectTo:", redirectTo);

    const getTargetRoute = () => {
      if (redirectTo) {
        return { path: redirectTo };
      }

      switch(role) {
        case 'admin':
          return { path: '/admin/dashboard' };
        case 'gad_staff':
          return { path: '/staff/dashboard' };
        case 'college':
          return { path: '/college/dashboard' };
        default:
          return { path: '/' };
      }
    };

    router.replace(getTargetRoute());
    
  } catch (err) {
    console.error('Login error:', err);
    
    if (err && err.messages) {
      error.value = err.messages.error || 'Login failed';
    } else if (err && err.message) {
      error.value = err.message;
    } else {
      error.value = 'Connection error. Please check if the backend is running.';
    }
  } finally {
    loading.value = false;
  }
};
</script>