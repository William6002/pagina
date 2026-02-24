// =============================================
// main.js — Funcionalidades gerais
// =============================================

/* ---- Navbar scroll ---- */
const navbar = document.getElementById('navbar');
if (navbar) {
  window.addEventListener('scroll', () => {
    navbar.classList.toggle('scrolled', window.scrollY > 20);
  });
}

/* ---- Mobile menu ---- */
const navToggle = document.getElementById('navToggle');
const navLinks = document.querySelector('.nav-links');
if (navToggle && navLinks) {
  navToggle.addEventListener('click', () => navLinks.classList.toggle('open'));
  document.addEventListener('click', e => {
    if (!navToggle.contains(e.target) && !navLinks.contains(e.target)) {
      navLinks.classList.remove('open');
    }
  });
}

/* ---- Storage simulado (substitui backend/SQL) ---- */
const DB = {
  get: (key) => JSON.parse(localStorage.getItem(key) || '[]'),
  set: (key, val) => localStorage.setItem(key, JSON.stringify(val)),
  push: (key, item) => {
    const arr = DB.get(key);
    arr.push(item);
    DB.set(key, arr);
    return item;
  }
};

/* ---- Coletar IP (simulado - em produção usar backend) ---- */
async function getClientInfo() {
  // Em produção: fetch('/api/client-info')
  return {
    ip: '(capturado pelo servidor)',
    datetime: new Date().toISOString(),
    userAgent: navigator.userAgent
  };
}

/* ---- Validação de formulário ---- */
function validateField(input) {
  const group = input.closest('.form-group');
  let errorEl = group?.querySelector('.field-error');
  if (!errorEl && group) {
    errorEl = document.createElement('span');
    errorEl.className = 'field-error';
    group.appendChild(errorEl);
  }
  if (input.required && !input.value.trim()) {
    input.style.borderColor = '#e05050';
    if (errorEl) errorEl.textContent = 'Este campo é obrigatório.';
    return false;
  }
  if (input.type === 'email' && input.value && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(input.value)) {
    input.style.borderColor = '#e05050';
    if (errorEl) errorEl.textContent = 'E-mail inválido.';
    return false;
  }
  input.style.borderColor = '';
  if (errorEl) errorEl.textContent = '';
  return true;
}

function validateForm(form) {
  let valid = true;
  form.querySelectorAll('input[required], textarea[required], select[required]').forEach(el => {
    if (!validateField(el)) valid = false;
  });
  return valid;
}

/* ---- Upload de arquivos ---- */
function initUpload(inputId, previewId) {
  const input = document.getElementById(inputId);
  const preview = document.getElementById(previewId);
  const area = input?.closest('.upload-area');
  if (!input || !preview) return;

  const files = new DataTransfer();

  function renderPreview() {
    preview.innerHTML = '';
    Array.from(files.files).forEach((f, i) => {
      const tag = document.createElement('div');
      tag.className = 'upload-tag';
      tag.innerHTML = `📎 ${f.name} <button type="button" data-i="${i}">×</button>`;
      tag.querySelector('button').addEventListener('click', () => {
        const dt = new DataTransfer();
        Array.from(files.files).forEach((ff, ii) => { if (ii !== i) dt.items.add(ff); });
        files.items.clear();
        Array.from(dt.files).forEach(ff => files.items.add(ff));
        input.files = files.files;
        renderPreview();
      });
      preview.appendChild(tag);
    });
  }

  input.addEventListener('change', () => {
    Array.from(input.files).forEach(f => files.items.add(f));
    input.files = files.files;
    renderPreview();
  });

  area?.addEventListener('click', () => input.click());
  area?.addEventListener('dragover', e => { e.preventDefault(); area.style.borderColor = 'var(--accent)'; });
  area?.addEventListener('dragleave', () => { area.style.borderColor = ''; });
  area?.addEventListener('drop', e => {
    e.preventDefault();
    area.style.borderColor = '';
    Array.from(e.dataTransfer.files).forEach(f => files.items.add(f));
    input.files = files.files;
    renderPreview();
  });
}

/* ---- Tabs ---- */
function initTabs(container) {
  const el = document.querySelector(container);
  if (!el) return;
  el.querySelectorAll('.tab-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      el.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
      el.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
      btn.classList.add('active');
      el.querySelector(`#${btn.dataset.tab}`)?.classList.add('active');
    });
  });
}

/* ---- Auth check ---- */
function requireAuth() {
  const user = sessionStorage.getItem('adminUser');
  if (!user) {
    window.location.href = 'login.html';
    return false;
  }
  return JSON.parse(user);
}

function logout() {
  sessionStorage.removeItem('adminUser');
  window.location.href = 'login.html';
}
