// 手机端下拉菜单点击外部后关闭
document.addEventListener('click', (e) => {
	const toggle = document.getElementById('nav-toggle');
	const content = document.querySelector('.navbar-content');
	if (toggle && toggle.checked && !content.contains(e.target)) {
		toggle.checked = false;
	}
});

// 点击菜单项后自动关闭下拉菜单
document.querySelectorAll('.navbar-menu a').forEach(link => {
	link.addEventListener('click', () => {
		document.getElementById('nav-toggle').checked = false;
	});
});