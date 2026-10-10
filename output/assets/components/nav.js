class DynBar extends HTMLElement {
  startY = 0;
  ticking = false;
  isMobile = false;

  connectedCallback() {
    this.mediaQuery = window.matchMedia("(max-width: 768px)");
    this.mediaQuery.addEventListener('change', this.handleMediaChange);
    this.handleMediaChange();

    window.addEventListener('scroll', this.onScroll, { passive: true });
    this.addEventListener('click', (event) => { event.stopPropagation(); });

    this.startY = window.scrollY;
  }
  disconnectedCallback() {
    window.removeEventListener('touchstart', this.touchStart);
    window.removeEventListener('scroll', this.onScroll);
  }

  handleMediaChange = () => {
    this.isMobile = this.mediaQuery.matches;
    // 如果切回大屏，自动还原导航栏展开状态
    if (!this.isMobile) {
      this.classList.remove('compact');
    }
  };

  onScroll = () => {
    // requestAnimationFrame 节流逻辑
    if (!this.ticking) {
      window.requestAnimationFrame(() => {
        this.handleScroll();
        this.ticking = false;
      });
      this.ticking = true;
    }
  }

  handleScroll = () => {
    // 仅在移动端 (<768px) 执行
    if (!this.isMobile) return;
    const current = window.scrollY;
    const diff = current - this.startY;

    if (diff > 20 && current > 30) {
      // console.log("nav ---->, current: ", current);
      this.classList.add('compact');
      this.startY = current;
    } else if (diff < -50 || current < 30) {
      // console.log("<---- nav, current: ", current);
      this.classList.remove('compact');
      this.startY = current;
    }
  }
}
customElements.define('dyn-bar', DynBar);

class ActiveLinks extends HTMLElement {
  currentActive = null;
  linkMap = new Map();

  connectedCallback() {
    this.querySelectorAll('.nav-link').forEach(a => {
      this.linkMap.set(a.href, a);
    });
    console.log("link map: \n\t" , this.linkMap);

    window.addEventListener('hashchange', this.syncNav);
    this.syncNav();
  }

  disconnectedCallback() {
    window.removeEventListener('hashchange', this.syncNav);
  }

  switchActive = (target) => {
    if (target === this.currentActive) return;
    target?.classList.add('is-active');
    this.currentActive?.classList.remove('is-active');
    this.currentActive = target;
  };

  syncNav = () => {
    const url = new URL(window.location.href);
    const path = url.pathname;
    const hash = url.hash || "#"; // 如果没有 hash，默认给个 # 匹配 Home
    
    const currentKey = window.location.origin + path + hash;
    console.log("currentKey", currentKey);
    const target = this.linkMap.get(currentKey);

    this.switchActive(target);
  };
}
customElements.define('active-links', ActiveLinks);