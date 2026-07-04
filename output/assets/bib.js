const masterCheckbox = document.getElementById('abstracts-toggle');
const allDetails = document.querySelectorAll('.abstract-details');

function animateDetails(details, shouldOpen) {
  const wrapper = details.querySelector('.details-wrapper');
  const inner = wrapper.querySelector('.details-inner');
  if (shouldOpen) {
    console.log("opening");
    details.open = true; 
    
    // 关键修改：获取 inner 的绝对精确高度（包含 padding）
    const fullHeight = inner.offsetHeight; 
    
    wrapper.style.height = '0px'; // 确保从0开始
    wrapper.offsetHeight;        // 强制重绘
    wrapper.style.height = fullHeight + 'px'; // 触发现身动画
  } else {
    console.log("closing");
    const currentHeight = inner.offsetHeight;
    wrapper.style.height = currentHeight + 'px';
    
    wrapper.offsetHeight; // 强制重绘，认账当前高度
    
    // 动画到 0
    requestAnimationFrame(() => {
      wrapper.style.height = '0px';
    });
  }
}

function updateCheckboxState() {
  console.log("update master toggle.");
  let hasOpen = false;
  let hasClosed = false;
  masterCheckbox.indeterminate = false;

  // 直接遍历内存里的节点列表，速度比操作 DOM 树快几个数量级
  for (const el of allDetails) {
    // 读取元素的 open 属性
    if (el.open) {
      hasOpen = true;
    } else {
      hasClosed = true;
    }
    if (hasOpen && hasClosed) {
      masterCheckbox.indeterminate = true;
      break;
    }
  }
  masterCheckbox.checked = !hasClosed;
}
// 初始化
updateCheckboxState();

// --------------------------------------------------
// 监听主复选框
masterCheckbox.addEventListener('change', () => {
  const shouldOpen = masterCheckbox.checked || masterCheckbox.indeterminate;
  allDetails.forEach(el => animateDetails(el, shouldOpen));
});

// --------------------------------------------------
// 事件委托：监听列表点击
const bibList = document.querySelector('.bib-list');
bibList.addEventListener('click', async (e) => {
  const summary = e.target.closest('summary');
  const copyBtn = e.target.closest('dialog button');

  if (summary) {
    e.preventDefault();
    const details = summary.closest('details');
    // details.classList.add('is-animating');
    animateDetails(details, !details.open);
  } else if (copyBtn) {
    try {
      copyBtn.disabled = true;
      const contentText = copyBtn.closest('dialog')?.querySelector('code')?.textContent;
      
      await navigator.clipboard.writeText(contentText);
      const originalText = copyBtn.textContent;
      copyBtn.textContent = '✓ copied!';
      setTimeout(() => {
        copyBtn.textContent = originalText;
        copyBtn.disabled = false;
      }, 1000);
    } catch (err) {
      console.error(err);
      copyBtn.disabled = false;
    }
  }
});

// 事件委托：监听列表动画完成
bibList.addEventListener('transitionend', (e) => {
  const details = e.target.closest('details');
  if (!details || e.propertyName !== 'height') return;
  // if (!details.classList.contains('is-animating')) return;
  const wrapper = details.querySelector('.details-wrapper');

  if (wrapper.style.height === '0px') {// 关闭的情况
    details.open = false;
  } else if (details.open) {// 打开的情况
    wrapper.style.height = 'auto'; 
  }
  
  // details.classList.remove('is-animating'); // 解锁
  updateCheckboxState();
});