let currentActive = null;

const link_map = {};
function init() {
	document.querySelectorAll('.nav-link').forEach(a => {
		link_map[a.href] = a;
	});
	document.querySelectorAll('.cite-link').forEach(a => {
		link_map[a.href] = a;
	});
	console.log("link map: \n\t" + Object.keys(link_map).join('\n\t'));
	syncNav();
	console.log("初始化成功");
}

function switch_active(target) {
	target.classList.add('is-active');
	if (currentActive) currentActive.classList.remove('is-active');
	currentActive = target;
}

function syncNav() {
	const url = new URL(window.location.href);
	let path = url.pathname;
	console.log("pathname", path);
	let hash = url.hash || "#"; // 如果没有 hash，默认给个 # 匹配 Home

	const currentKey = window.location.origin + path + hash;
	console.log("currentKey", currentKey);

	let target = link_map[currentKey];
	if (target) {
		if (target !== currentActive){
			switch_active(target)
		}
	} else {
		throw new Error("No Target Found");
	}
	
}
window.addEventListener('hashchange', syncNav);

init()