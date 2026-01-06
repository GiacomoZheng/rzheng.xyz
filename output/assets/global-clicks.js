import { unpeek } from '/assets/cite.js';

const navContent = document.querySelector('.navbar-content');
const navToggle = document.getElementById('navbar-toggle');

/**
 * global-click.js
 * 专门处理点击页面空白处（元素外部）时的自动收起逻辑
 */
document.addEventListener('click', (event) => {
    const target = event.target;

    if (navToggle?.checked && !navContent?.contains(target)) {
        // 1. 处理导航菜单 (Navbar)
        // 如果菜单已打开，且点击位置不在菜单内，也不在按钮上
        navToggle.checked = false;
    } else if (!target.closest('.citation-link')) {
        // 一次点击只处理一个
        // 2. 处理引用预览 (Citation Tooltips)
        // 如果点击位置不在引用链接范围内
        unpeek(target);
    }
    
    // 3. 未来可以在这里添加其他组件，例如：
    // if (!target.closest('.dropdown')) { ... }
});