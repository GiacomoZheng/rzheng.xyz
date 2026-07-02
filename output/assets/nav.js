const myNav = document.querySelector('nav');
let startY = 0;

window.addEventListener('touchstart', () => {
  startY = window.scrollY;  // 手指按下的起始位置
}, { passive: true });

function handleScroll() {
  if (window.matchMedia("(max-width: 768px)").matches) {
    const current = window.scrollY;
    
    if (current - startY > 20) {
      // console.log("nav ---->, current: ", current);
      myNav.classList.add('nav-compact');
      startY = current;
    } else if (current - startY < -50 || current < 30) {
      // console.log("<---- nav, current: ", current);
      myNav.classList.remove('nav-compact');
      startY = current;
    }
  }
}

let ticking = false;
window.addEventListener('scroll', () => {
  if (!ticking) { // 如果锁是开着的
    window.requestAnimationFrame(() => {
      handleScroll(); // 执行计算
      ticking = false; // 执行完了，把锁打开
    });
    ticking = true; // 只要进来了，先把锁关上，防止重复排队
  }
}, { passive: true });


myNav.addEventListener('click', (event) => {
  // 阻止点击事件向上冒泡,这样点击导航不会关闭菜单
  event.stopPropagation();
});