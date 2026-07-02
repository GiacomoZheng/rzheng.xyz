const masterCheckbox = document.getElementById('abstracts-toggle');
const allDetails = document.querySelectorAll('.abstract-details');

function animateDetails(el, shouldOpen) {
  const currentAnim = el.getAnimations({ pseudoElement: '::details-content' }).find(anim =>
    anim.id === 'opening' || anim.id === 'closing'
  ) || null;
  if (currentAnim) {
    const targetStatus = shouldOpen ? 'opening' : 'closing';
    if (currentAnim.id === targetStatus) return Promise.resolve();
    // else
    currentAnim.cancel();
  } else {
    // 如果没有折叠动画在播，走静态判断
    if (el.open === shouldOpen) return Promise.resolve();
  }

  const startHeight = parseFloat(window.getComputedStyle(el, '::details-content').height) || 0;
  if (shouldOpen) {
    el.open = true;
    const endHeight = parseFloat(window.getComputedStyle(el, '::details-content').height) || 0;

    // 展开动画
    const animation = el.animate([
      { height: `${startHeight}px` },
      { height: `${endHeight}px` }
    ], {
      duration: 250,
      easing: 'ease-out',
      pseudoElement: '::details-content'
    });
    animation.id = 'opening';

    return Promise.resolve();
  } else {
    // 关闭动画
    const animation = el.animate([
      { height: `${startHeight}px` },
      { height: '0px' }
    ], {
      duration: 150,
      easing: 'ease-in',
      pseudoElement: '::details-content'
    });
    animation.id = 'closing';

    return new Promise(resolve => {
      animation.onfinish = () => {
        el.open = false; // 真正关闭
        resolve();       // 发出通知
      };
      animation.oncancel = () => resolve();
    });
  }
}

function updateCheckboxState() {
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
// --------------------------------------------------
// 初始化
updateCheckboxState();

// 监听主复选框
masterCheckbox.addEventListener('change', () => {
  const shouldOpen = masterCheckbox.checked || masterCheckbox.indeterminate;
  const promises = Array.from(allDetails).map(el => animateDetails(el, shouldOpen));
  Promise.all(promises).then(() => {
    updateCheckboxState();
  });
});

// --------------------------------------------------
// diglog
// --------------------------------------------------
// const copyBtn = dialog.querySelector('button');
// copyBtn.addEventListener('click', async () => {
//   if (!activeBibText) return;
//   try {
//     copyBtn.disabled = true;
//     await navigator.clipboard.writeText(activeBibText);
//     const originalText = copyBtn.textContent;
//     copyBtn.textContent = '✓ copied!';
//     setTimeout(() => {
//       copyBtn.textContent = originalText;
//       copyBtn.disabled = false;
//     }, 1000);
//   } catch (err) {
//     console.error(err);
//     copyBtn.disabled = false;
//   }
// });

function dialogText(trigger) {
  const targetId = trigger.getAttribute('data-target');
  activeBibText = document.getElementById(targetId).textContent;
  dialog.querySelector('code').textContent = activeBibText;
}




// --------------------------------------------------
// 事件委托：监听列表点击
document.querySelector('.bib-list')?.addEventListener('click', async (e) => {
  const summary = e.target.closest('summary');
  const copyBtn = e.target.closest('dialog button');

  if (summary) {
    const details = summary.closest('details');
    e.preventDefault();
    // 🌟 关键：等动画彻底结束（无论是展开还是彻底关闭）后，再雷厉风行地更新 Checkbox！
    animateDetails(details, !details.open).then(() => {
      updateCheckboxState();
    });
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

// 监听每个按钮
// allDetails.forEach(el => el.addEventListener('click', (e) => {
//   if (!e.target.closest('summary')) return;

//   e.preventDefault();
//   // 🌟 关键：等动画彻底结束（无论是展开还是彻底关闭）后，再雷厉风行地更新 Checkbox！
//   animateDetails(el, !el.open).then(() => {
//     updateCheckboxState();
//   });
// }));