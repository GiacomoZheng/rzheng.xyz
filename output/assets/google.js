(function () {
    const hostname = window.location.hostname;

    // 正则表达式匹配本地和局域网 IP
    const isLocal =
        hostname === 'localhost' ||
        hostname === '127.0.0.1' ||
        /^192\.168\./.test(hostname) ||
        /^172\.(1[6-9]|2[0-9]|3[0-1])\./.test(hostname) ||
        /^10\./.test(hostname) ||
        /^100\.(6[4-9]|[7-9][0-9]|1[0-1][0-9]|12[0-7])\./.test(hostname) ||
        hostname.endsWith('.local'); // 兼容 macOS 的 mDNS 地址如 computer.local

    const calendar = document.getElementById('calendar-container');
    const poster = document.getElementById('poster-container');

    if (isLocal) {
        console.log("检测到本地环境，已跳过 Google 日历/云盘 请求");
        calendar.innerHTML = `
            <div class="google-component">
              <strong style="margin-bottom:8px;">📅 Google Calendar (Dev Mode)</strong>
              <p>当前处于局域网/本地测试 (${hostname})，不加载日历以节省请求。</p>
            </div>`;
        poster.innerHTML = `
            <div class="google-component">
              <strong style="margin-bottom:8px;">📁 Google Drive (Dev Mode)</strong>
              <p>当前处于局域网/本地测试 (${hostname})，不加载云盘以节省请求。</p>
            </div>`;
    } else {
        calendar.innerHTML = `
            <iframe src="https://calendar.google.com/calendar/embed?height=600&wkst=1&ctz=Europe%2FLondon&src=cmVucGVuZy56aGVuZy5hY0BnbWFpbC5jb20&color=%23039be5&showTitle=0&showPrint=0&showTabs=1&showCalendars=0&showNav=1&showDate=1&mode=AGENDA" 
                class="google-component" frameborder="0" scrolling="no">
            </iframe>`;
        poster.innerHTML = `
            <iframe src="https://drive.google.com/embeddedfolderview?id=1q8QhaxtVw2GYZgpMGKrZ1DxO4mGrGVxj#list"
                class="google-component" frameborder="0">
            </iframe>`;
    }
})();