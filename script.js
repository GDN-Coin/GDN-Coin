const menuButton = document.querySelector('.menu-toggle');
const nav = document.querySelector('.nav');

menuButton.addEventListener('click', () => {
  const isOpen = nav.classList.toggle('open');
  menuButton.setAttribute('aria-expanded', String(isOpen));
});

document.querySelectorAll('.nav a').forEach(link => {
  link.addEventListener('click', () => {
    nav.classList.remove('open');
    menuButton.setAttribute('aria-expanded', 'false');
  });
});

const copyButton = document.getElementById('copyContract');
const contract = document.getElementById('contractAddress').textContent.trim();

copyButton.addEventListener('click', async () => {
  try {
    await navigator.clipboard.writeText(contract);
    copyButton.textContent = 'Copied';
    setTimeout(() => copyButton.textContent = 'Copy', 1600);
  } catch {
    copyButton.textContent = 'Copy failed';
  }
});
