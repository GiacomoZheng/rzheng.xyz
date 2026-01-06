let currentActive = null;

const map = {};
function init() {
	document.querySelectorAll('.navbar-link').forEach(a => {
		map[a.href] = a;
	});
    document.querySelectorAll('.citation-link').forEach(a => {
        map[a.href] = a;
    });
	syncNav();
}
window.addEventListener('load', init);

function switch_active(target) {
    target.classList.add('is-active');
    if (currentActive) currentActive.classList.remove('is-active');
    currentActive = target;
}

function syncNav() {
	const url = new URL(window.location.href);
    let path = url.pathname === "/" ? "/index.html" : url.pathname;
    let hash = url.hash || "#"; // 如果没有 hash，默认给个 # 匹配 Home

    // 拼出我们想要匹配的“纯净” Key
    const currentKey = window.location.origin + path + hash;
	// 尝试寻找完全匹配（路径+Hash）
	let target = map[currentKey];

	if (target) {
        if (target !== currentActive){
            switch_active(target)
        }
	} else {
		throw new Error("No Target Found");
	}
	console.log("currentKey", currentKey);
}
window.addEventListener('hashchange', syncNav);
