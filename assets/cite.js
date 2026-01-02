function handleCiteClick(event, elem) {
    const isMobile = window.matchMedia("(max-width: 768px)").matches;

    if (isMobile) {
        // 如果当前引用没有 active 类，说明是第一次点击
        if (!elem.classList.contains('active')) {
            
            // 关键：必须在这里阻止默认的锚点跳转行为
            event.preventDefault(); 
            event.stopPropagation();

            // 清除其他激活状态
            document.querySelectorAll('.citation-link.active').forEach(el => {
                el.classList.remove('active');
            });

            // 激活当前引用，显示浮窗
            elem.classList.add('active');

            // 点击外部关闭逻辑...
            return false; // 双重保险
        }
        // 如果已经 active，则不拦截，执行默认跳转
    }
}