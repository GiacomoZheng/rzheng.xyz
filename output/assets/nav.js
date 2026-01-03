const navMap = {};
let currentActive = null;



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

function initNav() {
	document.querySelectorAll('.navbar-container a[data-type]').forEach(a => {
		navMap[a.href] = a;
	});
	syncNav();
}

window.addEventListener('load', initNav);
window.addEventListener('hashchange', syncNav);


// 2. 手机端下拉菜单
document.addEventListener('click', (e) => {
	const toggle = document.getElementById('nav-toggle');
	const content = document.querySelector('.navbar-content');
	if (toggle && toggle.checked && !content.contains(e.target)) {
		toggle.checked = false;
	}
});
// 3. 点击菜单项后自动关闭下拉菜单
document.querySelectorAll('.navbar-menu a').forEach(link => {
	link.addEventListener('click', () => {
		document.getElementById('nav-toggle').checked = false;
	});
});