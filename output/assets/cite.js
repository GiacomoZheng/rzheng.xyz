let currentPeeking = null;
const tooltip_toggle = document.getElementById("tooltip-toggle");

function peek(elem) {
    elem.classList.add('is-peeking');
    currentPeeking = elem;
    tooltip_toggle.checked = true; // 用来实现点击外部关闭
}
export function unpeek(elem) {
    elem.classList.remove('is-peeking');
    currentPeeking = null;
    tooltip_toggle.checked = false;
}


function handleCiteClick(event) {
    const elem = event.currentTarget;
    if (window.matchMedia("(max-width: 768px)").matches) {
        // 如果当前引用没有 is-peeking 类，说明是第一次点击
        if (!elem.classList.contains('is-peeking')) {
            event.preventDefault(); // 关键：必须在这里阻止默认的锚点跳转行为
            peek(elem); // 激活当前引用，显示浮窗
            return false;
        }
        // 如果已经 is-peeking，则不拦截，执行默认跳转，同时清理class
        unpeek(elem);
    }
}

document.querySelectorAll('.cite-link').forEach(link => {
    link.addEventListener('click', (e) => handleCiteClick(e));
});

document.getElementById("tooltip-overlay").addEventListener('click', (e) => unpeek(currentPeeking)) // 点击外部关闭