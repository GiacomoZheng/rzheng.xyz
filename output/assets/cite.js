let currentPeeking = null;

function peek(elem) {
    elem.classList.add('is-peeking');
    currentPeeking = elem;
}
export function unpeek(elem) {
    elem.classList.remove('is-peeking');
    currentPeeking = null;
}

function handleCiteClick(event) {
    const elem = event.currentTarget;
    const isMobile = window.matchMedia("(max-width: 768px)").matches;
    if (isMobile) {
        // 如果当前引用没有 is-peeking 类，说明是第一次点击
        if (!elem.classList.contains('is-peeking')) {
            // 关键：必须在这里阻止默认的锚点跳转行为
            event.preventDefault(); 
            // 激活当前引用，显示浮窗
            peek(elem);
            // 点击外部关闭逻辑...
            return false; // 双重保险
        }
        // 如果已经 is-peeking，则不拦截，执行默认跳转，同时清理class
        unpeek(elem);
    }
}

document.querySelectorAll('.citation-link').forEach(link => {
    link.addEventListener('click', (e) => handleCiteClick(e));
});