const menuToggle = document.getElementById('menuToggle');
const nav = document.getElementById('mainNav');
const languageSwitch = document.getElementById('languageSwitch');
const copyButton = document.getElementById('copyContract');
const contractAddress = document.getElementById('contractAddress').textContent.trim();
const cursorGlow = document.querySelector('.cursor-glow');
const progressBar = document.getElementById('progressBar');
let language = localStorage.getItem('gdn-language') || 'en';

function setLanguage(nextLanguage) {
  language = nextLanguage;
  document.documentElement.lang = language;
  document.querySelectorAll('[data-en][data-tr]').forEach((element) => {
    element.textContent = element.dataset[language];
  });
  languageSwitch.textContent = language === 'en' ? 'TR' : 'EN';
  localStorage.setItem('gdn-language', language);
}
setLanguage(language);
languageSwitch.addEventListener('click', () => setLanguage(language === 'en' ? 'tr' : 'en'));

menuToggle.addEventListener('click', () => {
  const open = nav.classList.toggle('open');
  menuToggle.setAttribute('aria-expanded', String(open));
});
document.querySelectorAll('.nav a').forEach((link) => link.addEventListener('click', () => {
  nav.classList.remove('open');
  menuToggle.setAttribute('aria-expanded', 'false');
}));

copyButton.addEventListener('click', async () => {
  try {
    await navigator.clipboard.writeText(contractAddress);
    copyButton.textContent = language === 'en' ? 'Copied' : 'Kopyalandı';
    setTimeout(() => copyButton.textContent = language === 'en' ? 'Copy' : 'Kopyala', 1600);
  } catch {
    copyButton.textContent = language === 'en' ? 'Copy failed' : 'Kopyalanamadı';
  }
});

const observer = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (!entry.isIntersecting) return;
    entry.target.classList.add('visible');
    entry.target.querySelectorAll?.('[data-count]').forEach(animateCounter);
    observer.unobserve(entry.target);
  });
}, { threshold: 0.14 });
document.querySelectorAll('.reveal').forEach((element) => observer.observe(element));

function animateCounter(element) {
  if (element.dataset.animated) return;
  element.dataset.animated = 'true';
  const target = Number(element.dataset.count || 0);
  const duration = 1100;
  const start = performance.now();
  const tick = (now) => {
    const progress = Math.min((now - start) / duration, 1);
    const value = Math.round(target * (1 - Math.pow(1 - progress, 3)));
    element.textContent = element.dataset.format === 'compact'
      ? new Intl.NumberFormat(language === 'tr' ? 'tr-TR' : 'en', { notation: 'compact', maximumFractionDigits: 0 }).format(value)
      : `${value}${element.dataset.suffix || ''}`;
    if (progress < 1) requestAnimationFrame(tick);
  };
  requestAnimationFrame(tick);
}

window.addEventListener('pointermove', (event) => {
  if (!cursorGlow) return;
  cursorGlow.style.left = `${event.clientX}px`;
  cursorGlow.style.top = `${event.clientY}px`;
});
window.addEventListener('scroll', () => {
  const total = document.documentElement.scrollHeight - window.innerHeight;
  progressBar.style.transform = `scaleX(${total > 0 ? window.scrollY / total : 0})`;
}, { passive: true });
