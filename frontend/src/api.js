import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'https://gad-ams-2-1.onrender.com/api/';

const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 60000,
  headers: {
    'Content-Type': 'application/json'
  }
});

// Request interceptor
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('authToken');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Response interceptor
api.interceptors.response.use(
  (response) => response,
  (error) => {
    console.error('API Error:', error);
    console.error('Error config:', error.config);
    console.error('Error response:', error.response);
    console.error('Error request:', error.request);

    if (error.response) {
      // Server responded with error status
      console.error('Server error:', error.response.status, error.response.data);
      return Promise.reject(error.response.data);
    } else if (error.request) {
      // Request made but no response
      console.error('No response received:', error.request);
      return Promise.reject({
        message: 'Please Refresh the page and try again',
        details: error.message,
        url: error.config?.url
      });
    } else {
      // Error in request setup
      console.error('Request setup error:', error.message);
      return Promise.reject({
        message: 'Error preparing request',
        details: error.message
      });
    }
  }
);

export default api;
