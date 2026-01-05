let currentActive = null;

const navMap = {};
function init() {
	document.querySelectorAll('.navbar-link').forEach(a => {
		navMap[a.href] = a;
	});
    document.querySelectorAll('.citation-link').forEach(a => {
        navMap[a.href] = a;
    });
    console.log("Initializing.", navMap);
	syncNav();
}

function syncNav() {
	const url = new URL(window.location.href);
    let path = url.pathname === "/" ? "/index.html" : url.pathname;
    let hash = url.hash || "#"; // 如果没有 hash，默认给个 # 匹配 Home

    // 拼出我们想要匹配的“纯净” Key
    const currentKey = window.location.origin + path + hash;
	// 尝试寻找完全匹配（路径+Hash）
	let target = navMap[currentKey];

	if (target && target !== currentActive) {
		if (currentActive) currentActive.classList.remove('active');
		target.classList.add('active');
		currentActive = target;
	} else {
		throw new Error("No Target Found");
	}
	console.log(currentKey);
}



window.addEventListener('load', init);
window.addEventListener('hashchange', syncNav);


function handleCiteClick(event, elem) {
    const isMobile = window.matchMedia("(max-width: 768px)").matches;

    if (isMobile) {
        // 如果当前引用没有 active 类，说明是第一次点击
        if (!elem.classList.contains('active')) {
            
            // 关键：必须在这里阻止默认的锚点跳转行为
            event.preventDefault(); 
            event.stopPropagation();

            // 清除其他激活状态
            // +

            // 激活当前引用，显示浮窗
            elem.classList.add('active');

            // 点击外部关闭逻辑...
            return false; // 双重保险
        }
        // 如果已经 active，则不拦截，执行默认跳转
    }
}