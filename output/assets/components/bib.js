class BibList extends HTMLElement {
  connectedCallback() {
    const toggleId = this.getAttribute('toggle-id');
    this.masterCheckbox = toggleId ? document.getElementById(toggleId) : null;
    this.allDetails = this.querySelectorAll('.abstract-details');

    this.masterCheckbox?.addEventListener('change', this.handleMasterToggle);
    this.addEventListener('click', this.handleClick);
    this.addEventListener('transitionend', this.handleTransitionEnd);

    this.updateCheckboxState();
  }

  disconnectedCallback() {
    this.masterCheckbox?.removeEventListener('change', this.handleMasterToggle);
    this.removeEventListener('click', this.handleClick);
    this.removeEventListener('transitionend', this.handleTransitionEnd);
  }

  handleMasterToggle = () => {
    if (!this.masterCheckbox) return;
    const shouldOpen = this.masterCheckbox.checked || this.masterCheckbox.indeterminate;
    this.masterCheckbox.indeterminate = false;
    this.masterCheckbox.checked = shouldOpen;
    this.allDetails.forEach(el => this.animateDetails(el, shouldOpen));
  };

  handleClick = (e) => {
    const summary = e.target.closest('summary'); // + 如果Safari支持interpolate-size: allow-keywords;了，这个就可以删除了
    const copyBtn = e.target.closest('dialog button');

    if (summary) {
      e.preventDefault();
      const details = summary.closest('details');
      if (details) this.animateDetails(details, !details.open);
    } else if (copyBtn) {
      this.handleCopy(copyBtn);
    }
  };

  handleTransitionEnd = (e) => {
    if (!e.target.classList.contains('details-wrapper') || e.propertyName !== 'height') return;
    const wrapper = e.target;
    const details = wrapper.closest('details');
    if (!details) return;
  
    if (wrapper.style.height === '0px') {
      details.open = false; // 关完后真正移除 open 属性
    } else {
      wrapper.style.height = 'auto'; // 展开后恢复 auto 自适应
    }
  
    this.updateCheckboxState();
  };

  animateDetails(details, shouldOpen) {
    const wrapper = details.querySelector('.details-wrapper');
    if (!wrapper) return;

    if (shouldOpen) {
      details.open = true;
      const fullHeight = wrapper.scrollHeight;
      wrapper.style.height = '0px';
      wrapper.offsetHeight; // 强制重绘
      wrapper.style.height = fullHeight + 'px';
    } else {
      wrapper.style.height = wrapper.scrollHeight + 'px';
      wrapper.offsetHeight; // 强制重绘
      wrapper.style.height = '0px';
    }
  }

  // --- 状态更新逻辑 (自动操控外部的 masterCheckbox) ---
  updateCheckboxState() {
    if (!this.masterCheckbox) return;

    let hasOpen = false;
    let hasClosed = false;

    for (const el of this.allDetails) {
      if (el.open) hasOpen = true;
      else hasClosed = true;

      if (hasOpen && hasClosed) {
        this.masterCheckbox.indeterminate = true;
        return;
      }
    }

    this.masterCheckbox.indeterminate = false;
    this.masterCheckbox.checked = !hasClosed && hasOpen;
  }

  async handleCopy(copyBtn) {
    try {
      copyBtn.disabled = true;
      const contentText = copyBtn.closest('dialog')?.querySelector('code')?.textContent;

      if (contentText) {
        await navigator.clipboard.writeText(contentText);
        const originalText = copyBtn.textContent;
        copyBtn.textContent = '✓ copied!';
        setTimeout(() => {
          copyBtn.textContent = originalText;
          copyBtn.disabled = false;
        }, 1000);
      }
    } catch (err) {
      console.error(err);
      copyBtn.disabled = false;
    }
  }
}
customElements.define('bib-list', BibList);