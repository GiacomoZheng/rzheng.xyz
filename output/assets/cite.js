(function () {
  let overlay = document.getElementById("tooltip-overlay") || createElem("div", "tooltip-overlay", "overlay");
  let tooltip = document.getElementById("global-tooltip") || createElem("div", "global-tooltip");

  function createElem(tag, id, className) {
    let el = document.createElement(tag);
    el.id = id;
    if (className) el.className = className;
    document.body.appendChild(el);
    return el;
  }

  const links = document.querySelectorAll('a.cite-link');
  let activeLink = null;
  let hideTimer = null;

  // --- 2. 响应式媒体查询与事件信号控制器 ---
  const mediaIsDesktop = window.matchMedia("(min-width: 769px)");
  let modeController = null; // 控制当前模式的事件生命周期

  // --- 3. 跨端通用事件（双端都需要） ---
  tooltip.addEventListener('click', (e) => {
    if (!activeLink) { console.warn('⚠️ 没有activeLink的情况下点击了浮窗，可能是逻辑错误。'); return; }
    if (e.target.closest('a')) return;
    if (window.getSelection()?.toString().trim().length > 0) return;

    activeLink.click();
    deactivate();
  });

  // --- 4. 模式切换与动态绑定逻辑 ---
  function resetTooltip() {
    tooltip.style.top = '';
    tooltip.style.left = '';
    tooltip.classList.remove('is-bottom');
    tooltip.innerHTML = '';
  }
  function switchMode() {
    // 切换模式时，先清理现有浮窗状态
    deactivate();
    resetTooltip();

    // 💥 一键销毁上一个模式绑定的所有监听器！
    if (modeController) {
      modeController.abort();
    }
    modeController = new AbortController();
    const { signal } = modeController; // 提取控制信号

    if (mediaIsDesktop.matches) {
      console.log(`🔄 切换到 💻 桌面端 (Desktop) 模式`);
      // ================= 桌面端绑定 =================
      links.forEach(link => {
        link.addEventListener('mouseenter', () => updateActiveDesktop(link), { signal });
        link.addEventListener('mouseleave', () => deactivateWithDelay(), { signal });
      });
      tooltip.addEventListener('mouseenter', () => clearTimeout(hideTimer), { signal });
      tooltip.addEventListener('mouseleave', () => deactivateWithDelay(), { signal });

    } else {
      console.log(`🔄 切换到 📱 移动端 (Mobile)模式`);
      // ================= 移动端绑定 =================
      links.forEach(link => {
        link.addEventListener('click', (e) => {
          if (activeLink !== link) {
            e.preventDefault();
            updateActive(link);
          } else {
            deactivate();
          }
        }, { signal });
      });

      overlay.addEventListener('click', deactivate, { signal });
    }
  }

  // 监听屏幕断点跨越（仅在 769px 临界点触发，不浪费性能）
  mediaIsDesktop.addEventListener('change', switchMode);

  // 初始化首次绑定
  switchMode();

  // --- 核心逻辑函数 ---
  function updateActive(link) {
    clearTimeout(hideTimer);
    if (activeLink && activeLink !== link) deactivate();

    const targetId = link.getAttribute('href');
    const tooltipContent = targetId ? document.querySelector(`${targetId} .tooltip-content`).innerHTML : null;
    if (!tooltipContent) return;

    tooltip.innerHTML = tooltipContent;
    link.classList.add('is-peeking');
    activeLink = link;
  }

  function deactivate() {
    // 虽然移动端不会有这两个事件，但切换模式时可能会残留
    window.removeEventListener('scroll', handleScrollOrResize);
    window.removeEventListener('resize', handleScrollOrResize);

    if (activeLink) {
      activeLink.classList.remove('is-peeking');
      activeLink = null;
    }
  }

  // --- 桌面端专用辅助函数 ---
  function updateActiveDesktop(link) {
    updateActive(link);
    positionTooltip(link);
    window.addEventListener('scroll', handleScrollOrResize, { passive: true });
    window.addEventListener('resize', handleScrollOrResize);
  }

  function deactivateWithDelay() {
    clearTimeout(hideTimer);
    hideTimer = setTimeout(deactivate, 200);
  }

  function positionTooltip(link) {
    const rect = link.getBoundingClientRect();
    const tooltipRect = tooltip.getBoundingClientRect();

    let top = rect.top - tooltipRect.height - 8;
    const isBottom = top < 10;
    if (isBottom) {
      top = rect.bottom + 8;
    }

    let left = rect.left + (rect.width / 2) - (tooltipRect.width / 2);
    if (left < 10) left = 10;
    if (left + tooltipRect.width > window.innerWidth - 10) {
      left = window.innerWidth - tooltipRect.width - 10;
    }

    tooltip.classList.toggle('is-bottom', isBottom);
    tooltip.style.top = `${top}px`;
    tooltip.style.left = `${left}px`;
  }

  function handleScrollOrResize() {
    if (!activeLink) return;
    
    // 滚动/缩放时：如果鼠标依然在链接或浮窗上，更新坐标；否则关掉
    const isHovered =  activeLink?.matches(':hover') || tooltip.matches(':hover');
    if (isHovered) {
      positionTooltip(activeLink);
    } else {
      deactivate();
    }
  };
})();
