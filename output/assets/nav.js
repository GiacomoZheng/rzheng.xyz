document.addEventListener('click', (e) => {
	const toggle = document.getElementById('nav-toggle');
	const content = document.querySelector('.navbar-content');
	if (toggle && toggle.checked && !content.contains(e.target)) {
		toggle.checked = false;
	}
});
const navMap = {};
document.querySelectorAll('.navbar-container a').forEach(a => {
	const href = a.getAttribute('href');
	navMap[href] = a;
});

// 记录当前活跃的元素，方便下次直接移除，而不用遍历全体
let currentActive = navMap["#"];

function syncActiveState() {
	const hash = window.location.hash;
	const target = navMap[hash];

	if (target) {
		// 如果不存在活跃项，报错
		if (!currentActive) throw new Error("无活跃项");
		
		// 给新目标加上类，并更新记录
		currentActive.classList.remove('active');
		target.classList.add('active');
		currentActive = target;
	}
}

// 2. 同步 Active 状态 (兼容 html.a 生成的结构)
function syncNav() {
	const hash = window.location.hash || "#";
	// 这里的选择器涵盖了 navbar 里的所有链接
	document.querySelectorAll('.navbar-container a').forEach(a => {
		const href = a.getAttribute('href');
		if (href === "/index.html" + hash || (hash === "#" && href === "/index.html#")) {
			a.classList.add('active');
		} else {
			a.classList.remove('active');
		}
	});
}

window.addEventListener('hashchange', syncNav);
window.addEventListener('load', syncNav);

// 3. 点击菜单项后自动关闭下拉菜单
document.querySelectorAll('.navbar-menu a').forEach(link => {
	link.addEventListener('click', () => {
		document.getElementById('nav-toggle').checked = false;
	});
});